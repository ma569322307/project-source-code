    //
//  XTUserHomePageViewController.m
//  tian
//
//  Created by 尚毅 杨 on 15/4/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUserHomePageViewController.h"
#import "XTHeadView.h"
#import "XTArtistHeadView.h"
#import "XTActionBar.h"
#import "XTCommonMacro.h"
#import "UIImage+rn_Blur.h"
#import "XTAlbumDetailCollectionViewCell.h"
#import "XTUserFilesCollectionViewCell.h"
#import "XTAlbumListCollectionViewCell.h"
#import "XTUserTopicCollectViewCell.h"
#import "XTUserHonourCollectViewCell.h"
#import "XTLatestUpdateCollectViewCell.h"
#import "XTDaysHotCollectViewCell.h"
#import "XTLickManitoCollectViewCell.h"
#import "XTDedicateListCollectViewCell.h"
#import "SlideTableView.h"
#import "XTUserStore.h"
#import "XTSubStore.h"
#import "XTUserAccountInfo.h"
#import "XTSetViewController.h"
#import "XTFansAndAttentionViewController.h"
#import "XTLikeAndHateViewController.h"
#import "XTLoveAndCollectViewController.h"
#import "YYTHUD.h"
#import "XTChatViewController.h"
#import "XTLickManitoAndFansViewController.h"
#import "JKImagePickerController.h"
#import "XTUploadImageManage.h"
#import "UIViewController+Extend.h"
#import "XTTabBarController.h"
#import "XTHeadPortraitView.h"
#define kHeaderMineHeight [XTHeadView calculateViewHeight:XTUserHeadViewTypeMine]
#define kHeaderHisHeight [XTHeadView calculateViewHeight:XTUserHeadViewTypeHis]
#define kHeaderArtistHeight [XTArtistHeadView calculateViewHeight]
#define kPositionZero 64
static NSString *kAlbumDetailCellIdentifier = @"kAlbumDetailCellIdentifier";
static NSString *kAlbumListCellIdentifier = @"kAlbumListCellIdentifier";
static NSString *kUserFilesCellIdentifier = @"kUserFilesCellIdentifier";
static NSString *kUserTopicCellIdentifier = @"kUserTopicCellIdentifier";
static NSString *kUserHonourCellIdentifier = @"kUserHonourCellIdentifier";

static NSString *kLatestUpdateCellIdentifier = @"kLatestUpdateCellIdentifier";
static NSString *kDaysHotCellIdentifier = @"kDaysHotCellIdentifier";
static NSString *kLickManitoCellIdentifier = @"kLickManitoCellIdentifier";
static NSString *kDedicateListCellIdentifier = @"kDedicateListCellIdentifier";

@interface XTUserHomePageViewController ()<UITableViewDataSource, UITableViewDelegate, XTActionBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, XTHeadViewDelegate, XTArtistHeadViewDelegate, JKImagePickerControllerDelegate,SlideCollectionViewDelegate,SlideTableViewDelegate>{
    CGPoint _origin;
    CGFloat duration;
    CGPoint currentPoint;
}
typedef enum {
    XTUserHeadUpdateBg = 0,     //个人背景修改
    XTUserHeadUpdateImage       //个人头像修改
} XTUserHeadUpdateType;
@property (nonatomic, strong) XTUserAccountInfo *currentUser;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) XTHeadView *headView;
@property (nonatomic, strong) XTArtistHeadView *artistHeadView;
@property (nonatomic, strong) XTActionBar *navigationActionBar;
@property (nonatomic, strong) UIView *statusBarAndNaviBarBgView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) XTActionBar *buttonActionBar;

@property (nonatomic, strong) UIView *myContainer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *headPanGesture;
@property (nonatomic, strong) UITapGestureRecognizer *headTapGesture;

@property (nonatomic, strong) XTCollectViewCell *currentCollectionViewCell;
@property (nonatomic, strong) NSMutableArray *picArray;

@property (nonatomic, strong) XTUserAccountInfo *hisUserAccountInfo;
@property (nonatomic, strong) XTOrderArtist *artistInfo;
@property (nonatomic, strong) UILabel *percentLabel;

@property (nonatomic, assign) BOOL isGetUserDetailSuccess;
@property (nonatomic, assign) BOOL isGetUserSignInSuccess;
@property (nonatomic, assign) BOOL isGetArtistDetailSuccess;
@property (nonatomic, assign) BOOL isFirstCreate;
@property (nonatomic, strong) JKAssets *asset;
@property (nonatomic, strong) UIImage *updateBgImage;

@property (nonatomic, assign) BOOL isRefreshUserDetail;

//@property (atomic, assign) BOOL canNotPan;//屏蔽pan手势
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
// 根据类别判断跳转相册界面的时候的类型
@property (nonatomic, assign) XTUserHeadUpdateType updateType;

@end

@implementation XTUserHomePageViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(postAdjustContainerView:) name:@"adjustContainerViewNotifition"
                                                   object:nil];
        //上传图片进度提示
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(uploadProgress:)
                                                     name:@"uploadProgress"
                                                   object:nil];
        self.isFirstCreate = YES;
        
        self.isRefreshUserDetail = NO;
        self.isRefreshAlbumDetail = NO;
        self.isRefreshAlbumList = NO;
        self.isRefreshUserTopic = NO;
        self.isRefreshUserFiles = NO;
        
        self.type = XTUserHomePageTypeMine;//默认显示我的主页
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        
//        self.headPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == XTUserHomePageTypeMine) {
        self.headTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        //刷新主页头部信息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(needRefreshUserDetail) name:@"refreshUserDetailNotifition"
                                                   object:nil];
        //刷新我的图片信息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(needRefreshAlbumDetail)
                                                     name:@"updateAlbumDetailNotification"
                                                   object:nil];
        //刷新我的图册信息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(needRefreshAlbumList)
                                                     name:@"updateAlbumListNotification"
                                                   object:nil];
        //刷新我的话题信息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(needRefreshUserTopic)
                                                     name:@"updateUserTopicNotification"
                                                   object:nil];
        //刷新粉丝资料信息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(needRefreshUserFiles)
                                                     name:@"updateUserFilesNotification"
                                                   object:nil];
        //更换头像的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateHeadImage)
                                                     name:@"userHomePageUpdateHeadImage"
                                                   object:self.headView.headPortraitView.headPortraitButton];
    }
    
    [self navigationActionBar];
    if (self.type == XTUserHomePageTypeArtist){
        [self getArtistInfo];
    }else{
        [self getUserDetailWithCompletionBlock:nil];
    }
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if ([self.currentCollectionViewCell slideViewState] == kDockUp) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else if ([self.currentCollectionViewCell slideViewState] == kDockDown){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    if (!self.isFirstCreate) {
        if (self.type != XTUserHomePageTypeArtist && !_isGetUserDetailSuccess) {
            [self getUserDetailWithCompletionBlock:nil];
        }
        
        if (self.type != XTUserHomePageTypeArtist && !_isGetUserSignInSuccess) {
            [self getSignInInfoWithCompletionBlock:nil];
        }
        
        if (self.type == XTUserHomePageTypeArtist && !_isGetArtistDetailSuccess) {
            [self getArtistInfo];
        }
    }
    
    if (self.isRefreshUserDetail) {
        [self getUserDetailWithCompletionBlock:nil];
    }

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(!self.imagePickerWillDisplay && !self.willPushToUserPage) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)needRefreshUserDetail{
    self.isRefreshUserDetail = YES;
}

- (void)needRefreshAlbumDetail{
    self.isRefreshAlbumDetail = YES;
    if ([self.currentCollectionViewCell isKindOfClass:[XTAlbumDetailCollectionViewCell class]]) {
        XTAlbumDetailCollectionViewCell *cell = (XTAlbumDetailCollectionViewCell *)self.currentCollectionViewCell;
        [cell loadDefaultDataWithCompletionBlock:nil];
    }
}

