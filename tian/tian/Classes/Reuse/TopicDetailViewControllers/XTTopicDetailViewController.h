//
//  XTTopicDetailViewController.h
//  tian
//
//  Created by loong on 15/7/7.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"

@interface XTTopicDetailViewController : XTRootViewController

@property(nonatomic,strong)NSNumber *topicID;

//@property(nonatomic,strong)NSString *topicTitle;
@property(nonatomic,strong)NSDictionary *commentInfo;

@end
