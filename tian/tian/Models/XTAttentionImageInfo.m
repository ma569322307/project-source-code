//
//  XTAttentionImageInfo.m
//  tian
//
//  Created by cc on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTAttentionImageInfo.h"

@implementation XTAttentionImageInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}
+ (NSValueTransformer *)thumbnailPicJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end
