//
//  XTMessageInfo_followInfo.m
//  tian
//
//  Created by cc on 15/7/7.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTMessageInfo_followInfo.h"
#import "XTUserInfo.h"
@implementation XTMessageInfo_followInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}
+ (NSValueTransformer *)userListJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *uList) {
        NSError *error = nil;
        NSArray *userArr = [MTLJSONAdapter modelsOfClass:[XTUserInfo class] fromJSONArray:uList error:&error];
        return userArr;
    }];
}

@end
