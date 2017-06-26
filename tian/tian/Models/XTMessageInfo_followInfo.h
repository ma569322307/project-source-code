//
//  XTMessageInfo_followInfo.h
//  tian
//
//  Created by cc on 15/7/7.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface XTMessageInfo_followInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic,assign) NSInteger userCount;
@property (nonatomic, strong) NSArray *userList;
@end
