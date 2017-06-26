//
//  AddPhotoViewController.m
//  tian
//
//  Created by 曹亚云 on 15-5-25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "AddPhotoViewController.h"
#import "XTTabBarController.h"
#import "UploadPhotoViewController.h"
#import "JKImagePickerController.h"
#import "PhotoCell.h"
#import "ZDStickerView.h"
#import "XTSingleSelectionController.h"
#import "XTUploadImageStickerInfo.h"
#import "JKAssets.h"
#import "XTUploadPhotoView.h"
#import "XTUploadStickerInfo.h"
#import "XTUploadSingleModel.h"
#import "UIColor+HexColors.h"
#import "XTLocalImageStoreManage.h"
#import "UIImage+Capture.h"
#import "YYTHUD.h"
#import "XTGuideManage.h"
#import "XTGuideImageCreateView.h"
#import "XTPhotoCanSelectCell.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <CommonCrypto/CommonDigest.h>
#define kPhotoImageDefaultCenter CGPointMake(SCREEN_SIZE.width * 0.5, (SCREEN_SIZE.height - 64 - kDistance) * 0.5)
@interface AddPhotoViewController ()<JKImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ZDStickerViewDelegate,UITextFieldDelegate,XTGuideImageCreateViewDelegate>
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, strong) XTUploadPhotoView *photoImageView;
// 单选控制器
@property (nonatomic, strong) XTSingleSelectionController *selectionController;
// 单选控制器视图
@property (nonatomic, weak) UIView *selectionView;
// 所有图片数组
@property (nonatomic, strong) NSMutableArray *imagesInfo;
// 贴图视图
@property (nonatomic, strong) NSMutableArray *stickerViews;
// 用于输入框的textField
@property (nonatomic, strong) UITextField *textField;
// 是否是logo调用相册
@property (nonatomic, assign,getter=isLogoPicker) BOOL logoPicker;
// 合成遮盖
@property (nonatomic, weak) UIImageView *dummyView;
// save
@property (nonatomic, assign,getter=isSave) BOOL save;
// 数组模型
@property (atomic, strong) NSArray *stickersInfo;
// 遮罩
@property (nonatomic, strong) UIView *guideMask;
// 引导视图
@property (nonatomic, strong) XTGuideImageCreateView *guideCollectionView;
// 引导显示按钮
@property (nonatomic, strong) UIImageView *guideStickerImageView;
@property (nonatomic, strong) UIImageView *guideLogoImageView;
// 手势移动开始点
@property (nonatomic, assign) CGPoint panStartPoint;

//为了解决照片流图片贴纸问题保存所有照片流图片
@property (nonatomic, strong) NSMutableArray *photoStreamList;

// 照片提取器
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

// 当前所看的相册图片
@property (nonatomic, strong) UIImage *photo;

// 判断是否需要保存节点
@property (nonatomic, assign) BOOL needSave;

@end

