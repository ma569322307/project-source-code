//
//  AppDelegate.m
//  tian
//
//  Created by 尚毅 杨 on 15/4/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "AppDelegate.h"
#import "XTTabBarController.h"
#import "XTUserStore.h"
#import "XTLoginViewController.h"
#import "XTNavigationController.h"
#import "KeyboardManager.h"
#import "XTLocalImageStoreManage.h"
#import "XTShareManager.h"

#import "XTGuideAnimationController.h"
#import "XTGuideManage.h"
#import "XTPushToOtherVCManager.h"

#import "XTBindApnsStore.h"
#import "XTRongCloudManager.h"

#import "UIViewController+Extend.h"
#import "XTUnReadMessageCountStore.h"
#import "XTShareStatistic.h"
#import "XTConfig.h"
#import "OpenUDID.h"

@interface AppDelegate () <UIAlertViewDelegate>
{
    BOOL __needCheckForceUpdate;
    XTShareManager *_shareManager;
}
@property (nonatomic, strong) NSTimer *requestUnReadMessageTimer;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"     %f    ",[UIApplication sharedApplication].keyWindow.center.x);

    //友盟
    [MobClick startWithAppkey:@"54f98d84fd98c5845c00037c"];
//    [MobClick startWithAppkey:@"54f98d84fd98c5845c00037c" reportPolicy:BATCH channelId:@"110060000"];
    //消息未读数
    [self startGetUnReadCountTimer];
    //融云IM
    [[XTRongCloudManager shareInstance] registeredRongCloud];
    [[XTRongCloudManager shareInstance] rongCloudLogin];
    
    // 先导入系统logo
    [[XTLocalImageStoreManage sharedLocalImageStoreManage] storeSystemLogos];
    NSLog(@"%@",NSHomeDirectory());
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    
    _shareManager = [XTShareManager sharedManager];

    
    //选择控制器
    [self createRootView];
    
    
    //注册推送通知
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 8000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert];
#endif
    
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        CLog(@"进入程序有推送消息");
        [self handlePushDataWith:remoteNotification isActive:NO];
    }

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    //升级umeng参数，及是否需要更新
    __needCheckForceUpdate = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configParamsUpdateSuccess:) name:UMOnlineConfigDidFinishedNotification object:nil];
    [MobClick updateOnlineConfig];
    
    //启动统计
    [self launchAppRequest];

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    return YES;
}

/**
 *  检查是否需要强制更新
 */
- (void)checkForceUpdate {
    
    NSString *forceUpdate = [MobClick getConfigParams:@"starpic_upgrade"];
    
    if(forceUpdate) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSComparisonResult result = [version compare:forceUpdate];
        
        if(result == NSOrderedAscending) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的应用版本过低，需要强制更新" delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:nil];
            alertView.tag = 1001;
            [alertView show];

        }else {
            [MobClick checkUpdate];
        }
    }else {
        [MobClick checkUpdate];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1001 && buttonIndex == alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id973879340"]];
    }
}

- (void)configParamsUpdateSuccess:(NSNotification *)notification {
    [self checkForceUpdate];
}

/**
 *  启动app时发送统计请求
 */
