//
//  XTDedicateListCollectViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-6-15.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTDedicateListCollectViewCell.h"
#import "XTUserHomePageViewController.h"
#import "XTHotRankListCell.h"
#import "XTSubStore.h"
#import "XTUserInfo.h"
#import "XTUserStore.h"
@interface XTDedicateListCollectViewCell()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, assign) NSInteger pageCount;
@end

@implementation XTDedicateListCollectViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        self.backgroundColor = [UIColor clearColor];        
        [self slideView];
        self.dedicateUserItem = [NSMutableArray arrayWithCapacity:0];
        self.pageCount = 0;
    }
    
    return self;
}

- (void)loadDedicateListData{
    [YYTHUD showLoadingNoLockFreeCenterAddedTo:self];
    XTSubStore *subStore = [[XTSubStore alloc] init];
    NSString *userId = self.userID;
    @weakify(self);
    [subStore fetchDedicateListFromArtistId:[userId integerValue]
                                   Location:0
                                     length:DefaultLoadCount
                            completionBlock:^(NSArray *artistItems, NSError *error) {
                                @strongify(self);
                                if (!error) {
                                    [YYTBlankView hideFromView:self];
                                    if ([artistItems count] == 0) {
                                        self.slideView.footer.hidden = YES;                                        
                                        YYTBlankView *blankView = [YYTBlankView showBlankInView:self style:YYTBlankViewStyleBlank eventClick:nil];
                                        blankView.tipString = @"还没有喜欢TA的舔神！";
                                    }else{
                                        self.pageCount = 1;
                                        [self.dedicateUserItem removeAllObjects];
                                        [self.dedicateUserItem addObjectsFromArray:artistItems];
                                        [self.slideView reloadData];
                                        if (!self.slideView.footer) {
                                            @weakify(self);
                                            self.slideView.footer = [XTGifFooter footerWithRefreshingBlock:^{
                                                @strongify(self);
                                                [self loadDedicateListMoreData];
                                            }];
                                        }
                                        self.slideView.footer.hidden = NO;
                                    }
                                }else{
                                    YYTBlankView *blankView = [YYTBlankView showBlankInView:self style:YYTBlankViewStyleNetworkError eventClick:^{
                                        [self loadDedicateListData];
                                    }];
                                    blankView.error = error;
                                }
                                [self.slideView.footer endRefreshing];                                
                                [YYTHUD hideLoadingFrom:self];
                            }];
}

- (void)loadDedicateListMoreData{
    XTSubStore *subStore = [[XTSubStore alloc] init];
    NSString *userId = self.userID;
    @weakify(self);
    [subStore fetchDedicateListFromArtistId:[userId integerValue]
                                   Location:self.pageCount*DefaultLoadCount
                                     length:DefaultLoadCount
                            completionBlock:^(NSArray *artistItems, NSError *error) {
                                @strongify(self);
                                if (!error) {
                                    [YYTBlankView hideFromView:self];
                                    if ([artistItems count] == 0) {
                                        self.slideView.footer.hidden = YES;
                                    }else{
                                        self.slideView.footer.hidden = NO;
                                        self.pageCount += 1;
                                        @weakify(self);
                                        //数据去重
                                        [self.dedicateUserItem addObjectsFromArray:artistItems withCheckKey:@"uid" completionBlock:^{
                                            @strongify(self);
                                            [self.slideView reloadData];
                                        }];
//                                        [self.dedicateUserItem addObjectsFromArray:artistItems];
//                                        [self.slideView reloadData];
                                    }
                                }else{
                                    YYTBlankView *blankView = [YYTBlankView showBlankInView:self style:YYTBlankViewStyleNetworkError eventClick:^{
                                        [self loadDedicateListData];
                                    }];
                                    blankView.error = error;
                                }
                                [self.slideView.footer endRefreshing];
                            }];
}

