//
//  XTOriginImgModel.m
//  tian
//
//  Created by loong on 15/7/2.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTOriginImgModel.h"

@implementation XTOriginImgModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}


//string类型转换成NSURL
+ (NSValueTransformer *)thumbnailPicJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)middlePicJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)originalPicJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}



@end
