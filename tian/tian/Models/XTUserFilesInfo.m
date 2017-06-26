//
//  XTUserFilesInfo.m
//  tian
//
//  Created by 曹亚云 on 15-6-12.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUserFilesInfo.h"

@implementation XTUserFilesInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"userID":         @"userId",
             };
}

//int类型转换成NSString
+ (NSValueTransformer *)userIDJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *objID) {
        return [objID stringValue];
    }];
}

//string类型转换成NSURL
+ (NSValueTransformer *)headImgJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)renownCountJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *objID) {
        return [objID stringValue];
    }];
}

+ (NSValueTransformer *)renownTodayJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *objID) {
        return [objID stringValue];
    }];
}

+ (NSValueTransformer *)creditsCountJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *objID) {
        return [objID stringValue];
    }];
}

+ (NSValueTransformer *)creditsTodayJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *objID) {
        return [objID stringValue];
    }];
}

+ (NSValueTransformer *)genderJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"Boy": @"男",
                                                                           @"Girl": @"女",
                                                                           @"Secret": @"保密"
                                                                           }];
}

+ (NSValueTransformer *)ageJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *objID) {
        return [objID stringValue];
    }];
}


@end