@implementation AddPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:UIIMAGE(@"upload_ture") forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.mainView = [[UIView alloc] init];
    self.mainView.backgroundColor = kBackColor;
    [self.view addSubview:self.mainView];
    
    [self.mainView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.navigationItem.titleView = self.photoCollectionView;
    
    [self.photoCollectionView reloadData];
    [self configureBottomToolView];
    // 关闭自动inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 添加约束
    [self addConstraints];
    self.selectionView.backgroundColor = [UIColor whiteColor];
    
    // 注册通知
    [self addNotifications];
    
    // 点击快贴
    [self.selectionController stickerClick];
    
    self.fd_interactivePopDisabled = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 关闭
    [self.view endEditing:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // 防止文本没有移除
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    // 清空照片流数组缓存的图片
    self.photoStreamList = nil;
    // 开启用户交互
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 关闭
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    self.save = NO;
    [self.photoCollectionView reloadData];
    // 添加贴图
    if (self.imageIndexForNow >= self.assetsArray.count) {
        self.imageIndexForNow = self.assetsArray.count - 1;
    }else if(self.imageIndexForNow < 0){
        self.imageIndexForNow = 0;
    }
//    [self saveStickersInfo];
    [self selectImageAtIndex:self.imageIndexForNow completion:nil];
    
     NSLog(@"%@",self.selectedAssetIndexArray);
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view endEditing:YES];
    // 判断是否是第一次来
    if ([XTGuideManage checkPhotoCreateNeeded]) {
        //进行引导
        [self guide];
    }
    // 防止文本没有移除
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
-(void)guide{
    // 保存数据
    [XTGuideManage setPhotoCreateNeeded];
    // 进行引导
    [self.guideMask makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, kHeight - kDistance, 0));
    }];
    UIView *window = [UIApplication sharedApplication].keyWindow;
    [self.guideCollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(kGuideImageCreateItemHeight);
        make.width.equalTo(kGuideImageCreateItemWidth);
        make.centerX.equalTo(window.centerX);
        make.centerY.equalTo(window.centerY);
    }];
    CGPoint stickerCenter = self.selectionController.stickerButton.center;
    CGPoint logoCenter = self.selectionController.logoButton.center;
    
    CGPoint guideStickerCenter = [self.selectionView convertPoint:stickerCenter toView:[UIApplication sharedApplication].keyWindow];
    CGPoint guideLogoCenter = [self.selectionView convertPoint:logoCenter toView:[UIApplication sharedApplication].keyWindow];
    self.guideStickerImageView.center = guideStickerCenter;
    self.guideLogoImageView.center = guideLogoCenter;
    
    self.guideLogoImageView.hidden = YES;
}
// 注册通知
-(void)addNotifications{
    // 用户选择具体贴纸通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseSticker:) name:kSelectSingleStickerNotification object:nil];
    // textField输入通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:nil];
    
}
// 文本改变
-(void)textChange{
    // 获取文本
    ZDStickerView *view = self.stickerViews.lastObject;
    UILabel *label = view.contentView.subviews.lastObject;
    // 赋值文字
    label.text = self.textField.text;
    label.alpha = 0;
    // 记录当前中心
    CGPoint center = label.center;
    // 调整大小
    [label sizeToFit];
    // 差值
    CGFloat widthDelta = 45.0;

    // 贴纸大小
    CGFloat width = 200;
    if (label.bounds.size.width > width) {
        // 计算宽度
        width = label.bounds.size.width;
    }
    if(width > (SCREEN_SIZE.width - 20)){
        width = (SCREEN_SIZE.width - 20);
    }

    // 如果大小不够，保持，够了往外扩
    if (view.frame.size.width < (label.frame.size.width + widthDelta) || view.frame.size.width > width) {
        CGFloat viewWidth = width + widthDelta;
        view.bounds = CGRectMake(0, 0, viewWidth, view.bounds.size.height);
        // 如果大小改变中心要变
        label.bounds = CGRectMake(0, 0, width, label.frame.size.height);
        self.textField.bounds = label.bounds;
        label.center = CGPointMake(view.contentView.frame.size.width * 0.5,view.contentView.frame.size.height * 0.5);
        return;
    }
    label.bounds = CGRectMake(0, 0, width, label.frame.size.height);
    self.textField.bounds = label.bounds;
    label.center = center;
}
// 获取旧数据
-(void)setOldInfo:(NSArray *)oldInfo{
    _oldInfo = oldInfo;
    self.stickersInfo = oldInfo;
}
-(void)setOldAssertsArray:(NSArray *)oldAssertsArray{
    _oldAssertsArray = oldAssertsArray;
    self.assetsArray = [NSMutableArray arrayWithArray:oldAssertsArray];
}

