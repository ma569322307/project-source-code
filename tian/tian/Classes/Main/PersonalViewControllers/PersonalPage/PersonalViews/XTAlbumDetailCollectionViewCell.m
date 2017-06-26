//
//  XTAlbumDetailCollectionViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-6-11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTAlbumDetailCollectionViewCell.h"
#import "XTWaterFallControl.h"
#import "XTSubStore.h"
#import "XTUserStore.h"
#import "XTImageInfo.h"
#import "XTImgDetailViewController.h"
#import "XTUserHomePageViewController.h"
@interface XTAlbumDetailCollectionViewCell()<XTWaterFallViewControlDelegate>
@property(nonatomic, strong) XTWaterFallControl *waterFallControl;
@property(nonatomic, assign) long long maxId;
@property(nonatomic, assign) long long sinceId;
@end

@implementation XTAlbumDetailCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        self.backgroundColor = [UIColor whiteColor];
        [self slideView];
        [self waterFallControl];
    }
    
    return self;
}

- (SlideCollectionView *)slideView{
    if (!_slideView) {
        RAMCollectionViewFlemishBondLayout *layout = [[RAMCollectionViewFlemishBondLayout alloc] init];
        _slideView = [[SlideCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _slideView.backgroundView = [[UIView alloc] init];
        _slideView.backgroundView.backgroundColor = [UIColor whiteColor];
        _slideView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_slideView];
        
        [_slideView makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(@0);
            make.left.offset(@0);
            make.right.offset(@0);
            make.height.equalTo(self);
        }];
    }
    return _slideView;
}

- (XTWaterFallControl *)waterFallControl{
    if (!_waterFallControl) {
        _waterFallControl = [[XTWaterFallControl alloc] initWithCollectionView:_slideView headerView:nil refreshType:XTWaterFallRefreshType_footer cellType:XTWaterFallViewCellType_imageAndDescription];
        _waterFallControl.delegate = self;
        [_waterFallControl hidenTheFooterView:NO];
    }
    return _waterFallControl;
}

- (void)loadDefaultDataWithCompletionBlock:(void(^)(NSError *error))completionBlock{
    // 没有回调表示是普通刷新，有回调表示是下拉刷新不需要提示框
    if (!completionBlock) {
        [YYTHUD showLoadingNoLockFreeCenterAddedTo:self];
    }
    XTSubStore *subStore = [[XTSubStore alloc] init];
    NSString *userId = self.userID;
    @weakify(self);
    [subStore fetchUserImageFromUserId:[userId integerValue]
                                 maxId:0
                               sinceId:0
                                length:DefaultLoadCount
                       completionBlock:^(NSArray *imageItems, NSError *error) {
                           @strongify(self);
                           if (!error) {
                               [UIViewController UserHomePageController].isRefreshAlbumDetail = NO;
                               [YYTBlankView hideFromView:self];
                               if ([imageItems count] > 0) {
                                   [_waterFallControl hidenTheFooterView:NO];
                               }else if([imageItems count] == 0){
                                   [_waterFallControl hidenTheFooterView:YES];
                               }
                               if (!self.imageInfoItem) {
                                   self.imageInfoItem = [NSMutableArray arrayWithCapacity:0];
                               }
                               [self.imageInfoItem removeAllObjects];
                               [self.imageInfoItem addObjectsFromArray:imageItems];
                               [self reloadCollectView];
                               if (completionBlock) {
                                   completionBlock(nil);
                               }
                           }else if (completionBlock) {
                               // 完成的回调失败不作处理
                               completionBlock(error);
                           }else{
                               YYTBlankView *blankView = [YYTBlankView showBlankInView:self style:YYTBlankViewStyleNetworkError eventClick:^{
                                   [self loadDefaultDataWithCompletionBlock:nil];
                               }];
                               blankView.error = error;
                           }
                           [_waterFallControl stopWaterViewAnimating];
                           [YYTHUD hideLoadingFrom:self];
                           
                       }];
}

