//
//  XTHTTPRequestOperationManager.m
//  StarPicture
//
//  Created by 尚毅 杨 on 15/2/12.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTHTTPRequestOperationManager.h"
#import "XTConfig.h"
#import "NSString+NSString_DES.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <MF_Base64Additions.h>
#import "sys/sysctl.h"
#import <OpenUDID.h>
#import <Mantle.h>
#import "XTHTTPResponseError.h"
#import "NSError+XTError.h"
NSString * const YYTNetStatus2G = @"2G";
NSString * const YYTNetStatus3G = @"3G";
NSString * const YYTNetStatus3GNET = @"3GNET";
NSString * const YYTNetStatus3GWAP = @"3GWAP";
NSString * const YYTNetStatus4G = @"4G";
NSString * const YYTNetStatus4GNET = @"4GNET";
NSString * const YYTNetStatus4GWAP = @"4GWAP";

#define RADIO_NET_STATUS @{ \
CTRadioAccessTechnologyGPRS:    YYTNetStatus2G, \
CTRadioAccessTechnologyEdge:    YYTNetStatus2G, \
\
CTRadioAccessTechnologyWCDMA:   YYTNetStatus3G, \
CTRadioAccessTechnologyHSDPA:   YYTNetStatus3G, \
CTRadioAccessTechnologyHSUPA:   YYTNetStatus3G, \
CTRadioAccessTechnologyCDMA1x:  YYTNetStatus3G, \
CTRadioAccessTechnologyCDMAEVDORev0:    YYTNetStatus3G, \
CTRadioAccessTechnologyCDMAEVDORevA:    YYTNetStatus3G, \
CTRadioAccessTechnologyCDMAEVDORevB:    YYTNetStatus3G, \
CTRadioAccessTechnologyeHRPD:           YYTNetStatus3G, \
\
CTRadioAccessTechnologyLTE:     YYTNetStatus4G \
}

typedef void (^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface XTHTTPRequestOperationManager ()
{
    AFHTTPRequestOperationManager *_requestOperationManager;
    AFHTTPRequestSerializer *_requestSerializer;
    AFNetworkReachabilityManager *_reachabilityManager;
    XTConfig *_config;
    void (^requestFailureBlock)(AFHTTPRequestOperation *operation, NSError *error, FailureBlock block);
}
@end

@implementation XTHTTPRequestOperationManager

+ (instancetype)sharedManager
{
    static XTHTTPRequestOperationManager *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[self alloc] init];
    });
    return _shareManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _config = [[XTConfig alloc] init];
        _requestSerializer = [[AFHTTPRequestSerializer alloc] init];
        [_requestSerializer setTimeoutInterval:5];
        [self setBaseURL:nil];
        _reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [_reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//            NSLog(@"%ld", status);
            
        }];
        [_reachabilityManager startMonitoring];
        [self setupHTTPRequestHeaders];
        // 请求失败时的基本处理Block
        requestFailureBlock = ^(AFHTTPRequestOperation *operation, NSError *error, FailureBlock block) {
            
            if (operation.responseObject) {
                XTHTTPResponseError *responseError = [MTLJSONAdapter modelOfClass:[XTHTTPResponseError class] fromJSONDictionary:operation.responseObject error:nil];
                int errorCode = [responseError.code intValue];
                if (errorCode == YYTHTTPResponseErrorCodeInvalidationUser || errorCode == YYTHTTPResponseErrorCodeInvalidToken) {
#warning 报错删除用户信息
//                    [[XTUserStore sharedManager] removeUserInfo];
                }
            }
            if (operation.responseObject) {
                NSError *yytError = [NSError xtServerFailureWithJSON:operation.responseObject];
                if (block) block(operation, yytError);
            }
            else {
                if (block) block(operation, error);                
            }
        };

    }
    return self;
}

- (BOOL)reachable
{
    return _reachabilityManager.reachable;
}

- (void)setBaseURL:(NSURL *)baseURL
{
    if (!baseURL) {
//#define YYT_DEBUG
//#ifdef YYT_DEBUG
//        baseURL = [NSURL URLWithString:@"http://papi.yinyuetai.com/"];
//#else
//        baseURL = [NSURL URLWithString:@"papi.beta.yinyuetai.com/"];
//        
//#endif
    //    baseURL = [NSURL URLWithString:@"http://papi.beta.yinyuetai.com/"];
        baseURL = [NSURL URLWithString:@"http://papi.yinyuetai.com/"];
    }
    _requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    _requestOperationManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    _requestOperationManager.requestSerializer = _requestSerializer;
}

- (void)setupHTTPRequestHeaders
{
    [self setHTTPRequestHeaderField:@"App-Id"
                              value:_config.appID];
    [self setHTTPRequestHeaderField:@"Device-Id"
                              value:[[XTConfig md5:[OpenUDID value]] lowercaseString]];
    [self setHTTPRequestHeaderField:@"Device-V"
                              value:[[self deviceVersion] base64String]];
    [self setHTTPRequestHeaderField:@"Authorization"
                              value:nil];
}

