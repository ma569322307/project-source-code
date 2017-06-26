//
//  XTMessageInfo_postCommendInfo.m
//  tian
//
//  Created by cc on 15/7/8.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTMessageInfo_postCommendInfo.h"

@implementation XTMessageInfo_postCommendInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}
+ (NSValueTransformer *)postJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *picDic) {
        NSError *error = nil;
        XTTopicInfo *topicInfo =[MTLJSONAdapter modelOfClass:[XTTopicInfo class] fromJSONDictionary:[picDic objectForKey:@"topic"] error:&error];
        return topicInfo;
    }];
}
+ (NSValueTransformer *)userListJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *uList) {
        NSError *error = nil;
        NSArray *userArr = [MTLJSONAdapter modelsOfClass:[XTUserInfo class] fromJSONArray:uList error:&error];
        return userArr;
    }];
}

@end
