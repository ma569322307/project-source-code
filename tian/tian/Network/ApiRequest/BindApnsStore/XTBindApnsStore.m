//
//  XTBindApnsStore.m
//  StarPicture
//
//  Created by cc on 15-3-16.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTBindApnsStore.h"
#import "XTHTTPRequestOperationManager.h"

#import "XTUserStore.h"
#import "XTUserAccountInfo.h"
#define kPushTokenKey @"PUSH_DEVICE_TOKE"
#define kDeviceTokenKey @"device_token"

#import "YYTAlertView.h"

@implementation XTBindApnsStore
+ (instancetype)sharedManager
{
    static XTBindApnsStore *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[self alloc] init];
    });
    return _shareManager;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *apnsToken = [[NSUserDefaults standardUserDefaults] objectForKey:kPushTokenKey];
        if ([apnsToken isExist]) {
            self.apnsToken = apnsToken;
        }
        }
    return self;
}

-(BOOL)isCanBind
{
    return [self.apnsToken isExist];
}
-(void)setApnsToken:(NSString *)apnsToken
{
    if(_apnsToken != apnsToken)
    {
        _apnsToken = apnsToken;
        [[NSUserDefaults standardUserDefaults] setObject:_apnsToken forKey:kPushTokenKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
-(id)bindApns
{
    NSString *accessToken = [XTUserStore sharedManager].user.access_token;
    if (self.apnsToken) {
        NSString * accessTokenkey = @"";
        if (accessToken) {
            accessTokenkey = accessToken;
        }
        NSDictionary *parameters = @{
                                 @"access_token":accessTokenkey,
                                 @"device_token":self.apnsToken
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager POST:BindApns_capiKey parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"deviceToken绑定成功 == %@",responseObject);
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"tishi" message:@"chenggong" delegate:nil cancelButtonTitle:@"quxiao" otherButtonTitles:nil, nil];
//        [alert show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"tishi" message:@"绑定失败" delegate:nil cancelButtonTitle:@"quxiao" otherButtonTitles:nil, nil];
//        [alert show];
        NSLog(@"deviceToken绑定失败");
    }];
    }
    return nil;
}

@end
