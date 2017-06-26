//
//  XTNavigationController.m
//  tian
//
//  Created by 尚毅 杨 on 15/4/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTNavigationController.h"
#import "AddPhotoViewController.h"
#import "XHTransitionProtocol.h"
#import "UICollectionView+XHIndexPath.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#define UIColorFromRGB(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])
@interface XTNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation XTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    [self setNavBackgroundImage];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x4f242b),NSForegroundColorAttributeName, nil]];
    
    [self.navigationBar setShadowImage:[UIImage new]];
    self.fd_fullscreenPopGestureRecognizer.enabled = YES;
    
//    __weak XTNavigationController *weakSelf = self;
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
//        
//    {
//        
//        self.interactivePopGestureRecognizer.delegate = weakSelf;
//        
//        self.delegate = weakSelf;
//        
//    }
    
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated  {
//    
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES)
//        
//        self.interactivePopGestureRecognizer.enabled = NO;
//
//    [super pushViewController:viewController animated:animated];
//    
//}
//
//
//
//- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
//    
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]&&animated == YES)
//        
//        self.interactivePopGestureRecognizer.enabled = NO;
//
//    return  [super popToRootViewControllerAnimated:animated];
//    
//}
//
//
//
//- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
//        
//        self.interactivePopGestureRecognizer.enabled = NO;
//    
//    return [super popToViewController:viewController animated:animated];
//    
//}

//#pragma mark UINavigationControllerDelegate
//
//
//
//- (void)navigationController:(UINavigationController *)navigationController
//       didShowViewController:(UIViewController *)viewController
//                    animated:(BOOL)animate {
//    
//    // Enable the gesture again once the new controller is shown
//    
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && ![viewController isKindOfClass:[AddPhotoViewController class]]){
//        
//        self.interactivePopGestureRecognizer.enabled = YES;
//        
//    }else {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
//    
//}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    id<UIViewControllerTransitionCoordinator> tc = navigationController.topViewController.transitionCoordinator;
    [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        NSLog(@"7: %i", [context isCancelled]);
    }];
}



//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    
//    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
//        
//        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
//            
//            return NO;
//            
//        }
//        
//    }
//    
//    return YES;
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setNavColor
//{
//    self.navigationBar.backItem.hidesBackButton = YES;
//    
//    [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    
//    self.navigationBar.translucent = NO;
//    
//    self.navigationBar.tintColor = UIColorFromRGB(0x27d5bf, 1);
//    
//    if ([self.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
//        [self.navigationBar setBarTintColor:UIColorFromRGB(0x27d5bf, 1)];
//    }
//}


- (void)setNavBackgroundImage
{
    self.navigationBar.backItem.hidesBackButton = YES;
    UIImage* bgImg = [UIImage imageNamed:@"Tabbar_nav_title"];
    
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - Pop Helper Method

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    NSInteger childrenCount = self.viewControllers.count;
    
    XTRootViewController <XHTransitionProtocol, XHWaterFallViewControllerProtocol> *toViewController = (XTRootViewController <XHTransitionProtocol, XHWaterFallViewControllerProtocol> *)self.viewControllers[childrenCount - 2];
    if ([toViewController isKindOfClass:[XTRootViewController class]] && toViewController.needTranform) {
        UICollectionView *toView = [toViewController transitionCollectionView];
        UIViewController *popedViewController = self.viewControllers[childrenCount - 1];
        
        UICollectionView *popView  = [popedViewController valueForKey:@"collectionView"];
        NSIndexPath *indexPath = [popView currentIndexPath];
        
        [toViewController viewWillAppearWithPageIndex:indexPath.row];
        [toView setCurrentIndexPath:[popView currentIndexPath]];
    }
    return [super popViewControllerAnimated:animated];
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 专门对于友盟统计的适配，将导航栏的透明度开放
    if (viewController.view.tag == 56700) {
        self.navigationBar.translucent = YES;
    }else{
        self.navigationBar.translucent = NO;
    }
    [super pushViewController:viewController animated:animated];
}


@end