//选择具体贴纸
-(void)chooseSticker:(NSNotification *)note{
    NSDictionary *dic = note.userInfo;
    XTUploadSingleModel *model= dic[@"model"];
    if (model.type.integerValue == 3) {
        // 选择logo
        [self composeLogoAdd];
        return;
    }
    if (self.stickerViews.count >= 5) {
        //只能贴5个贴纸
        [YYTHUD showPromptAddedTo:self.view withText:@"贴纸不能超过5张!" withCompletionBlock:nil];
        return;
    }
    [self addStickerWithIndex:-1 andModel:model];
}
- (void)composeLogoAdd
{
    [self saveStickersInfoWithCompelectionBlock:^{
        // 判断是否是选择logo
        self.logoPicker = YES;
        JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.showsCancelButton = YES;
        imagePickerController.allowsMultipleSelection = NO;
        imagePickerController.minimumNumberOfSelection = 1;
        imagePickerController.maximumNumberOfSelection = 1;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }];

}
// 根据assetPropertyURL获取图片
-(void)imageWithAssetPropertyURL:(NSURL *)propertyURL withCompeletionBlock:(void(^)(UIImage *image))compeletionBlock{
    [self.assetsLibrary assetForURL:propertyURL
                        resultBlock:^(ALAsset *asset)
     {
         if (asset){
             UIImage *photoImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
             if(compeletionBlock){
                 compeletionBlock(photoImage);
             }
         }
         else {
             // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
             [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                               usingBlock:^(ALAssetsGroup *group, BOOL *stop)
              {
                  [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger indexG, BOOL *stop) {
                      if([result.defaultRepresentation.url isEqual:propertyURL])
                      {
                          UIImage *photoImage = [UIImage imageWithCGImage:[[result defaultRepresentation] fullScreenImage]];
                          if(compeletionBlock){
                              compeletionBlock(photoImage);
                          }
                          *stop = YES;
                      }
                  }];
              }
              
                                             failureBlock:^(NSError *error)
              {
                  NSLog(@"Error: Cannot load asset from photo stream - %@", [error localizedDescription]);
                  
                  
              }];
         }
     
     }
                       failureBlock:^(NSError *error)
     {
         NSLog(@"Error: Cannot load asset - %@", [error localizedDescription]);
         
     }
     ];

}
// 选择图片
-(void)selectImageAtIndex:(NSInteger)index completion:(void(^)(UIImage *image, NSURL *assetPropertyURL))completionBlock{
    //加载图片
    JKAssets *assets = self.assetsArray[index];
    @weakify(self);
    [self.assetsLibrary assetForURL:assets.assetPropertyURL
             resultBlock:^(ALAsset *asset)
     {
         @strongify(self);
         if (asset){
             // 移除图片和贴纸
             [self photoImageRemoveAllStickersAndSelf];
             UIImage *photoImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
             self.photoImageView.bounds = [self calculateBoundsWithImage:photoImage];
             self.photoImageView.image = photoImage;
             self.photo = photoImage;
             [self addAllStickers];
         }
         else {
             if (self.isSave) {
                 @strongify(self);
                 // 移除图片和贴纸
                 [self photoImageRemoveAllStickersAndSelf];
                 // 根据URL 从图片数组获取图片
                 UIImage *photoImage = [self imageWithURL:assets.assetPropertyURL];
                 self.photoImageView.bounds = [self calculateBoundsWithImage:photoImage];
                 self.photoImageView.image = photoImage;
                 self.photo = photoImage;
                 [self addAllStickers];
             }else{
                 // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
                 @weakify(self);
                 [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                    usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                  {
                      @strongify(self);
                      @weakify(self);
                      [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger indexG, BOOL *stop) {
                          if([result.defaultRepresentation.url isEqual:assets.assetPropertyURL])
                          {
                              @strongify(self);
                              // 移除图片和贴纸
                              [self photoImageRemoveAllStickersAndSelf];
                              UIImage *photoImage = [UIImage imageWithCGImage:[[result defaultRepresentation] fullScreenImage]];
                              self.photoImageView.bounds = [self calculateBoundsWithImage:photoImage];
                              self.photoImageView.image = photoImage;
                              [self addAllStickers];
                              if (completionBlock) {
                                  completionBlock(photoImage,assets.assetPropertyURL);
                              }
                              *stop = YES;
                          }
                      }];
                  }
                  
                                  failureBlock:^(NSError *error)
                  {
                      NSLog(@"Error: Cannot load asset from photo stream - %@", [error localizedDescription]);
                      
                      
                  }];
             }
         }
         
     }
            failureBlock:^(NSError *error)
     {
         NSLog(@"Error: Cannot load asset - %@", [error localizedDescription]);
         
     }
     ];

}

///图片文件名MD5
- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return filename;
}

//根据URL获取图片
-(UIImage *)imageWithURL:(NSURL *)url{
    for (NSDictionary *dic in self.photoStreamList) {
        if (dic[@"URL"] == url) {
            return dic[@"image"];
        }
    }
 return nil;
}
// 按图片比例计算宽高
-(CGRect)calculateBoundsWithImage:(UIImage *)image{
    CGSize imageSize = image.size;
    CGFloat resultWidth;
    CGFloat resultHeight;
    CGFloat scale = imageSize.width / imageSize.height;
    CGFloat screenScale = SCREEN_SIZE.width / (SCREEN_SIZE.height - 64 - kDistance);
    if (scale >= screenScale) {
        resultWidth = [UIScreen mainScreen].bounds.size.width;
        resultHeight = resultWidth / scale;
    }else{
        resultHeight = [UIScreen mainScreen].bounds.size.height - 64 - kDistance;
        resultWidth = resultHeight * scale;
    }
    CGRect frame = CGRectMake(0, 0, resultWidth, resultHeight);
    return frame;
}

// 移除贴图和贴纸
-(void)photoImageRemoveAllStickersAndSelf{
    for (UIView *view in self.photoImageView.subviews) {
        [view removeFromSuperview];
    }
    [self.photoImageView removeFromSuperview];
    self.photoImageView = nil;
    self.stickerViews = nil;
}

