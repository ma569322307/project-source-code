//
//  XTUploadSingleModal.h
//  tian
//
//  Created by Jiajun Zheng on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTUploadSingleModel : NSObject
// 图片名称
@property (nonatomic, copy) NSString *name;
// 小图名称
@property (nonatomic, copy) NSString *smallName;
// 类型
@property (nonatomic, strong) NSNumber *type;
// 如果是快贴有颜色
@property (nonatomic, copy) NSString *color;

-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)uploadSingleModelWithDic:(NSDictionary *)dic;

+(NSArray *)uploadSingleModelWithList:(NSArray *)array;
+(NSArray *)uploadLogoSingleModelWithSystemList;
+(NSArray *)uploadLogoSingleModelWithLocalList;
@end
