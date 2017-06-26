//
//  XTMessageInfo_postCommentInfo.m
//  tian
//
//  Created by cc on 15/7/7.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTMessageInfo_postCommentInfo.h"

@implementation XTMessageInfo_postCommentInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"pDescription":@"description"
    };
}
+ (NSValueTransformer *)userJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *uList) {
        NSError *error = nil;
        NSArray *userArr = [MTLJSONAdapter modelsOfClass:[XTUserInfo class] fromJSONArray:uList error:&error];
        return userArr;
    }];
}
+ (NSValueTransformer *)topicJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *topDic) {
        NSError *error = nil;
        XTTopicInfo *topicInfo = [MTLJSONAdapter modelOfClass:[XTTopicInfo class] fromJSONDictionary:topDic error:&error];
        return topicInfo;
    }];
}
+ (NSValueTransformer *)imagesJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *imgArr) {
        NSError *error = nil;
        NSArray *arr = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:imgArr error:&error];
        return arr;
    }];
}
@end
