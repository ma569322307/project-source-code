//
//  XTSingleSelectionController.m
//  collectionViewPlay
//
//  Created by Jiajun Zheng on 15/6/23.
//  Copyright (c) 2015年 zjProject. All rights reserved.
//

#import "XTSingleSelectionController.h"
#import "XTGroupSelectionCollectionViewController.h"
#import "ZDStickerView.h"
#import "XTUploadSingleCell.h"
#import "XTUploadSingleModel.h"
#import "XTUploadGroupModel.h"
#define kStickerLabelSize CGSizeMake(kStickerLabelWidth, kStickerLabelHeight)
#define kStickerSize CGSizeMake(kSmallSize, kSmallSize)
#define kStickerLabelInset (kHeight - 2 * kStickerLabelHeight) / 6
@interface XTSingleSelectionController ()<UICollectionViewDataSource,UICollectionViewDelegate>
// 提供分组展示的控制器的视图
@property (nonatomic, weak) UICollectionView *groupsCollectionView;
// 具体单个分组展示collectionView
@property (nonatomic, weak) UICollectionView *singleGroupCollectionView;
// 具体单个分组布局
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
// 隐藏按钮
@property (nonatomic, weak) UIButton *hiddenButton;
// 隐藏选择
@property (nonatomic, assign, getter=isHideSelection) BOOL hideSelection;
// 用户手动隐藏判断
@property (nonatomic, assign,getter=isHideByUser) BOOL hideByUser;
// 快贴类型
@property (nonatomic, assign) BOOL type;
// 单选视图的背景视图
@property (nonatomic, strong) UIView *singleBackgroundView;
@end

@implementation XTSingleSelectionController

