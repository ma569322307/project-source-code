//
//  XTUserTopicCollectViewCell.h
//  tian
//
//  Created by 曹亚云 on 15-6-15.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTCollectViewCell.h"
#import "XTTopicTableView.h"
#import "XTUserHomePageViewController.h"
@interface XTUserTopicCollectViewCell : XTCollectViewCell
@property (nonatomic, strong) XTTopicTableView *slideView;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSMutableArray *topicArray;

- (void)setSlideViewState:(State)state;
- (void)loadDefaultUserTopicDataWithCompletionBlock:(void(^)(NSError *error))completionBlock;
- (State)slideViewState;
@end
