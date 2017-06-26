//
//  XTTabBarController.h
//  tian
//
//  Created by 尚毅 杨 on 15/4/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTTabBarController : UIViewController//UITabBarController

@property (nonatomic, assign,getter=isNeddGuide) BOOL needGuide;
@property (nonatomic, assign) BOOL isImageUploadComplete;
@property (nonatomic, strong) NSMutableDictionary*	tabBarViewControllers;	//存储TabBar视图
- (void)hideBottomViewWhenPushed;
- (void)showBottomViewWhenPoped;

- (UIViewController*)currentVC;
@end
