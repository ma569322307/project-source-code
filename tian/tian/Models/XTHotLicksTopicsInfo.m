//
//  XTHotLicksTopicsInfo.m
//  tian
//
//  Created by 尚毅 杨 on 15/5/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHotLicksTopicsInfo.h"

@interface XTHotLicksTopicsInfo ()

@property (nonatomic, copy) NSString *content;

@end

@implementation XTHotLicksTopicsInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"topicDescription" : @"description"
             };
}

+ (NSValueTransformer *)imageJSONTransformer
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

+ (NSValueTransformer *)topicJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *user) {
        NSError *error = nil;
        XTTopicInfo *userInfo = [MTLJSONAdapter modelOfClass:[XTTopicInfo class] fromJSONDictionary:user error:&error];
        return userInfo;
    }];
}

+ (NSValueTransformer *)favoriteUsersJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *favoriteUsers) {
        NSError *error = nil;
        NSArray *favoriteUserInfo = [MTLJSONAdapter modelsOfClass:[XTUserInfo class] fromJSONArray:favoriteUsers error:&error];
        return favoriteUserInfo;
    }];
}

- (void)setContent:(NSString *)content {
    self.topicDescription = content;
}

@end
