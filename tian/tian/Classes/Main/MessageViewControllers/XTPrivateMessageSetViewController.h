//
//  XTPrivateMessageSetViewController.h
//  tian
//
//  Created by cc on 15/7/6.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"

@interface XTPrivateMessageSetViewController : XTRootViewController
@property (weak, nonatomic) IBOutlet UISwitch *blacklistSwich;
@property (assign, nonatomic) NSInteger myFriendId;
- (IBAction)clickSwich:(id)sender;
- (IBAction)clickBlackListBtn:(id)sender;

@end
