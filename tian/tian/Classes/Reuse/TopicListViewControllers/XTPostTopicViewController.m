//
//  XTPostTopicViewController.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTPostTopicViewController.h"
#import "XTTabBarController.h"
#import "XTTextNumberControlView.h"
#import "XTLocalPhotoModel.h"
#import "XTPostTopicImageCell.h"
#import "JKPhotoBrowser.h"
#import "AddPhotoViewController.h"
#import "XTNavigationController.h"
#import "JKImagePickerController.h"
#import "YYTBarButtonItem.h"
#import "XTLocalImageStoreManage.h"
#import "XTUploadImageManage.h"
#import "YYTHUD.h"
#import "XTPhotoDisplayViewController.h"
#define kEdgeLength 5
#define kcolonNumber 3
@interface XTPostTopicViewController ()<XTTextNumberControlViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,JKImagePickerControllerDelegate>
/// 文本输入视图
@property (nonatomic, weak) XTTextNumberControlView *textView;
/// 文本部分父控件
@property (nonatomic, weak) UIView *textBaseView;
/// 分割线
@property (nonatomic, strong) UIView *lineView;
/// 标题文本
@property (nonatomic, weak) UILabel *titleLabel;
/// 计数文本
@property (nonatomic, weak) UILabel *textCountLabel;
/// 字数控制
@property (nonatomic, assign) NSInteger textCount;

/// 图片选择视图
@property (nonatomic, weak) UICollectionView *collectionView;
/// 布局
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) CGSize itemSize;

/// 模型数组
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSMutableArray *assetsArray;

/// 贴纸信息储存
@property (nonatomic, strong) NSArray *stickersInfo;

/// 发布按钮
@property (nonatomic, weak) YYTBarButtonItem *rightBaritem;

///判断是否正在上传
@property (nonatomic, assign,getter=isUploading) BOOL uploading;

@end

@implementation XTPostTopicViewController
static NSString * const reuseIdentifierPhoto = @"photoCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // 删除本地图片
    [XTLocalImageStoreManage deletePhotoFolder];
    // Do any additional setup after loading the view.
    // 关闭自动滚动属性
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 添加确定按钮
    YYTBarButtonItem *rightBaritem = [YYTBarButtonItem barItemWithImageName:@"upload_ture" target:self action:@selector(uploadTopic)];
    rightBaritem.enabled = NO;
    self.rightBaritem = rightBaritem;
    self.navigationItem.rightBarButtonItem = rightBaritem;
    // 注册cell
    [self.collectionView registerClass:[XTPostTopicImageCell class] forCellWithReuseIdentifier:reuseIdentifierPhoto];
    // 添加约束
    [self addConstraints];
    // 注册通知
    [self addNotifications];
}
// 注册通知
-(void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveInfo:) name:kStickersInfoSaveNotifiacation object:nil];
}
// 储存信息
-(void)saveInfo:(NSNotification *)note{
    self.stickersInfo = note.userInfo[@"info"];
    self.assetsArray = note.userInfo[@"assertsArray"];
}
// 添加约束
-(void)addConstraints{
    
    [self.textBaseView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@8);
        make.right.equalTo(@-kEdgeLength);
        make.left.equalTo(@kEdgeLength);
        make.height.equalTo(@140);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@8);
        make.left.equalTo(@8);
    }];
    
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@kEdgeLength);
        make.top.equalTo(self.titleLabel.bottom).with.offset(@0);
        make.right.equalTo(@-kEdgeLength);
        make.height.equalTo(@100);
    }];
    
    [self.textCountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(@-kEdgeLength);
    }];
    
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textBaseView.bottom).with.offset(@8);
        make.left.equalTo(@kEdgeLength);
        make.right.equalTo(@-kEdgeLength);
        make.bottom.equalTo(@-kEdgeLength);
    }];
    
    
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textBaseView);
        make.bottom.equalTo(self.textBaseView);
        make.height.equalTo(@1);
    }];
}
// cell点击
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // 点击结束编辑
    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"发布话题";
    self.navigationController.navigationBar.translucent = NO;
    self.photos = nil;
    [self.collectionView reloadData];
    // 判断是否可以点击发布
    // 文字为空不可点
    self.rightBaritem.enabled = self.textView.text.length != 0 && self.photos.count > 1;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 手动触发文本编辑
        [self.textView becomeFirstResponder];
    });
}

