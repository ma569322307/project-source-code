//
//  XTSearchAllModel.m
//  tian
//
//  Created by huhuan on 15/6/13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchAllModel.h"
#import "XTSearchTopicModel.h"
#import "XTImageInfo.h"
#import "XTAlbumInfo.h"

@implementation XTSearchAllModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}

+ (NSValueTransformer *)artistJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *artistdic) {
        NSError *error = nil;
        XTSearchUserModel *artistinfo = [MTLJSONAdapter modelOfClass:[XTSearchUserModel class] fromJSONDictionary:artistdic error:&error];
        return artistinfo;
    }];
}

+ (NSValueTransformer *)usersJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *userArray) {
        NSError *error = nil;
        return [MTLJSONAdapter modelsOfClass:[XTSearchUserModel class] fromJSONArray:userArray error:&error];
    }];
}

+ (NSValueTransformer *)topicsJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *topicArray) {
        NSError *error = nil;
        return [MTLJSONAdapter modelsOfClass:[XTSearchTopicModel class] fromJSONArray:topicArray error:&error];
    }];
}

+ (NSValueTransformer *)albumsJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *albumArray) {
        NSError *error = nil;
        return [MTLJSONAdapter modelsOfClass:[XTAlbumInfo class] fromJSONArray:albumArray error:&error];
    }];
}

+ (NSValueTransformer *)picsJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *imageArray) {
        NSError *error = nil;
        return [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:imageArray error:&error];
    }];
}

@end
