//
//  XTFollowInfo.m
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/6.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTFollowInfo.h"

@implementation XTFollowInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"pid":@"id"
             
             };
}

+ (NSValueTransformer *)picUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end