// 创建贴图
-(UIImageView *)createStickerWithName:(NSString *)name andBounds:(CGRect)bounds andType:(NSNumber *)type{
    UIImage *image;
    if (type.integerValue == 2) {
        // 加载logo图片
        image = [[XTLocalImageStoreManage sharedLocalImageStoreManage] logoImageWithName:name];
    }else{
        image = [UIImage imageNamed:name];
    }
    UIImageView *zdImageView = [[UIImageView alloc] initWithImage:image];
    zdImageView.bounds = bounds;
    return zdImageView;
}
// 添加所有标签
-(void)addAllStickers{
    // 获取当前操作的图片信息模型
    XTUploadImageStickerInfo *imageInfo = self.stickersInfo[self.imageIndexForNow];
    // 循环遍历内部的标签属性模型
    for (int i = 0; i<imageInfo.stickersInfo.count; i++) {
        [self addStickerWithIndex:i andModel:nil];
    }
}

// 添加标签
-(void)addStickerWithIndex:(NSInteger)index andModel:(XTUploadSingleModel *)model{
    XTUploadStickerInfo *stickerInfo;
    BOOL needHide = YES;
    BOOL needText = NO;
    NSString *name = model.name;
    BOOL isLabel = model.type.integerValue == 1;
    NSNumber *type = model.type;
    UIColor *labelColor;
    
    // 为文本框准备的中心位置
    CGPoint textFieldCenter;
    // 如果传递的-1表示是新加的
    if (index == -1) {
        NSLog(@"添加了新的贴纸");
        self.needSave = YES;
        // 在默认位置创建
        CGPoint center = CGPointMake(self.photoImageView.frame.size.width * 0.5, self.photoImageView.frame.size.height * 0.3);
        textFieldCenter = center;
        stickerInfo = [XTUploadStickerInfo uploadStickerInfoWithType:type withCenter:center];
        needHide = NO;
        needText = YES;
        labelColor = [UIColor colorWithHexString:model.color];
    }else {
        // 根据信息提供具体位置
        XTUploadImageStickerInfo *info = self.stickersInfo[self.imageIndexForNow];
        stickerInfo = info.stickersInfo[index];
        name = stickerInfo.stickerName;
        isLabel = stickerInfo.type.integerValue == 1;
        type = stickerInfo.type;
        labelColor = [UIColor colorWithHexString:stickerInfo.textColor];
    }
    UIView *zdImageView;
    // 判断是不是快贴
    if (isLabel) {
        zdImageView = [[UIView alloc] initWithFrame:stickerInfo.stickerBounds];
        zdImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:name]];
        UILabel *label = [[UILabel alloc] initWithFrame:stickerInfo.stickerBounds];
        // 添加文字
        label.text = stickerInfo.stickerLabelText;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = labelColor;
        [zdImageView addSubview:label];
    }else {
        zdImageView = [self createStickerWithName:name andBounds:stickerInfo.stickerBounds andType:type];
    }
    ZDStickerView *userResizableView = [[ZDStickerView alloc] initWithFrame:zdImageView.bounds];
    zdImageView.contentMode = UIViewContentModeScaleAspectFit;
    userResizableView.contentView = zdImageView;
    userResizableView.preventsPositionOutsideSuperview = NO;
    userResizableView.translucencySticker = NO;
    userResizableView.stickerViewDelegate = self;
    
    [userResizableView showEditingHandles];
    [self.photoImageView bringSubviewToFront:userResizableView];
    [self.photoImageView addSubview:userResizableView];
    
    // 记录图片名称
    userResizableView.stickerName = name;
    // 赋值属性
    userResizableView.center = stickerInfo.stickerCenter;
    userResizableView.bounds = stickerInfo.stickerBounds;
    userResizableView.transform = stickerInfo.stickerTransform;
    userResizableView.type = stickerInfo.type;
    userResizableView.keepHeight = stickerInfo.type.integerValue == 1;
    [self.stickerViews addObject:userResizableView];
    // 判断是否需要隐藏
    [userResizableView whetherHide:needHide];
    if (isLabel && needText) {
        self.textField.hidden = NO;
        [self.textField becomeFirstResponder];
        textFieldCenter = [self.mainView convertPoint:textFieldCenter fromView:self.photoImageView];
        self.textField.center = textFieldCenter;
        [self.mainView bringSubviewToFront:self.textField];
        [userResizableView whetherHide:YES];
    }
}
// 添加约束
- (void)addConstraints{
    // 关闭autoResizing
    self.selectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.photoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 创建约束groupsCollectionView
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.selectionView
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.selectionView
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.selectionView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.selectionView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:kHeight];
    
    // 添加约束
    [self.selectionView addConstraint:height];
    [self.view addConstraints:@[left,right,bottom]];

    // 记录约束用于调制
    self.selectionController.height = height;
}

