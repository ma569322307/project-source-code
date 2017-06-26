//
//  XTHotTopicModel.h
//  tian
//
//  Created by loong on 15/7/15.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "MTLModel.h"
@class XTHotTopicSetModel;
@interface XTHotTopicModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSArray *topics;

@end
