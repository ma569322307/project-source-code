//
//  XTTopicInfo.m
//  tian
//
//  Created by 曹亚云 on 15-7-2.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTopicInfo.h"

@implementation XTTopicInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"topicId" : @"id",
             @"topicDescription" : @"description",
             @"imageUrl": @"image",
             };
}

+ (NSValueTransformer *)imageUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)userJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *user) {
        NSError *error = nil;
        XTUserInfo *userInfo = [MTLJSONAdapter modelOfClass:[XTUserInfo class] fromJSONDictionary:user error:&error];
        return userInfo;
    }];
}

@end