// assetsArray重写setter方法
-(void)setAssetsArray:(NSMutableArray *)assetsArray{
    // 赋值
    _assetsArray = assetsArray;
    // 遍历两个数组，根据图片数组创建或者修改数组
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:assetsArray.count];
    for (JKAssets *asset in _assetsArray) {
        BOOL exit = NO;
        // 判断原先的数组是否有该图片的信息模型
        for (XTUploadImageStickerInfo *stickerInfo in self.stickersInfo) {
            /// 判断该图片的具体url是否相同，使同一个图片没有删除就会一直保存上面的贴纸信息
            if ([stickerInfo.asset.assetPropertyURL.absoluteString isEqualToString:asset.assetPropertyURL.absoluteString ]) {
                exit = YES;
                // 如果有，将对应的模型添加到模型数组中
                [arrayM addObject:stickerInfo];
            }
        }
        // 如果没有，添加一个默认模型
        if (!exit) {
            XTUploadImageStickerInfo *info = [XTUploadImageStickerInfo UploadImageWithAsset:asset];
            [arrayM addObject:info];
        }
    }
    // 修改目前的数组为最新的数组
    self.stickersInfo = arrayM.copy;
    self.nameArray = [self photoNameArray];
}
// 根据当前图片信息数组生成保存图片的文件名数组
-(NSArray *)photoNameArray{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (XTUploadImageStickerInfo *info in self.stickersInfo) {
        NSString *fileName = [self cachedFileNameForKey:info.asset.assetPropertyURL.absoluteString];
        [arrayM addObject:fileName];
    }
    return arrayM;
}
// 根据图片的key保存图片
-(void)storePhotoImagesWithNameSet:(NSSet *)nameSet withCompeletionBlock:(void(^)())compeletionBlock{
    if (nameSet.count == 0) {
        if (compeletionBlock) {
            compeletionBlock();
        }
        return;
    }
    NSLog(@"%zd图片需要创建",nameSet.count);
    // 子线程异步执行
    dispatch_async([XTLocalImageStoreManage sharedLocalImageStoreManage].ioQueue, ^{
        dispatch_group_t group = dispatch_group_create();
        // 调度组控制所有图片修改完毕
        dispatch_group_enter(group);
        for (XTUploadImageStickerInfo *info in self.stickersInfo) {
            NSString *fileName = [self cachedFileNameForKey:info.asset.assetPropertyURL.absoluteString];
            if ([nameSet containsObject:fileName]) {
                // 调度组控制所有图片修改完毕
                dispatch_group_enter(group);
                // 需要添加，故添加该图片
                [self imageWithAssetPropertyURL:info.asset.assetPropertyURL withCompeletionBlock:^(UIImage *image) {
                    [[XTLocalImageStoreManage sharedLocalImageStoreManage] storePhoto:image withKey:[self cachedFileNameForKey:info.asset.assetPropertyURL.absoluteString] completion:^{
                        NSLog(@"合成图片");
                        // 添加完毕
                        dispatch_group_leave(group);
                    }];
                }];
            }
        }
        // 防止第一张图片不符合直接跳出调度组
        dispatch_group_leave(group);
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"全部照片储存完毕");
            if (compeletionBlock) {
                compeletionBlock();
            }
        });
    });
}
// 保存当前操作图片的贴图信息
-(void)saveStickersInfoWithCompelectionBlock:(void(^)())compelectionBlock{
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    // 将保存和切换图片包装成一个任务防止上面的loading不显示
    @weakify(self);
    dispatch_async([XTLocalImageStoreManage sharedLocalImageStoreManage].ioQueue, ^{
        @strongify(self);
        // 当前操作图片信息的模型
        NSMutableArray *arryM = [NSMutableArray arrayWithCapacity:self.stickerViews.count];
        // 循环遍历所有的贴图
        for (ZDStickerView *stickerView in self.stickerViews) {
            // 根据贴图信息创建一个贴图信息模型
            XTUploadStickerInfo *stickerInfo = [[XTUploadStickerInfo alloc] initWithStickerName:stickerView.stickerName stickerCenter:stickerView.center stickerBounds:stickerView.bounds stickerTransform:stickerView.transform andType:stickerView.type];
            if (stickerView.isKeepHeight) {
                // 保存文字
                UILabel *label = stickerView.contentView.subviews.lastObject;
                stickerInfo.stickerLabelText = label.text;
                stickerInfo.textColor = [UIColor hexValuesFromUIColor:label.textColor];
            }
            // 将贴图信息添加到数组当中
            [arryM addObject:stickerInfo];
        }
        // 保存贴图信息数组
        XTUploadImageStickerInfo *info = self.stickersInfo[self.imageIndexForNow];
        info.stickersInfo = arryM;
        // 隐藏所有贴纸
        for (ZDStickerView *stickerView in self.photoImageView.subviews) {
            [stickerView whetherHide:YES];
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
        }
        if (self.needSave) {
            ///保存图片
                [self saveOnePhotoWithCompelectionBlock:compelectionBlock];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
                if (compelectionBlock) {
                    compelectionBlock();
                }
            });
            
        }
    });
}
/// 保存贴纸
-(void)saveOnePhotoWithCompelectionBlock:(void(^)())compelectionBlock{
    UIImage *capture;
    // 获取当前操作的图片信息模型
    XTUploadImageStickerInfo *imageInfo = self.stickersInfo[self.imageIndexForNow];
    if (imageInfo.stickersInfo.count == 0) {
        // 没有贴纸保持原图上传
        capture = self.photo;
    }else{
        // 有贴纸按照屏幕截图上传
        capture = [UIImage captureShotWithView:self.photoImageView];
    }
    [[XTLocalImageStoreManage sharedLocalImageStoreManage] storePhoto:capture withKey:[self cachedFileNameForKey:imageInfo.asset.assetPropertyURL.absoluteString] completion:^{
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        self.needSave = NO;
        if (compelectionBlock) {
            compelectionBlock();
        }
    }];
}
- (void)clickNaBackBtn:(UIButton *)sender
{
    if (!self.isNeedPop) {
        // 删除本地合成图片
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            [XTLocalImageStoreManage deletePhotoFolder];
        });
    }else{
        if (self.oldInfo != nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kStickersInfoSaveNotifiacation object:nil userInfo:@{@"info" : self.oldInfo.mutableCopy,@"assertsArray" : self.oldAssertsArray.mutableCopy}];
        }
    }
    if (self.backBlock) {
        self.backBlock(self.assetsArray,self.selectedAssetIndexArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureBottomToolView {
    UIView *bottomToolBgView = [[UIView alloc] init];
    [self.view addSubview:bottomToolBgView];
    
}
- (void)clickRightBtn
{
    [self createPhotoes];
}
// 根据数组合成图片
-(void)createPhotoes{
    [self.navigationController.view endEditing:YES];
    //保存当前观看图片的索引
    NSInteger lastIndex = self.imageIndexForNow;
    // 开始合成图片
    UIImage *image = [UIImage captureShotWithView:self.navigationController.view];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.navigationController.view addSubview:imageView];
    self.dummyView = imageView;
    // 指示器
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    // 访问当前文件夹的图片，删除不必要的图片,返回缺少的图片
    NSSet *nameSet = [[XTLocalImageStoreManage sharedLocalImageStoreManage] checkDifferenceBetweenLocalPhotoListAndGivenArray:[self photoNameArray]andTimeKey:[XTLocalImageStoreManage sharedLocalImageStoreManage].timeKey];
    [self storePhotoImagesWithNameSet:nameSet withCompeletionBlock:^{
        [self selectPhotoAtIndex:lastIndex];
        // 将最新的图片信息从新刷新
        [[XTLocalImageStoreManage sharedLocalImageStoreManage] addPhotoInfoWithNameArray:self.nameArray compelectionBlock:^{
            if (self.isNeedPop) {
                [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:kStickersInfoSaveNotifiacation object:nil userInfo:@{@"info" : self.stickersInfo.mutableCopy,@"assertsArray" : self.assetsArray.mutableCopy}];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
            }else{
                UploadPhotoViewController *uploadPhotoCtr = [[UploadPhotoViewController alloc] init];
                uploadPhotoCtr.assetsArray = _assetsArray;
                uploadPhotoCtr.type = self.type;
                uploadPhotoCtr.albumInfo = self.albumInfo;
                NSLog(@"%zd",self.type);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.dummyView removeFromSuperview];
                    [self.navigationController pushViewController:uploadPhotoCtr animated:YES];
                    [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
                });
            }
        }];
    }];

}

