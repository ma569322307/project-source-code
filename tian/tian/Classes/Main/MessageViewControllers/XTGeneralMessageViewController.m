//
//  XTGeneralMessageViewController.m
//  tian
//
//  Created by cc on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTGeneralMessageViewController.h"
#import "XTGeneralMessageTypeOneCell.h"
#import "XTGeneralMessageTypeTwoCell.h"
#import "XTGeneralMessageTypeThreeCell.h"

#import "XTUserHomePageViewController.h"
#import "XTTopicIndexViewController.h"
#import "XTUserStore.h"
#import "XTMessageStore.h"
#import "XTImgDetailViewController.h"
#import "XTUnReadMessageCountStore.h"
#import "XTMessageInfo_postCommendInfo.h"
#import "XTTopicDetailViewController.h"

#define XTCellOneHeight 117
#define XTCellTwoHeight 143
@interface XTGeneralMessageViewController ()<UITableViewDataSource,UITableViewDelegate,XTGeneralMessageTypeOneCellDelegate,XTGeneralMessageTypeThreeCellDelegate,XTGeneralMessageTypeTwoCellDelegate>
@property (nonatomic, strong) NSMutableArray *dataMutableArray;

@property (nonatomic, assign) NSInteger loadDataPage;
@end

static NSString *const cellOneIdentifier = @"cellOneIdentifier";
static NSString *const cellTwoIdentifier = @"cellTwoIdentifier";
static NSString *const cellThreeIdentifier = @"cellThreeIdentifier";
@implementation XTGeneralMessageViewController

- (void)viewDidLoad {
    self.loadDataPage = 0;
    [super viewDidLoad];
    [self.theTableView registerNib:[UINib nibWithNibName:@"XTGeneralMessageTypeOneCell" bundle:nil] forCellReuseIdentifier:cellOneIdentifier];
    [self.theTableView registerNib:[UINib nibWithNibName:@"XTGeneralMessageTypeTwoCell" bundle:nil] forCellReuseIdentifier:cellTwoIdentifier];
    [self.theTableView registerNib:[UINib nibWithNibName:@"XTGeneralMessageTypeThreeCell" bundle:nil] forCellReuseIdentifier:cellThreeIdentifier];
    self.theTableView.separatorColor = UIColorFromRGB(0xd2d2d2);
    __weak XTGeneralMessageViewController *weakSelf = self;
    self.theTableView.header = [XTGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWith:NO];
    }];
    XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataWith:YES];
    }];
//    footer.automaticallyRefresh = NO;
    self.theTableView.footer = footer;
    [self.theTableView.header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
    
    UIView *footerV = [UIView new];
    [self.theTableView setTableFooterView:footerV];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (VERSION > 7.9) {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, SCREEN_SIZE.width, self.view.frame.size.height);
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    if ([XTUnReadMessageCountStore getInstance].unreadInfo.msgCount>0 && !self.theTableView.header.isRefreshing) {
        [self.theTableView.header beginRefreshing];
    }
}
- (void)loadDataWith:(BOOL)isloadMore;
{
    NSInteger offset = isloadMore == YES?self.loadDataPage*20:0;
    
    __weak XTGeneralMessageViewController *weakSelf = self;
    [[[XTMessageStore alloc]init] fetchMessageListWithoffset:offset size:20 CompletionBlock:^(id notiList, NSError *error) {
        [self.theTableView.header endRefreshing];
        [self.theTableView.footer endRefreshing];
        [YYTBlankView hideFromView:self.view];
        [YYTHUD hideLoadingFrom:self.view];
        if (!error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMessagekey object:nil];
            NSArray *arr = notiList;
            if (arr.count<2) {
                self.theTableView.footer.hidden = YES;
            }
            if(isloadMore)
            {
                self.loadDataPage+=1;
                [self.dataMutableArray addObjectsFromArray:arr withCheckKey:@"id" completionBlock:^{
                    [weakSelf.theTableView reloadData];
                }];
            }else
            {
                self.loadDataPage = 1;
                self.dataMutableArray = [NSMutableArray arrayWithArray:arr];
                
                if (self.dataMutableArray.count==0) {
                    [self.theTableView.header setHidden:YES];
                    YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleBlank eventClick:nil];
                    blankView.tipString = @"一个评论、点赞都不给人家，心碎ing…";
                    blankView.headerStyle =YYTBlankHeaderStyleCry;
                    
                }else
                {
                    [self.theTableView.header setHidden:NO];
                }
                [self.theTableView reloadData];
            }
            
        }else
        {
            if (self.dataMutableArray.count == 0) {
                YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
                    [YYTHUD showLoadingAddedTo:self.view];
                    [self loadDataWith:NO];
                }];
                blankView.error = error;
            }
            
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XTGeneralMessageTypeOneCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellOneIdentifier];
    XTGeneralMessageTypeTwoCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellTwoIdentifier];
    XTGeneralMessageTypeThreeCell *cellThree = [tableView dequeueReusableCellWithIdentifier:cellThreeIdentifier];
    cellOne.delegate = self;
    cellTwo.delegate = self;
    cellThree.delegate = self;
    
    XTMessageInfo * messageInfo = [self.dataMutableArray objectAtIndex:indexPath.row];
    
    if ([messageInfo.source isEqualToString:@"picCommend"]||[messageInfo.source isEqualToString:@"follow"]||[messageInfo.source isEqualToString:@"postCommend"]) {
        [cellOne configureCellWithIndexPath:indexPath andWithModel:messageInfo];
        return cellOne;
    }else if([messageInfo.source isEqualToString:@"postComment"]||[messageInfo.source isEqualToString:@"picComment"])
    {
        [cellTwo configureCellWithIndexPath:indexPath andWithModel:messageInfo];
        return cellTwo;
    }else if([messageInfo.source isEqualToString:@"award"])
    {
        [cellThree configureCellWithIndexPath:indexPath andWithModel:messageInfo];
        return cellThree;
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataMutableArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XTMessageInfo * messageInfo = [self.dataMutableArray objectAtIndex:indexPath.row];
    
    if ([messageInfo.source isEqualToString:@"picCommend"]||[messageInfo.source isEqualToString:@"follow"]||[messageInfo.source isEqualToString:@"postCommend"]) {
        return XTCellOneHeight;
    }else if([messageInfo.source isEqualToString:@"postComment"]||[messageInfo.source isEqualToString:@"picComment"])
    {
        return XTCellTwoHeight;
    }else if([messageInfo.source isEqualToString:@"award"])
    {
        return XTCellOneHeight;
    }
    
    return 0;
}

