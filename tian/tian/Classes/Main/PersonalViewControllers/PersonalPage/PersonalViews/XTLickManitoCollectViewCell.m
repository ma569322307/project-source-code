//
//  XTLickManitoCollectViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-7-8.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTLickManitoCollectViewCell.h"
#import "XTWaterFallControl.h"
#import "XTSubStore.h"
#import "XTImageInfo.h"
#import "XTImgDetailViewController.h"
#import "XTPhotosListViewController.h"
@interface XTLickManitoCollectViewCell()<XTWaterFallViewControlDelegate>
@property(nonatomic, strong) XTWaterFallControl *waterFallControl;
@property(nonatomic, assign) NSInteger pageCount;
@end

@implementation XTLickManitoCollectViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        /*
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateLickManito)
                                                     name:@"updateLickManitoNotification"
                                                   object:nil];*/
        
        self.backgroundColor = [UIColor clearColor];
        [self slideView];
        [self waterFallControl];
        self.imageInfoItem = [NSMutableArray arrayWithCapacity:0];
        self.pageCount = 0;
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
    }
    return _waterFallControl;
}

- (void)loadLickManitoNewData
{
    [YYTHUD showLoadingNoLockFreeCenterAddedTo:self];
    XTSubStore *subStore = [[XTSubStore alloc] init];
    NSString *userId = self.userID;
    @weakify(self);
    [subStore fetchLickManitoFromArtistId:[userId integerValue]
                                   fromId:0
                                 location:0
                                   length:DefaultLoadCount
                          completionBlock:^(NSArray *imageItems, NSError *error) {
                              @strongify(self);
                              if (!error) {
                                  [YYTBlankView hideFromView:self];
                                  if ([imageItems count] > 0) {
                                      self.pageCount = 1;
                                      [_waterFallControl hidenTheFooterView:NO];
                                      [self.imageInfoItem removeAllObjects];
                                      [self.imageInfoItem addObjectsFromArray:imageItems];
                                      [self reloadCollectView];
                                  }else if([imageItems count] == 0){
                                      YYTBlankView *blankView = [YYTBlankView showBlankInView:self style:YYTBlankViewStyleBlank eventClick:nil];
                                      blankView.tipString = @"还没有舔神传图！";
                                      [_waterFallControl hidenTheFooterView:YES];
                                  }
                              }else{
                                  YYTBlankView *blankView = [YYTBlankView showBlankInView:self style:YYTBlankViewStyleNetworkError eventClick:^{
                                      [self loadLickManitoNewData];
                                  }];
                                  blankView.error = error;
                              }
                              [YYTHUD hideLoadingFrom:self];
                              [_waterFallControl stopWaterViewAnimating];
                       }];
}

- (void)loadLickManitoMoreData
{
    XTSubStore *subStore = [[XTSubStore alloc] init];
    NSString *userId = self.userID;
    XTImageInfo *imageInfo = (XTImageInfo *)[self.imageInfoItem objectAtIndex:[_imageInfoItem count]-1];
    NSInteger imageId = imageInfo.sid;
    
    @weakify(self);
    [subStore fetchLickManitoFromArtistId:[userId integerValue]
                                   fromId:imageId
                                 location:0
                                   length:DefaultLoadCount
                          completionBlock:^(NSArray *imageItems, NSError *error) {
                              @strongify(self);
                              if (!error) {
                                  NSLog(@"%@",imageItems);
                                  if ([imageItems count] > 0) {
                                      [_waterFallControl hidenTheFooterView:NO];
                                      self.pageCount += 1;
                                      @weakify(self);
                                      //数据去重
                                      [self.imageInfoItem addObjectsFromArray:imageItems withCheckKey:@"id" completionBlock:^{
                                          @strongify(self);
                                          [self reloadCollectView];
                                      }];
//                                      [self.imageInfoItem addObjectsFromArray:imageItems];
//                                      [self reloadCollectView];
                                  }else if([imageItems count] == 0){
                                      [_waterFallControl hidenTheFooterView:YES];
                                  }
                              }
                              [_waterFallControl stopWaterViewAnimating];
                          }];
}

- (void)reloadCollectView
{
    _waterFallControl.dataArray = self.imageInfoItem;
    [_waterFallControl reloadCollectionViewData];
}

- (void)updateLickManito{
    [self performSelector:@selector(loadLickManitoNewData) withObject:self afterDelay:2];
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
    [self loadLickManitoMoreData];
}

- (void)clickCellIndexRow:(NSInteger)clickRow{
    XTImageInfo *info = [self.imageInfoItem objectAtIndex:clickRow];
    if (info.imgCount == 1) {
        //单个图片
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
        XTImgDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
        NSArray *arr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",info.picId], nil];
        controller.pidArr = arr;
        [[UIViewController topViewController] pushViewController:controller animated:YES];
    }else if(info.imgCount > 1){
        //图集
        XTPhotosListViewController *atlasVC = [[XTPhotosListViewController alloc]init];
        atlasVC.pictureId = info.sid;
        atlasVC.type = XTPhotosListOtherType;
        atlasVC.pictureCount = info.imgCount;
        [[UIViewController topViewController] pushViewController:atlasVC animated:YES];
    }
}

/*
- (void)collectionViewWillBeginDragging:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    NSLog(@"1111-----%f,%f",point.x,point.y);
    scrollView.bounces = YES;
}

- (void)collectionViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if ((*targetContentOffset).y <= 0) {
        scrollView.bounces = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"adjustContainerViewNotifition" object:[NSNumber numberWithFloat:velocity.y]];
    }
}

- (void)collectionViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    if (point.y <= 0) {
        scrollView.bounces = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"adjustContainerViewNotifition" object:[NSNumber numberWithFloat:-point.y]];
    }
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
