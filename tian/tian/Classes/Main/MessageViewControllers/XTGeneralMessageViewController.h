//
//  XTGeneralMessageViewController.h
//  tian
//
//  Created by cc on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"
static NSString *const XTGeneralMessageUnreadKey = @"XTGeneralMessageUnreadKey";
@interface XTGeneralMessageViewController : XTRootViewController
@property (strong, nonatomic) UITableView *theTableView;
- (void)loadDataWith:(BOOL)isloadMore;
@end
