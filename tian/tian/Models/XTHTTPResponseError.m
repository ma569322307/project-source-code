//
//  XTHTTPResponseError.m
//  StarPicture
//
//  Created by 尚毅 杨 on 15/2/12.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTHTTPResponseError.h"

@implementation XTHTTPResponseError

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"message":    @"display_message",
             @"reason":     @"error",
             @"code":       @"error_code",
             @"requestURL": @"request"
             };
}

+ (NSValueTransformer *)requestURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end
