//
//  XTLoveAndCollectCollectionView.m
//  tian
//
//  Created by 刘佳 on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTLoveAndCollectCollectionView.h"
#import "JKUtil.h"
#import "RAMCollectionViewFlemishBondLayout.h"

@implementation XTLoveAndCollectCollectionView

+ (XTLoveAndCollectCollectionView *)loveAndCollectCollectionViewWithCellType:(XTWaterFallViewCellType)type
{
    RAMCollectionViewFlemishBondLayout *layout = [[RAMCollectionViewFlemishBondLayout alloc] init];
    XTLoveAndCollectCollectionView *collectionView = [[XTLoveAndCollectCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [collectionView waterFallControlWithCellType:type];
    collectionView.backgroundColor = [UIColor whiteColor];
    
    return collectionView;
}

- (XTWaterFallControl *)waterFallControlWithCellType:(XTWaterFallViewCellType)type
{
    if (!_waterFallControl) {
        
        _waterFallControl = [[XTWaterFallControl alloc] initWithCollectionView:self headerView:nil refreshType:XTWaterFallRefreshType_footer | XTWaterFallRefreshType_header cellType:type];
        _waterFallControl.delegate = self;
    }
    
    return _waterFallControl;
}

- (void)configureCollectionViewWithArray:(NSArray*)array
{
    self.waterFallControl.dataArray = [NSMutableArray arrayWithArray:array];
    
    [self.waterFallControl reloadCollectionViewData];
    
   // [self reloadData];
}

#pragma mark - XTWaterFallViewControlDelegate
- (void)pullToRefresh
{
    if (self.loadRefreshBlock) {
        self.loadRefreshBlock();
    }
}

- (void)infiniteScrolling
{
    if(self.loadMoreBlock) {
        self.loadMoreBlock();
    }
}

- (void)clickCellIndexRow:(NSInteger)clickRow
{
    if (self.clickCellIndexRowBlock) {
        self.clickCellIndexRowBlock(clickRow);
    }
}

@end
