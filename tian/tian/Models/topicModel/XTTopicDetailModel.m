//
//  XTTopicDetailModel.m
//  tian
//
//  Created by loong on 15/7/7.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTopicDetailModel.h"
#import "XTImgsModel.h"
#import "XTUserInfo.h"
@implementation XTTopicDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"des":@"description",@"user":@"user",@"title":@"topic.title"};
}

+ (NSValueTransformer *)imagesJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *arr) {
        NSError *error = nil;
        
        NSArray *imagesArr = [MTLJSONAdapter modelsOfClass:[XTImgsModel class] fromJSONArray:arr error:&error];
        
        return imagesArr;
    }];
}


+(NSValueTransformer *)commendUsersJSONTransformer{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *arr) {
        NSError *error = nil;
        
        NSArray *commendUsers = [MTLJSONAdapter modelsOfClass:[XTUserInfo class] fromJSONArray:arr error:&error];
        
        return commendUsers;
    }];
}


+(NSValueTransformer *)userJSONTransformer{
    
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *dic) {
        NSError *error;

        XTUserInfo *userInfoModel = [MTLJSONAdapter modelOfClass:[XTUserInfo class] fromJSONDictionary:dic error:&error];
        return userInfoModel;
    }];
    
}


@end
