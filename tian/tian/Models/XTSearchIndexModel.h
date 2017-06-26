//
//  XTSearchIndexModel.h
//  tian
//
//  Created by huhuan on 15/6/12.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"

static  NSString *const searchIndexUrl = @"/search/recommend.json";

@interface XTSearchIndexModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSArray *topics;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, copy) NSArray *artists;
@property (nonatomic, copy) NSArray *users;

@end
