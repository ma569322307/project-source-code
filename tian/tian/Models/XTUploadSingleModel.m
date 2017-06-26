//
//  XTUploadSingleModal.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUploadSingleModel.h"
#import "XTLocalImageStoreManage.h"

@implementation XTUploadSingleModel
-(instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+(instancetype)uploadSingleModelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

+(NSArray *)uploadSingleModelWithList:(NSArray *)array
{
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        XTUploadSingleModel *model = [XTUploadSingleModel uploadSingleModelWithDic:dic];
        [temp addObject:model];
    }
    return temp;
}
// 单独的系统logo数组
+(NSArray *)uploadLogoSingleModelWithSystemList{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"XTLogos" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    return [self uploadSingleModelWithList:array];
}
// 本地logo数组
+(NSArray *)uploadLogoSingleModelWithLocalList{
    NSArray *array = [[XTLocalImageStoreManage sharedLocalImageStoreManage] logoInfoArray];
    return [self uploadSingleModelWithList:array];
}
@end
