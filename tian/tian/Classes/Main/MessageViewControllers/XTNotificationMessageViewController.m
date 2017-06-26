//
//  XTNotificationMessageViewController.m
//  tian
//
//  Created by cc on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTNotificationMessageViewController.h"
#import "XTNotificationMessageCell.h"
#import "XTMessageStore.h"
#import "XTPushToOtherVCManager.h"
#import "XTUnReadMessageCountStore.h"
#define XTNotiCellHeight 55+10
@interface XTNotificationMessageViewController ()<UITableViewDataSource,UITableViewDelegate,XTNotificationMessageCellDelegate>
@property(nonatomic, strong) NSMutableArray *mutableDataArray;
@property (nonatomic, assign) NSInteger loadDataPage;

@end
static NSString * const notiCellidentifier = @"notificationCell";
@implementation XTNotificationMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadDataPage = 0;
    [self.theTableView registerNib:[UINib nibWithNibName:@"XTNotificationMessageCell" bundle:nil] forCellReuseIdentifier:notiCellidentifier];
    
    self.theTableView.separatorColor = UIColorFromRGB(0xd2d2d2);
    self.theTableView.showsHorizontalScrollIndicator = NO;
    self.theTableView.showsVerticalScrollIndicator = NO;
    [self.theTableView setTableFooterView:[UIView new]];
    __weak XTNotificationMessageViewController *weakSelf = self;
    self.theTableView.header = [XTGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataIsLoadMore:NO];
    }];
    
    XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataIsLoadMore:YES];
    }];
    
    if ([self.theTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.theTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
//    footer.automaticallyRefresh = NO;
    self.theTableView.footer = footer;
    [self.theTableView.header beginRefreshing];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    if ([XTUnReadMessageCountStore getInstance].unreadInfo.notifyCount>0 && !self.theTableView.header.isRefreshing) {
        [self.theTableView.header beginRefreshing];
    }
}
#pragma mark -
- (void)loadDataIsLoadMore:(BOOL)isLoadMore
{
    NSInteger offset = isLoadMore==YES?self.loadDataPage*20:0;
    __weak XTNotificationMessageViewController *weakSelf = self;
    [[[XTMessageStore alloc]init]fetchNotifyMessageListWithoffset:offset size:20 CompletionBlock:^(id notiList, NSError *error) {
        [self.theTableView.header endRefreshing];
        [self.theTableView.footer endRefreshing];
        [YYTBlankView hideFromView:self.view];
        [YYTHUD hideLoadingFrom:self.view];
        if (!error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationkey object:nil];
            NSArray *arr = notiList;
            if (arr.count==0) {
                self.theTableView.footer.hidden = YES;
            }
                if (isLoadMore) {
                    self.loadDataPage+=1;
                    [self.mutableDataArray addObjectsFromArray:arr withCheckKey:@"id" completionBlock:^{
                        [weakSelf.theTableView reloadData];
                    }];
                    
                }else
                {
                    self.loadDataPage = 1;
                    self.mutableDataArray = [NSMutableArray arrayWithArray:arr];
                    if (self.mutableDataArray.count==0) {
                        [self.theTableView.header setHidden:YES];
                        YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleBlank eventClick:nil];
                        blankView.tipString = @"社区喇叭君…睡你**，起来嗨！";
                        blankView.headerStyle =YYTBlankHeaderStyleFear;
                        
                    }else
                    {
                        [self.theTableView.header setHidden:NO];
                    }
                    [self.theTableView reloadData];
                }
            
            
        }else{
            if (self.mutableDataArray.count==0) {
                YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
                    [YYTHUD showLoadingAddedTo:self.view];
                    [self loadDataIsLoadMore:NO];
                }];
                blankView.error = error;
            }
            
        }
    }];
}
- (void)deleteNotifyWithId:(NSInteger)deletId
{
    [[[XTMessageStore alloc]init] deleteNotifyMessageWithId:deletId CompletionBlock:^(BOOL success, NSError *error) {
        if (!error) {
            if (success) {
                CLog(@"删除成功");
            
            }
        }else
        {
            CLog(@"删除失败= %@",error);
        }
    }];
}
#pragma mark - tableView Delegate
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mutableDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return XTNotiCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XTNotificationMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:notiCellidentifier];
    cell.delegate = self;
    XTMessageInfo *messageInfo = [self.mutableDataArray objectAtIndex:indexPath.row];
    [cell configureCellWithIndexPath:indexPath andWithModel:messageInfo];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row<self.mutableDataArray.count) {
             XTMessageInfo *messageInfo = [[self.mutableDataArray objectAtIndex:indexPath.row] copy];
            [self.mutableDataArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            [self deleteNotifyWithId:messageInfo.id];
        }
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}



#pragma mark - cellDelegate
- (void)clickNotificationMessageCellUserAvatarBtnWithIndexpathRow:(NSInteger)indexpathRow
{
    XTMessageInfo *messageInfo = [self.mutableDataArray objectAtIndex:indexpathRow];
    
    CLog(@"clickUserAvatar   userid = %ld",messageInfo.user.uid);
}
- (void)clickNotificationMessageCellBgViewWithIndexpathRow:(NSInteger)indexpathRow
{
  //  消息来源， topic, album, link, xlnr, djyc, zsyr, rdsj, rmht, dvxc
    XTMessageInfo *messageInfo = [self.mutableDataArray objectAtIndex:indexpathRow];
    [XTPushToOtherVCManager pushMessagePushToOtherViewControllerWithType:messageInfo.source withViewController:self.navigationController withModel:messageInfo];
       CLog(@"click cell   notiID = %ld",messageInfo.id);
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

@end
