//
//  XTAppVersionInfo.m
//  StarPicture
//
//  Created by cc on 15-3-16.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTAppVersionInfo.h"

@implementation XTAppVersionInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"appNewVersion":@"newVersion",
             @"appUrl":       @"newAppUrl",
             };
}
//string类型转换成NSURL
+ (NSValueTransformer *)appUrlURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end
