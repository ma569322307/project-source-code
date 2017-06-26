//
//  XTImageDetailInfo.m
//  StarPicture
//
//  Created by cc on 15-3-4.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTImageDetailInfo.h"
@implementation XTImageDetailInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}
//string类型转换成NSURL
+ (NSValueTransformer *)picUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
//userinfo
+ (NSValueTransformer *)userJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *userdic) {
        NSError *error = nil;
        XTUserInfo *userinfo = [MTLJSONAdapter modelOfClass:[XTUserInfo class] fromJSONDictionary:userdic error:&error];
        return userinfo;
    }];
}
//artistsArray
+ (NSValueTransformer *)artistsJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *artistsarray) {
        NSError *error = nil;
        NSArray *artistsArray = [MTLJSONAdapter modelsOfClass:[XTUserInfo class] fromJSONArray:artistsarray error:&error];
        return artistsArray;
    }];
}
//album
+ (NSValueTransformer *)albumJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *userdic) {
        NSError *error = nil;
        XTAlbumInfo *albuminfo = [MTLJSONAdapter modelOfClass:[XTAlbumInfo class] fromJSONDictionary:userdic error:&error];
        return albuminfo;
    }];
}


@end