- (void)launchAppRequest {
    NSString *appId = [[XTConfig sharedManager] appID];
    NSString *info = [XTConfig md5:[NSString stringWithFormat:@"%@%@%@",appId, @"8J%^jds@1g", [XTConfig md5:[OpenUDID value]]]];
    NSDictionary *parameters = @{
                                 @"s" : info
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:@"http://statistics.yinyuetai.com/statistics/pulse_on.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 未读消息
//获取未读消息数
-(void)startGetUnReadCountTimer{
    CLog(@"广场每60s定时获取消息未读数");
    _requestUnReadMessageTimer = [NSTimer scheduledTimerWithTimeInterval:600
                                                                  target:self
                                                                selector:@selector(requestUnReadMessageCount)
                                                                userInfo:nil
                                                                 repeats:YES];
    
}
//是否有新消息
-(void)requestUnReadMessageCount
{
    [[XTUnReadMessageCountStore getInstance] fetchUnReadMessageCount];
}


#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // Register to receive notifications.
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    // Handle the actions.
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{

    NSString *cacheToken  = [XTBindApnsStore sharedManager].apnsToken;
    if (deviceToken&&!cacheToken) {
        NSString *token = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
//        [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
//                                                               withString:@""]
//          stringByReplacingOccurrencesOfString:@">"
//          withString:@""]
//         stringByReplacingOccurrencesOfString:@" "
//         withString:@""];
        [XTBindApnsStore sharedManager].apnsToken = token;
        [[XTBindApnsStore sharedManager] bindApns];
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"tishi" message:token delegate:nil cancelButtonTitle:@"quxiao" otherButtonTitles:nil, nil];
//        [alert show];
        
        [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    }
    
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    CLog(@"获取deviceToken失败了  %@",error);
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[url absoluteString] hasPrefix:APPID_WeiXin]) {
        return  [WXApi handleOpenURL:url delegate:self];
    }else if ([[url absoluteString] hasPrefix:APPID_Qzone]) {
        [QQApiInterface handleOpenURL:url delegate:self];
        return [TencentOAuth HandleOpenURL:url];
    }else if ([[url absoluteString] hasPrefix:APPID_SinaWeiBo]) {
        return [WeiboSDK handleOpenURL:url delegate:_shareManager];
    }
    NSLog(@"handleOpenUrl = %@",url);
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url absoluteString] hasPrefix:APPID_WeiXin]) {
        return  [WXApi handleOpenURL:url delegate:self];
    }else if ([[url absoluteString] hasPrefix:APPID_Qzone]) {
        [QQApiInterface handleOpenURL:url delegate:self];
        return [TencentOAuth HandleOpenURL:url];
    }else if ([[url absoluteString] hasPrefix:APPID_SinaWeiBo]) {
        return [WeiboSDK handleOpenURL:url delegate:_shareManager];
    }
    NSLog(@"OpenUrl = %@",url);
    return YES;
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    UIApplicationState state = [application applicationState];
    BOOL isActive = NO;
    if (state == UIApplicationStateActive) {
        isActive = YES;
    }
    NSDictionary *pushDic = [NSDictionary dictionaryWithDictionary:userInfo];
    CLog(@"推送消息  %@ isActive = %d",userInfo,isActive);
    [self handlePushDataWith:pushDic isActive:isActive];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  /*
   融云
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                        ]];
    //TODO: 产品说私信条数不用显示
 //   application.applicationIconBadgeNumber = unreadMsgCount;
   */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //检查是否需要强制更新app
    if(__needCheckForceUpdate) {
        [self checkForceUpdate];
    }else {
        __needCheckForceUpdate = YES;
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//推送通知跳转
- (void)handlePushDataWith:(NSDictionary *)pushData isActive:(BOOL)isActive
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if (!pushData) {
        return;
    }
    
    
    NSString *dataType = [pushData objectForKey:@"dataType"];
    NSDictionary *dataDic = [NSDictionary dictionary];
    
    
    
    if ([[pushData objectForKey:@"data"] isKindOfClass:[NSString class]]) {
        NSString *dataStr = [pushData objectForKey:@"data"];
        NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        dataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            CLog(@"解析失败");
        }
        CLog(@"解析后的data==%@",dataDic);
    }else if ([[pushData objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
    {
        dataDic = [pushData objectForKey:@"data"];
    }
    CLog(@"class==%@",[[pushData objectForKey:@"data"] class]);
    
    long dataId = [[dataDic objectForKey:@"id"] longLongValue];
    BOOL isLogin= [[XTUserStore sharedManager] isLogin];
    
    if (!isLogin) {
        return;
    }
    if (isActive) {
        return;
    }
    
    XTMessageInfo *messageInfo = [[XTMessageInfo alloc]init];
    if ([[dataDic objectForKey:@"id"] isKindOfClass:[NSString class]]) {
        messageInfo.dataId = [dataDic objectForKey:@"id"];
    }
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"tishi" message:[NSString stringWithFormat:@"dataid = %@   \n type = %@",messageInfo.dataId,[pushData objectForKey:@"dataType"]] delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
//    [alert show];
    [XTPushToOtherVCManager pushMessagePushToOtherViewControllerWithType:dataType withViewController:[UIViewController topViewController] withModel:messageInfo];
    
}

#pragma mark - 微信回调
-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *sendAuthResp = (SendAuthResp *)resp;
        if (sendAuthResp.errCode == 0) {
            [[XTShareManager sharedManager] getWXAccessTokenWithCode:sendAuthResp.code];
        }else
        {
            if (sendAuthResp.errStr == nil||[sendAuthResp.errStr isEqualToString:@""]||sendAuthResp.errStr.length==0) {
                [YYTHUD showPromptAddedTo:XTKeyWindow withText:@"登录失败" withCompletionBlock:nil];
            }else
            {
                [YYTHUD showPromptAddedTo:XTKeyWindow withText:sendAuthResp.errStr withCompletionBlock:nil];
            }
            
        }
//        NSString *code = sendAuthResp.code;
//        NSString *state = sendAuthResp.state;
//        NSString *lang = sendAuthResp.lang;
//        NSString *country = sendAuthResp.country;
//        
//        int errcode = sendAuthResp.errCode;
//        NSString *errstr = sendAuthResp.errStr;
//        
        CLog(@"sendAuthResp = %@",sendAuthResp);
    }
    // 微信分享回调
    else if ([resp isKindOfClass:[SendMessageToWXResp class]]){
        SendMessageToWXResp *sendMessageToWXResp = (SendMessageToWXResp *)resp;
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", sendMessageToWXResp.errCode];
        
        NSLog(@"结果码%@,结果文字%@",strMsg,sendMessageToWXResp.errStr);
        NSLog(@"相应类型%zd",sendMessageToWXResp.type);
        if (sendMessageToWXResp.errCode == 0) {
            [YYTHUD showPromptAddedTo:self.window withText:@"分享成功" withCompletionBlock:nil];
            //分享成功统计次数
            [[XTShareStatistic sharedShareStatistic] sendShareInfo];
        }else if (sendMessageToWXResp.errCode == -2){
            [YYTHUD showPromptAddedTo:self.window withText:@"用户取消" withCompletionBlock:nil];
        }else{
            [YYTHUD showPromptAddedTo:self.window withText:@"分享失败" withCompletionBlock:nil];
        }
    }
    else if ([resp isKindOfClass:[SendMessageToQQResp class]]){
        QQBaseResp *respQQ = (QQBaseResp *)resp;
        NSLog(@"结果码%@,结果文字%@",respQQ.result,respQQ.errorDescription);
        NSLog(@"相应类型%zd",respQQ.type);
        if ([respQQ.result isEqualToString:@"0"]) {
            [YYTHUD showPromptAddedTo:self.window withText:@"分享成功" withCompletionBlock:^{
                //分享成功统计次数
                [[XTShareStatistic sharedShareStatistic] sendShareInfo];
            }];
        }else if ([respQQ.result isEqualToString:@"-4"]){
            [YYTHUD showPromptAddedTo:self.window withText:@"用户取消" withCompletionBlock:nil];
        }else{
            [YYTHUD showPromptAddedTo:self.window withText:@"分享失败" withCompletionBlock:nil];
        }
    }
}
- (void)createRootView
{
    //测试引导页使用
//    [XTGuideManage resetGuideSettings]; 
    //删除合成图片文件夹 防止意外崩溃的时候文件夹中内容还在
    [XTLocalImageStoreManage deletePhotoFolder];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [XTGuideManage createDispayViewController];
    [self.window makeKeyAndVisible];
}
@end
