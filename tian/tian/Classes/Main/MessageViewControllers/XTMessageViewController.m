//
//  XTMessageViewController.m
//  tian
//
//  Created by 尚毅 杨 on 15/4/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTMessageViewController.h"
#import "XTTitleSliderBar.h"

#import "XTPrivateMessageViewController.h"
#import "XTGeneralMessageViewController.h"
#import "XTNotificationMessageViewController.h"
#import "XTUnreadCountView.h"
#import "XTSearchIndexViewController.h"
#import "XTMessageScrollView.h"
#import "XTUnReadMessageCountStore.h"

@interface XTMessageViewController ()<UIScrollViewDelegate,RCIMReceiveMessageDelegate>
@property (nonatomic, strong) XTTitleSliderBar *titleSliderBar;
@property (nonatomic, assign) NSInteger theSelectedIndex;
@property (weak, nonatomic) IBOutlet XTMessageScrollView *bgScrollView;

@property (nonatomic, strong) XTPrivateMessageViewController *privateMessageViewController;
@property (nonatomic, strong) XTGeneralMessageViewController *generalMessageViewController;
@property (nonatomic, strong) XTNotificationMessageViewController *notificationMessageViewController;

@end

@implementation XTMessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    self.theSelectedIndex = 0;
//    [self.titleSliderBar animationToNext:self.theSelectedIndex];
//    [self changeView];
    //获取未读数
    [[XTUnReadMessageCountStore getInstance] fetchUnReadMessageCount];
    [self setPrivteUnreadCount];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self addUnreadNotification];
    
    [self addNavigationBarItems];
    self.theSelectedIndex = 0;
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_SIZE.width*3, 0);
    
    [self changeView];
    [self unreadCountNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTopAndRefreshView:) name:@"scrollToTopAndRefreshView" object:nil];
}
- (void)unreadCountNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageUnreadCount:) name:kMessagekey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationUnreadCount:) name:kNotificationkey object:nil];
    
}

- (void)addNavigationBarItems
{
    self.navigationItem.leftBarButtonItem = nil;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:UIIMAGE(@"homePage_Search") forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    NSArray *titleArray = @[@"消息",@"通知",@"私信"];
    self.titleSliderBar = [[XTTitleSliderBar alloc] initWIthTitleArray:titleArray];
    CGFloat width = [self.titleSliderBar getTitleSliderBarWidth];
    [self.titleSliderBar setFrame:CGRectMake(0, 0, width, XTTitleSliderBarHeight)];
    
    self.navigationItem.titleView = self.titleSliderBar;
    
    __weak XTMessageViewController *weakSelf = self;
    self.titleSliderBar.tilteSliderBarSelectedBlock = ^(NSInteger index)
    {
        weakSelf.theSelectedIndex = index;
        [weakSelf changeView];
    };
    [self.titleSliderBar animationToNext:0];
}

- (void)scrollTopAndRefreshView:(NSNotification *)notification
{
    NSInteger tabarSelectdIndex = [notification.object integerValue];
    CLog(@"hotlick == ==notification.object = = = =%ld",tabarSelectdIndex);
    if (tabarSelectdIndex == 2) {
        switch (self.theSelectedIndex) {
            case 0:
            {
                [self.generalMessageViewController.theTableView.header beginRefreshing];
                break;
            }
            case 1:
            {
                [self.notificationMessageViewController.theTableView.header beginRefreshing];
                break;
            }
            default:
                break;
        }
    }
}

- (void)changeView
{
    switch (self.theSelectedIndex) {
        case 2:
        {
            if (![self.bgScrollView.subviews containsObject:self.privateMessageViewController.view]) {
                self.privateMessageViewController.view.frame = CGRectMake(SCREEN_SIZE.width*2, 0, SCREEN_SIZE.width, CGRectGetHeight(self.bgScrollView.frame));
                [self.bgScrollView addSubview:self.privateMessageViewController.view];
                [self addChildViewController:self.privateMessageViewController];
            }
            break;
        }
        case 0:
        {
            if (![self.bgScrollView.subviews containsObject:self.generalMessageViewController.view]) {
                CLog(@"%f",SCREEN_SIZE.width);
                self.generalMessageViewController.view.frame = CGRectMake(0, 0, SCREEN_SIZE.width, CGRectGetHeight(self.bgScrollView.frame));
                [self.bgScrollView addSubview:self.generalMessageViewController.view];
                [self addChildViewController:self.generalMessageViewController];
            }
            
            break;
        }
        case 1:
        {
//            self.bgScrollView.scrollEnabled = NO;
            if (![self.bgScrollView.subviews containsObject:self.notificationMessageViewController.view]) {
                self.notificationMessageViewController.view.frame = CGRectMake(SCREEN_SIZE.width, 0, SCREEN_SIZE.width, CGRectGetHeight(self.bgScrollView.frame));
                [self.bgScrollView addSubview:self.notificationMessageViewController.view];
                [self addChildViewController:self.notificationMessageViewController];
            }
            
            break;
        }
            
        default:
            break;
    }
    [self.bgScrollView setContentOffset:CGPointMake(SCREEN_SIZE.width*self.theSelectedIndex, 0) animated:YES];
    
    //刷新新数据，并把气泡置为0；
    if ([self.titleSliderBar.messageUnreadView getTheUnreadCount]>0&&self.theSelectedIndex == 0) {
        [self.generalMessageViewController loadDataWith:NO];
    }else if ([self.titleSliderBar.notificationUnreadView getTheUnreadCount]>0&&self.theSelectedIndex == 1)
    {
        [self.notificationMessageViewController loadDataIsLoadMore:NO];
    }
}
#pragma mark -
- (XTPrivateMessageViewController *)privateMessageViewController
{
    if (!_privateMessageViewController) {
        _privateMessageViewController = [[XTPrivateMessageViewController alloc]init];
        [_privateMessageViewController setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    }
    return _privateMessageViewController;
}
- (XTGeneralMessageViewController *)generalMessageViewController
{
    if(!_generalMessageViewController)
    {
        _generalMessageViewController = [[XTGeneralMessageViewController alloc]init];
        
    }
    return _generalMessageViewController;
}
- (XTNotificationMessageViewController *)notificationMessageViewController
{
    if (!_notificationMessageViewController) {
        _notificationMessageViewController = [[XTNotificationMessageViewController alloc]init];
    }
    return _notificationMessageViewController;
}
#pragma mark - 更新消息未读数
- (void)addUnreadNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataPrivateUnreadCount:) name:@"PrivateMessageKey" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageUnreadCount:) name:kMessagekey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationUnreadCount:) name:kNotificationkey object:nil];
}