- (void)composePicAdd
{
    self.logoPicker = NO;
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.alreadySelectedNumber = self.alreadySelectedNumber;
    imagePickerController.selectedAssetArray = self.assetsArray;
    imagePickerController.selectedAssetIndexArray = self.selectedAssetIndexArray;
    imagePickerController.oldArray = self.assetsArray.mutableCopy;
    imagePickerController.oldIndexArray = self.selectedAssetIndexArray.mutableCopy;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}
- (void)dealloc {
    // 移除监听通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 移除文本框
    [self.textField removeFromSuperview];
    self.textField = nil;
    NSLog(@"add photo release");
}

-(void)selectPhotoAtIndex:(NSInteger)index{
    [self.navigationController.view endEditing:YES];
    // 保存当前贴图信息
    [self saveStickersInfoWithCompelectionBlock:^{
        if(index < [self.assetsArray count]) {
            [self selectImageAtIndex:index completion:nil];
            // 选出cell 将背景颜色根据是否选中改变颜色
            XTPhotoCanSelectCell *lastCell = (XTPhotoCanSelectCell *)[self.photoCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.imageIndexForNow inSection:0]];
            lastCell.displaying = NO;
            self.imageIndexForNow = index;
            XTPhotoCanSelectCell *nowCell = (XTPhotoCanSelectCell *)[self.photoCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.imageIndexForNow inSection:0]];
            nowCell.displaying = YES;
        }else {
            [self composePicAdd];
        }

    }];
}
#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    if (self.isLogoPicker) {
        JKAssets *ast = assets.lastObject;
        
        [self.assetsLibrary assetForURL:ast.assetPropertyURL
             resultBlock:^(ALAsset *asset)
         {
             if (asset){
                 if ([[XTLocalImageStoreManage sharedLocalImageStoreManage] canAddLogo]) {
                     UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                     // 处理添加的logo
                     [[XTLocalImageStoreManage sharedLocalImageStoreManage] storeLogo:image completion:^{
                         // 完成再取消去刷新数据
                         [imagePicker dismissViewControllerAnimated:YES completion:^{
                             
                         }];
                         
                     }];
                     // 通知刷新logo
                     [[NSNotificationCenter defaultCenter] postNotificationName:kReloadLogoGroupNotification object:nil];
                 }else{
                     // 完成再取消去刷新数据
                     [imagePicker dismissViewControllerAnimated:YES completion:^{
                         [[[YYTAlertView alloc] initWithTitle:@"提醒" message:@"Logo已超过最大添加额度，长按贴纸可清除现有的贴纸" delegate:nil verifyButtonTitle:@"知道了"] show];
                     }];
                 }

             }
             else {
                 // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
                 
                 [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                    usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                  {
                      [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                          if([result.defaultRepresentation.url isEqual:ast.assetPropertyURL])
                          {
                              if ([[XTLocalImageStoreManage sharedLocalImageStoreManage] canAddLogo]) {
                                  UIImage *image = [UIImage imageWithCGImage:[[result defaultRepresentation] fullScreenImage]];
                                  // 处理添加的logo
                                  [[XTLocalImageStoreManage sharedLocalImageStoreManage] storeLogo:image completion:^{
                                      // 完成再取消去刷新数据
                                      [imagePicker dismissViewControllerAnimated:YES completion:^{
                                          
                                      }];
                                      
                                  }];
                                  // 通知刷新logo
                                  [[NSNotificationCenter defaultCenter] postNotificationName:kReloadLogoGroupNotification object:nil];
                                  
                                  *stop = YES;
                              }else{
                                  // 完成再取消去刷新数据
                                  [imagePicker dismissViewControllerAnimated:YES completion:^{
                                      [[[YYTAlertView alloc] initWithTitle:@"提醒" message:@"Logo已超过最大添加额度，长按贴纸可清除现有的贴纸" delegate:nil verifyButtonTitle:@"知道了"] show];
                                  }];
                                  *stop = YES;
                              }

                          }
                      }];
                  }
                  
                                  failureBlock:^(NSError *error)
                  {
                      NSLog(@"Error: Cannot load asset from photo stream - %@", [error localizedDescription]);
                      
                      
                  }];
             }
             
         }
            failureBlock:^(NSError *error)
         {
             NSLog(@"Error: Cannot load asset - %@", [error localizedDescription]);
             
         }
         ];
        return;
    }
    self.assetsArray = [NSMutableArray arrayWithArray:assets];
    [self.photoCollectionView reloadData];
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    if (!self.isLogoPicker){
        self.assetsArray = imagePicker.oldArray;
        self.selectedAssetIndexArray = imagePicker.oldIndexArray;
    }
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(NSArray *)imagePickerControllerCheckRepeatNameList:(JKImagePickerController *)imagePicker{
    return [self photoNameArray];
}
static NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetsArray count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XTPhotoCanSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    if(indexPath.row < [self.assetsArray count]) {
        cell.asset = [self.assetsArray objectAtIndex:[indexPath row]];
    }else {
        cell.asset = nil;
    }
    if (indexPath.item == self.imageIndexForNow) {
        cell.displaying = YES;
    }else{
        cell.displaying = NO;
    }
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40, 40);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectPhotoAtIndex:indexPath.item];
}


