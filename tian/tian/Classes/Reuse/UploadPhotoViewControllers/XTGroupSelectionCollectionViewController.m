//
//  XTGroupSelectionCollectionViewController.m
//  collectionViewPlay
//
//  Created by Jiajun Zheng on 15/6/23.
//  Copyright (c) 2015年 zjProject. All rights reserved.
//

#import "XTGroupSelectionCollectionViewController.h"
#import "XTSingleSelectionController.h"
#import "XTUploadGroupCell.h"
#import "XTUploadGroupModel.h"
#import "JKImagePickerController.h"
#import "XTUploadSingleModel.h"
#import "XTUploadLogoCell.h"
#import "XTLocalImageStoreManage.h"
#import "UIImage+Capture.h"
#import "YYTAlertView.h"
#define kStickerGroupSize CGSizeMake(kBigSize,kBigSize)
#define kLogoSize CGSizeMake(kSmallSize,kSmallSize)
#define kAnimationDuration 0.3
#define kGroupEdgeLeft 8
@interface XTGroupSelectionCollectionViewController ()<JKImagePickerControllerDelegate,XTUpLoadLogoCellDelegate,UIAlertViewDelegate>
// 布局
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
// 动画左边视图和位置
@property (nonatomic, weak) UIView *animationLeftView;
@property (nonatomic, assign) CGRect animationLeftFrame;
// 动画右边视图和位置
@property (nonatomic, weak) UIView *animationRightView;
@property (nonatomic, assign) CGRect animationRightFrame;
// 返回视图
@property (nonatomic, weak) UIView *backButton;
// 判断是显示贴图还是logo
@property (nonatomic, assign,getter=isLogo) BOOL logo;
// 贴图模型数组
@property (nonatomic, strong) NSArray *strickerGroups;
// logo模型数组
@property (nonatomic, strong) NSArray *logoGroup;
// 判断是否被隐藏
@property (nonatomic, assign,getter=isHiddenSelection) BOOL hiddenSelection;
// 删除logo的索引
@property (nonatomic, assign) NSInteger deleteIndex;
@end

@implementation XTGroupSelectionCollectionViewController

static NSString * const reuseIdentifierSticker = @"stickerCell";
static NSString * const reuseIdentifierLogo = @"logoCell";
-(void)loadView{
    // 创建collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    self.collectionView = collectionView;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsZero;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, kGroupEdgeLeft, 0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Register cell classes
    [self.collectionView registerClass:[XTUploadGroupCell class] forCellWithReuseIdentifier:reuseIdentifierSticker];
    [self.collectionView registerClass:[XTUploadLogoCell class] forCellWithReuseIdentifier:reuseIdentifierLogo];
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = kBackColor;
    // 注册通知
    [self registerNotification];
}

// 注册通知
-(void)registerNotification{
    // 注册贴图点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stickerClick) name:kStickerClickNotification object:nil];
    // 注册logo点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoClick) name:kLogoClickNotification object:nil];
    // 注册刷新logo通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLogoGroup) name:kReloadLogoGroupNotification object:nil];
    // 注册是否隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenClick:) name:kHideNotification object:nil];
    
}

