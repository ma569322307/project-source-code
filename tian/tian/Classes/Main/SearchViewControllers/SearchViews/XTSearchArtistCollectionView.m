//
//  XTSearchArtistCollectionView.m
//  tian
//
//  Created by huhuan on 15/6/23.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchArtistCollectionView.h"
#import "JKUtil.h"
#import "XTSearchArtistModel.h"
#import "RAMCollectionViewFlemishBondLayout.h"
#import "XTSearchArtistTableView.h"
#import "XTImageInfo.h"
#import "XTImgDetailViewController.h"
#import "UIViewController+Extend.h"
#import "XTSearchIndexViewController.h"

@interface XTSearchArtistCollectionView ()<XTWaterFallViewControlDelegate>

@property (nonatomic, strong) XTSearchArtistTableView *headerView;

@end

@implementation XTSearchArtistCollectionView

+ (XTSearchArtistCollectionView *)searchArtistCollectionView {
    RAMCollectionViewFlemishBondLayout *layout = [[RAMCollectionViewFlemishBondLayout alloc] init];
    XTSearchArtistCollectionView *artistCollectionView = [[XTSearchArtistCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [artistCollectionView waterFallControl];
    artistCollectionView.backgroundColor = [UIColor clearColor];
    return artistCollectionView;
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
        _headerView = [XTSearchArtistTableView searchArtistTableView];
    }
    return _headerView;
}

- (void)configureSearchArtistCollectionView {
    self.headerView.artistModel = self.artistModel;
    self.headerView.frame = CGRectMake(0., 0., SCREEN_SIZE.width, [self.headerView tableViewHeight]);
    [self.headerView configureSearchArtistTableView];
    [self.headerView reloadData];
    
    self.waterFallControl.dataArray = [NSMutableArray arrayWithArray:self.artistModel.pics];
    [self.waterFallControl reloadCollectionViewData];
    
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
    
    XTSearchIndexViewController *indexVC = (XTSearchIndexViewController *)[UIViewController currentViewController];
    indexVC.needTranform = YES;
    XTImageInfo *imageInfo = self.waterFallControl.dataArray[clickRow];
    [indexVC tranformPushWithCollectionView:self.waterFallControl.collectionView imageSize:CGSizeMake(imageInfo.width, imageInfo.height) currentIndex:clickRow];
    
    [indexVC.navigationController pushViewController:detailController animated:YES];
}

@end
