//
//  XTCommentsModel.h
//  tian
//
//  Created by loong on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"

@interface XTCommentsModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, copy) NSArray  *comments;

@property (nonatomic, strong) NSNumber *totalCount;

@property (nonatomic, copy)   NSDictionary  *pk;

@end
