//
//  UIViewController+Extend.m
//  tian
//
//  Created by huhuan on 15/7/8.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "UIViewController+Extend.h"
#import "XTTabBarController.h"
#import "XTNavigationController.h"
#import "XTUserHomePageViewController.h"
@implementation UIViewController (Extend)

+ (UIViewController *)currentViewController {
    UINavigationController *navigationController = [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    return navigationController.topViewController;
}

+ (UINavigationController *)topViewController {
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UINavigationController *)topViewController:(UIViewController *)rootViewController
{
    if([rootViewController isKindOfClass:[XTTabBarController class]]) {
        XTTabBarController *tabbarController = (XTTabBarController *)rootViewController;
        return (XTNavigationController *)[tabbarController currentVC];
    }
    return nil;
}

+ (XTTabBarController *)tabBarController{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[XTTabBarController class]]) {
        XTTabBarController *tabbarController = (XTTabBarController *)rootViewController;
        return tabbarController;
    }
    return nil;
}

+ (XTUserHomePageViewController *)UserHomePageController{
    XTNavigationController *userHomePageNavi = [self tabBarController].tabBarViewControllers[@(3)];
    UIViewController *controller = [[userHomePageNavi viewControllers] objectAtIndex:0];
    if ([controller isKindOfClass:[XTUserHomePageViewController class]]) {
        return (XTUserHomePageViewController *)controller;
    }
    return nil;
}

@end