/*
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    NSLog(@"1111-----%f,%f",point.x,point.y);
    scrollView.bounces = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGPoint point = scrollView.contentOffset;
    NSLog(@"2222-----%f,%f",point.x,point.y);
    NSLog(@"velocity:%f,%f,targetContentOffset:%f,%f",velocity.x,velocity.y,(*targetContentOffset).x,(*targetContentOffset).y);
    if ((*targetContentOffset).y <= 0) {
        scrollView.bounces = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"adjustContainerViewNotifition" object:[NSNumber numberWithFloat:velocity.y]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) {
        CGPoint point = scrollView.contentOffset;
        NSLog(@"3333-----%f,%f",point.x,point.y);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    NSLog(@"4444-----%f,%f",point.x,point.y);
    if (point.y <= 0) {
        scrollView.bounces = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"adjustContainerViewNotifition" object:[NSNumber numberWithFloat:-point.y]];
    }
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dedicateUserItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HotfourTableViewCell = @"XTHotfourTableViewCell";
    XTHotRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:HotfourTableViewCell];
    if (cell == nil) {
        cell = [[XTHotRankListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HotfourTableViewCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XTUserInfo *userInfo = [self.dedicateUserItem objectAtIndex:indexPath.row];
    
//    [cell.headPortraitImageView sd_setImageWithURL:userInfo.smallAvatar placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        //[YYTConfig sharedConfig].networkFlow = receivedSize;
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
//        [cell.headPortraitImageView setImage:image];
//        [cell.headPortraitImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//        [cell.headPortraitImageView setContentMode:UIViewContentModeScaleAspectFill];
//        [cell.headPortraitImageView setClipsToBounds:YES];
//        cell.headPortraitImageView.alpha = 0.0;
//        [UIView animateWithDuration:1.0f animations:^{
//            cell.headPortraitImageView.alpha = 1.0;
//        }];
//    }];
    [cell.headPortraitImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    [cell.headPortraitImageView setContentMode:UIViewContentModeScaleAspectFill];
    [cell.headPortraitImageView setClipsToBounds:YES];
    [cell.headPortraitImageView an_setImageWithURL:userInfo.smallAvatar placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
    cell.VImageView.hidden = !userInfo.vuser;
    cell.nickNameLabel.text = userInfo.nickName;
    cell.levelLabel.text = [NSString stringWithFormat:@"lv%ld",userInfo.level];
    cell.contentLabel.text = [NSString stringWithFormat:@"%ld",userInfo.prestigeValue];
    cell.valueLabel.text = [NSString stringWithFormat:@"%ld",userInfo.ranking];
    if (indexPath.row == 0) {
        cell.valueLabel.textColor = UIColorFromRGB(0xff9600);
    }else if (indexPath.row == 1){
        cell.valueLabel.textColor = UIColorFromRGB(0xffc000);
    }else if (indexPath.row == 2){
        cell.valueLabel.textColor = UIColorFromRGB(0xffd34b);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XTUserInfo *userInfo = [self.dedicateUserItem objectAtIndex:indexPath.row];
    NSString *userID = [NSString stringWithFormat:@"%ld", userInfo.uid];
    if (![userID isEqualToString:[[XTUserStore sharedManager] user].userID]) {
        XTUserHomePageViewController *userHomeVC = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
        userHomeVC.type = XTUserHomePageTypeHis;
        userHomeVC.userType = userInfo.vuser?XTAccountFans:XTAccountCommon;
        userHomeVC.userID = userID;
        [[UIViewController topViewController] pushViewController:userHomeVC animated:YES];
    }
//    [tempUserHomeVC performSelector:@selector(setWillPushToUserPage:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.5];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [self.dedicateUserItem count]-1) {
        return 85.0f;
    }
    return 85.0f;
}

- (UITableView *)slideView{
    if (!_slideView) {
        _slideView = [SlideTableView new];
        _slideView.tableViewCellStyle = XTTopicTableViewCellStyleOwn;
        _slideView.showsVerticalScrollIndicator = NO;
        _slideView.backgroundView = [[UIView alloc] init];
        _slideView.backgroundView.backgroundColor = [UIColor whiteColor];
        _slideView.backgroundColor = [UIColor whiteColor];
        _slideView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _slideView.delegate = self;
        _slideView.dataSource = self;
        [self addSubview:_slideView];
        [_slideView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.and.right.equalTo(self).insets(UIEdgeInsetsMake(0, 8, 0, 8));
        }];
    }
    return _slideView;
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