- (void)loadUserAlbumListNewData
{
    XTSubStore *subStore = [[XTSubStore alloc] init];
    NSString *userId = self.userID;
    @weakify(self)
    [subStore fetchUserImageFromUserId:[userId integerValue]
                                 maxId:0
                               sinceId:self.sinceId
                                length:DefaultLoadCount
                       completionBlock:^(NSArray *imageItems, NSError *error) {
                           @strongify(self);
                           if (!error) {
                               if ([imageItems count] > 0) {
                                   [_waterFallControl hidenTheFooterView:NO];
                                   for (int i = 0; i < [imageItems count]; i++) {
                                       [self.imageInfoItem insertObject:[imageItems objectAtIndex:i] atIndex:i];
                                   }
                                   [self reloadCollectView];
                                   
                               }else if([imageItems count] == 0){
                                   [_waterFallControl hidenTheFooterView:YES];
                               }
                           }
                           [_waterFallControl stopWaterViewAnimating];
                       }];
}

- (void)loadUserAlbumListMoreData
{
    XTSubStore *subStore = [[XTSubStore alloc] init];
    NSString *userId = self.userID;
    @weakify(self)
    [subStore fetchUserImageFromUserId:[userId integerValue]
                                 maxId:self.maxId
                               sinceId:0
                                length:DefaultLoadCount
                       completionBlock:^(NSArray *imageItems, NSError *error) {
                           @strongify(self)
                           if (!error) {
                               if ([imageItems count] > 0) {
                                   [_waterFallControl hidenTheFooterView:NO];
                                   [self.imageInfoItem addObjectsFromArray:imageItems];
                                   [self reloadCollectView];
                                   
                               }else if([imageItems count] == 0){
                                   [_waterFallControl hidenTheFooterView:YES];
                               }
                           }
                           [_waterFallControl stopWaterViewAnimating];
                      }];
}

- (void)reloadCollectView{
    _waterFallControl.dataArray = self.imageInfoItem;
    if ([self.imageInfoItem count] == 0) {
        YYTBlankView *blankView = [YYTBlankView showBlankInView:self style:YYTBlankViewStyleBlank eventClick:nil];
        if ([self.userID isEqualToString:[XTUserStore sharedManager].user.userID]) {
            blankView.tipString = @"饭盆空空，求喂（chuan）食（tu）";
        }else{
            blankView.tipString = @"这只汪可能是懒吧";
        }
        
        [_waterFallControl reloadCollectionViewData];
        return;
    }
    
    for (int i = 0; i<[_imageInfoItem count]; i++) {
        if (i == 0) {
            XTImageInfo *info = [_imageInfoItem objectAtIndex:i];
            self.sinceId = info.id;
        }
        if (i == [_imageInfoItem count]-1) {
            XTImageInfo *info = [_imageInfoItem objectAtIndex:i];
            self.maxId = info.id;
        }
    }
    [_waterFallControl reloadCollectionViewData];
}

- (void)updateAlbumDetail{
    [self loadDefaultDataWithCompletionBlock:nil];
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

#pragma mark - XTWaterFallViewControlDelegate
- (void)pullToRefresh{
    
}

- (void)infiniteScrolling{
    [self loadUserAlbumListMoreData];
}

- (void)clickCellIndexRow:(NSInteger)clickRow
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
    XTImgDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
    controller.pidArr = [self getAllIdArray];
    controller.curIndex = clickRow;
    if ([self.userID isEqualToString:[[XTUserStore sharedManager] user].userID]) {
        controller.fromType = XTImgDetailViewControllerTypeMine;
    }
    [[UIViewController topViewController] pushViewController:controller animated:YES];
}

- (NSMutableArray *)getAllIdArray
{
    NSMutableArray *mArray = [NSMutableArray array];
    for (XTImageInfo *imgInfo in self.waterFallControl.dataArray) {
        [mArray addObject:[NSString stringWithFormat:@"%ld",imgInfo.id]];
    }
    return mArray;
}

@end