static NSString * const reuseIdentifier = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // 关闭自动调整inset功能
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 注册
    [self.singleGroupCollectionView registerClass:[XTUploadSingleCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // 添加视图约束
    [self addConstraints];
    // 设置背景颜色
    self.singleGroupCollectionView.backgroundColor = kBackColor;
    // 监听通知
    [self registerNotifications];
}

// 监听通知
-(void)registerNotifications{
    // 监听点击具体组的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseGroup:) name:kSelectionGroupNotification object:nil];
    // 监听开始移动通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movingBeganClick) name:kStickerViewBeginMovingNotification object:nil];
    // 监听结束移动通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movingEndClick) name:kStickerViewEndMovingNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 接收选择了某个组的通知
-(void)chooseGroup:(NSNotification *)note{
    NSDictionary *userInfo = note.userInfo;
    XTUploadGroupModel *model = userInfo[@"model"];
    //判断类型
    self.type = model.type.integerValue;
    //根据类型变化itemSize
    if (self.type) {
        self.flowLayout.itemSize = kStickerSize;
        self.flowLayout.sectionInset = UIEdgeInsetsMake(kItemMerage, 10, kItemMerage, 0);
        self.flowLayout.minimumLineSpacing = 1;
    }else{
        self.flowLayout.itemSize = kStickerSize;
        self.flowLayout.sectionInset = UIEdgeInsetsMake(kItemMerage, 10, kItemMerage, 0);
        self.flowLayout.minimumLineSpacing = 6;
    }
    // 接收数据
    self.singleStickers = model.singleStickers;
}
// 隐藏的时候发送通知
-(void)setHideSelection:(BOOL)hideSelection{
    _hideSelection = hideSelection;
    // 发送通知告诉是否隐藏
    [[NSNotificationCenter defaultCenter] postNotificationName:kHideNotification object:nil userInfo:@{@"hide":@(hideSelection)}];
}


// 添加约束
- (void)addConstraints{
    // 关闭autoResizing
    self.groupsCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.singleGroupCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.hiddenButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.stickerButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.logoButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.singleBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    // 创建约束groupsCollectionView
    NSLayoutConstraint *groupsLeft = [NSLayoutConstraint constraintWithItem:self.groupsCollectionView
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1
                                                                   constant:0];
    NSLayoutConstraint *groupsRight = [NSLayoutConstraint constraintWithItem:self.groupsCollectionView
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1
                                                                    constant:0];
    NSLayoutConstraint *groupsTop = [NSLayoutConstraint constraintWithItem:self.groupsCollectionView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1
                                                                     constant:kDistance];
    NSLayoutConstraint *groupsHeight = [NSLayoutConstraint constraintWithItem:self.groupsCollectionView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1
                                                                     constant:kBigSize + kItemMerage * 2];
    // 创建约束singleGroupCollectionView
    NSLayoutConstraint *singleLeft = [NSLayoutConstraint constraintWithItem:self.singleGroupCollectionView
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1
                                                                   constant:kSingleLeftEdge];
    NSLayoutConstraint *singleRight = [NSLayoutConstraint constraintWithItem:self.singleGroupCollectionView
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1
                                                                    constant:0];
    NSLayoutConstraint *singleTop = [NSLayoutConstraint constraintWithItem:self.singleGroupCollectionView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1
                                                                     constant:kDistance];
    NSLayoutConstraint *singleHeight = [NSLayoutConstraint constraintWithItem:self.singleGroupCollectionView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1
                                                                     constant:kBigSize + kItemMerage * 2];
    // 创建约束singleBackgroundView
    NSLayoutConstraint *singleBackLeft = [NSLayoutConstraint constraintWithItem:self.singleBackgroundView
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1
                                                                   constant:0];
    NSLayoutConstraint *singleBackRight = [NSLayoutConstraint constraintWithItem:self.singleBackgroundView
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1
                                                                    constant:0];
    NSLayoutConstraint *singleBackTop = [NSLayoutConstraint constraintWithItem:self.singleBackgroundView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:kDistance];
    NSLayoutConstraint *singleBackHeight = [NSLayoutConstraint constraintWithItem:self.singleBackgroundView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1
                                                                     constant:kBigSize + kItemMerage * 2];
    
    // 添加隐藏按钮约束
    NSLayoutConstraint *btnCenterY = [NSLayoutConstraint constraintWithItem:self.hiddenButton
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1
                                                                   constant:kDistance * 0.5];
    NSLayoutConstraint *btnRight = [NSLayoutConstraint constraintWithItem:self.hiddenButton
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1
                                                                 constant:-20];
    NSLayoutConstraint *btnWidth = [NSLayoutConstraint constraintWithItem:self.hiddenButton
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1
                                                                 constant:25];
    NSLayoutConstraint *btnHeight = [NSLayoutConstraint constraintWithItem:self.hiddenButton
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:25];
    // 添加快贴按钮约束
    NSLayoutConstraint *stickerCenterY = [NSLayoutConstraint constraintWithItem:self.stickerButton
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1
                                                                   constant:kDistance * 0.5];
    NSLayoutConstraint *stickerCenterX = [NSLayoutConstraint constraintWithItem:self.stickerButton
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:0.5
                                                                 constant:20];
    NSLayoutConstraint *stickerWidth = [NSLayoutConstraint constraintWithItem:self.stickerButton
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1
                                                                 constant:60];
    NSLayoutConstraint *stickerHeight = [NSLayoutConstraint constraintWithItem:self.stickerButton
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:40];
    // 添加logo按钮约束
    NSLayoutConstraint *logoCenterY = [NSLayoutConstraint constraintWithItem:self.logoButton
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1
                                                                       constant:kDistance * 0.5];
    NSLayoutConstraint *logoCenterX = [NSLayoutConstraint constraintWithItem:self.logoButton
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.5
                                                                       constant:-20];
    NSLayoutConstraint *logoWidth = [NSLayoutConstraint constraintWithItem:self.logoButton
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1
                                                                     constant:60];
    NSLayoutConstraint *logoHeight = [NSLayoutConstraint constraintWithItem:self.logoButton
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1
                                                                      constant:40];
    // 添加约束
    [self.groupsCollectionView addConstraint:groupsHeight];
    [self.singleGroupCollectionView addConstraint:singleHeight];
    [self.hiddenButton addConstraints:@[btnWidth,btnHeight]];
    [self.stickerButton addConstraints:@[stickerHeight,stickerWidth]];
    [self.logoButton addConstraints:@[logoWidth,logoHeight]];
    
    [self.view addConstraints:@[groupsLeft,groupsRight,groupsTop,singleLeft,singleRight,singleTop,btnCenterY,btnRight,stickerCenterX,stickerCenterY,logoCenterX,logoCenterY,singleBackHeight,singleBackLeft,singleBackRight,singleBackTop]];
}

// 隐藏按钮点击
-(void)hiddenButtonClick{
    self.hideByUser = !self.isHideByUser;
    [self hiddenAnimation];
}
// 隐藏显示动画
-(void)hiddenAnimation{
    self.hideSelection = !self.isHideSelection;
    if (self.isHideSelection) {
        self.height.constant = kDistance;
        self.hiddenButton.transform = CGAffineTransformMakeRotation(M_PI);
    }else {
        self.height.constant = kHeight;
        self.hiddenButton.transform = CGAffineTransformIdentity;
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 图片移动开始通知处理
-(void)movingBeganClick{
    if (!self.isHideSelection) {
        [self hiddenAnimation];
    }
}
// 图片移动结束通知处理
-(void)movingEndClick{
    if (self.hideSelection && !self.isHideByUser) {
        [self hiddenAnimation];
    }
}
// 贴图按钮点击事件
-(void)stickerClick{
    self.stickerButton.selected = YES;
    self.logoButton.selected = NO;
    // 发放贴图按钮通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kStickerClickNotification object:nil];
    if (self.isHideSelection) {
        [self hiddenButtonClick];
    }
}
//logo按钮点击事件
-(void)logoClick{
    self.stickerButton.selected = NO;
    self.logoButton.selected = YES;
    // 发放logo按钮通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoClickNotification object:nil];
    if (self.isHideSelection) {
        [self hiddenButtonClick];
    }
}
// 获取数组时刷新数据
-(void)setSingleStickers:(NSArray *)singleStickers{
    _singleStickers = singleStickers;
    // 刷新数据
    [self.singleGroupCollectionView reloadData];
}
#pragma mark - collectionView数据源
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.singleStickers.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XTUploadSingleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    XTUploadSingleModel *model = self.singleStickers[indexPath.item];
    cell.single = model;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 将贴纸的名称传递
    XTUploadSingleModel *model = self.singleStickers[indexPath.item];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectSingleStickerNotification object:nil userInfo:@{@"model" : model}];
}

#pragma mark - 懒加载
// 组控制器视图
-(UICollectionView *)groupsCollectionView{
    if (_groupsCollectionView == nil) {
        // 创建控制器
        self.groupsController = [[XTGroupSelectionCollectionViewController alloc] init];
        // 添加到父控制器当中
        [self addChildViewController:self.groupsController];
        // 记录控制器视图
        _groupsCollectionView = _groupsController.collectionView;
        // 添加到视图
        [self.view addSubview:_groupsCollectionView];
    }
    return _groupsCollectionView;
}
// 单组视图
-(UICollectionView *)singleGroupCollectionView{
    if (_singleGroupCollectionView == nil) {
        // 创建视图
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _singleGroupCollectionView = collectionView;
        // 设置代理和数据源
        _singleGroupCollectionView.dataSource = self;
        _singleGroupCollectionView.delegate = self;
        _singleGroupCollectionView.showsHorizontalScrollIndicator = NO;
        _singleGroupCollectionView.contentInset = UIEdgeInsetsMake(0, kBigSize - kSingleLeftEdge, 0, 0);
        
        //在试图添加之前添加一个背景视图
        [self.view addSubview:self.singleBackgroundView];
        [self.view addSubview:collectionView];
    }
    return _singleGroupCollectionView;
}
-(UIView *)singleBackgroundView
{
    if (_singleBackgroundView == nil) {
        _singleBackgroundView = [[UIView alloc] init];
        _singleBackgroundView.backgroundColor = kBackColor;
    }
    return _singleBackgroundView;
}
// 单组视图布局
-(UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = kStickerSize;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

// 隐藏按钮
-(UIButton *)hiddenButton{
    if (_hiddenButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hiddenButton = btn;
        [btn setImage:[UIImage imageNamed:@"upload_hiddenSelection"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"upload_hiddenSelection_sel"] forState:UIControlStateHighlighted];
        [self.view addSubview:btn];
        // 监听隐藏点击事件
        [btn addTarget:self action:@selector(hiddenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hiddenButton;
}

// 快贴按钮
-(UIButton *)stickerButton{
    if (_stickerButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stickerButton = btn;
        [btn setImage:[UIImage imageNamed:@"upload_sticker"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"upload_sticker_sel"] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"upload_sticker_sel"] forState:UIControlStateSelected];
        [self.view addSubview:btn];
        // 监听贴图点击事件
        [btn addTarget:self action:@selector(stickerClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stickerButton;
}

// 快贴按钮
-(UIButton *)logoButton{
    if (_logoButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoButton = btn;
        [btn setImage:[UIImage imageNamed:@"upload_logo"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"upload_logo_sel"] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"upload_logo_sel"] forState:UIControlStateSelected];
        [self.view addSubview:btn];
        
        // logo点击事件
        [btn addTarget:self action:@selector(logoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoButton;
}
@end
