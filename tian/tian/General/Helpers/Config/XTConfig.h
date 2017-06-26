//
//  XTConfig.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/2/12.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * XTConfig:
 * 1.读取配置文件相关类
 */
@interface XTConfig : NSObject
{
    NSDictionary *_appInfos;
}

- (NSString *)appKey;
- (NSString *)appID;
- (NSString *)appSecret;
- (NSString *)channelId;
- (NSString *)deviceInfo;

+ (instancetype)sharedManager;
+ (NSString*) md5:(NSString*) str;
@end