-(void)dealloc{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 视图消失的时候需要将动画视图也移除
    [self removeAnimationViews];

}
// 添加新的logo之后刷新
-(void)reloadLogoGroup{
    self.logoGroup = nil;
    [self.collectionView reloadData];
    if (!self.deleteIndex) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.logoGroup.count -1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

// 贴图点击
-(void)stickerClick{
    if (!self.isLogo) {
        [self reloadWithAnimation];
        return;
    }
    // 不是的话变成贴图界面
    self.logo = NO;
    self.flowLayout.itemSize = kStickerGroupSize;
    [self reloadWithAnimation];
}
// logo点击
-(void)logoClick{
    if (self.isLogo) {
        [self reloadWithAnimation];
        return;
    }
    // 不是的话变成logo界面
    self.logo = YES;
    // 判断自身是不是隐藏状态
    if (self.isHiddenSelection) {
        // 移除按钮
        [self.backButton removeFromSuperview];
        // 移除动画视图
        [self removeAnimationViews];
        // 显示collectionView
        self.collectionView.hidden = NO;
    }else{
        [self backClick];
    }
    self.flowLayout.itemSize = kLogoSize;
    [self reloadWithAnimation];
}
// 判断隐藏
-(void)hiddenClick:(NSNotification *)note{
    self.hiddenSelection = [note.userInfo[@"hide"] integerValue];
}

// 刷新到最前方
-(void)reloadWithAnimation{
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//    [UIView animateWithDuration:(self.collectionView.contentOffset.x / 600.0) animations:^{
//        self.collectionView.contentOffset = CGPointMake(-kGroupEdgeLeft, 0);
//    }completion:^(BOOL finished) {
//        
//    }];
}

// 展开动画
-(void)openAnimation:(UICollectionViewCell *)cell{
    // 根据window转换cell具体所在位置
    CGRect frame = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
    // 将当前情况进行截图
    UIView *snapShotLeft = [self.collectionView snapshotViewAfterScreenUpdates:YES];
    UIView *snapShotRight = [self.collectionView snapshotViewAfterScreenUpdates:YES];
    // 计算左右frame
    CGRect leftFrame = CGRectMake(0, frame.origin.y - kItemMerage, frame.origin.x + self.flowLayout.itemSize.width, self.collectionView.frame.size.height + kItemMerage * 2);
    CGRect rightFrame = CGRectMake(CGRectGetMaxX(leftFrame), frame.origin.y - kItemMerage, snapShotRight.frame.size.width - leftFrame.size.width, self.collectionView.frame.size.height + kItemMerage * 2);
    // 创建左边展示视图
    UIView *anmationLeftView = [[UIView alloc] initWithFrame:leftFrame];
    anmationLeftView.contentMode = UIViewContentModeScaleAspectFill;
    [anmationLeftView addSubview:snapShotLeft];
    anmationLeftView.clipsToBounds = YES;
    // 创建右边展示视图
    UIView *anmationRightView = [[UIView alloc] initWithFrame:rightFrame];
    anmationRightView.clipsToBounds = YES;
    anmationRightView.contentMode = UIViewContentModeScaleAspectFill;
    [anmationRightView addSubview:snapShotRight];
    snapShotRight.frame = CGRectMake(-leftFrame.size.width, 0, snapShotRight.frame.size.width, snapShotRight.frame.size.height);
    // 添加到window进行动画
    [[UIApplication sharedApplication].keyWindow addSubview:anmationLeftView];
    [[UIApplication sharedApplication].keyWindow addSubview:anmationRightView];
    
    // 记录动画视图
    self.animationLeftView = anmationLeftView;
    self.animationRightView = anmationRightView;
    // 记录初始位置
    self.animationLeftFrame = self.animationLeftView.frame;
    self.animationRightFrame = self.animationRightView.frame;
    
    // 设定动画
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.collectionView.hidden = YES;
        anmationLeftView.frame = CGRectMake(
                                            self.flowLayout.itemSize.width -
                                            anmationLeftView.frame.size.width,
                                            frame.origin.y - kItemMerage,
                                            anmationLeftView.frame.size.width,
                                            anmationLeftView.frame.size.height);
        anmationRightView.frame = CGRectMake(
                                             self.collectionView.frame.size.width,
                                             frame.origin.y - kItemMerage,
                                             anmationRightView.frame.size.width,
                                             anmationRightView.frame.size.height);
    }completion:^(BOOL finished) {
        // 添加收回的视图
        UIImage *snap = [UIImage captureShotWithView:cell];
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:snap forState:UIControlStateNormal];
        [backButton setImage:snap forState:UIControlStateHighlighted];
//        UIView *backButton = [cell snapshotViewAfterScreenUpdates:YES];
        backButton.backgroundColor = [UIColor clearColor];
        [self.collectionView.superview addSubview:backButton];
        //调整数值
        CGFloat hMerage = [UIScreen mainScreen].bounds.size.height < 667 ? 1: 0;
        if ([UIScreen mainScreen].bounds.size.height == 480) {
            hMerage = 0;
        }
        // 调整到具体位置
        backButton.frame = CGRectMake(0,
                                      kDistance,
                                      kBigSize,
                                      kBigSize + kItemMerage * 2 + hMerage);
        self.backButton = backButton;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClick)];
        [self.backButton addGestureRecognizer:tap];
        // 隐藏动画视图
        anmationLeftView.hidden = YES;
        anmationRightView.hidden = YES;
    }];
}

