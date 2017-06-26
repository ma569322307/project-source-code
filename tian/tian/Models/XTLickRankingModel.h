//
//  XTexampleModel.h
//  tian
//
//  Created by yyt on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
//#import <Mantle.h>
@interface XTLickRankingModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *HeadImg;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) BOOL vuser;
//
//+ (NSDictionary *)JSONKeyPathsByPropertyKey;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
