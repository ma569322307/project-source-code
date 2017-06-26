//
//  XTTopicIndexViewController.h
//  tian
//
//  Created by huhuan on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"

@interface XTTopicIndexViewController : XTRootViewController

@property (nonatomic, assign) NSInteger topicId;
@property (nonatomic, copy)   NSString *topicTitle;
@property (nonatomic ,copy) void(^completion)();

@end
