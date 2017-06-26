//
//  XTUserAlbumInfo.m
//  StarPicture
//
//  Created by 曹亚云 on 15-3-7.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTUserAlbumInfo.h"

@implementation XTUserAlbumInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"albumID":      @"id",
             @"albumTitle":   @"title",
             @"traceURL":   @"traceUrl",
             };
}

@end
