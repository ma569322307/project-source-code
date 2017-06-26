//
//  XTConfig.m
//  StarPicture
//
//  Created by 尚毅 杨 on 15/2/12.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTConfig.h"
#import <CommonCrypto/CommonDigest.h>

@implementation XTConfig

+ (instancetype)sharedManager
{
    static XTConfig *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[self alloc] init];
    });
    return _shareManager;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
        if (!configPath) {
            [NSException raise:@"App startup fail" format:@"Can not found Config.plist file"];
        } else {
            _appInfos = [NSDictionary dictionaryWithContentsOfFile:configPath];
        }
    }
    return self;
}

- (NSString *)appKey
{
    return _appInfos[@"AppId"][@"App_Key"];
}

- (NSString *)appID
{
    return [_appInfos valueForKeyPath:@"AppId.App_Id"];
}

- (NSString *)appSecret
{
    return [_appInfos valueForKeyPath:@"AppId.App_Secret"];
}

- (NSString *)channelId
{
    return [_appInfos valueForKeyPath:@"ChannelId.YinYueTaiChannelId"];
}

- (NSString *)deviceInfo {
    
    NSDictionary *diviceInfoDic = @{
                                    @"aid"  : @"10102002",
                                    @"as"   : @"WIFI",
                                    @"cr"   : @"",
                                    @"dn"   : @"iPhone 4",
                                    @"os"   : @"iPhone OS",
                                    @"ov"   : @"6.0.1",
                                    @"rn"   : @"640*960",
                                    @"uid"  : @"28a0daf7414b7424e9d69b8deabfeddc",
                                    @"clid" : @"50"
                                    };
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:diviceInfoDic
                                                       options:0
                                                         error:&error];
    
    if (jsonData == nil) {
        NSLog(@"fail to get JSON from dictionary: %@, error: %@", self, error);
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


+ (NSString*) md5:(NSString*) str {
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
