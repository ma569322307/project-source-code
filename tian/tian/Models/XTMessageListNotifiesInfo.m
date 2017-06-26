//
//  XTMessageListNotifiesInfo.m
//  StarPicture
//
//  Created by cc on 15-3-15.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTMessageListNotifiesInfo.h"

@implementation XTMessageListNotifiesInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}
+ (NSValueTransformer *)userJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *userdic) {
        NSError *error = nil;
        XTUserInfo *userinfo = [MTLJSONAdapter modelOfClass:[XTUserInfo class] fromJSONDictionary:userdic error:&error];
        return userinfo;
    }];
}
+ (NSValueTransformer *)dataJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *picInfo) {
        NSError *error = nil;
        XTMessageDataInfo *picData = [MTLJSONAdapter modelOfClass:[XTMessageDataInfo class] fromJSONDictionary:picInfo error:&error];
        return picData;
    }];
}
@end
