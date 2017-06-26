//
//  XTMessageInfo_awardInfo.m
//  tian
//
//  Created by cc on 15/8/2.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTMessageInfo_awardInfo.h"

@implementation XTMessageInfo_awardInfo
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

@end
