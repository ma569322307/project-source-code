//
//  XTVSpreadCollectionView.m
//  tian
//
//  Created by huhuan on 15/7/7.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTVSpreadCollectionView.h"
#import "JKUtil.h"
#import "RAMCollectionViewFlemishBondLayout.h"
#import "XTVSpreadTableView.h"
#import "XTHotLicksCommonArtistInfo.h"
#import "XTImageInfo.h"
#import "XTImgDetailViewController.h"
#import "UIViewController+Extend.h"

@interface XTVSpreadCollectionView () <XTWaterFallViewControlDelegate>

@property (nonatomic, strong) XTVSpreadTableView *headerView;

@end

@implementation XTVSpreadCollectionView

+ (XTVSpreadCollectionView *)spreadCollectionView {
    RAMCollectionViewFlemishBondLayout *layout = [[RAMCollectionViewFlemishBondLayout alloc] init];
    XTVSpreadCollectionView *spreadCollectionView = [[XTVSpreadCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [spreadCollectionView waterFallControl];
    spreadCollectionView.backgroundColor = [UIColor whiteColor];
    return spreadCollectionView;
}

- (XTWaterFallControl *)waterFallControl{
    if (!_waterFallControl) {
        _waterFallControl = [[XTWaterFallControl alloc] initWithCollectionView:self headerView:self.headerView refreshType:XTWaterFallRefreshType_footer cellType:XTWaterFallViewCellType_imageAndDescription];
        _waterFallControl.delegate = self;
    }
    return _waterFallControl;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [XTVSpreadTableView spreadTableView];
        _headerView.frame = CGRectMake(0., 0., SCREEN_SIZE.width, [_headerView tableViewHeight]);

    }
    return _headerView;
}

- (void)configureSpreadCollectionViewWithCommonArtistInfo:(XTHotLicksCommonArtistInfo *)artistInfo {
    self.headerView.artistInfo = artistInfo;
    [self.headerView configureSpreadTableView];
    self.headerView.frame = CGRectMake(0., 0., SCREEN_SIZE.width, [self.headerView tableViewHeight]);
    
}

#pragma mark - XTWaterFallViewControlDelegate
- (void)pullToRefresh {
    
}

- (void)infiniteScrolling {
    if(self.loadMore) {
        self.loadMore();
    }
}

- (void)clickCellIndexRow:(NSInteger)clickRow {
    NSMutableArray *mArray = [NSMutableArray array];
    for (XTImageInfo *imgInfo in self.waterFallControl.dataArray) {
        [mArray addObject:[NSString stringWithFormat:@"%@",@(imgInfo.id)]];
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
    XTImgDetailViewController *detailController = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
    NSArray *arr = mArray;
    detailController.pidArr = arr;
    detailController.curIndex = clickRow;
    [[UIViewController topViewController] pushViewController:detailController animated:YES];
}

@end
