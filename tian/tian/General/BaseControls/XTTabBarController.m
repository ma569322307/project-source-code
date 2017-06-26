//
//  XTTabBarController.m
//  tian
//
//  Created by 尚毅 杨 on 15/4/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTabBarController.h"
#import "JKImagePickerController.h"
#import "PhotoCell.h"
#import "XTHomePageViewController.h"
#import "XTHotLicksViewController.h"
#import "XTMessageViewController.h"
#import "XTUserHomePageViewController.h"
#import "XTNavigationController.h"
#import "XTTabBarSelectedView.h"
#import "AddPhotoViewController.h"
#import "UIViewController+Extend.h"
#define kTabBarHeight	49.0+5.0											//Tabbar高度

@interface XTTabBarController ()<JKImagePickerControllerDelegate>{
}
@property(nonatomic, strong) XTTabBarSelectedView*	tabBar;
@property(nonatomic, strong) NSLayoutConstraint*	tabBarHeight;

@property(nonatomic, readwrite) NSInteger			currentPos;				//当前TabBar视图pos
//@property(nonatomic, strong) NSMutableDictionary*	tabBarViewControllers;	//存储TabBar视图


@property(nonatomic, weak)	UIViewController*		selectedVC;				//指向当前VC

@property(nonatomic, strong) NSLayoutConstraint*	playDeliverTop;

@property (nonatomic, strong) NSMutableArray   *assetsArray;

@property (nonatomic, weak) UIImageView *guideImageView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end

@implementation XTTabBarController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isImageUploadComplete = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showTabBar:)
                                                     name:@"isShowTabBarNotification"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showUserHomePage)
                                                     name:@"showUserHomePageNotification"
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.tabBarViewControllers = [[NSMutableDictionary alloc] initWithCapacity:4];
    self.currentPos = -1;

    XTHomePageViewController *homePageVC = [[XTHomePageViewController alloc] initWithNibName:@"XTHomePageViewController" bundle:nil];
    XTNavigationController *homePageNV = [[XTNavigationController alloc] initWithRootViewController:homePageVC];
    self.tabBarViewControllers[@(0)] = homePageNV;

    XTHotLicksViewController *hotLicksVC = [[XTHotLicksViewController alloc] initWithNibName:@"XTHotLicksViewController" bundle:nil];
    XTNavigationController *hotLicksNV = [[XTNavigationController alloc] initWithRootViewController:hotLicksVC];
    self.tabBarViewControllers[@(1)] = hotLicksNV;

    XTMessageViewController *messageVC = [[XTMessageViewController alloc] initWithNibName:@"XTMessageViewController" bundle:nil];
    XTNavigationController *messageNV = [[XTNavigationController alloc] initWithRootViewController:messageVC];
    self.tabBarViewControllers[@(2)] = messageNV;
    
    XTUserHomePageViewController *userHomeVC = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
//    userHomeVC.type = XTUserHomePageTypeArtist;
//    userHomeVC.userType = XTAccountCommon;
//    userHomeVC.userID = @"154";
    
    XTNavigationController *userHomeNV = [[XTNavigationController alloc] initWithRootViewController:userHomeVC];
    self.tabBarViewControllers[@(3)] = userHomeNV;
    
    [self createTarBar];
    //设置选项卡状态 及 设置 选项卡视图
    [_tabBar setCustomPos:0];
    [self toClickVC:0];
    //判断是否需要展示引导
    if (self.isNeddGuide) {
        //展示引导
        [self.guideImageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
}

- (UIImage*)imageFromColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
//    self.assetsArray = [NSMutableArray arrayWithArray:assets];
//    
//    [imagePicker dismissViewControllerAnimated:YES completion:^{
//        XTNavigationController *currentCtr = (XTNavigationController *)self.tabBarViewControllers[@(self.currentPos)];
//        AddPhotoViewController *addPhotoCtr = [[AddPhotoViewController alloc] init];
//        addPhotoCtr.assetsArray = self.assetsArray;
//        addPhotoCtr.selectedAssetIndexArray = imagePicker.selectedAssetIndexArray;
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"NO",@"isShowTabBar",nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"isShowTabBarNotification" object:dic];
//        [currentCtr pushViewController:addPhotoCtr animated:YES];
//    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)tapClick:(UITapGestureRecognizer *)tap{
    [self.guideImageView removeFromSuperview];
}
#pragma mark 创建底部选项卡TabBar
/**
 * 创建底部选项卡
 */
