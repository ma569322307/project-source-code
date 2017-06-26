//
//  XTUploadGroupModal.h
//  tian
//
//  Created by Jiajun Zheng on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTUploadGroupModel : NSObject
// 组图片名称
@property (nonatomic, copy) NSString *name;
// 小图名称
@property (nonatomic, copy) NSString *smallName;
// 类型是否是快贴
@property (nonatomic, strong) NSNumber *type;
// 子图片名称
@property (nonatomic, strong) NSArray *singleStickers;

-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)uploadGroupModelWithDic:(NSDictionary *)dic;

+(NSArray *)uploadGroupModelWithList;
@end
