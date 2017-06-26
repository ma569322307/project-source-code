//
//  XTWaterFallPicInfo.m
//  tian
//
//  Created by cc on 15/6/4.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTWaterFallPicInfo.h"

@implementation XTWaterFallPicInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"descriptionStr":@"description"
             };
}
+ (NSValueTransformer *)imgUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
+ (NSValueTransformer *)headImgJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
+ (NSValueTransformer *)topicJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *topicDic) {
        NSError *error = nil;
        XTHotLicksTopicsInfo *topicInfo = [MTLJSONAdapter modelOfClass:[XTHotLicksTopicsInfo class] fromJSONDictionary:topicDic error:&error];
        return topicInfo;
    }];
}
+ (NSValueTransformer *)imagesJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *imagearr) {
        NSError *error = nil;
        NSArray *images = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:imagearr error:&error];
        
        return images;
    }];
}
@end