-(void)uploadTopic{
    if ([[XTHTTPRequestOperationManager sharedManager] reachable] == NO) {
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow
                         withText:@"网络未连接"
              withCompletionBlock:nil];
        return;
    }
    // 判断需要上传的内容
    [YYTHUD showLoadingAddedTo:self.view];
    self.rightBaritem.enabled = NO;
    //注册上传完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadResult:) name:UploadImageSucceedNotification object:nil];
    // 上传话题
    NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicM setObject:self.textView.text forKey:@"description"];
    [dicM setObject:@(self.topicId) forKey:@"topicId"];
    XTUploadImageManage *upLoadImageManage = [XTUploadImageManage shareUploadImageManage];
    upLoadImageManage.type = XTUploadImageTypeTopic;
    upLoadImageManage.albumParameterDic = dicM;
    self.uploading = YES;
    [upLoadImageManage uploadImages:[XTLocalPhotoModel localPhotoModelWithList]];
}
// 上传结果
-(void)uploadResult:(NSNotification *)note{
    [YYTHUD hideLoadingFrom:self.view];
    NSString *result = [note.object objectForKey:@"message"];
    if ([result isEqualToString:@"照片上传成功"]) {
        // 上传完成回调
        if (self.completionBlock) {
            self.completionBlock();
        }
        // 删除本地照片
        [XTLocalImageStoreManage deletePhotoFolder];
        // 发送通知通知主页界面的参与话题信息
        [self postNitifications];
        // 弹出
        [self.navigationController popViewControllerAnimated:YES];

    }else{
        self.rightBaritem.enabled = YES;
        // 提示上传失败
        NSLog(@"上传图片失败:%@",result);
        if ([[result substringToIndex:4] isEqualToString:@"网络错误"]) {
            result = @"网络错误,上传失败";
        }else if(result == nil){
            result = @"上传失败";
        }
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:result withCompletionBlock:nil];
    }
}
-(void)postNitifications{
    // 发送通知通知主页界面的参与话题信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserTopicNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserFilesNotification" object:nil];
}
- (void)clickNaBackBtn:(UIButton *)sender
{
    // 额外处理
    [XTLocalImageStoreManage deletePhotoFolder];
    if (self.isUploading) {
        XTUploadImageManage *upLoadImageManage = [XTUploadImageManage shareUploadImageManage];
        [upLoadImageManage cancelOperation];
        self.uploading = NO;
    }
    // 弹出
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark XTTextNumberControlViewDelegate
-(void)textNumberControlView:(XTTextNumberControlView *)textView numberOfText:(NSInteger)numberOfText{
    // 文字为空不可点
    self.rightBaritem.enabled = numberOfText != 0 && self.photos.count > 1;
    // 追踪字数
    self.textCountLabel.text = [NSString stringWithFormat:@"%zd/%zd",numberOfText,self.textCount];
}
#pragma mark collectionView数据源
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XTPostTopicImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierPhoto forIndexPath:indexPath];
    cell.model = self.photos[indexPath.item];
    return cell;
}
#pragma mark collectionView代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 关闭文本编辑
    [self.view endEditing:YES];
    // 处理图片
    XTLocalPhotoModel *model = self.photos[indexPath.item];
    if (model.smallName == nil) {
        if ([UIViewController tabBarController].isImageUploadComplete) {
            JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.showsCancelButton = YES;
            imagePickerController.allowsMultipleSelection = YES;
            imagePickerController.minimumNumberOfSelection = 1;
            imagePickerController.maximumNumberOfSelection = 9;
            imagePickerController.alreadySelectedNumber = self.photos.count - 1; // 数组中有+符号故要减去1个空格
            imagePickerController.selectedAssetArray = nil;
            imagePickerController.needPush = YES;
            imagePickerController.needPop = YES;
            UINavigationController *navigationController = [[XTNavigationController alloc] initWithRootViewController:imagePickerController];
            [self presentViewController:navigationController animated:YES completion:NULL];
            return;
        }else{
            [YYTHUD showPromptAddedTo:self.view withText:@"当前有正在上传的图片" withCompletionBlock:nil];
            return;
        }        // 添加图片
    }
//    // 查看图片
//    AddPhotoViewController *addPhotoCtr = [[AddPhotoViewController alloc] init];
//    addPhotoCtr.oldAssertsArray = self.assetsArray;
//    addPhotoCtr.needPop = YES;
//    addPhotoCtr.imageIndexForNow = indexPath.item;
//    // 传递数据
//    addPhotoCtr.oldInfo = self.stickersInfo;
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"NO",@"isShowTabBar",nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"isShowTabBarNotification" object:dic];
//    [self.navigationController pushViewController:addPhotoCtr animated:YES];
    // 预览图片
    XTPhotoDisplayViewController *pVC = [[XTPhotoDisplayViewController alloc] init];
    pVC.currentPage = indexPath.item;
    // 剔除添加符号
    XTLocalPhotoModel *checkModel = self.photos.lastObject;
    if (checkModel.smallName != nil) {
        pVC.photos = self.photos;
    }else{
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.photos];
        [arrayM removeLastObject];
        pVC.photos = arrayM.copy;
    }
    @weakify(self);
    [pVC setCompletionBlock:^(NSArray *indexArray) {
        @strongify(self);
        [self deletePhotoAtIndexArray:indexArray];
    }];
    
    [self presentViewController:pVC animated:YES completion:nil];
}

