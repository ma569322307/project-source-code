//
//  XTPostTopicViewController.h
//  tian
//
//  Created by Jiajun Zheng on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"

@interface XTPostTopicViewController : XTRootViewController
@property (nonatomic, assign) NSInteger topicId;
@property (nonatomic, copy)   NSString *topicTitle;
@property (nonatomic, copy) void(^completionBlock)();
@end
