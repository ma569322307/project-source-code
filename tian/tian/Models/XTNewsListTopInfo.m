//
//  XTNewsListTopInfo.m
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/9.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTNewsListTopInfo.h"

@implementation XTNewsListTopInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"gid":         @"id",
             @"coverURL": @"cover"
             };
}

+ (NSValueTransformer *)coverURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end