- (void)needRefreshAlbumList{
    self.isRefreshAlbumList = YES;
    if ([self.currentCollectionViewCell isKindOfClass:[XTAlbumListCollectionViewCell class]]) {
        XTAlbumListCollectionViewCell *cell = (XTAlbumListCollectionViewCell *)self.currentCollectionViewCell;
        [cell loadUserAlbumListNewDataWithCompletionBlock:nil];
    }
}

- (void)needRefreshUserTopic{
    self.isRefreshUserTopic = YES;
    if ([self.currentCollectionViewCell isKindOfClass:[XTUserTopicCollectViewCell class]]) {
        XTUserTopicCollectViewCell *cell = (XTUserTopicCollectViewCell *)self.currentCollectionViewCell;
        [cell loadDefaultUserTopicDataWithCompletionBlock:nil];
    }
}

- (void)needRefreshUserFiles{
    self.isRefreshUserFiles = YES;
    if ([self.currentCollectionViewCell isKindOfClass:[XTUserFilesCollectionViewCell class]]) {
        XTUserFilesCollectionViewCell *cell = (XTUserFilesCollectionViewCell *)self.currentCollectionViewCell;
        [cell loadUserFilesDataWithCompletionBlock:nil];
    }
}

- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 438)];
        [self.view insertSubview:_backgroundImageView atIndex:0];
    }
    return _backgroundImageView;
}

- (void)setBackgroundImage:(NSURL *)imageUrl{
    UIImage *defaultImage = [[UIImage imageNamed:@""] applyBlurWithRadius:self.type == XTUserHomePageTypeArtist?3:1 tintColor:[UIColor colorWithWhite:0 alpha:0.20] saturationDeltaFactor:1.0 maskImage:nil];
    [self.backgroundImageView sd_setImageWithURL:imageUrl placeholderImage:defaultImage
    options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         
    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
         if (!error) {
             UIImage *defaultImage = [image applyBlurWithRadius:self.type == XTUserHomePageTypeArtist?3:1 tintColor:[UIColor colorWithWhite:0 alpha:0.20] saturationDeltaFactor:1.0 maskImage:nil];
             _backgroundImageView.image = defaultImage;
             [_backgroundImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
             [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
             [_backgroundImageView setClipsToBounds:YES];
         }
    }];
//    [self.backgroundImageView an_setImageWithURL:imageUrl placeholderImage:defaultImage
//                                         options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

- (UIView *)statusBarAndNaviBarBgView{
    if (!_statusBarAndNaviBarBgView) {
        _statusBarAndNaviBarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 64)];
        _statusBarAndNaviBarBgView.backgroundColor = UIColorFromRGB(0xffe707);
        _statusBarAndNaviBarBgView.alpha = 0.0;
        [self.view addSubview:_statusBarAndNaviBarBgView];
    }
    return _statusBarAndNaviBarBgView;
}

- (XTActionBar *)navigationActionBar{
    if (!_navigationActionBar) {
        _navigationActionBar = [[XTActionBar alloc] initWithFrame:CGRectMake(0, 20, SCREEN_SIZE.width, 44)];
        _navigationActionBar.backgroundColor = [UIColor clearColor];
        _navigationActionBar.delegate = self;
        _navigationActionBar.type = XTActionBarNavigationType;
        _navigationActionBar.titleColor = ABACTIONBAR_DEFAULT_TITLECOLOR;
        _navigationActionBar.titleFont = ABACTIONBAR_DEFAULT_TITLEFONT;
        _navigationActionBar.titleSpecialFont = ABACTIONBAR_DEFAULT_S_TITLEFONT;
        _navigationActionBar.titleSpecialColor = ABACTIONBAR_DEFAULT_S_TITLECOLOR;
        [self.view addSubview:_navigationActionBar];
    }
    return _navigationActionBar;
}

- (void)setNavigationActionBarStatus{
    if (self.type == XTUserHeadViewTypeMine) {
        self.navigationActionBar.rightBtnItems = @[@"set"];
    }else if (self.type == XTUserHeadViewTypeHis){
        self.navigationActionBar.leftBtnItems = @[@"na_back"];
        if (self.hisUserAccountInfo.hasFollowed) {
            self.navigationActionBar.rightBtnItems = @[@"attentioned",@"message"];
        }else{
            self.navigationActionBar.rightBtnItems = @[@"attention",@"message"];
        }
    }else if (self.type == XTUserHomePageTypeArtist){
        self.navigationActionBar.leftBtnItems = @[@"na_back"];
        if (self.artistInfo.subStatus) {
            self.navigationActionBar.rightBtnItems = @[@"HomePage_like"];
        }else{
            self.navigationActionBar.rightBtnItems = @[@"HomePage_noLike"];
        }
    }
}

- (UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [UIActivityIndicatorView new];
        _activityView.hidesWhenStopped = YES;
        [self.navigationActionBar addSubview:_activityView];
        
        [_activityView makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.navigationActionBar);
        }];
    }
    return _activityView;
}

- (void)setNavigationActionBarErrorStatus{
    if (self.type != XTUserHomePageTypeMine) {
        self.navigationActionBar.leftBtnItems = @[@"na_back"];
    }
}

- (UILabel *)percentLabel{
    if (!_percentLabel) {
        _percentLabel = [UILabel new];
        _percentLabel.backgroundColor = [UIColor clearColor];
        _percentLabel.textColor = [UIColor whiteColor];
        _percentLabel.textAlignment = NSTextAlignmentCenter;
        _percentLabel.font = [UIFont systemFontOfSize:14];
        [self.navigationActionBar addSubview:_percentLabel];
        
        [_percentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.navigationActionBar);
            make.width.equalTo(@200);
            make.height.equalTo(@20);
        }];
    }
    return _percentLabel;
}

- (XTHeadView *)headView{
    if (!_headView) {
        if (self.type == XTUserHeadViewTypeMine) {
            _headView = [[XTHeadView alloc] initWithType:XTUserHeadViewTypeMine];
            [_headView addGestureRecognizer:self.headTapGesture];
        }else if (self.type == XTUserHeadViewTypeHis){
            _headView = [[XTHeadView alloc] initWithType:XTUserHeadViewTypeHis];
        }
        _headView.delegate = self;
        [self.view addSubview:_headView];
        
        @weakify(self);
        [_headView makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.left.equalTo(self.view);
            if (self.type == XTUserHomePageTypeMine) {
                make.height.equalTo(kHeaderMineHeight);
            }else if (self.type == XTUserHomePageTypeHis){
                make.height.equalTo(kHeaderHisHeight);
            }
            make.width.equalTo(self.view);
        }];
        [_headView fillUesrInformation:_currentUser];
//        [_headView addGestureRecognizer:self.headPanGesture];
    }
    return _headView;
}

- (XTArtistHeadView *)artistHeadView{
    if (!_artistHeadView) {
        _artistHeadView = [[XTArtistHeadView alloc] init];
        _artistHeadView.delegate = self;
        [self.view addSubview:_artistHeadView];
        
        @weakify(self);
        [_artistHeadView makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.left.equalTo(self.view);
            make.height.equalTo(kHeaderArtistHeight);
            make.width.equalTo(self.view);
        }];
//        [_artistHeadView addGestureRecognizer:self.headPanGesture];
    }
    return _artistHeadView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.bounces = NO;
        @weakify(self);
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            if (self.type == XTUserHomePageTypeMine) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeaderMineHeight, 0, 54-kHeaderMineHeight, 0));
            }else if (self.type == XTUserHomePageTypeHis){
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeaderHisHeight, 0, 0-kHeaderHisHeight, 0));
            }else if (self.type == XTUserHomePageTypeArtist){
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeaderArtistHeight, 0, 0-kHeaderArtistHeight, 0));
            }
        }];
        