// 删除图片
- (void)deletePhotoAtIndexArray:(NSArray *)indexArray{
    // 删除图片
    for (NSNumber *index in indexArray) {
        XTLocalPhotoModel *model = self.photos[index.integerValue];
        [[XTLocalImageStoreManage sharedLocalImageStoreManage] deletePhotoWithImageName:model.name];
    }
    self.photos = nil;
    [self.collectionView reloadData];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"%s",__func__);
}
#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
//    [imagePicker dismissViewControllerAnimated:YES completion:^{
//        AddPhotoViewController *addPhotoCtr = [[AddPhotoViewController alloc] init];
//        addPhotoCtr.oldInfo = self.stickersInfo;
//        addPhotoCtr.oldAssertsArray = self.assetsArray;
//        addPhotoCtr.alreadySelectedNumber = self.photos.count - 1;
//        addPhotoCtr.assetsArray = [NSMutableArray arrayWithArray:assets];
//        addPhotoCtr.selectedAssetIndexArray = imagePicker.selectedAssetIndexArray;
//        addPhotoCtr.needPop = YES;
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"NO",@"isShowTabBar",nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"isShowTabBarNotification" object:dic];
//        [self.navigationController pushViewController:addPhotoCtr animated:YES];
//    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark 懒加载
// 文本父视图
-(UIView *)textBaseView{
    if (_textBaseView == nil) {
        UIView *view = [[UIView alloc]init];
        [self.view addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        _textBaseView = view;
    }
    return _textBaseView;
}
// 文本输入控制视图
-(XTTextNumberControlView *)textView{
    if (_textView == nil) {
        XTTextNumberControlView *textView = [[XTTextNumberControlView alloc] init];
        [self.textBaseView addSubview:textView];
        textView.count = self.textCount;
        textView.countDelegate = self;
        _textView = textView;
    }
    return _textView;
}
// 标题文本
-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        [self.textBaseView addSubview:label];
        label.text = [NSString stringWithFormat:@"#%@#",self.topicTitle];
        label.font = [UIFont boldSystemFontOfSize:12];
        label.textColor = UIColorFromRGB(0x4f242b);
        _titleLabel = label;
    }
    return _titleLabel;
}
// 计数文本
-(UILabel *)textCountLabel{
    if (_textCountLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        [self.textBaseView addSubview:label];
        label.textColor = [UIColor lightGrayColor];
        label.text = [NSString stringWithFormat:@"0/%zd",self.textCount];
        label.font = [UIFont systemFontOfSize:11];
        _textCountLabel = label;
    }
    return _textCountLabel;
}
// 字数控制数目
-(NSInteger)textCount{
    if (_textCount == 0) {
        _textCount = 140;
    }
    return _textCount;
}
// 布局
-(UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = self.itemSize;
        _flowLayout.minimumInteritemSpacing = 3;
        _flowLayout.minimumLineSpacing =3;
    }
    return _flowLayout;
}
// 图片选择视图
-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        [self.view addSubview:view];
        view.backgroundColor = [UIColor clearColor];
        view.showsVerticalScrollIndicator = NO;
        view.dataSource = self;
        view.delegate = self;
        view.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        view.backgroundColor = [UIColor clearColor];
        _collectionView = view;
    }
    return _collectionView;
}
// cell大小
-(CGSize)itemSize{
    if (CGSizeEqualToSize(_itemSize,CGSizeZero)) {
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 2 * kEdgeLength - 3 * (kcolonNumber - 1)) / kcolonNumber;
        CGFloat height = width;
        _itemSize = CGSizeMake(width, height);
    }
    return _itemSize;
}
// 图片数组
-(NSArray *)photos{
    if (_photos == nil) {
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:[XTLocalPhotoModel localPhotoModelWithList]];
        if (arrayM.count < 9) {
            XTLocalPhotoModel *model = [XTLocalPhotoModel localPhotoModelAddModel];
            [arrayM addObject:model];
        }
        _photos = arrayM;
    }
    return _photos;
}
//分割线线条
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = UIColorFromRGB(0xececec);
        [self.textBaseView addSubview:_lineView];
    }
    return _lineView;
}
@end
