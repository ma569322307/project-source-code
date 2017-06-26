//
//  XTHotLicksRankInfo.m
//  tian
//
//  Created by 尚毅 杨 on 15/5/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHotLicksRankInfo.h"

@implementation XTHotLicksRankInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}
+ (NSValueTransformer *)headImgJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end