//        [_tableView addGestureRecognizer:self.panGesture];
    }
    return _tableView;
}

- (XTActionBar *)buttonActionBar{
    if (!_buttonActionBar) {
        _buttonActionBar = [[XTActionBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 64)];
        _buttonActionBar.backgroundColor = [UIColor whiteColor];
        _buttonActionBar.delegate = self;
        _buttonActionBar.bottomBorderColor = UIColorFromRGB(0xd2d2d2);
        _buttonActionBar.type = XTActionBarButtonType;
        if (self.type == XTUserHomePageTypeArtist) {
            _buttonActionBar.buttonItems = @[@"HomePage_latestUpdate",@"HomePage_hot",@"HomePage_manito",@"HomePage_contribute"];
        }else if(self.type == XTUserHeadViewTypeMine || self.type == XTUserHeadViewTypeHis){
            if (self.userType == XTAccountCommon) {
                _buttonActionBar.buttonItems = @[@"HomePage_image",@"HomePage_album",@"HomePage_topic",@"HomePage_userData"];
            }else if(self.userType == XTAccountFans){
                _buttonActionBar.buttonItems = @[@"HomePage_image",@"HomePage_album",@"HomePage_topic",@"HomePage_userData",@"HomePage_honor"];
            }
        }
        [_buttonActionBar setButtonStatus:0];
    }
    return _buttonActionBar;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.clipsToBounds = YES;
        [_collectionView registerClass:[XTAlbumDetailCollectionViewCell class] forCellWithReuseIdentifier:kAlbumDetailCellIdentifier];
        [_collectionView registerClass:[XTAlbumListCollectionViewCell class] forCellWithReuseIdentifier:kAlbumListCellIdentifier];
        [_collectionView registerClass:[XTUserFilesCollectionViewCell class] forCellWithReuseIdentifier:kUserFilesCellIdentifier];
        [_collectionView registerClass:[XTUserTopicCollectViewCell class] forCellWithReuseIdentifier:kUserTopicCellIdentifier];
        [_collectionView registerClass:[XTUserHonourCollectViewCell class] forCellWithReuseIdentifier:kUserHonourCellIdentifier];
        
        [_collectionView registerClass:[XTLatestUpdateCollectViewCell class] forCellWithReuseIdentifier:kLatestUpdateCellIdentifier];
        [_collectionView registerClass:[XTDaysHotCollectViewCell class] forCellWithReuseIdentifier:kDaysHotCellIdentifier];
        [_collectionView registerClass:[XTLickManitoCollectViewCell class] forCellWithReuseIdentifier:kLickManitoCellIdentifier];
        [_collectionView registerClass:[XTDedicateListCollectViewCell class] forCellWithReuseIdentifier:kDedicateListCellIdentifier];
    }
    return _collectionView;
}