/**
 接收消息到消息后执行。
 
 @param message 接收到的消息。
 @param left    剩余消息数.
 */
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{

   [self setPrivteUnreadCount];
}
//私信未读数
- (void)setPrivteUnreadCount
{
    int privteUnreadCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    if (privteUnreadCount>0) {
        CLog(@"未读消息数目为%zd",privteUnreadCount);
        self.titleSliderBar.privateUnreadView.hidden = NO;
        
        [self.titleSliderBar.privateUnreadView setUnreadCountLabelText:privteUnreadCount];
    }else
    {
        [self.titleSliderBar.privateUnreadView setUnreadCountLabelText:0];
    }

}

- (void)updataPrivateUnreadCount:(NSNotification *)notification
{
    CLog(@"收到私信  更改私信气泡");
    [self performSelectorOnMainThread:@selector(setPrivteUnreadCount) withObject:nil waitUntilDone:NO];
  //  [self setPrivteUnreadCount];
}
- (void)updateMessageUnreadCount:(NSNotification *)notification
{
    XTUnReadInfo *unreadInfo = notification.object;
    if (unreadInfo.msgCount) {
        [self.titleSliderBar.messageUnreadView setUnreadCountLabelText:unreadInfo.msgCount];
        CLog(@"设置消息未读数 = =%zd",unreadInfo.msgCount);
    }else
    {
        [self.titleSliderBar.messageUnreadView setUnreadCountLabelText:0];
        CLog(@"设置消息未读数为00000 = =%zd",unreadInfo.msgCount);
    }
}
- (void)updateNotificationUnreadCount:(NSNotification *)notification
{
    XTUnReadInfo *unreadInfo = notification.object;
    if (unreadInfo.notifyCount) {
        [self.titleSliderBar.notificationUnreadView setUnreadCountLabelText:unreadInfo.notifyCount];
    }else
    {
        [self.titleSliderBar.notificationUnreadView setUnreadCountLabelText:0];

    }
}

-(void)setSubViewScrollEnabled:(BOOL)enabled{
    self.generalMessageViewController.theTableView.scrollEnabled = enabled;
    self.notificationMessageViewController.theTableView.scrollEnabled = enabled;
    self.privateMessageViewController.conversationListTableView.scrollEnabled = enabled;
}
#pragma mark - scrollview Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 父视图停止滚动，子视图重新能滚动
    [self setSubViewScrollEnabled:YES];
    float contentOffset = scrollView.contentOffset.x;
    NSInteger endSelected = self.theSelectedIndex;
    if (contentOffset<SCREEN_SIZE.width) {
        endSelected = 0;
    }else if (contentOffset>=SCREEN_SIZE.width&&contentOffset<SCREEN_SIZE.width*2)
    {
        endSelected = 1;
    }else
    {
        endSelected = 2;
    }
    
    
    if (endSelected!=self.theSelectedIndex) {
        self.theSelectedIndex = endSelected;
        [self.titleSliderBar animationToNext:endSelected];
        [self changeView];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 父视图滚动，子视图不能滚
    [self setSubViewScrollEnabled:NO];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // 父视图停止滚动，子视图重新能滚动
    [self setSubViewScrollEnabled:YES];
}
- (void)clickRightBtn
{
    XTSearchIndexViewController *searchVC = [[XTSearchIndexViewController alloc] initWithNibName:@"XTSearchIndexViewController" bundle:nil];
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"scrollToTopAndRefreshView" object:nil];
}
@end
