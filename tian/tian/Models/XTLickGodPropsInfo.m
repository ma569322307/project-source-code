//
//  XTLickGodPropsInfo.m
//  tian
//
//  Created by cc on 15/6/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTLickGodPropsInfo.h"

@implementation XTLickGodPropsInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}
+ (NSValueTransformer *)imgUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end
