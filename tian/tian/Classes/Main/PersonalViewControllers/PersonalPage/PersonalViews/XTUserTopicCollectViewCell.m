//
//  XTUserTopicCollectViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-6-15.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUserTopicCollectViewCell.h"
#import "XTTopicIndexViewController.h"
#import "XTSubStore.h"
#import "XTTopicInfo.h"
#import "XTPostInfo.h"
#import <Mantle/EXTScope.h>
#import "YYTHUD.h"
#import "XTTopicDetailViewController.h"
#import "XTUserStore.h"
@interface XTUserTopicCollectViewCell()
@property (nonatomic, assign) long long maxId;
@property (nonatomic, assign) long long sinceId;
@end

@implementation XTUserTopicCollectViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(updateUserTopic)
//                                                     name:@"updateUserTopicNotification"
//                                                   object:nil];
        [self slideView];
        self.topicArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return self;
}

- (XTTopicTableView *)slideView{
    if (!_slideView) {
        _slideView = [XTTopicTableView topicTableViewWithCellStyle:XTTopicTableViewCellStyleOwn];
        _slideView.backgroundView = [[UIView alloc] init];
        _slideView.backgroundView.backgroundColor = [UIColor whiteColor];
        _slideView.backgroundColor = [UIColor whiteColor];
        _slideView.topicCellClick = ^(MTLModel *topicInfo){
            if ([topicInfo isKindOfClass:[XTTopicInfo class]]) {
                XTTopicInfo *info = (XTTopicInfo *)topicInfo;
                XTTopicIndexViewController *topicCtr = [[XTTopicIndexViewController alloc] init];
                topicCtr.topicId = info.topicId;
                topicCtr.topicTitle = info.title;
                [[UIViewController topViewController] pushViewController:topicCtr animated:YES];
            }else if ([topicInfo isKindOfClass:[XTPostInfo class]]){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
                XTTopicDetailViewController *topicDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"XTTopicDetailViewController"];
                XTPostInfo *postInfo = (XTPostInfo *)topicInfo;
                topicDetailVC.topicID = @(postInfo.postId);
                [[UIViewController topViewController] pushViewController:topicDetailVC animated:YES];
            }
        };
        [self addSubview:_slideView];
        
        [_slideView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.bottom.right.equalTo(self.contentView);
        }];
    }
    
    return _slideView;
}

- (void)updateUserTopic{
    [self loadDefaultUserTopicDataWithCompletionBlock:nil];
}

- (void)loadDefaultUserTopicDataWithCompletionBlock:(void(^)(NSError *error))completionBlock{
    // 没有回调表示是普通刷新，有回调表示是下拉刷新不需要提示框
    if (!completionBlock) {
        [YYTHUD showLoadingNoLockFreeCenterAddedTo:self];
    }
    XTSubStore *subStore = [[XTSubStore alloc] init];
    NSString *userId = self.userID;
    @weakify(self)
    [subStore fetchUserTopicFromUserId:[userId integerValue]
                                 maxId:0
                               sinceId:0
                                length:DefaultLoadCount
                       completionBlock:^(NSArray *topicItems, NSError *error) {
                           @strongify(self)
                           if (!error) {
                               [UIViewController UserHomePageController].isRefreshUserTopic = NO;
                               [YYTBlankView hideFromView:self];                               
                               if ([topicItems count] > 0) {
                                   id topic = [topicItems objectAtIndex:0];
                                   if ([topic isKindOfClass:[XTTopicInfo class]]) {
                                       XTTopicInfo *info = (XTTopicInfo *)topic;
                                       self.sinceId = info.stateID;
                                   }else if([topic isKindOfClass:[XTPostInfo class]]){
                                       XTPostInfo *info = (XTPostInfo *)topic;
                                       self.sinceId = info.stateID;
                                   }
                                   
                                   topic = [topicItems objectAtIndex:[topicItems count]-1];
                                   if ([topic isKindOfClass:[XTTopicInfo class]]) {
                                       XTTopicInfo *info = (XTTopicInfo *)topic;
                                       self.maxId = info.stateID;
                                   }else if([topic isKindOfClass:[XTPostInfo class]]){
                                       XTPostInfo *info = (XTPostInfo *)topic;
                                       self.maxId = info.stateID;
                                   }
                                   
                                   if (!self.slideView.footer) {
                                       self.slideView.footer = [XTGifFooter footerWithRefreshingBlock:^{
                                           [self loadUserTopicMoreData];
                                       }];
                                   }
                                   self.slideView.footer.hidden = NO;
                               }else if([topicItems count] == 0){
                                   YYTBlankView *blankView = [YYTBlankView showBlankInView:self style:YYTBlankViewStyleBlank eventClick:nil];
                                   if ([self.userID isEqualToString:[XTUserStore sharedManager].user.userID]) {
                                       blankView.tipString = @"不给我们看看你的脑洞吗?";;
                                   }else{
                                       blankView.tipString = @"这只汪的脑洞可能是弱吧";
                                   }
                                   
                                   self.slideView.footer.hidden = YES;
                               }
                               [self.topicArray removeAllObjects];
                               [self.topicArray addObjectsFromArray:topicItems];
                               self.slideView.topicArray = self.topicArray;
                               [self.slideView refreshTableView];
                               if (completionBlock) {
                                   completionBlock(nil);
                               }
                           }else if (completionBlock) {
                               // 完成的回调失败不作处理
                               completionBlock(error);
                           }else{
                               YYTBlankView *blankView = [YYTBlankView showBlankInView:self style:YYTBlankViewStyleNetworkError eventClick:^{
                                   [self loadDefaultUserTopicDataWithCompletionBlock:nil];
                               }];
                               blankView.error = error;
                           }
                           [YYTHUD hideLoadingFrom:self];
                       }];
}

