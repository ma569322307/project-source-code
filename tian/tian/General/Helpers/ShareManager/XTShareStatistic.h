//
//  XTShareStatistic.h
//  tian
//
//  Created by Jiajun Zheng on 15/8/4.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTShareManager.h"
#define kPlatformSINAWEIBO @"SINAWEIBO"
#define kPlatformQZONE @"QZONE"
#define kPlatformTENCENTWEIBO @"TENCENTWEIBO"
#define kPlatformRENREN @"RENREN"
#define kPlatformWEIXIN @"WEIXIN"
#define kPlatformPENGYOUQUAN @"PENGYOUQUAN"
#define kPlatformQQ @"QQ"
@interface XTShareStatistic : NSObject

@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *datatype;
@property (nonatomic, assign) NSInteger dataid;
@property (nonatomic, copy) NSString *s;

+(instancetype)sharedShareStatistic;
-(void)setShareValueWithPlatform:(NSString *)platform datatype:(NSString *)datatype dataId:(NSInteger)dataId;
//分享统计
-(void)sendShareInfo;
@end
