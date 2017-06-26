//
//  XTSearchAllCollectionView.m
//  tian
//
//  Created by huhuan on 15/6/23.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchAllCollectionView.h"
#import "JKUtil.h"
#import "XTSearchAllModel.h"
#import "RAMCollectionViewFlemishBondLayout.h"
#import "XTSearchAllTableView.h"
#import "XTImageInfo.h"
#import "XTImgDetailViewController.h"
#import "UIViewController+Extend.h"
#import "XTSearchAllViewController.h"
#import "XTSearchIndexViewController.h"

@interface XTSearchAllCollectionView ()<XTWaterFallViewControlDelegate>

@property (nonatomic, strong) XTSearchAllTableView *headerView;

@end

@implementation XTSearchAllCollectionView

+ (XTSearchAllCollectionView *)searchAllCollectionView {
    RAMCollectionViewFlemishBondLayout *layout = [[RAMCollectionViewFlemishBondLayout alloc] init];
    XTSearchAllCollectionView *allCollectionView = [[XTSearchAllCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [allCollectionView waterFallControl];
    allCollectionView.backgroundColor = [UIColor clearColor];
    return allCollectionView;
}

- (XTWaterFallControl *)waterFallControl{
    if (!_waterFallControl) {
        _waterFallControl = [[XTWaterFallControl alloc] initWithCollectionView:self headerView:self.headerView refreshType:XTWaterFallRefreshType_footer cellType:XTWaterFallViewCellType_imageAndDescription];
        _waterFallControl.delegate = self;
    }
    return _waterFallControl;
}

- (void)configureSearchAllCollectionView {
    self.headerView.searchAllModel = self.searchAllModel;
    [self.headerView configureSearchAllTableView];
    self.headerView.frame = CGRectMake(0., 0., SCREEN_SIZE.width, [self.headerView tableViewHeight]);
    [self.headerView reloadData];
    self.waterFallControl.dataArray = [NSMutableArray arrayWithArray:self.searchAllModel.pics];
    [self.waterFallControl reloadCollectionViewData];

}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [XTSearchAllTableView searchAllTableView];
    }
    return _headerView;
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