#pragma mark ZDStickerViewDelegate代理
// 标签关闭
-(void)stickerViewDidClose:(ZDStickerView *)sticker{
    self.needSave = YES;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    for (ZDStickerView *view in self.stickerViews) {
        // 找到关闭的标签，移除掉
        if (sticker == view) {
            [self.stickerViews removeObject:view];
            break;
        }
    }
    // 发放结束通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kStickerViewEndMovingNotification object:nil];
}
//开始编辑
- (void)stickerViewDidBeginEditing:(ZDStickerView *)sticker{
    self.needSave = YES;
    [self.view endEditing:YES];
    for (ZDStickerView *view in self.stickerViews) {
        if (view != sticker) {
            [view whetherHide:YES];
        }
    }
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    // 清除文本
    self.textField.text = nil;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField endEditing:YES];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.textField.hidden = YES;
    [self selectPhotoAtIndex:self.imageIndexForNow];
}
#pragma mark XTGuideImageCreateViewDelegate
-(void)guideImageCreateViewClickClose:(XTGuideImageCreateView *)guideImageCreateView{
    [self.guideMask removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}
-(void)guideImageCreateView:(XTGuideImageCreateView *)guideImageCreateView showingCellIndex:(NSInteger)index{
    if (index != 2) {
        self.guideStickerImageView.hidden = NO;
        self.guideLogoImageView.hidden = YES;
        [self.selectionController stickerClick];
        return;
    }
    self.guideStickerImageView.hidden = YES;
    self.guideLogoImageView.hidden = NO;
    [self.selectionController logoClick];
    return;
}
#pragma mark - 懒加载
- (XTUploadPhotoView *)photoImageView {
    if(!_photoImageView) {
        _photoImageView = [[XTUploadPhotoView alloc] init];
        _photoImageView.userInteractionEnabled = YES;
        _photoImageView.center = kPhotoImageDefaultCenter;
        [self.mainView addSubview:_photoImageView];
    }
    return _photoImageView;
}

- (UICollectionView *)photoCollectionView{
    if (!_photoCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2.0;
        layout.minimumInteritemSpacing = 2.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(50, 0, SCREEN_SIZE.width - 100, 44) collectionViewLayout:layout];
        _photoCollectionView.backgroundColor = [UIColor clearColor];
        [_photoCollectionView registerClass:[XTPhotoCanSelectCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
        _photoCollectionView.showsHorizontalScrollIndicator = NO;
        _photoCollectionView.showsVerticalScrollIndicator = NO;
    }
    return _photoCollectionView;
}

// 组控制器视图
-(UIView *)selectionView{
    if (_selectionView == nil) {
        // 创建控制器
        self.selectionController = [[XTSingleSelectionController alloc] init];
        // 添加到父控制器当中
        [self addChildViewController:self.selectionController];
        // 记录控制器视图
        _selectionView = self.selectionController.view;
        // 添加到视图
        [self.view addSubview:_selectionView];
    }
    return _selectionView;
}

// 贴图数组
-(NSMutableArray *)stickerViews{
    if (_stickerViews == nil) {
        _stickerViews = [NSMutableArray array];
    }
    return _stickerViews;
}

-(UITextField *)textField{
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 34)];
        _textField.textAlignment = NSTextAlignmentCenter;
        [self.mainView addSubview:_textField];
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDone;
    }
    return _textField;
}