- (XTMessageInfo *)getTheMessageInfoWithIndexRow:(NSInteger)indexpathRow
{
    if (self.dataMutableArray.count>indexpathRow) {
        return [self.dataMutableArray objectAtIndex:indexpathRow];
    }
    return nil;
}
#pragma mark - cellOneDelegate
- (void)clickGeneralMessageCellUserAvatarBtnWithIndexRow:(NSInteger)indexpathRow
{
    if ([[XTUserStore sharedManager].user.userID isEqualToString:[NSString stringWithFormat:@"%zd",indexpathRow]]) {
        return;
    }
    XTUserHomePageViewController *userHomeVC = [[XTUserHomePageViewController alloc]init];
    userHomeVC.userID = [NSString stringWithFormat:@"%zd",indexpathRow];
    userHomeVC.type = XTUserHomePageTypeHis;
    userHomeVC.userType = XTAccountCommon;
    [self.navigationController pushViewController:userHomeVC animated:YES];
    
}
- (void)clickGeneralMessageCellImageViewWithindex:(NSInteger)index{
    
     XTMessageInfo *messageInfo = [self getTheMessageInfoWithIndexRow:index];
    if ([messageInfo.data isKindOfClass:[XTMessageInfo_picCommendInfo class]]) {
        XTMessageInfo_picCommendInfo *picImgInfo = messageInfo.data;
        XTImageInfo *imgInfo = picImgInfo.pic;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
        XTImgDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
        NSArray *arr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%zd",imgInfo.id], nil];
        controller.pidArr = arr;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([messageInfo.data isKindOfClass:[XTImageInfo class]]) {
        XTImageInfo *imgInfo = messageInfo.data;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
        XTImgDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
        NSArray *arr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%zd",imgInfo.id], nil];
        controller.pidArr = arr;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([messageInfo.data isKindOfClass:[XTMessageInfo_postCommendInfo class]])
    {
        XTMessageInfo_postCommendInfo *postTopicinfo = messageInfo.data;

        XTTopicIndexViewController *topicCtr = [[XTTopicIndexViewController alloc] init];
        topicCtr.topicId = postTopicinfo.post.topicId;
        topicCtr.topicTitle = postTopicinfo.post.title;
        [self.navigationController pushViewController:topicCtr animated:YES];
    }
    
}
- (void)clickCellTopicBtnWithIndexRow:(NSInteger)indexpathRow
{
    XTMessageInfo *messageInfo = [self getTheMessageInfoWithIndexRow:indexpathRow];
    XTMessageInfo_postCommendInfo *postTopicinfo = messageInfo.data;
    XTTopicIndexViewController *topicCtr = [[XTTopicIndexViewController alloc] init];
    topicCtr.topicId = postTopicinfo.post.topicId;
    topicCtr.topicTitle = postTopicinfo.post.title;
    [self.navigationController pushViewController:topicCtr animated:YES];
}

#pragma mark - cellTwoDelegate
- (void)clickGeneralMessageTypeTwoCellUserAvatarBtnWithIndexpthRow:(NSInteger)indexpthRow
{
    if ([[XTUserStore sharedManager].user.userID isEqualToString:[NSString stringWithFormat:@"%zd",indexpthRow]]) {
        return;
    }
    XTUserHomePageViewController *userHomeVC = [[XTUserHomePageViewController alloc]init];
    userHomeVC.userID = [NSString stringWithFormat:@"%zd",indexpthRow];
    userHomeVC.type = XTUserHomePageTypeHis;
    userHomeVC.userType = XTAccountCommon;
    [self.navigationController pushViewController:userHomeVC animated:YES];
}
- (void)clickGeneralMessageTypeTwoCellCommentBtnWithIndexpthRow:(NSInteger)indexpthRow
{
    XTMessageInfo *messageInfo = [self getTheMessageInfoWithIndexRow:indexpthRow];
    if ([messageInfo.source isEqualToString:@"postComment"]) {
        XTMessageInfo_postCommentInfo *postCommentinfo = messageInfo.data;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
        
        XTTopicDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTTopicDetailViewController"];
        controller.topicID = [NSNumber numberWithInteger:postCommentinfo.id];
        controller.commentInfo = @{@"cid":[NSNumber numberWithInteger:postCommentinfo.cid],@"userInfo":messageInfo.user};
        [self.navigationController pushViewController:controller animated:YES];
//        XTTopicIndexViewController *topicIndex = [[XTTopicIndexViewController alloc]init];
//        topicIndex.topicId = postCommentinfo.topic.topicId;
//        topicIndex.topicTitle = postCommentinfo.topic.title;
//        [self.navigationController pushViewController:topicIndex animated:YES];
        
    }else if([messageInfo.source isEqualToString:@"picComment"])
    {
        XTImageInfo *imginfo = messageInfo.data;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
        XTImgDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
        NSArray *arr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%zd",imginfo.id], nil];
        controller.pidArr = arr;
        controller.commentInfo = @{@"userInfo":messageInfo.user,@"cid":@(imginfo.cid)};
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (void)clickGeneralMessageTypeTwoCellRightImageViewBtnWithIndexpthRow:(NSInteger)indexpthRow
{
    XTMessageInfo *messageInfo = [self getTheMessageInfoWithIndexRow:indexpthRow];
    
     if ([messageInfo.source isEqualToString:@"postComment"]) {
         XTMessageInfo_postCommentInfo *postCommentinfo = messageInfo.data;
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
         
         XTTopicDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTTopicDetailViewController"];
         controller.topicID = [NSNumber numberWithInteger:postCommentinfo.id];
         [self.navigationController pushViewController:controller animated:YES];
     }else if([messageInfo.source isEqualToString:@"picComment"])
     {
         XTImageInfo *imginfo = messageInfo.data;
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
         XTImgDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
         NSArray *arr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%zd",imginfo.id], nil];
         controller.pidArr = arr;
         [self.navigationController pushViewController:controller animated:YES];
     }
   
}
- (void)clickGeneralMessageTypeTwoCellTopicBtnWithIndexpthRow:(NSInteger)indexpthRow
{
    XTMessageInfo *messageInfo = [self getTheMessageInfoWithIndexRow:indexpthRow];
    XTMessageInfo_postCommentInfo *postCommentinfo = messageInfo.data;
    
    XTTopicIndexViewController *topicCtr = [[XTTopicIndexViewController alloc] init];
    topicCtr.topicId = postCommentinfo.topic.topicId;
    topicCtr.topicTitle = postCommentinfo.topic.title;
    [self.navigationController pushViewController:topicCtr animated:YES];
    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
//    
//    XTTopicDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTTopicDetailViewController"];
//    controller.topicID = [NSNumber numberWithInteger:postCommentinfo.id];
//    [self.navigationController pushViewController:controller animated:YES];

}

#pragma mark - cellThreeDelegate
- (void)clickXTGeneralMessageTypeThreeCellUserAvatarBtnWithIndexpathRow:(NSInteger)indexpathRow
{
    if ([[XTUserStore sharedManager].user.userID isEqualToString:[NSString stringWithFormat:@"%zd",indexpathRow]]) {
        return;
    }

    XTUserHomePageViewController *userHomeVC = [[XTUserHomePageViewController alloc]init];
    userHomeVC.userID = [NSString stringWithFormat:@"%zd",indexpathRow];
    userHomeVC.type = XTUserHomePageTypeHis;
    userHomeVC.userType = XTAccountCommon;
    [self.navigationController pushViewController:userHomeVC animated:YES];
    
}
- (void)clickXTGeneralMessageTypeThreeCellRightImageViewBtnWithIndexpathRow:(NSInteger)indexpathRow
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
    XTImgDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
    NSArray *arr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%zd",indexpathRow], nil];
    controller.pidArr = arr;
    [self.navigationController pushViewController:controller animated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(UITableView *)theTableView
{
    if (_theTableView == nil) {
        _theTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _theTableView.delegate = self;
        _theTableView.dataSource = self;
        _theTableView.showsHorizontalScrollIndicator = NO;
        _theTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_theTableView];
        
        [_theTableView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0., 0., 49, 0.));
        }];
        
    }
    return _theTableView;
}
@end