- (void)loadUserTopicNewData
{
    XTSubStore *subStore = [[XTSubStore alloc] init];
    NSString *userId = self.userID;
    __weak XTUserTopicCollectViewCell *wself = self;
    
    [subStore fetchUserTopicFromUserId:[userId integerValue]
                                 maxId:0
                               sinceId:self.sinceId
                                length:DefaultLoadCount
                       completionBlock:^(NSArray *topicItems, NSError *error) {
                           if (!error && [topicItems count] > 0) {
                               CLog(@"%@",topicItems);
                               id topic = [topicItems objectAtIndex:0];
                               if ([topic isKindOfClass:[XTTopicInfo class]]) {
                                   XTTopicInfo *info = (XTTopicInfo *)topic;
                                   self.sinceId = info.stateID;
                               }else if([topic isKindOfClass:[XTPostInfo class]]){
                                   XTPostInfo *info = (XTPostInfo *)topic;
                                   self.sinceId = info.stateID;
                               }
                               
                               for (int i = 0; i < [topicItems count]; i++) {
                                   [wself.topicArray insertObject:[topicItems objectAtIndex:i] atIndex:i];
                               }
                               self.slideView.topicArray = self.topicArray;
                               [self.slideView refreshTableView];
                           }
                       }];
}

- (void)loadUserTopicMoreData
{
    XTSubStore *subStore = [[XTSubStore alloc] init];
    NSString *userId = self.userID;
    __weak XTUserTopicCollectViewCell *wself = self;
    
    [subStore fetchUserTopicFromUserId:[userId integerValue]
                                 maxId:self.maxId
                               sinceId:0
                                length:DefaultLoadCount
                       completionBlock:^(NSArray *topicItems, NSError *error) {
                           if (!error) {
                               if ([topicItems count] > 0) {
                                   wself.slideView.footer.hidden = NO;
                                   id topic = [topicItems objectAtIndex:[topicItems count]-1];
                                   if ([topic isKindOfClass:[XTTopicInfo class]]) {
                                       XTTopicInfo *info = (XTTopicInfo *)topic;
                                       self.maxId = info.stateID;
                                   }else if([topic isKindOfClass:[XTPostInfo class]]){
                                       XTPostInfo *info = (XTPostInfo *)topic;
                                       self.maxId = info.stateID;
                                   }
                                   
                                   [self.topicArray addObjectsFromArray:topicItems];
                                   self.slideView.topicArray = self.topicArray;
                                   [self.slideView reloadData];
                                   
                               }else if([topicItems count] == 0){
                                   wself.slideView.footer.hidden = YES;
                               }
                           }
                           [self.slideView.footer endRefreshing];
                       }];
}

- (void)setContentOffset:(CGPoint)point{
    [self.slideView setContentOffset:point animated:YES];
}

- (void)setSlideViewState:(State)state{
    self.slideView.tState = state;
}

- (State)slideViewState{
    return self.slideView.tState;
}
@end
