//
//  XTUploadGroupModal.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUploadGroupModel.h"
#import "XTUploadSingleModel.h"

@implementation XTUploadGroupModel
-(instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.name = dic[@"name"];
        self.type = dic[@"type"];
        self.smallName = dic[@"smallName"];
        NSArray *array = dic[@"singleStickers"];
        self.singleStickers = [XTUploadSingleModel uploadSingleModelWithList:array];
    }
    return self;
}

+(instancetype)uploadGroupModelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

+(NSArray *)uploadGroupModelWithList
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"XTStickers" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        XTUploadGroupModel *model = [XTUploadGroupModel uploadGroupModelWithDic:dic];
        [temp addObject:model];
    }
    return temp.copy;
}
@end
