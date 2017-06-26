//
//  XTTopicIndexTableView.h
//  tian
//
//  Created by huhuan on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "SlideTableView.h"
@class XTPostInfo;

@interface XTTopicTableView : SlideTableView

@property (nonatomic, assign) BOOL     isMine;
@property (nonatomic, assign) long     topicId;
@property (nonatomic, copy  ) NSString *topicTitle;
@property (nonatomic, copy  ) NSArray  *topicArray;

/**
 *  刷新列表数据
 */
@property (nonatomic, copy) void (^refreshTopicInfo)();
/**
 *  点击cell回传postInfo
 */
@property (nonatomic, copy) void (^topicCellClick)(MTLModel *topicInfo);

+ (XTTopicTableView *)topicTableViewWithCellStyle:(XTTopicTableViewCellStyle)cellStyle;
- (void)refreshTableView;
@end
