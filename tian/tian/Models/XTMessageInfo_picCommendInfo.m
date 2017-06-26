//
//  XTMessageInfo_picCommendInfo.m
//  tian
//
//  Created by cc on 15/7/8.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTMessageInfo_picCommendInfo.h"

@implementation XTMessageInfo_picCommendInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}
+ (NSValueTransformer *)picJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *picDic) {
        NSError *error = nil;
        XTImageInfo *imgInfo =[MTLJSONAdapter modelOfClass:[XTImageInfo class] fromJSONDictionary:picDic error:&error];
        return imgInfo;
    }];
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