-(NSMutableArray *)imagesInfo{
    if (_imagesInfo == nil) {
        _imagesInfo = [NSMutableArray array];
    }
    return _imagesInfo;
}
-(UIView *)guideMask{
    if (_guideMask == nil) {
        _guideMask = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _guideMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
        [[UIApplication sharedApplication].keyWindow addSubview:_guideMask];
        [_guideMask addSubview:self.guideCollectionView];
        self.view.userInteractionEnabled = NO;
    }
    return _guideMask;
}
-(XTGuideImageCreateView *)guideCollectionView{
    if (_guideCollectionView == nil) {
        _guideCollectionView = [XTGuideImageCreateView guideImageCreateView];
        _guideCollectionView.indexDelegate = self;
    }
    return _guideCollectionView;
}
-(UIImageView *)guideStickerImageView{
    if (_guideStickerImageView == nil) {
        _guideStickerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GuideCreateImageSticker"]];
        _guideStickerImageView.bounds =  CGRectMake(0, 0, kDistance, kDistance);
        [self.guideMask addSubview:_guideStickerImageView];
        
    }
    return _guideStickerImageView;
}
-(UIImageView *)guideLogoImageView{
    if (_guideLogoImageView == nil) {
        _guideLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GuideCreateImageLogo"]];
        _guideLogoImageView.bounds =  CGRectMake(0, 0, kDistance, kDistance);
        [self.guideMask addSubview:_guideLogoImageView];
    }
    return _guideLogoImageView;
}
-(NSMutableArray *)photoStreamList
{
    if (_photoStreamList == nil) {
        _photoStreamList = [NSMutableArray array];
    }
    return _photoStreamList;
}
- (ALAssetsLibrary *)assetsLibrary{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}
@end
