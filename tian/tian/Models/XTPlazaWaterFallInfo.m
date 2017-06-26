//
//  XTPlazaWaterFallInfo.m
//  StarPicture
//
//  Created by cc on 15-3-4.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTPlazaWaterFallInfo.h"

@implementation XTPlazaWaterFallInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
   return  nil;
    
}
//string类型转换成NSURL
+ (NSValueTransformer *)picUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end
