//
//  XTCommentsModel.m
//  tian
//
//  Created by loong on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTCommentsModel.h"
#import "XTUserInfo.h"
#import "XTCommentItemModel.h"

@interface XTCommentsModel ()

//兼容字段
@property(nonatomic, strong)NSNumber *commentCount;

@end
@implementation XTCommentsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return nil;
}

+ (NSValueTransformer *)commentsJSONTransformer{
    
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *arr) {
        NSError *error = nil;
        
        NSArray *array = [MTLJSONAdapter modelsOfClass:[XTCommentItemModel class] fromJSONArray:arr error:&error];
        
        return array;
    }];
}

- (void)setCommentCount:(NSNumber *)commentCount {
    self.totalCount = commentCount;
}

@end
