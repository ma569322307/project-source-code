//
//  XTHotTopicModel.m
//  tian
//
//  Created by loong on 15/7/15.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTHotTopicModel.h"
#import "XTHotTopicSetModel.h"
@implementation XTHotTopicModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{@"title":@"basic.title"};
}


+ (NSValueTransformer *)topicsJSONTransformer{
    
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *arr) {
        NSError *error;
        NSArray *topicsArr = [MTLJSONAdapter modelsOfClass:[XTHotTopicSetModel class] fromJSONArray:arr error:&error];
        return topicsArr;
    }];
}

@end
