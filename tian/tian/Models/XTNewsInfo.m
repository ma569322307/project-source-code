//
//  XTNewsInfo.m
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/7.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTNewsInfo.h"
#import "XTGraphicInfo.h"

@implementation XTNewsInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"pid":         @"id",
             @"coverURL": @"cover"
             };
}

+ (NSValueTransformer *)coverURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)detailsListJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XTGraphicInfo class]];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{


}
@end
