//
//  XTMessageInfo_postCommendInfo.h
//  tian
//
//  Created by cc on 15/7/8.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
#import "XTTopicInfo.h"
@interface XTMessageInfo_postCommendInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) XTTopicInfo *post;
@property (nonatomic, assign) NSInteger userCount;
@property (nonatomic, strong) NSArray *userList;
@end
