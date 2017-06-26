//
//  XTBlackListInfo.m
//  StarPicture
//
//  Created by cc on 15-3-4.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTBlackListInfo.h"
@implementation XTBlackListInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}
//string类型转换成NSURL
+ (NSValueTransformer *)headImgJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end