- (void)createTarBar
{
    _tabBar = [[XTTabBarSelectedView alloc] init];
    [_tabBar setBackgroundColor:[UIColor colorWithRed:253.0/255.0 green:229.0/255.0 blue:13.0/255.0 alpha:1.0]];
    [self.view addSubview:_tabBar];
    
    [_tabBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(kTabBarHeight);
    }];
    
    __block XTTabBarController* _self = self;
    _tabBar.customButtonDelegate = ^(NSInteger pos) {
        NSLog(@"%d",(int)pos);
        if (_self.currentPos == pos-100) {
            //点击当前页面的tabar按钮
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToTopAndRefreshView" object:[NSNumber numberWithInteger:_self.currentPos]];
        }else
        {
            [_self toClickVC:pos-100];
        }
    };
    
    _tabBar.playButtonDelegate = ^() {
        NSLog(@"点击中间按钮");
        [_self composePicAdd];
    };
}

- (void)composePicAdd
{
    if ([[XTHTTPRequestOperationManager sharedManager] reachable] == NO) {
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow
                         withText:@"网络未连接"
              withCompletionBlock:nil];
        return;
    }
    
    if (_isImageUploadComplete) {
        JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.showsCancelButton = YES;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.minimumNumberOfSelection = 1;
        imagePickerController.maximumNumberOfSelection = 9;
        imagePickerController.needPush = YES;
        UINavigationController *navigationController = [[XTNavigationController alloc] initWithRootViewController:imagePickerController];
        if (self.currentPos == 3) {
            XTNavigationController * XTNavi = (XTNavigationController *)[UINavigationController topViewController];
            if ([XTNavi.topViewController isKindOfClass:[XTUserHomePageViewController class]]) {
                XTUserHomePageViewController *userHomeCtr = (XTUserHomePageViewController *)XTNavi.topViewController;
                userHomeCtr.imagePickerWillDisplay = YES;
                [self presentViewController:navigationController animated:YES completion:^{
                    userHomeCtr.imagePickerWillDisplay = NO;
                }];
            }
        }else{
            [self presentViewController:navigationController animated:YES completion:nil];
        }
    }else{
        [YYTHUD showPromptAddedTo:self.view withText:@"当前有正在上传的图片" withCompletionBlock:nil];
    }
}

#pragma mark 显示 或者 隐藏 自定义TabBar
/**
 *隐藏自定义TabBar
 */
- (void)hideBottomViewWhenPushed
{
    //UIViewController* vc = self.tabBarViewControllers[@(self.currentPos)];
    //vc.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.tabBar.hidden = YES;
}

/**
 *显示自定义Tabbar
 */
- (void)showBottomViewWhenPoped
{
    //UIViewController* vc = self.tabBarViewControllers[@(self.currentPos)];
    //vc.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - kTabBarHeight);
    
    self.tabBar.hidden = NO;
}

#pragma mark 选项卡选取视图
/**
 *选项卡选取视图
 */
- (void)toClickVC:(NSInteger)pos
{
    UIViewController* toView = self.tabBarViewControllers[@(pos)];
    
//    toView.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - kTabBarHeight);
    
    [self addChildViewController:toView];
    [self.view insertSubview:toView.view belowSubview:_tabBar];
    [toView didMoveToParentViewController:self];
    
    self.selectedVC = toView;
    
    if (self.currentPos == -1) {
        
        self.currentPos = pos;
        
        return;
    }
    
    UIViewController* fromView = self.tabBarViewControllers[@(self.currentPos)];
    [fromView willMoveToParentViewController:self];
    [fromView.view removeFromSuperview];
    [fromView removeFromParentViewController];
    
    self.currentPos = pos;
}

- (UIViewController*)currentVC
{
    return self.selectedVC;
}

- (void)showTabBar:(NSNotification *)notification{
    NSDictionary *dic = [notification object];
    if ([[dic objectForKey:@"isShowTabBar"] isEqualToString:@"NO"]) {
        [self hideBottomViewWhenPushed];
    }else if([[dic objectForKey:@"isShowTabBar"] isEqualToString:@"YES"]){
        [self showBottomViewWhenPoped];
    }
}

- (void)showUserHomePage{
    if (self.currentPos != 3) {
        [_tabBar setCustomPos:3];
        [self toClickVC:3];
    }
}
#pragma mark 懒加载
-(UIImageView *)guideImageView{
    if (_guideImageView == nil) {
        NSString *guideName;
        if ([UIScreen mainScreen].bounds.size.width > 320) {
            guideName = @"GuideHomePage6";
        }else{
            guideName = @"GuideHomePage";
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:guideName]];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:self.tap];
        [self.view addSubview:imageView];
        _guideImageView = imageView;
    }
    return _guideImageView;
}
-(UITapGestureRecognizer *)tap{
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    }
    return _tap;
}
@end
