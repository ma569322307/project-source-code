//
//  XTSingleTopicDisplayController.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"
@class XTHotLicksTopicsInfo;

@interface XTSingleTopicDisplayController : XTRootViewController

@property (nonatomic, strong) XTHotLicksTopicsInfo *topicInfo;
@property (nonatomic, strong) NSMutableDictionary *parameterDic;
@property (nonatomic, copy) void(^completionBlock)();

@end