- (void)chooseHeadViewPicture
{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 1;
    imagePickerController.needSquareCrop = YES;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    self.imagePickerWillDisplay = YES;
    [self presentViewController:navigationController animated:YES completion:^{
        self.imagePickerWillDisplay = NO;
    }];
}
//下拉刷新方法
-(void)refeshData{
    if ([self.activityView isAnimating] == YES) {
        return;
    }
    [self.activityView startAnimating];
    __block BOOL needRefersh = YES;
    
    dispatch_group_t group = dispatch_group_create();
        if ([self.currentCollectionViewCell isKindOfClass:[XTAlbumDetailCollectionViewCell class]]) {
            XTAlbumDetailCollectionViewCell *cell = (XTAlbumDetailCollectionViewCell *)self.currentCollectionViewCell;
            dispatch_group_enter(group);
            [cell loadDefaultDataWithCompletionBlock:^(NSError *error) {
                if (error) {
                    needRefersh = NO;
                }
                dispatch_group_leave(group);
            }];
        }
        else if ([self.currentCollectionViewCell isKindOfClass:[XTAlbumListCollectionViewCell class]]) {
            XTAlbumListCollectionViewCell *cell = (XTAlbumListCollectionViewCell *)self.currentCollectionViewCell;
            dispatch_group_enter(group);
            [cell loadUserAlbumListNewDataWithCompletionBlock:^(NSError *error) {
                if (error) {
                    needRefersh = NO;
                }
                dispatch_group_leave(group);
            }];
        }
        else if ([self.currentCollectionViewCell isKindOfClass:[XTUserTopicCollectViewCell class]]) {
            XTUserTopicCollectViewCell *cell = (XTUserTopicCollectViewCell *)self.currentCollectionViewCell;
            dispatch_group_enter(group);
            [cell loadDefaultUserTopicDataWithCompletionBlock:^(NSError *error) {
                if (error) {
                    needRefersh = NO;
                }
                dispatch_group_leave(group);
            }];
        }
        else if ([self.currentCollectionViewCell isKindOfClass:[XTUserFilesCollectionViewCell class]]) {
            XTUserFilesCollectionViewCell *cell = (XTUserFilesCollectionViewCell *)self.currentCollectionViewCell;
            dispatch_group_enter(group);
            [cell loadUserFilesDataWithCompletionBlock:^(NSError *error) {
                if (error) {
                    needRefersh = NO;
                }
                dispatch_group_leave(group);
            }];
        }
    dispatch_group_enter(group);
    [self getUserDetailWithCompletionBlock:^(NSError *error) {
        if (error) {
            needRefersh = NO;
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self getSignInInfoWithCompletionBlock:^(NSError *error) {
        if (error) {
            needRefersh = NO;
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 隐藏菊花
        [self.activityView stopAnimating];
        // 有错误
        if (!needRefersh) {
            // 错误提示
            
        }
    });
}
// 更换头像通知方法
-(void)updateHeadImage{
    NSLog(@"修改头像");
    // 设置类型
    self.updateType = XTUserHeadUpdateImage;
    [self chooseHeadViewPicture];
}

#pragma mark - JKImagePickerControllerDelegate

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    // 根据自身属性判断获取来的图片做什么处理
    if (self.updateType == XTUserHeadUpdateBg) {
        // 修改背景
        [imagePicker dismissViewControllerAnimated:YES completion:^{
            // 背景需要变成方。
            UIImage *defaultImage = assets.lastObject;
            _backgroundImageView.image = defaultImage;
            [_backgroundImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
            [_backgroundImageView setClipsToBounds:YES];
            XTUploadImageManage *uploadManage = [XTUploadImageManage shareUploadImageManage];
            uploadManage.type = XTUploadImageTypeHeadPortraitBg;
            [uploadManage uploadImagePicker:defaultImage];
        }];
    }else if (self.updateType == XTUserHeadUpdateImage){
        // 修改头像
        [imagePicker dismissViewControllerAnimated:YES completion:^{
            // 背景需要变成方。
            UIImage *defaultImage = assets.lastObject;
            UIImageView *imageView = self.headView.headPortraitView.headPortraitImageView;
            imageView.image = defaultImage;
            [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [imageView setClipsToBounds:YES];
            // 访问接口
            XTUploadImageManage *uploadManage = [XTUploadImageManage shareUploadImageManage];
            uploadManage.type = XTUploadImageTypeHeadPortrait;
            //uploadManage.userFilesInfo = self.userFilesInfo;
            [uploadManage uploadImagePicker:defaultImage];
            
        }];
    }

    /* 不变方需求代码
    self.asset = assets.lastObject;
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset){
                UIImage *defaultImage = [[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]] applyBlurWithRadius:1 tintColor:[UIColor colorWithWhite:0 alpha:0.20] saturationDeltaFactor:1.0 maskImage:nil];
                _backgroundImageView.image = defaultImage;
                [_backgroundImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
                [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
                [_backgroundImageView setClipsToBounds:YES];
                XTUploadImageManage *uploadManage = [XTUploadImageManage shareUploadImageManage];
                uploadManage.type = XTUploadImageTypeHeadPortraitBg;
                [uploadManage uploadImagePicker:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
            }
            else {
                // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
                [lib enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                                  usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                 {
                     [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger indexG, BOOL *stop) {
                         if([result.defaultRepresentation.url isEqual:_asset.assetPropertyURL])
                         {
                             UIImage *defaultImage = [[UIImage imageWithCGImage:[[result defaultRepresentation] fullScreenImage]] applyBlurWithRadius:1 tintColor:[UIColor colorWithWhite:0 alpha:0.20] saturationDeltaFactor:1.0 maskImage:nil];
                             _backgroundImageView.image = defaultImage;
                             [_backgroundImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
                             [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
                             [_backgroundImageView setClipsToBounds:YES];
                             XTUploadImageManage *uploadManage = [XTUploadImageManage shareUploadImageManage];
                             uploadManage.type = XTUploadImageTypeHeadPortraitBg;
                             [uploadManage uploadImagePicker:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
                             *stop = YES;
                         }
                     }];
                 }
                 
                                                failureBlock:^(NSError *error)
                 {
                     NSLog(@"Error: Cannot load asset from photo stream - %@", [error localizedDescription]);
                     
                     
                 }];
                
            }
            } failureBlock:^(NSError *error) {
            
        }];
    }];*/
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - XTActionBarDelegate
- (void)onClickActionBar:(XTActionBar *)actionBar atTitle:(NSInteger)index
{
    BOOL isMine = [self.userID isEqualToString:_currentUser.userID];
    switch (actionBar.type) {
        case XTActionBarNavigationType:{
            if ((self.type == XTUserHomePageTypeMine||(self.type == XTUserHomePageTypeHis&&isMine))){
                switch (index) {
                    case 0:{
                        XTSetViewController *setCtr = [[XTSetViewController alloc] initWithNibName:@"XTSetViewController" bundle:nil];
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"NO",@"isShowTabBar",nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"isShowTabBarNotification"
                                                                            object:dic];
                        [self.navigationController pushViewController:setCtr animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            }else if (self.type == XTUserHeadViewTypeHis && !isMine){
                switch (index) {
                    case 0:{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                        break;
                    case 1:{
                        XTSubStore *subStore = [[XTSubStore alloc] init];
                        YYTButton *button = [actionBar.rightBtnViews objectAtIndex:index-1];
                        if(self.hisUserAccountInfo.hasFollowed) {
                            button.enabled = NO;
                            [subStore fetchUserDeleteSubFromUserId:[self.hisUserAccountInfo.userID integerValue]
                                                   completionBlock:^(id data, NSError *error) {
                                                       if (!error) {
                                                           _navigationActionBar.rightBtnItems = @[@"attention",@"message"];
                                                           self.hisUserAccountInfo.hasFollowed = NO;
                                                           [YYTHUD showPromptAddedTo:self.view withText:@"取消关注成功" withCompletionBlock:^{
                                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshUserListNotification" object:nil userInfo:@{@"userID":self.hisUserAccountInfo.userID,@"status":@"0"}];
                                                           }];
                                                           
                                                       }else{
                                                           _navigationActionBar.rightBtnItems = @[@"attentioned",@"message"];
                                                           self.hisUserAccountInfo.hasFollowed = YES;
                                                           [YYTHUD showPromptAddedTo:self.view withText:@"取消关注失败" withCompletionBlock:nil];
                                                       }
                                                       button.enabled = YES;
                                                   }];
                        }else{
                            button.enabled = NO;
                            [subStore fetchUserSubFromUserId:[self.hisUserAccountInfo.userID integerValue]
                                             completionBlock:^(id data, NSError *error) {
                                                 if (!error) {
                                                     _navigationActionBar.rightBtnItems = @[@"attentioned",@"message"];
                                                     self.hisUserAccountInfo.hasFollowed = YES;
                                                     [YYTHUD showPromptAddedTo:self.view withText:@"关注成功" withCompletionBlock:nil];
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshUserListNotification" object:nil userInfo:@{@"userID":self.hisUserAccountInfo.userID,@"status":@"1"}];
                                                 }else{
                                                     _navigationActionBar.rightBtnItems = @[@"attention",@"message"];
                                                     self.hisUserAccountInfo.hasFollowed = NO;
                                                     [YYTHUD showPromptAddedTo:self.view withText:@"关注失败" withCompletionBlock:nil];
                                                 }
                                                 button.enabled = YES;
                                             }];
                        }
                    }
                        break;
                    case 2:{
                        if(self.hisUserAccountInfo.hasFollowed){
                            // 您需要根据自己的 App 选择场景触发聊天。这里的例子是一个 Button 点击事件。
                            XTChatViewController *chatViewController = [[XTChatViewController alloc]init];
                            chatViewController.conversationType = ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
                            chatViewController.targetId = self.userID; // 接收者的 targetId，这里为举例。
                            chatViewController.userName = self.hisUserAccountInfo.nickname; // 接受者的 username，这里为举例。
                            chatViewController.title = self.hisUserAccountInfo.nickname; // 会话的 title。
                            [chatViewController setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
                            // 把单聊视图控制器添加到导航栈。
                            [self.navigationController pushViewController:chatViewController animated:YES];
                        }else{
                            [YYTHUD showPromptAddedTo:self.view withText:@"你和他还不是好友呢！" withCompletionBlock:nil];
                        }
                    }
                        break;
                    default:
                        break;
                }
                
            }else if (self.type == XTUserHomePageTypeArtist){
                switch (index) {
                    case 0:{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                        break;
                    case 1:{
                        XTSubStore *subStore = [[XTSubStore alloc] init];
                        YYTButton *button = [actionBar.rightBtnViews objectAtIndex:index-1];
                        if(self.artistInfo.subStatus) {
                            button.enabled = NO;
                            [subStore deleteSubscribeArtistFromArtistId:self.artistInfo.artistId
                                                        completionBlock:^(id favoriteVideos, NSError *error) {
                                                       if (!error) {
                                                           _navigationActionBar.rightBtnItems = @[@"HomePage_noLike"];
                                                           self.artistInfo.subStatus = NO;
                                                           [YYTHUD showPromptAddedTo:self.view withText:@"取消喜欢成功" withCompletionBlock:^{
                                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshUserListNotification" object:nil userInfo:@{@"userID":@(self.artistInfo.artistId),@"status":@"0"}];
                                                           }];
                                                       }else{
                                                           _navigationActionBar.rightBtnItems = @[@"HomePage_like"];
                                                           self.artistInfo.subStatus = YES;
                                                           [YYTHUD showPromptAddedTo:self.view withText:[error xtErrorMessage] withCompletionBlock:nil];
                                                       }
                                                       button.enabled = YES;
                                                   }];
                        }else{
                            button.enabled = NO;
                            [subStore subscribeArtistFromArtistId:self.artistInfo.artistId
                                                  completionBlock:^(id data, NSError *error) {
                                                 if (!error) {
                                                     _navigationActionBar.rightBtnItems = @[@"HomePage_like"];
                                                     self.artistInfo.subStatus = YES;
                                                     [YYTHUD showPromptAddedTo:self.view withText:@"喜欢成功" withCompletionBlock:^{
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshUserListNotification" object:nil userInfo:@{@"userID":@(self.artistInfo.artistId),@"status":@"1"}];
                                                     }];
                                                 }else{
                                                     _navigationActionBar.rightBtnItems = @[@"HomePage_noLike"];
                                                     self.artistInfo.subStatus = NO;
                                                     [YYTHUD showPromptAddedTo:self.view withText:[error xtErrorMessage] withCompletionBlock:nil];
                                                 }
                                                 button.enabled = YES;
                                             }];
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        case XTActionBarButtonType:{
            switch (index) {
                case 0:{
                    [self.collectionView scrollRectToVisible:CGRectMake(0, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height) animated:NO];
                }
                    break;
                case 1:{
                    [self.collectionView scrollRectToVisible:CGRectMake(SCREEN_SIZE.width, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height) animated:NO];
                }
                    break;
                case 2:{
                    [self.collectionView scrollRectToVisible:CGRectMake(SCREEN_SIZE.width*2, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height) animated:NO];
                }
                    break;
                case 3:{
                    [self.collectionView scrollRectToVisible:CGRectMake(SCREEN_SIZE.width*3, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height) animated:NO];
                }
                    break;
                case 4:{
                    [self.collectionView scrollRectToVisible:CGRectMake(SCREEN_SIZE.width*4, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height) animated:NO];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - XTHeadViewDelegate
- (void)onClickSignInBtn:(UIButton *)signInBtn{
//    signInBtn.enabled = NO;
    signInBtn.selected = YES;
    [[XTUserStore sharedManager] signInWithCompletionBlock:^(id user, NSError *error) {
        if (!error) {
            [YYTHUD showPromptAddedTo:[[UIApplication sharedApplication] keyWindow] withText:@"签到成功" withCompletionBlock:^{
                [self getSignInInfoWithCompletionBlock:nil];
                [self getUserDetailWithCompletionBlock:nil];
                //如果用户档案已经初始化完成，就去发通知去更新它的内容
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserFilesNotification"
                                                                    object:nil];
            }];
        }else{
            //signInBtn.enabled = YES;
            signInBtn.selected = NO;
            [YYTHUD showPromptAddedTo:[[UIApplication sharedApplication] keyWindow] withText:@"签到失败" withCompletionBlock:nil];
        }
    }];
}

- (void)onClickHeadBar:(XTActionBar *)headBar atTitle:(NSInteger)index
{
	if (index == 0) {
		
		//粉丝/关注页
        if (self.type == XTUserHomePageTypeMine && ([self.currentUser.friendsCount intValue] > 0 || [self.currentUser.fansCount intValue] > 0)){
            [self push:[XTFansAndAttentionViewController class] userID:self.currentUser.userID];
            
        }else if (self.type == XTUserHomePageTypeHis && ([self.hisUserAccountInfo.friendsCount intValue] > 0 || [self.hisUserAccountInfo.fansCount intValue] > 0)){
            [self push:[XTFansAndAttentionViewController class] userID:self.hisUserAccountInfo.userID];
            
        }
	} else if (index == 1) {
		
		//喜欢/嫌弃
        if (self.type == XTUserHomePageTypeMine && ([self.currentUser.subArtistCount intValue] > 0 || [self.currentUser.hideArtistCount intValue] > 0)){
            [self push:[XTLikeAndHateViewController class] userID:self.currentUser.userID];
            
        }else if (self.type == XTUserHomePageTypeHis && ([self.hisUserAccountInfo.subArtistCount intValue] > 0 || [self.hisUserAccountInfo.hideArtistCount intValue] > 0)){
            [self push:[XTLikeAndHateViewController class] userID:self.hisUserAccountInfo.userID];
            
        }
        
    } else if (index == 2) {
        
        //赞过/收藏
        if (self.type == XTUserHomePageTypeMine && ([self.currentUser.commendCount intValue] > 0 || [self.currentUser.favoriteCount intValue] > 0)){
            [self push:[XTLoveAndCollectViewController class] userID:self.currentUser.userID];
            
        }else if (self.type == XTUserHomePageTypeHis && ([self.hisUserAccountInfo.commendCount intValue] > 0 || [self.hisUserAccountInfo.favoriteCount intValue] > 0)){
            [self push:[XTLoveAndCollectViewController class] userID:self.hisUserAccountInfo.userID];
            
        }
    }
}

- (void)push:(Class)className userID:(NSString *)userID
{
    UIViewController *vc = [[className alloc] initWithUID:userID];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - XTArtistHeadViewDelegate
- (void)onClickBtn:(UIButton *)btn{
    XTLickManitoAndFansViewController *vc = [[XTLickManitoAndFansViewController alloc] initWithUID:self.userID];
    if (btn == _artistHeadView.manitoLabelAndBtnView.clickButton) {
        NSLog(@"舔神列表页");
        vc.currentSelectTag = tagSelect_item_left;
    }else if (btn == _artistHeadView.fansLabelAndBtnView.clickButton){
        NSLog(@"粉丝列表页");
        vc.currentSelectTag = tagSelect_item_right;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging");
    CGPoint point = scrollView.contentOffset;
    NSLog(@"%f,%f",point.x,point.y);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSLog(@"scrollViewWillEndDragging");
    NSLog(@"%f,%f",velocity.x, velocity.y);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
    CGPoint point = scrollView.contentOffset;
    if (scrollView == self.collectionView) {
        if (point.x == 0) {
            [self.buttonActionBar setButtonStatus:0];
        }else if (point.x == SCREEN_SIZE.width*1) {
            [self.buttonActionBar setButtonStatus:1];
        }else if (point.x == SCREEN_SIZE.width*2) {
            [self.buttonActionBar setButtonStatus:2];
        }else if (point.x == SCREEN_SIZE.width*3) {
            [self.buttonActionBar setButtonStatus:3];
        }else if (point.x == SCREEN_SIZE.width*4) {
            [self.buttonActionBar setButtonStatus:4];
        }
    }
    // 从中可以读取contentOffset属性以确定其滚动到的位置。
    // 注意：当ContentSize属性小于Frame时，将不会出发滚动
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    NSLog(@"arealy top");
}

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:pan.view];//手势平移的距离
    CGPoint velocity = [pan velocityInView:pan.view];//手势平移的速度
//    NSLog(@"translation.x:%f--translation.y%f--velocity.x:%f--velocity.y:%f",translation.x,translation.y,velocity.x,velocity.y);
    switch (pan.state){
        case UIGestureRecognizerStateBegan:{
            _origin = self.tableView.frame.origin;//tableView的起始点
            
            /*
            //手势在tableView头部坐标系中起始点坐标
            CGPoint pointInHeader = [pan locationInView:self.buttonActionBar];
            //判断tableView头部是否包含此坐标点
            if(CGRectContainsPoint(self.buttonActionBar.bounds, pointInHeader))
            {
                //如果包含，屏蔽tableView头部识别
                if ([self SlideCollectionViewCheckState:nil] == kDockUp) {
                    pan.enabled = YES;
                }else{
                    self.canNotPan = NO;
                }
                
                return;
            }*/
        }
            break;
        case UIGestureRecognizerStateChanged:{
            
            /*
            if (self.canNotPan) {
                self.canNotPan = NO;
                return;
            }*/
            // 判断当前列别头部的范围
            float checkTranslation = 0.0;
            if (self.type == XTUserHomePageTypeMine){
                checkTranslation = kHeaderMineHeight - kPositionZero;
            }else if(self.type == XTUserHomePageTypeHis){
                checkTranslation = kHeaderHisHeight - kPositionZero;
            }else if(self.type == XTUserHomePageTypeArtist){
                checkTranslation = kHeaderArtistHeight - kPositionZero;
            }
            float y;
            if ((translation.y > 0) && (self.currentCollectionViewCell.slideViewState == kDockDown)) {
                // 如果是底部模式，添加弹簧算法
                y = _origin.y + sqrt(translation.y) * sqrt(translation.y / 15);
            }else if ((translation.y > 0) && (self.currentCollectionViewCell.slideViewState == kDockUp) && translation.y > checkTranslation){
                // 如果是顶部模式，在下拉到底部模式的范围的时候添加弹簧算法
                y = _origin.y + sqrt(translation.y) * sqrt(translation.y / 15) + checkTranslation - kPositionZero;
            }else{
                // 其他情况无弹簧模式
                y = _origin.y + translation.y;
            }
            float y2 = 0;
            if (self.type == XTUserHomePageTypeMine) {
                y2 = kHeaderMineHeight;
            }else if(self.type == XTUserHomePageTypeHis) {
                y2 = kHeaderHisHeight;
            }else if(self.type == XTUserHomePageTypeArtist) {
                y2 = kHeaderArtistHeight;
            }
            
            if (y >= kPositionZero){
                CGRect f = self.tableView.frame;
                CGPoint finalOrigin = CGPointMake(0, y);
                f.origin = finalOrigin;
                self.tableView.transform = CGAffineTransformIdentity;
                self.tableView.frame = f;
                self.statusBarAndNaviBarBgView.alpha = 1-y/y2;
                if (y > y2) {
                    if (self.type == XTUserHomePageTypeMine) {
                        self.headView.frame = CGRectMake(0, y-y2, SCREEN_SIZE.width, kHeaderMineHeight);
                    }else if(self.type == XTUserHomePageTypeHis) {
                        self.headView.frame = CGRectMake(0, y-y2, SCREEN_SIZE.width, kHeaderHisHeight);
                    }else if(self.type == XTUserHomePageTypeArtist) {
                        self.artistHeadView.frame = CGRectMake(0, y-y2, SCREEN_SIZE.width, kHeaderArtistHeight);
                    }
                    self.backgroundImageView.transform = CGAffineTransformMakeScale((y-y2)/300+1, (y-y2)/300+1);
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded:{
            
            /*
            if (self.canNotPan) {
                self.canNotPan = NO;
                return;
            }*/
            float y;
            if ((translation.y > 0) && (self.currentCollectionViewCell.slideViewState == kDockDown)) {
                y = sqrt(translation.y) * sqrt(translation.y / 15);
            }else{
                y = translation.y;
            }
            if (self.currentCollectionViewCell.slideViewState == kDockDown && y > 50.0 && self.type == XTUserHomePageTypeMine) {
                [self refeshData];
            }
            [self adjustMyContainerView:velocity.y];
        }
            break;
        case UIGestureRecognizerStateCancelled:{
            
            /*
            if (self.canNotPan) {
                self.canNotPan = NO;
                return;
            }*/
            float y;
            if ((translation.y > 0) && (self.currentCollectionViewCell.slideViewState == kDockDown)) {
                y = sqrt(translation.y) * sqrt(translation.y / 15);
            }else{
                y = translation.y;
            }
            if (self.currentCollectionViewCell.slideViewState == kDockDown && y > 50.0 && self.type == XTUserHomePageTypeMine) {
                [self refeshData];
            }
            [self adjustMyContainerView:velocity.y];
        }
            break;
        default:
            break;
    }
}

- (void)onTap:(UITapGestureRecognizer *)tap{
    NSLog(@"tap手势");
    // 设置类型
    self.updateType = XTUserHeadUpdateBg;
    [self chooseHeadViewPicture];
}

-(void)postAdjustContainerView:(NSNotification *)notification{
//    NSNumber *number = (NSNumber *)notification.object;
//    CGFloat velocityY = [number floatValue];
//    [self adjustMyContainerView:velocityY];
}

- (void)adjustMyContainerView:(CGFloat)velocityY{
    CGPoint finalOrigin = CGPointMake(0, kPositionZero);
    CGFloat fullDistance = 0.0;
    //velocityY>0就是tableView往下移动
    if (velocityY > 0) {
        if (self.type == XTUserHomePageTypeMine){
            finalOrigin.y = kHeaderMineHeight;
        }else if(self.type == XTUserHomePageTypeHis){
            finalOrigin.y = kHeaderHisHeight;
        }else if(self.type == XTUserHomePageTypeArtist){
            finalOrigin.y = kHeaderArtistHeight;
        }
        fullDistance = finalOrigin.y - kPositionZero;
    }else if(velocityY < 0){
        if (self.type == XTUserHomePageTypeMine){
            fullDistance = kHeaderMineHeight - kPositionZero;
        }else if(self.type == XTUserHomePageTypeHis){
            fullDistance = kHeaderHisHeight - kPositionZero;
        }else if(self.type == XTUserHomePageTypeArtist){
            fullDistance = kHeaderArtistHeight - kPositionZero;
        }
    }
    
    CGRect f = self.tableView.frame;
    f.origin = finalOrigin;
    
    currentPoint = finalOrigin;
    /*
    // 根据手势速度计算动画时间
    NSLog(@"%f",velocityY);
    NSLog(@"%f",f.origin.y - self.tableView.frame.origin.y);
    CGFloat distance = f.origin.y - self.tableView.frame.origin.y;
    CGFloat animationTime = distance / velocityY;
    NSLog(@"%f",animationTime);
    
    // 根据总路程的百分比计算动画时间
    CGFloat distance = f.origin.y - self.tableView.frame.origin.y;
    CGFloat animationTime = distance / fullDistance * 0.5;*/
    
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.75 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundImageView.transform = CGAffineTransformMakeScale(1, 1);
                         self.tableView.transform = CGAffineTransformIdentity;
                         self.tableView.frame = f;
                         if (self.tableView.frame.origin.y == kPositionZero){
                             NSLog(@"........UP");
                             
                             self.view.backgroundColor = [UIColor whiteColor];
                             [self.currentCollectionViewCell setSlideViewState:kDockUp];
                             [self.currentCollectionViewCell setContentOffset:CGPointMake(0, 0)];
                             self.statusBarAndNaviBarBgView.alpha = 1.0;
                             [self.navigationActionBar setLeftBtnsImage:NO];
                             self.percentLabel.textColor = UIColorFromRGB(0x4f242b);
                             [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
                             
                             if (self.type == XTUserHomePageTypeMine) {
                                 [self.navigationActionBar setRightBtnsImage:NO];
                                 self.headView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, kHeaderMineHeight);
                             }else if(self.type == XTUserHomePageTypeHis) {
                                 self.headView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, kHeaderHisHeight);
                             }else if(self.type == XTUserHomePageTypeArtist) {
                                 self.artistHeadView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, kHeaderArtistHeight);
                             }
                             
                             [self.tableView updateConstraints:^(MASConstraintMaker *make) {
                                 if (self.type == XTUserHomePageTypeMine) {
                                     make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kPositionZero, 0, 54, 0));
                                 }else if (self.type == XTUserHomePageTypeHis){
                                     make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kPositionZero, 0, 0, 0));
                                 }else if (self.type == XTUserHomePageTypeArtist){
                                     make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kPositionZero, 0, 0, 0));
                                 }
                             }];
                             
                         } else if(self.tableView.frame.origin.y == kHeaderMineHeight||self.tableView.frame.origin.y == kHeaderHisHeight||self.tableView.frame.origin.y == kHeaderArtistHeight){
                             NSLog(@"........DOWN");
                             
                             self.view.backgroundColor = [UIColor blackColor];                             
                             [self.currentCollectionViewCell setSlideViewState:kDockDown];
                             [self.currentCollectionViewCell setContentOffset:CGPointMake(0, 0)];
                             self.statusBarAndNaviBarBgView.alpha = 0.0;
                             [self.navigationActionBar setLeftBtnsImage:YES];
                             self.percentLabel.textColor = [UIColor whiteColor];
                             [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                             
                             if (self.type == XTUserHomePageTypeMine) {
                                 [self.navigationActionBar setRightBtnsImage:YES];
                                 self.headView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, kHeaderMineHeight);
                             }else if(self.type == XTUserHomePageTypeHis) {
                                 self.headView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, kHeaderHisHeight);
                             }else if(self.type == XTUserHomePageTypeArtist) {
                                 self.artistHeadView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, kHeaderArtistHeight);
                             }
                             
                             [self.tableView updateConstraints:^(MASConstraintMaker *make) {
                                 if (self.type == XTUserHomePageTypeMine) {
                                     make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeaderMineHeight, 0, 54-kHeaderMineHeight, 0));
                                 }else if (self.type == XTUserHomePageTypeHis){
                                     make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeaderHisHeight, 0, 0-kHeaderHisHeight, 0));
                                 }else if (self.type == XTUserHomePageTypeArtist){
                                     make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeaderArtistHeight, 0, 0-kHeaderArtistHeight, 0));
                                 }
                             }];
                         }
                         
                     } completion:^(BOOL finished) {

                     }];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.backgroundImageView.transform = CGAffineTransformMakeScale(1, 1);
//    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil];
    [cell setClipsToBounds:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:[self collectionView]];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(cell.contentView);
        make.height.equalTo(cell.contentView);
        make.width.equalTo(cell.contentView);
    }];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.buttonActionBar;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 64.0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == XTUserHeadViewTypeMine) {
        return [UIScreen mainScreen].bounds.size.height-20-44-64-54;
    }
    return [UIScreen mainScreen].bounds.size.height-20-44-64;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.type == XTUserHomePageTypeArtist) {
        return 4;
    }
    
    if (self.userType == XTAccountCommon){
        return 4;
    }
    
    if (self.userType == XTAccountFans) {
        return 5;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if (self.type == XTUserHomePageTypeArtist) {
        switch (indexPath.row) {
            case 0:{
                XTLatestUpdateCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLatestUpdateCellIdentifier forIndexPath:indexPath];
                cell.userID = self.userID;
                cell.slideView.stateDelegate = self;
                if ([cell.imageInfoItem count] <= 0) {
                    [cell loadLatestUpdateDefaultData];
                }
                cell.slideViewState = self.currentCollectionViewCell.slideViewState;
                cell.slideView.contentOffset = CGPointMake(0, 0);
                self.currentCollectionViewCell = cell;
                cell.slideView.stateDelegate = self;
                
                return cell;
            }
                break;
            case 1:{
                XTDaysHotCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDaysHotCellIdentifier forIndexPath:indexPath];
                cell.userID = self.userID;
                cell.slideView.stateDelegate = self;
                if ([cell.imageInfoItem count] <= 0) {
                    [cell loadDaysHotNewData];
                }
                cell.slideViewState = self.currentCollectionViewCell.slideViewState;
                cell.slideView.contentOffset = CGPointMake(0, 0);
                self.currentCollectionViewCell = cell;
                cell.slideView.stateDelegate = self;
                
                return cell;
            }
                break;
            case 2:{
                XTLickManitoCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLickManitoCellIdentifier forIndexPath:indexPath];
                cell.userID = self.userID;
                cell.slideView.stateDelegate = self;
                if ([cell.imageInfoItem count] <= 0) {
                    [cell loadLickManitoNewData];
                }
                cell.slideViewState = self.currentCollectionViewCell.slideViewState;
                cell.slideView.contentOffset = CGPointMake(0, 0);
                self.currentCollectionViewCell = cell;
                cell.slideView.stateDelegate = self;
                
                return cell;
            }
                break;
            case 3:{
                XTDedicateListCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDedicateListCellIdentifier forIndexPath:indexPath];
                cell.userID = self.userID;
                
                if ([cell.dedicateUserItem count] <= 0) {
                    [cell loadDedicateListData];
                }
                cell.slideViewState = self.currentCollectionViewCell.slideViewState;
                cell.slideView.contentOffset = CGPointMake(0, 0);
                self.currentCollectionViewCell = cell;
                cell.slideView.stateDelegate = self;
                
                return cell;
            }
                break;
            default:
                break;
        }
        return cell;
    }else{
        switch (indexPath.row) {
            case 0:{
                XTAlbumDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAlbumDetailCellIdentifier forIndexPath:indexPath];
                if (self.type == XTUserHomePageTypeMine) {
                    cell.userID = [[XTUserStore sharedManager] user].userID;
                }else if (self.type == XTUserHomePageTypeHis){
                    cell.userID = self.userID;
                }
                /*
                 imageInfoItem数组个数大于零证明用户图片数据已经返回，以后的数据加载全部在类内部进行
                 */
                if ([self.picArray count] > 0) {
                    cell.imageInfoItem = [NSMutableArray arrayWithArray:self.picArray];
                    [self.picArray removeAllObjects];
                }
                [cell reloadCollectView];
                
                if (self.isRefreshAlbumDetail) {
                    [cell loadDefaultDataWithCompletionBlock:nil];
                }
                cell.slideViewState = self.currentCollectionViewCell.slideViewState;
                cell.slideView.contentOffset = CGPointMake(0, 0);
                self.currentCollectionViewCell = cell;
                cell.slideView.stateDelegate = self;
                return cell;
            }
                break;
            case 1:{
                XTAlbumListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAlbumListCellIdentifier forIndexPath:indexPath];
                if (self.type == XTUserHomePageTypeMine) {
                    cell.userID = [[XTUserStore sharedManager] user].userID;
                }else if (self.type == XTUserHomePageTypeHis){
                    cell.userID = self.userID;
                }
                
                if ([cell.albumInfoItem count] <= 0 || self.isRefreshAlbumList) {
                    [cell loadUserAlbumListNewDataWithCompletionBlock:nil];
                }
                cell.slideViewState = self.currentCollectionViewCell.slideViewState;
                cell.slideView.contentOffset = CGPointMake(0, 0);
                self.currentCollectionViewCell = cell;
                cell.slideView.stateDelegate = self;
                return cell;
            }
                break;
            case 2:{
                XTUserTopicCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUserTopicCellIdentifier forIndexPath:indexPath];
                if (self.type == XTUserHomePageTypeMine) {
                    cell.userID = [[XTUserStore sharedManager] user].userID;
                }else if (self.type == XTUserHomePageTypeHis){
                    cell.userID = self.userID;
                }
                
                if ([cell.topicArray count] <= 0 || self.isRefreshUserTopic){
                    [cell loadDefaultUserTopicDataWithCompletionBlock:nil];
                }
                cell.slideViewState = self.currentCollectionViewCell.slideViewState;
                cell.slideView.contentOffset = CGPointMake(0, 0);
                self.currentCollectionViewCell = cell;
                cell.slideView.stateDelegate = self;
                
                return cell;
            }
                break;
            case 3:{
                XTUserFilesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUserFilesCellIdentifier forIndexPath:indexPath];
                if (self.type == XTUserHomePageTypeMine) {
                    cell.userID = [[XTUserStore sharedManager] user].userID;
                }else if (self.type == XTUserHomePageTypeHis){
                    cell.userID = self.userID;
                }
                
                if (cell.userFilesInfo == nil || self.isRefreshUserFiles) {
                    [cell loadUserFilesDataWithCompletionBlock:nil];
                }
                cell.slideViewState = self.currentCollectionViewCell.slideViewState;
                cell.slideView.contentOffset = CGPointMake(0, 0);
                self.currentCollectionViewCell = cell;
                cell.slideView.stateDelegate = self;
                
                return cell;
            }
                break;
            case 4:{
                XTUserHonourCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUserHonourCellIdentifier forIndexPath:indexPath];
                if (self.type == XTUserHomePageTypeMine) {
                    cell.honours = [[XTUserStore sharedManager] user].honours;
                }else if (self.type == XTUserHomePageTypeHis) {
                    cell.honours = self.hisUserAccountInfo.honours;
                }
                //cell.slideViewState = self.currentCollectionViewCell.slideViewState;
                cell.slideView.contentOffset = CGPointMake(0, 0);
                self.currentCollectionViewCell = cell;
                cell.slideView.stateDelegate = self;
                
                return cell;
            }
                break;
            default:
                break;
        }
        return cell;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == XTUserHeadViewTypeMine) {
        return CGSizeMake(SCREEN_SIZE.width, SCREEN_SIZE.height-20-44-64-54);
    }
    return CGSizeMake(SCREEN_SIZE.width, SCREEN_SIZE.height-20-44-64);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectItem:%ld",(long)[indexPath row]);
}
// 用户详情信息加载
- (void)getUserDetailWithCompletionBlock:(void(^)(NSError *error))completionBlock
{
    //没有回调表示是普通刷新，有回调表示是下拉刷新不需要提示框
    if (!completionBlock) {
        [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    }
    NSString *userId = nil;
    if (self.type == XTUserHomePageTypeMine){
        userId = [[XTUserStore sharedManager] user].userID;
    }else if(self.type == XTUserHomePageTypeHis){
        userId = self.userID;
    }
    @weakify(self);
    [[XTUserStore sharedManager] showUserWithUserID:userId
                                    completionBlock:^(XTUserAccountInfo *user, NSArray *picArray, NSError *error){
                                        @strongify(self);
                                        if (!error) {
                                            self.panGesture.enabled = YES;
                                            [YYTBlankView hideFromView:self.view];//隐藏异常数据界面
                                            self.isFirstCreate = NO;
                                            self.isGetUserDetailSuccess = YES;
                                            self.isRefreshUserDetail = NO;
                                            [self statusBarAndNaviBarBgView];
                                            
                                            if (self.type == XTUserHomePageTypeMine) {
                                                [self getSignInInfoWithCompletionBlock:nil];
                                                self.currentUser = [[XTUserStore sharedManager] user];
                                                [self setBackgroundImage:_currentUser.bgImgURL];
                                            }else if (self.type == XTUserHomePageTypeHis){
                                                self.hisUserAccountInfo = user;
                                                [self setBackgroundImage:_hisUserAccountInfo.bgImgURL];
                                            }
                                            
                                            [self setNavigationActionBarStatus];
                                            self.picArray = [NSMutableArray arrayWithArray:picArray];
                                            self.userType = user.type;
                                            
                                            [self.headView fillUesrInformation:user];
                                            [self.view bringSubviewToFront:self.navigationActionBar];
                                            [self.view bringSubviewToFront:self.tableView];
                                            if (completionBlock) {
                                                completionBlock(nil);
                                            }
                                        }else if (completionBlock) {
                                            // 完成的回调失败不作处理
                                            completionBlock(error);
                                        }else{
                                            self.isGetUserDetailSuccess = NO;
                                            self.panGesture.enabled = NO;
                                            [self setNavigationActionBarErrorStatus];
                                            if (self.isFirstCreate) {
                                                YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
                                                    [self getUserDetailWithCompletionBlock:nil];
                                                }];
                                                blankView.error = error;
                                            }
                                            //[YYTHUD showPromptAddedTo:self.view withText:[error xtErrorMessage] withCompletionBlock:nil];
                                            [YYTHUD showPromptAddedTo:self.view withText:@"获取用户信息失败" withCompletionBlock:nil];
                                        }
                                        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
                                    }];
}
//签到信息加载
- (void)getSignInInfoWithCompletionBlock:(void(^)(NSError *error))completionBlock
{
    [[XTUserStore sharedManager] showSignInInfoCompletionBlock:^(XTUserAccountInfo *user, NSError *error) {
        if (!error) {
            self.isGetUserSignInSuccess = YES;
            [self.headView fillLocalUserSignInInfo:user];
            if (completionBlock) {
                completionBlock(nil);
            }
        }else if (completionBlock) {
            // 完成的回调失败不作处理
            completionBlock(error);
        }else{
            self.isGetUserSignInSuccess = NO;
            XTUserAccountInfo *user = [[XTUserAccountInfo alloc] init];
            user.continueDays = @"0";
            user.lastSignDate = [NSDate date];
            [self.headView fillLocalUserSignInInfo:user];
            //[YYTHUD showPromptAddedTo:self.view withText:[error xtErrorMessage] withCompletionBlock:nil];
            [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"获取签到信息失败" withCompletionBlock:nil];
        }

    }];
}

