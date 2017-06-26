//
//  XTSearchTopicTableView.h
//  tian
//
//  Created by huhuan on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTTapTableView.h"

@interface XTSearchTopicTableView : XTTapTableView

@property (nonatomic, strong) NSArray *topicArray;

+ (XTSearchTopicTableView *)topicTableView;

@end
