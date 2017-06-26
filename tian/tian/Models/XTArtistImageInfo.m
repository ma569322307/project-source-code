//
//  XTArtistImageInfo.m
//  tian
//
//  Created by 曹亚云 on 15-7-9.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTArtistImageInfo.h"

@implementation XTArtistImageInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"artistImageInfoID": @"id"
             };
}

////userinfo
//+ (NSValueTransformer *)imageInfoJSONTransformer
//{
//    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *imageDic) {
//        NSError *error = nil;
//        XTImageInfo *imageInfo = [MTLJSONAdapter modelOfClass:[XTImageInfo class] fromJSONDictionary:imageDic error:&error];
//        return imageInfo;
//    }];
//}

@end
