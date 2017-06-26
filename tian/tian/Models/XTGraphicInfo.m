//
//  XTGraphicInfo.m
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/7.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTGraphicInfo.h"
@implementation XTGraphicInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"gid":         @"id",
             @"picURL": @"picUrl"
             };
}

+ (NSValueTransformer *)picURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
