//
//  XTPictureInfoModel.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/14.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTPictureInfoModel.h"

@implementation XTPictureInfoModel

-(instancetype)initURLWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.picUrl = dic[@"picUrl"];
        self.id = [dic[@"id"] integerValue];
    }
    return self;
}
-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+(NSMutableArray *)pictureURLListWithList:(NSArray *)array{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        [arrayM addObject:[[self alloc] initURLWithDic:dic]];
    }
    return arrayM;
}
+(NSMutableArray *)pictureInfoListWithList:(NSArray *)array{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        [arrayM addObject:[[self alloc] initWithDic:dic]];
    }
    return arrayM;
}
@end
