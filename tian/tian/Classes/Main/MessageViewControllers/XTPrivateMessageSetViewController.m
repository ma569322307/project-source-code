//
//  XTPrivateMessageSetViewController.m
//  tian
//
//  Created by cc on 15/7/6.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTPrivateMessageSetViewController.h"
#import "XTMessageStore.h"
#import "XTUserStore.h"
#import "XTBlackListViewController.h"
@interface XTPrivateMessageSetViewController ()

@end

@implementation XTPrivateMessageSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天设置";
    [self addBackNavigationItem];
    [self.blacklistSwich setSelected:NO];
    self.blacklistSwich.onTintColor = UIColorFromRGB(0xffe707);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)removeFromShipendWithFriendId:(long)friendId
{
    [[[XTMessageStore alloc]init] removeShipendWithId:friendId CompletionBlock:^(BOOL removeSuccess, NSError *error) {
        if (removeSuccess) {
            CLog(@"删除成功");
        }else
        {
            CLog(@"删除失败 == =%@",error);
        }
    }];
}
- (void)addShipendWithFriendId:(long)friendId
{
    NSString *uid = [XTUserStore sharedManager].user.userID;
    
    [[[XTMessageStore alloc]init] addShipendWithSelfUserId:[uid longLongValue] FriendUserId:friendId CompletionBlock:^(BOOL addSuccess, NSError *error) {
        if (addSuccess) {
            
        }else
        {
            
        }
    }];
    
}

- (IBAction)clickSwich:(id)sender {
    UISwitch *swth = (UISwitch *)sender;
    if (swth.selected) {
        [self removeFromShipendWithFriendId:self.myFriendId];
    }else
    {
        [self addShipendWithFriendId:self.myFriendId];
    }
}

- (IBAction)clickBlackListBtn:(id)sender {
    XTBlackListViewController *blackListVC = [[XTBlackListViewController alloc]init];
    [self.navigationController pushViewController:blackListVC animated:YES];
}
@end
