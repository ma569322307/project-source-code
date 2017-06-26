//
//  XTHotTopicSetModel.m
//  tian
//
//  Created by loong on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHotTopicSetModel.h"
#import "XTUserInfo.h"
@implementation XTHotTopicSetModel



/**
 @property(nonatomic,strong)NSNumber *itemID;
 
 @property(nonatomic,strong)NSString *title;
 
 @property(nonatomic,strong)NSString *des;
 
 @property(nonatomic,strong)NSArray *users;
 
 @property(nonatomic,strong)NSArray *images;
 
 @property(nonatomic,strong)NSNumber *userCount;
 
 
 @property(nonatomic,strong)NSNumber *postCount;
 
 @property(nonatomic,strong)NSNumber *viewCount;
 
 @property(nonatomic,strong)NSNumber *favoritesCount;
 
 @property(nonatomic,strong)XTUserInfo *user;


*/
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"itemID":@"topic.id",@"title":@"topic.title",@"des":@"topic.description",@"postCount":@"topic.postCount",@"viewCount":@"topic.viewCount",@"favoritesCount":@"topic.favoritesCount",@"user":@"topic.user",@"image":@"topic.image"};
}



+ (NSValueTransformer *)userJSONTransformer{
    
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *dic) {
        NSError *error = nil;
        XTUserInfo *user = [MTLJSONAdapter modelOfClass:[XTUserInfo class] fromJSONDictionary:dic error:&error];
        return user;
    }];
}

+(NSValueTransformer *)usersJSONTransformer{
    
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *arr) {
        NSError *error = nil;
        NSArray *users = [MTLJSONAdapter modelsOfClass:[XTUserInfo class] fromJSONArray:arr error:&error];
        return users;
    }];
}

//string类型转换成NSURL
+ (NSValueTransformer *)imageJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
