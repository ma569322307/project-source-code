//
//  XTPostInfo.m
//  tian
//
//  Created by huhuan on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTPostInfo.h"
#import "XTUserInfo.h"
#import "XTImageInfo.h"
#import "XTTopicInfo.h"
@interface XTPostInfo ()

//兼容字段
@property (nonatomic, assign) double createdAt;
@property (nonatomic, copy) NSString *text;

@end

@implementation XTPostInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"postId" : @"id",
             @"postDescription" : @"description",
             };
}

+ (NSValueTransformer *)userJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *user) {
        NSError *error = nil;
        XTUserInfo *userInfo = [MTLJSONAdapter modelOfClass:[XTUserInfo class] fromJSONDictionary:user error:&error];
        return userInfo;
    }];
}

+ (NSValueTransformer *)topicJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *topic) {
        NSError *error = nil;
        XTTopicInfo *topicInfo = [MTLJSONAdapter modelOfClass:[XTTopicInfo class] fromJSONDictionary:topic error:&error];
        return topicInfo;
    }];
}

+ (NSValueTransformer *)imagesJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *imageArray) {
        NSError *error = nil;
        return [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:imageArray error:&error];
    }];
}

- (void)setCreatedAt:(double)createdAt
{
    _created = createdAt;
}

- (void)setText:(NSString *)text
{
    _postDescription = text;
}

@end
