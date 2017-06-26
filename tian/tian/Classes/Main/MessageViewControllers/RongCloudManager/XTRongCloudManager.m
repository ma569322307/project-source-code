//
//  XTRongCloudManager.m
//  tian
//
//  Created by cc on 15/7/11.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTRongCloudManager.h"
#import "XTBindApnsStore.h"
#define XTMaxConnectCount 3
@interface XTRongCloudManager()
@property (nonatomic, assign) NSInteger connectCount;//请求服务器次数，最多3次
@end

@implementation XTRongCloudManager
+ (XTRongCloudManager *)shareInstance
{
    static XTRongCloudManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.connectCount = 0;
    }
    return self;
}
- (void)registeredRongCloud
{
    //融云
//    NSString *deviceTokenCache =
//    [XTBindApnsStore sharedManager].apnsToken;
    [[RCIM sharedRCIM] initWithAppKey:XTRongCloud_AppKey];
    //关闭提示声音
    [RCIM sharedRCIM].disableMessageAlertSound = YES;
    //关闭推送
    [RCIM sharedRCIM].disableMessageNotificaiton = YES;
    //设置会话列表头像和会话界面头像
    if (iPhone6Plus) {
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(56, 56);
    } else {
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    }
    
    [self setDataSourceDelegate];
    
    //收到消息的通知方法
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
}
- (void)rongCloudLogin
{
    //未登录时return
    if (![[XTUserStore sharedManager] isLogin])
        return;
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[XTUserStore sharedManager].user.userID]) {
        [self connectRongCloud];
    }else
    {
        [self getTheRongCloudToken];
    }
}
- (void)rongCloudLogout
{
    [[RCIM sharedRCIM] logout];
}

/**
 *   获取融云token
 */
- (void)getTheRongCloudToken
{
    self.connectCount+=1;
    if (self.connectCount>XTMaxConnectCount)
        return;
    
    if ([XTUserStore sharedManager].user.userID&&[XTUserStore sharedManager].user.nickname) {
        
    
    [[[XTMessageStore alloc]init] fetchRongTokenWithUserId:[XTUserStore sharedManager].user.userID userName:[XTUserStore sharedManager].user.nickname CompletionBlock:^(id token, NSError *error) {
        if (!error) {
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:[XTUserStore sharedManager].user.userID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self connectRongCloud];
        }else
        {
            CLog(@"获取token失败--%@",error);
        }
    }];
    }
}
/**
 *  连接融云服务器 。。
 */
- (void)connectRongCloud
{
    NSString *Rtoken = [[NSUserDefaults standardUserDefaults] objectForKey:[XTUserStore sharedManager].user.userID];
    [[RCIM sharedRCIM] connectWithToken:Rtoken success:^(NSString *userId) {
        CLog(@"融云连接成功Userid = %@",userId);
        self.connectCount = 0;
    } error:^(RCConnectErrorCode status) {
        CLog(@"融云连接失败 status = %zd",status);
        [self getTheRongCloudToken];
    } tokenIncorrect:^{
        CLog(@"融云Token失效");
        
        [self getTheRongCloudToken];
    }];
    
}

- (void)setDataSourceDelegate
{
    [[RCIM sharedRCIM] setUserInfoDataSource:XTPMessageDataSource];
    [[RCIM sharedRCIM] setGroupInfoDataSource:XTPMessageDataSource];

}



- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    
}
//收到消息
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PrivateMessageKey" object:nil];
    
    //    [UIApplication sharedApplication].applicationIconBadgeNumber =
    //    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}
@end
