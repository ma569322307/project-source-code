//
//  XTSearchArtistModel.m
//  tian
//
//  Created by huhuan on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchArtistModel.h"
#import "XTSearchUserModel.h"
#import "XTSearchTopicModel.h"
#import "XTImageInfo.h"

@implementation XTSearchArtistModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}

+ (NSValueTransformer *)artistsJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *artistArray) {
        NSError *error = nil;
        return [MTLJSONAdapter modelsOfClass:[XTSearchUserModel class] fromJSONArray:artistArray error:&error];
    }];
}

+ (NSValueTransformer *)topicsJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *topicArray) {
        NSError *error = nil;
        return [MTLJSONAdapter modelsOfClass:[XTSearchTopicModel class] fromJSONArray:topicArray error:&error];
    }];
}

+ (NSValueTransformer *)picsJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *imageArray) {
        NSError *error = nil;
        return [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:imageArray error:&error];
    }];
}

@end
