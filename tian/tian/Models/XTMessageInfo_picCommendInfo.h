//
//  XTMessageInfo_picCommendInfo.h
//  tian
//
//  Created by cc on 15/7/8.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
#import "XTImageInfo.h"
#import "XTUserInfo.h"
@interface XTMessageInfo_picCommendInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) XTImageInfo *pic;
@property (nonatomic, assign) NSInteger userCount;
@property (nonatomic, strong) NSArray *userList;
@end
