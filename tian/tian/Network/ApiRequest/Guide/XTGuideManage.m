//
//  XTGuideManage.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/4.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTGuideManage.h"
#import "XTAddLikeAndHateViewController.h"
#import "XTGuideAnimationController.h"
#import "XTTabBarController.h"
#import "XTNavigationController.h"
#import "XTLoginViewController.h"
#import "XTUserStore.h"
@implementation XTGuideManage
static NSString *guideAnimationKey = @"guideAnimationKey";
static NSString *guideChooseLikeKey = @"guideChooseLikeKey";
static NSString *guideHomePageGuideKey = @"guideHomePageGuideKey";
static NSString *guidePhotoUploadKey = @"guidePhotoUploadKey";
static NSString *guidePhotoCreateKey = @"guidePhotoCreateKey";
/// 单例创建
+(instancetype)sharedGuideManage{
    static XTGuideManage *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[self alloc] init];
    });
    return _shareManager;
}
///根据具体情况选择最开始需要显示的类型
+(XTGuideType)chooseDisplayType{
    //需要引导动画
    if ([self checkGuideAnimationNeeded]) {
        return XTGuideAnimation;
    }
    //需要选择喜欢艺人
    if ([self checkChooseLikeNeeded]) {
        return XTGuideChooseLike;
    }
    //需要主页面引导
    if ([self checkHomePageGuideNeeded]) {
        return XTGuideHomePageGuide;
    }
    //直接显示主页面
    return XTGuideNormal;
}

///判断引导动画第一次
+(BOOL)checkGuideAnimationNeeded{
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    return ![bundleId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:guideAnimationKey]];
}
///设置引导动画
+(void)setGuideAnimationNeeded{
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    [[NSUserDefaults standardUserDefaults] setObject:bundleId forKey:guideAnimationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///判断添加喜欢艺人第一次
+(BOOL)checkChooseLikeNeeded{
    return [self checkGuideNeededForKey:guideChooseLikeKey];
}
///设置添加艺人
+(void)setChooseLikeNeeded{
    [self setGuideNeededForKey:guideChooseLikeKey];
}

///判断主页引导第一次
+(BOOL)checkHomePageGuideNeeded{
    return [self checkGuideNeededForKey:guideHomePageGuideKey];
}
///设置主页引导
+(void)setHomePageGuideNeeded{
    [self setGuideNeededForKey:guideHomePageGuideKey];
}

///判断贴图界面第一次
+(BOOL)checkPhotoCreateNeeded{
    return [self checkGuideNeededForKey:guidePhotoCreateKey];
}
///设置贴图界面第一次
+(void)setPhotoCreateNeeded{
    [self setGuideNeededForKey:guidePhotoCreateKey];
}

///判断贴图界面第一次
+(BOOL)checkPhotoUploadNeeded{
    return [self checkGuideNeededForKey:guidePhotoUploadKey];
}
///设置贴图界面第一次
+(void)setPhotoUploadNeeded{
    [self setGuideNeededForKey:guidePhotoUploadKey];
}

///判断第一次
+(BOOL)checkGuideNeededForKey:(NSString *)key{
    NSString *localKey = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return ![localKey isEqualToString:key];
}
///设置第一次
+(void)setGuideNeededForKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(UIViewController *)createDispayViewController{
    ///引导动画
    if ([self chooseDisplayType] == XTGuideAnimation) {
        XTGuideAnimationController *vc = [[XTGuideAnimationController alloc] init];
        [self setGuideAnimationNeeded];
        return vc;
    }
    ///登录界面
    if (![[XTUserStore sharedManager] isLogin]) {
        XTLoginViewController *loginViewController = [[XTLoginViewController alloc] init];
        XTNavigationController *loginViewControllerNV = [[XTNavigationController alloc] initWithRootViewController:loginViewController];
        return loginViewControllerNV;
    }
    
    ///喜欢艺人
    if ([self chooseDisplayType] == XTGuideChooseLike) {
        XTAddLikeAndHateViewController *vc = [[XTAddLikeAndHateViewController alloc] initWithNibName:@"XTAddLikeAndHateViewController" bundle:nil];
        vc.buttonStyle = XTUserCollectionViewCellButtonStyleLike;
        vc.displayType = XTAddLikeAndHateGuidePage;
        XTNavigationController *nv = [[XTNavigationController alloc] initWithRootViewController:vc];
        [self setChooseLikeNeeded];
        return nv;
    }
    ///主界面
    XTTabBarController *tabbarController = [[XTTabBarController alloc] init];
    //需要引导添加引导界面
    tabbarController.needGuide = [self chooseDisplayType] == XTGuideHomePageGuide;
    [self setHomePageGuideNeeded];
    return tabbarController;
}
///设置第一次
+(void)resetGuideNeededForKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}
+(void)resetGuideSettings{
    NSArray *keys = @[guideAnimationKey,guideChooseLikeKey,guideHomePageGuideKey,guidePhotoCreateKey,guidePhotoUploadKey];
    for (NSString *key in keys) {
        [self resetGuideNeededForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
