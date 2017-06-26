//
//  AppDelegate.h
//  tian
//
//  Created by 尚毅 杨 on 15/4/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>//QQ空间

#import "XTShareManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,QQApiInterfaceDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

