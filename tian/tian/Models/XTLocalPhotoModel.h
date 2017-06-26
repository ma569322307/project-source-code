//
//  XTLocalPhotoModel.h
//  tian
//
//  Created by Jiajun Zheng on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTLocalPhotoModel : NSObject
@property (nonatomic, copy) NSString *smallName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *timeKey;

-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)localPhotoModelWithDic:(NSDictionary *)dic;
+(NSArray *)localPhotoModelWithList;
// 创建添加按钮
+(instancetype)localPhotoModelAddModel;
@end
