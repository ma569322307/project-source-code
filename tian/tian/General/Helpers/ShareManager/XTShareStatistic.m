//
//  XTShareStatistic.m
//  tian
//
//  Created by Jiajun Zheng on 15/8/4.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTShareStatistic.h"
#import "XTSubStore.h"
@implementation XTShareStatistic
/// 单例创建
+(instancetype)sharedShareStatistic{
    static XTShareStatistic *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[self alloc] init];
    });
    return _shareManager;
}
-(void)setShareValueWithPlatform:(NSString *)platform datatype:(NSString *)datatype dataId:(NSInteger)dataId;{
    self.platform = platform;
    self.datatype = datatype;
    self.dataid = dataId;
}
-(void)sendShareInfo{
    //分享类型
    NSLog(@"平台:%@, 数据类型:%@, 数据id:%zd",self.platform,self.datatype,self.dataid);
    [[[XTSubStore alloc] init] shareStatisticWithPlatform:self.platform datatype:self.datatype dataid:self.dataid completionBlock:^(id results, NSError *error) {
        NSLog(@"统计结果:%@, 分享错误:%@",results,error);
    }];
}
@end
