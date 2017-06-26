//
//  XTSearchImageCollectionView.m
//  tian
//
//  Created by huhuan on 15/6/17.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchImageCollectionView.h"
#import "RAMCollectionViewFlemishBondLayout.h"
#import "XTImgDetailViewController.h"
#import "UIViewController+Extend.h"
#import "XTImageInfo.h"
#import "XTSearchIndexViewController.h"

@interface XTSearchImageCollectionView () <XTWaterFallViewControlDelegate>

@end

@implementation XTSearchImageCollectionView

static NSString *cellIdentifier = @"SearchImageCell";

- (XTWaterFallControl *)waterFallControl{
    if (!_waterFallControl) {
        _waterFallControl = [[XTWaterFallControl alloc] initWithCollectionView:self headerView:nil refreshType:XTWaterFallRefreshType_footer cellType:XTWaterFallViewCellType_imageAndDescription];
        _waterFallControl.delegate = self;
    }
    return _waterFallControl;
}

+ (XTSearchImageCollectionView *)imageCollectionView {

    RAMCollectionViewFlemishBondLayout *layout = [[RAMCollectionViewFlemishBondLayout alloc] init];
    XTSearchImageCollectionView *imageCollectionView = [[XTSearchImageCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [imageCollectionView waterFallControl];
    imageCollectionView.backgroundColor = [UIColor clearColor];
    return imageCollectionView;

}

- (void)reloadCollectView{
    self.waterFallControl.dataArray = [NSMutableArray arrayWithArray:self.imageArray];

    [_waterFallControl reloadCollectionViewData];
}

#pragma mark - XTWaterFallViewControlDelegate
- (void)pullToRefresh{
    
}

- (void)infiniteScrolling{
    if(self.loadMore) {
        self.loadMore();
    }
}

- (void)clickCellIndexRow:(NSInteger)clickRow{
    
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