- (void)setHTTPRequestHeaderField:(NSString *)headerField value:(NSString *)value
{
    if ([headerField isEqual:@"Authorization"]) {
        if (value) {
            value = [NSString stringWithFormat:@"Bearer %@", value];
        }
        else {
            NSString *keySecret = [NSString stringWithFormat:@"%@:%@", _config.appKey, _config.appSecret];
            value = [NSString stringWithFormat:@"Basic %@", [keySecret base64String]];
        }
    }
    [_requestSerializer setValue:value forHTTPHeaderField:headerField];
//    NSLog(@"headerField :%@, value :%@", headerField,value);
}

- (void)setupRuntimeHTTPRequestHeaders
{
    
    NSDate *now = [NSDate date];
    NSTimeInterval tInMillisecond = [now timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", tInMillisecond];
    [self setHTTPRequestHeaderField:@"tt"
                              value:[NSString encryptDESPlaintext:timeString]];
    [self setHTTPRequestHeaderField:@"pp"
                              value:[self verificationCodeWithIngredient:timeString]];
    [self setHTTPRequestHeaderField:@"Device-N"
                              value:[[self deviceNetwork] base64String]];
//    [YYTUserStore defaultStore];
}

- (NSString *)verificationCodeWithIngredient:(NSString *)timeIngredient
{
    NSString *secreKey = @"p2-iE$gAuN";//ic%hM4pB$d //dm#gR2sV&z
    NSString *origin = [NSString stringWithFormat:@"%@%@%@%@",
                        [[XTConfig md5:[OpenUDID value]] lowercaseString],
                        _config.appID,
                        secreKey,
                        timeIngredient];
    return [[XTConfig md5:origin] lowercaseString];
}

- (NSString *)deviceNetwork
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    NSString *netStatus;
    switch (_reachabilityManager.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusNotReachable:
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            netStatus = @"WIFI";
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            netStatus = [self deviceNetStatusWithNetworkInfo:networkInfo];
            break;
        case AFNetworkReachabilityStatusUnknown:
            // TODO: 暂时还不知道怎么处理，稍后需要关注一下
            break;
            
        default:
            break;
    }
    
    NSString *carrierName = networkInfo.subscriberCellularProvider.carrierName;
    NSLog(@"%@",carrierName);
    
    return [NSString stringWithFormat:@"%@_%@", carrierName, netStatus];
}

- (NSString *)deviceNetStatusWithNetworkInfo:(CTTelephonyNetworkInfo *)networkInfo
{
    if (!networkInfo) {
        networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    }
    return [RADIO_NET_STATUS valueForKey:networkInfo.currentRadioAccessTechnology];
}

- (NSString *)deviceVersion
{
    UIDevice *device = [UIDevice currentDevice];
    // 这里取的是屏幕的点数，并非像素数，如果需要像素数需要重新发版
    UIScreenMode *screenMode = [UIScreen mainScreen].currentMode;
    
    return [NSString stringWithFormat:@"%@_%@_%.0f*%.0f_%@_%@",
            device.systemName,
            device.systemVersion,
            screenMode.size.width,
            screenMode.size.height,
            _config.channelId,
            [self deviceName]
            ];
}
- (NSString *)deviceName
{
    NSString *platform = [self platformString];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])         return @"iPhone Simulator";
    return platform;
}

- (NSString *) platformString{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

- (NSDictionary *)setupRuntimeParameters:(NSDictionary *)parameters
{
    NSMutableDictionary *mutableParameters = [parameters mutableCopy];
    NSString *deviceNetwork = [self deviceNetwork];
    NSUInteger underLineLocation = [deviceNetwork rangeOfString:@"_"].location;
    NSString *netStatus = [deviceNetwork substringFromIndex:underLineLocation + 1];
    int netStatusCode = 12; // Not WIFI
    if ([netStatus isEqual:@"WIFI"]) {
        netStatusCode = 0;
    }
    else if ([netStatus isEqual:YYTNetStatus4G]) {
        netStatusCode = 11;
    }
    else if ([netStatus isEqual:YYTNetStatus3G]) {
        netStatusCode = 3;
    }
    else if ([netStatus isEqual:YYTNetStatus2G]) {
        netStatusCode = 6;
    }
    [mutableParameters setObject:[NSNumber numberWithInt:netStatusCode] forKey:@"D-A"];
    
    return mutableParameters;
    
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    [self setupRuntimeHTTPRequestHeaders];
    
    parameters = [self setupRuntimeParameters:parameters];
    
    return [_requestOperationManager GET:URLString
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    success(operation,responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                    requestFailureBlock(operation, error, failure);
                                }];

}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setupRuntimeHTTPRequestHeaders];
    
    parameters = [self setupRuntimeParameters:parameters];
    
    return [_requestOperationManager POST:URLString
                               parameters:parameters
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     success(operation,responseObject);
                                 }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                     requestFailureBlock(operation, error, failure);
                                     
                                 }];
}
@end
