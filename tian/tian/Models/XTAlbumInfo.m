//
//  XTAlbumInfo.m
//  StarPicture
//
//  Created by cc on 15-3-5.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTAlbumInfo.h"
@interface XTAlbumInfo()
@property (nonatomic, assign) NSInteger picNum;
@end

@implementation XTAlbumInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"type":           @"personal",
             @"createTime":     @"createdAt",
             @"des":            @"description",
             };
}
//string类型转换成NSURL
+ (NSValueTransformer *)coverJSONTransformer
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

+ (NSValueTransformer *)typeJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           [NSNumber numberWithInteger:0]: @(AlbumTypePublic),
                                                                           [NSNumber numberWithInteger:1]: @(AlbumTypeSecret)
                                                                           }];
}

//long类型转换成NSDate
+ (NSValueTransformer *)createTimeJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *timeInMillisecond) {
        return [NSDate dateWithTimeIntervalSince1970:[timeInMillisecond doubleValue] / 1000];
    }];
}

- (void)setPicNum:(NSInteger)picNum{
    _picCount = picNum;
}

@end
