//
//  XTMessageInfo.m
//  tian
//
//  Created by cc on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTMessageInfo.h"

@implementation XTMessageInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"dataId":@"data.id"};
}
+ (NSValueTransformer *)userJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *userDic) {
        NSError *error = nil;
        XTUserInfo *userinfo = [MTLJSONAdapter modelOfClass:[XTUserInfo class] fromJSONDictionary:userDic error:&error];
       
        return userinfo;
    }];
}
//+ (NSValueTransformer *)imageUrlJSONTransformer
//{
//    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
//}
@end
