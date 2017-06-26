//
//  XTCreateTopicController.h
//  tian
//
//  Created by Jiajun Zheng on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"

@interface XTCreateTopicController : XTRootViewController
@property (nonatomic, strong) NSMutableDictionary *parameterDic;
@property (nonatomic, copy) void(^completionBlock)();
@end
