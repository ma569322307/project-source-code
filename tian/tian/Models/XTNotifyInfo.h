//
//  XTNotifyInfo.h
//  tian
//
//  Created by cc on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
#import "XTUserInfo.h"
@interface XTNotifyInfo : MTLModel
@property (nonatomic, strong) XTUserInfo *user;
@property (nonatomic, assign) long id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *xlnr;
@end
