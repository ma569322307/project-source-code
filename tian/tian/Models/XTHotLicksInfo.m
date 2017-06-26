//
//  XTHotLicksInfo.m
//  tian
//
//  Created by cc on 15/5/26.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTHotLicksInfo.h"

@implementation XTHotLicksInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}
+ (NSValueTransformer *)bannerJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *bannerDic) {
        NSError *error = nil;
        XTHotLicksBannerInfo *banner = [MTLJSONAdapter modelOfClass:[XTHotLicksBannerInfo class] fromJSONDictionary:bannerDic error:&error];
        return banner;
    }];
}
+ (NSValueTransformer *)ranksJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *bannerArr) {
        NSError *error = nil;
        NSArray *bannerInfoArr = [MTLJSONAdapter modelsOfClass:[XTHotLicksRankInfo class] fromJSONArray:bannerArr error:&error];
        return bannerInfoArr;
    }];
}
+ (NSValueTransformer *)recsJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *bannerArr) {
        NSError *error = nil;
        NSArray *bannerInfoArr = [MTLJSONAdapter modelsOfClass:[XTHotLicksRecsInfo class] fromJSONArray:bannerArr error:&error];
        return bannerInfoArr;
    }];
}
+ (NSValueTransformer *)topicsJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *bannerArr) {
        NSError *error = nil;
        NSArray *bannerInfoArr = [MTLJSONAdapter modelsOfClass:[XTHotLicksTopicsInfo class] fromJSONArray:bannerArr error:&error];
        return bannerInfoArr;
    }];
}
+ (NSValueTransformer *)hotsJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *bannerArr) {
        NSError *error = nil;
        NSArray *bannerInfoArr = [MTLJSONAdapter modelsOfClass:[XTWaterFallPicInfo class] fromJSONArray:bannerArr error:&error];
        return bannerInfoArr;
    }];
}
@end
