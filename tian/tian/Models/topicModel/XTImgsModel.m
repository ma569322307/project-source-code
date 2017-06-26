


//
//  XTImgsModel.m
//  tian
//
//  Created by loong on 15/7/7.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTImgsModel.h"

@implementation XTImgsModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"itemID":@"id"};
}


//string类型转换成NSURL
+ (NSValueTransformer *)urlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}



@end
