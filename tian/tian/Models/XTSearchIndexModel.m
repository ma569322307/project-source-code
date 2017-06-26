//
//  XTSearchIndexModel.m
//  tian
//
//  Created by huhuan on 15/6/12.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchIndexModel.h"
#import "XTSearchUserModel.h"

@implementation XTSearchIndexModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}

+ (NSValueTransformer *)artistsJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *userArray) {
        NSError *error = nil;
        return [MTLJSONAdapter modelsOfClass:[XTSearchUserModel class] fromJSONArray:userArray error:&error];
    }];
}

+ (NSValueTransformer *)usersJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *userArray) {
        NSError *error = nil;
        return [MTLJSONAdapter modelsOfClass:[XTSearchUserModel class] fromJSONArray:userArray error:&error];
    }];
}

@end
