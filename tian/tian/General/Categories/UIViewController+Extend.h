//
//  UIViewController+Extend.h
//  tian
//
//  Created by huhuan on 15/7/8.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTTabBarController,XTUserHomePageViewController;
@interface UIViewController (Extend)

+ (UIViewController *)currentViewController;
+ (UINavigationController *)topViewController;
+ (XTTabBarController *)tabBarController;
+ (XTUserHomePageViewController *)UserHomePageController;

@end
