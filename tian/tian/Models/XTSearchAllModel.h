//
//  XTSearchAllModel.h
//  tian
//
//  Created by huhuan on 15/6/13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
#import "XTSearchUserModel.h"

static  NSString *const searchAllUrl = @"/search/so.json";

@interface XTSearchAllModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) XTSearchUserModel *artist;
@property (nonatomic, copy) NSArray *users;
@property (nonatomic, copy) NSArray *topics;
@property (nonatomic, copy) NSArray *albums;
@property (nonatomic, copy) NSArray *pics;

@end
