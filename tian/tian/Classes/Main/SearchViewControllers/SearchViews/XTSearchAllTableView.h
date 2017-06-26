//
//  XTSearchUsersTableView.h
//  tian
//
//  Created by huhuan on 15/6/13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTTapTableView.h"
@class XTSearchAllModel;

@interface XTSearchAllTableView : XTTapTableView

@property (nonatomic, strong) XTSearchAllModel *searchAllModel;

+ (XTSearchAllTableView *)searchAllTableView;

- (void)configureSearchAllTableView;

- (float)tableViewHeight;

@end
