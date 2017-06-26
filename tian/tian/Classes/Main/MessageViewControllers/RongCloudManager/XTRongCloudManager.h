//
//  XTRongCloudManager.h
//  tian
//
//  Created by cc on 15/7/11.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RongIMKit/RongIMKit.h>
#import "XTPrivateMessageDataSource.h"
#import "XTMessageStore.h"
#import "XTUserStore.h"

#define XTRongCloud_AppKey @"pgyu6atqyrvnu"
#define XTRongCloud_AppSecret @"DPEx4PnVgTY"
//#define kDeviceToken @"RongCloud_SDK_DeviceToken"

@interface XTRongCloudManager : NSObject
+ (XTRongCloudManager *)shareInstance;
- (void)registeredRongCloud;
- (void)rongCloudLogin;
- (void)setDataSourceDelegate;
- (void)rongCloudLogout;
@end
