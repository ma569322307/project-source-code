//
//  XTLocalPhotoModel.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTLocalPhotoModel.h"
#import "XTLocalImageStoreManage.h"

@implementation XTLocalPhotoModel
-(instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+(instancetype)localPhotoModelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

+(NSArray *)localPhotoModelWithList
{
    NSArray *array = [[XTLocalImageStoreManage sharedLocalImageStoreManage] photoInfoArray];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        XTLocalPhotoModel *model = [XTLocalPhotoModel localPhotoModelWithDic:dic];
        [temp addObject:model];
    }
    return temp;
}

+(instancetype)localPhotoModelAddModel{
    return [self localPhotoModelWithDic:@{@"name" : @"addButton"}];
}
@end
