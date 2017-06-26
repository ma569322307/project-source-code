//
//  XTPhotoHeadModel.h
//  tian
//
//  Created by yyt on 15/7/16.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "MTLModel.h"

@interface XTPhotoHeadModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic ,assign) NSInteger commendCount;
@property (nonatomic, copy) NSString *descrip;
@property (nonatomic, copy) NSURL *cover;
@property (nonatomic, assign)NSInteger picNum;
@property (nonatomic, assign) NSInteger personal;
@property (nonatomic, assign) NSInteger commentCount;
+ (NSDictionary *)JSONKeyPathsByPropertyKey;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
