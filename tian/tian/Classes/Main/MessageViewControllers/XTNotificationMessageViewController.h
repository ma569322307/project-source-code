//
//  XTNotificationMessageViewController.h
//  tian
//
//  Created by cc on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"
static NSString *const XTNotificationMessageUnreadKey = @"notificationMessageUnreadKey";
@interface XTNotificationMessageViewController : XTRootViewController

@property (weak, nonatomic) IBOutlet UITableView *theTableView;

- (void)loadDataIsLoadMore:(BOOL)isLoadMore;
@end
