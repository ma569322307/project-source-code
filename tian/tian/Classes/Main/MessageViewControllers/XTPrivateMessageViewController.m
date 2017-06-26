//
//  XTPrivateMessageViewController.m
//  tian
//
//  Created by cc on 15/7/1.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTPrivateMessageViewController.h"
#import "XTChatViewController.h"
#import "XTPrivateMessageListCell.h"
@interface XTPrivateMessageViewController ()

@end

@implementation XTPrivateMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 //   self.conversationListTableView.separatorColor = [UIColor grayColor];
    self.conversationListTableView.tableFooterView = [UIView new];
    self.isShowNetworkIndicatorView = NO;
 //   self.conversationListTableView.backgroundColor = UIColorFromRGB(0xececec);
    //设置要显示的会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
    
    self.conversationListTableView.separatorColor = UIColorFromRGB(0xd2d2d2);
 //   NSLog(@"%f     \n %f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidenBottomTabarWith:@"YES"];
    [self notifyUpdateUnreadMessageCount];
    
    self.conversationListTableView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 49);
}

- (void)notifyUpdateUnreadMessageCount
{
//    __weak typeof(self) __weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        int count = [[RCIMClient sharedRCIMClient]getUnreadCount:self.displayConversationTypeArray];
//        if (count>0) {
//            __weakSelf.tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
//        }else
//        {
//            __weakSelf.tabBarItem.badgeValue = nil;
//        }
//        
//    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    //按照作者最后的意思还要加上下面这一段
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath

{//RCConversationCell
    RCConversationCell *theCell = (RCConversationCell*)cell;
    /*回话头像背景图*/
  //  theCell.headerImageViewBackgroundView
    //会话title
    theCell.conversationTitle.textColor = UIColorFromRGB(0x595959);
    theCell.conversationTitle.font = [UIFont systemFontOfSize:11];
    
    [theCell.conversationTitle updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(theCell.centerY);
    }];
    //会话内容label
    theCell.messageContentLabel.textColor = UIColorFromRGB(0x7b7b7b);
    theCell.messageContentLabel.font = [UIFont systemFontOfSize:12];
    //消息创建时间label
    theCell.messageCreatedTimeLabel.textColor = UIColorFromRGB(0x7b7b7b);
    theCell.messageCreatedTimeLabel.font = [UIFont systemFontOfSize:10];
    //tip number视图
 //   theCell.bubbleTipView.bubbleTipAlignment = RC_MESSAGE_BUBBLE_TIP_VIEW_ALIGNMENT_BOTTOM_RIGHT;//右下
    //头像样式
    theCell.portraitStyle = RC_USER_AVATAR_CYCLE;
    //会话状态视图
    theCell.conversationStatusImageView.image = [UIImage imageNamed:@""];
    
    [theCell.conversationTitle updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(theCell.messageCreatedTimeLabel);
    }];
  //  theCell.conversationStatusImageView.backgroundColor = [UIColor redColor];
}

//重载函数，onSelectedTableRow 是选择会话列表之后的事件，该接口开放是为了便于您自定义跳转事件。在快速集成过程中，您只需要复制这段代码。
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    XTChatViewController *conversationVC = [[XTChatViewController alloc]init];
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.userName =model.conversationTitle;
    conversationVC.title = model.conversationTitle;
    [conversationVC setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    
//    if (iPhone6Plus) {
//        [conversationVC setMessagePortraitSize:CGSizeMake(56, 56)];
//    } else {
//        [conversationVC setMessagePortraitSize:CGSizeMake(46, 46)];
//    }
    [self hidenBottomTabarWith:@"NO"];
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)didTapCellPortrait:(NSString *)userId
{
    
}
//隐藏、显示tabar
- (void)hidenBottomTabarWith:(NSString *)showBool
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:showBool,@"isShowTabBar",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isShowTabBarNotification" object:dic];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
