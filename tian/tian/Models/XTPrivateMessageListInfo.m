//
//  XTPrivateMessageListInfo.m
//  StarPicture
//
//  Created by cc on 15-3-15.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTPrivateMessageListInfo.h"

@implementation XTPrivateMessageListInfo
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
+ (NSValueTransformer *)lastMsgJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *PrivateMessageDic) {
        NSError *error = nil;
        XTPrivateMessageInfo *privateMessageInfo = [MTLJSONAdapter modelOfClass:[XTPrivateMessageInfo class] fromJSONDictionary:PrivateMessageDic error:&error];
        return privateMessageInfo;
    }];
}
@end