- (void)getArtistInfo
{
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    XTSubStore *subStore = [[XTSubStore alloc] init];
    [subStore fetchArtistShowFromArtistId:[self.userID integerValue] completionBlock:^(XTOrderArtist *artistInfo, NSError *error) {
        if (!error) {
            self.panGesture.enabled = YES;
            [YYTBlankView hideFromView:self.view];//隐藏异常数据界面
            self.isFirstCreate = NO;
            self.isGetArtistDetailSuccess = YES;
            self.artistInfo = artistInfo;
            [self.artistHeadView fillUesrInformation:artistInfo];
            
            [self statusBarAndNaviBarBgView];
            [self setBackgroundImage:[NSURL URLWithString:artistInfo.bigAvatar]];
            [self setNavigationActionBarStatus];
            
            [self.view bringSubviewToFront:self.navigationActionBar];
            [self.view bringSubviewToFront:self.tableView];
        }else{
            self.isGetArtistDetailSuccess = NO;
            self.panGesture.enabled = NO;
            if (self.isFirstCreate) {
                YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
                    [self getArtistInfo];
                }];
                blankView.error = error;
            }
            //[YYTHUD showPromptAddedTo:self.view withText:[error xtErrorMessage] withCompletionBlock:nil];
            [YYTHUD showPromptAddedTo:self.view withText:@"获取艺人信息失败" withCompletionBlock:nil];
        }
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
    }];
}

