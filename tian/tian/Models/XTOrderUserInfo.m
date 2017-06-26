//
//  XTOrderUserInfo.m
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/6.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTOrderUserInfo.h"

@implementation XTOrderUserInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"smallAvatarURL":@"smallAvatar"};
}

+ (NSValueTransformer *)smallAvatarURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end
