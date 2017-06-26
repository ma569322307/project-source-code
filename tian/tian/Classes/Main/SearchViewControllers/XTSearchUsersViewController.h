//
//  XTSearchUsersViewController.h
//  tian
//
//  Created by huhuan on 15/6/13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"

@interface XTSearchUsersViewController : XTRootViewController

@property (nonatomic, copy) NSString *keyword;

- (void)refreshViewController;

@end