- (void)uploadProgress:(NSNotification *)notification
{
    NSDictionary *dic = [notification object];
    if (dic) {
        int totalPage = [[dic objectForKey:@"totalPage"] intValue];
        int currentPage = [[dic objectForKey:@"currentPage"] intValue];
        float percent = [[dic objectForKey:@"percent"] floatValue];
        NSLog(@"图片总数:%d,当前第几张:%d,已上传的百分比:%f",totalPage, currentPage, percent);
        float totalProgress = 100/totalPage*percent+100/totalPage*(currentPage-1);
        self.percentLabel.text = [NSString stringWithFormat:@"正在上传：%.0f%%",totalProgress];
        self.percentLabel.hidden = [[dic objectForKey:@"isLastImage"] boolValue];
    }else{
        self.percentLabel.hidden = YES;
    }
}

#pragma mark - SlideCollectionViewDelegate

-(State)SlideCollectionViewCheckState:(SlideCollectionView *)SlideCollectionView{
    if (self.tableView.frame.origin.y == kPositionZero){
        //[self.currentCollectionViewCell setSlideViewState:kDockUp];
        return kDockUp;
    } else if(self.tableView.frame.origin.y == kHeaderMineHeight||self.tableView.frame.origin.y == kHeaderHisHeight||self.tableView.frame.origin.y == kHeaderArtistHeight){
        //[self.currentCollectionViewCell setSlideViewState:kDockDown];
        return kDockDown;
    }
    return kDockMiddle;
}

#pragma mark - SlideTableViewDelegate

-(State)SlideTableViewCheckState:(SlideTableView *)SlideTableView{
    if (self.tableView.frame.origin.y == kPositionZero){
        //[self.currentCollectionViewCell setSlideViewState:kDockUp];
        return kDockUp;
    } else if(self.tableView.frame.origin.y == kHeaderMineHeight||self.tableView.frame.origin.y == kHeaderHisHeight||self.tableView.frame.origin.y == kHeaderArtistHeight){
        //[self.currentCollectionViewCell setSlideViewState:kDockDown];
        return kDockDown;
    }
    return kDockMiddle;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
