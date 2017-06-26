//
//  XTMapImageModel.m
//  tian
//
//  Created by loong on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTMapImageSetViewModel.h"
#import "XTMapImageViewModel.h"

@implementation XTMapImageSetViewModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"content" : @"basic.content",@"title":@"basic.title"
    };
    return nil;
}

+ (NSValueTransformer *)albumsJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *albumsArray) {
        NSError *error = nil;
        NSArray *albumArray = [MTLJSONAdapter modelsOfClass:[XTMapImageViewModel class] fromJSONArray:albumsArray error:&error];
        return albumArray;
    }];
}

@end
