//
//  XTUserFriendTrendsInfo.m
//  StarPicture
//
//  Created by 曹亚云 on 15-3-11.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTUserFriendTrendsInfo.h"

@implementation XTUserFriendTrendsInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"createTime":         @"createdAt",
             @"infoID":             @"id",
             @"imageDesc":          @"text",
             @"thumbnailPicURL":    @"thumbnailPic"
             };
}

//+ (NSValueTransformer *)createTimeJSONTransformer
//{
//    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *timeInMillisecond) {
//        return [NSDate dateWithTimeIntervalSince1970:[timeInMillisecond doubleValue] / 1000];
//    }];
//}

//int类型转换成NSString
+ (NSValueTransformer *)infoIDJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *objID) {
        return [objID stringValue];
    }];
}

//string类型转换成NSURL
+ (NSValueTransformer *)thumbnailPicURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


@end