// 点击返回，闭合动画
-(void)backClick{
    [self.backButton removeFromSuperview];
    self.backButton = nil;
    self.animationLeftView.hidden = NO;
    self.animationRightView.hidden = NO;
    // 闭合动画
    [UIView animateWithDuration:kAnimationDuration animations:^{
        // 回到开合前的状态
        self.animationLeftView.frame = self.animationLeftFrame;
        self.animationRightView.frame = self.animationRightFrame;
    } completion:^(BOOL finished) {
        // 移除动画视图
        [self removeAnimationViews];
        // 显示collectionView
        self.collectionView.hidden = NO;
    }];
}
// 移除动画视图
-(void)removeAnimationViews{
    [self.animationLeftView removeFromSuperview];
    [self.animationRightView removeFromSuperview];
    self.animationLeftView = nil;
    self.animationRightView = nil;
}



#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isLogo) {
        return self.logoGroup.count;
    }
    return self.strickerGroups.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if (self.isLogo) {
        XTUploadLogoCell *logoCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLogo forIndexPath:indexPath];
        logoCell.delegate = self;
        XTUploadSingleModel *model = self.logoGroup[indexPath.item];
        logoCell.single = model;
        cell = logoCell;
    }else{
        XTUploadGroupCell *stickerCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierSticker forIndexPath:indexPath];
        XTUploadGroupModel *model = self.strickerGroups[indexPath.item];
        stickerCell.group = model;
        cell = stickerCell;
    }
    return cell;
}

#pragma mark - collectionView代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isLogo) {
        XTUploadSingleModel *model = self.logoGroup[indexPath.item];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSelectSingleStickerNotification object:nil userInfo:@{@"model": model}];
        return;
    }
    
    // 获取点击的cell
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    // 根据window转换cell具体所在位置
    CGRect frame = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
    // 发放通知
    XTUploadGroupModel *model = self.strickerGroups[indexPath.item];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectionGroupNotification object:nil userInfo:@{@"model": model}];
    // 判断该cell是否完全显示
    if (frame.origin.x < 0) {
        // 前半部分未显示出来
        CGFloat offsetX = (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing) * indexPath.item;
        
        // 手动滚动
        [UIView animateWithDuration:0.1 animations:^{
            self.collectionView.contentOffset = CGPointMake(offsetX, 0);
        } completion:^(BOOL finished) {
            // 结束正式开始展开动画
            [self openAnimation:cell];
        }];
    }else if(CGRectGetMaxX(frame) > [UIScreen mainScreen].bounds.size.width){
        
        // 后半部分未显示
        CGFloat offsetX = self.flowLayout.itemSize.width * (indexPath.item + 1) + self.flowLayout.minimumLineSpacing * indexPath.item - self.collectionView.frame.size.width;

        // 手动滚动
        [UIView animateWithDuration:0.1 animations:^{
            self.collectionView.contentOffset = CGPointMake(offsetX, 0);
        } completion:^(BOOL finished) {
            // 结束正是开始展开动画
            [self openAnimation:cell];
        }];
    }else{
        // 全部显示出来，直接调用动画方法
        [self openAnimation:cell];
    }
}
#pragma mark - XTUploadLoadLogoCellDelegate
-(void)uploadLogoCellDidLongPressed:(XTUploadLogoCell *)uploadLogoCell{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:uploadLogoCell];
    // 第一个无效
    if (indexPath.item == 0) {
        return;
    }
    // 记录索引
    self.deleteIndex = indexPath.item;
    // 弹框通知用户
    [YYTAlertView showFullTypeAlertViewWithTitle:@"删除logo" message:@"确定需要删除这个logo么" completaionBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            // 获取模型
            XTUploadSingleModel *model = self.logoGroup[self.deleteIndex];
            [[XTLocalImageStoreManage sharedLocalImageStoreManage] deleteLogoWithImageName:model.name];
            [self reloadLogoGroup];
            self.deleteIndex = 0;
        }
    }];
}
#pragma mark - 懒加载
// 布局属性
-(UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = kStickerGroupSize;
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
    }
    return _flowLayout;
}
-(NSArray *)strickerGroups{
    if (_strickerGroups == nil) {
        _strickerGroups = [XTUploadGroupModel uploadGroupModelWithList];
    }
    return _strickerGroups;
}

-(NSArray *)logoGroup{
    if (_logoGroup == nil) {
        _logoGroup = [XTUploadSingleModel uploadLogoSingleModelWithLocalList];
    }
    return _logoGroup;
}
@end
