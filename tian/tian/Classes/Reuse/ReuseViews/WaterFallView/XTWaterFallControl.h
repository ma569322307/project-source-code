//
//  XTWaterFallControl.h
//  tian
//
//  Created by cc on 15/6/8.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAMCollectionViewFlemishBondLayout.h"

typedef NS_ENUM(NSUInteger, XTWaterFallViewRefreshType) {
    XTWaterFallRefreshType_none = 0,
    XTWaterFallRefreshType_header = 1 << 0,
    XTWaterFallRefreshType_footer = 1 << 1,
};
//typedef enum{
//    XTWaterFallRefreshType_none = 0,
//    XTWaterFallRefreshType_header = 1 << 0,
//    XTWaterFallRefreshType_footer = 1 << 1,
//} XTWaterFallViewRefreshType;


@protocol XTWaterFallViewControlDelegate <NSObject>
@optional
- (void)pullToRefresh;//下拉
- (void)infiniteScrolling;//上提
- (void)clickCellIndexRow:(NSInteger)clickRow;
- (void)clickUserAvatarBtn:(NSInteger)clickUserid;
- (void)clickImgAndTopicCellTopicBtn:(NSInteger)clickTopicId;

- (void)collectionViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
- (void)collectionViewDidScroll:(UIScrollView *)scrollView;
- (void)collectionViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)collectionViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
-(void)collectionViewDidEndDecelerating:(UIScrollView *)scrollView;
-(void)collectionViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end

@interface XTWaterFallControl : NSObject<UICollectionViewDataSource, UICollectionViewDelegate, RAMCollectionViewFlemishBondLayoutDelegate>

@property (nonatomic, weak) id<XTWaterFallViewControlDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) RAMCollectionViewFlemishBondLayout *collectionViewLayout;

- (id)initWithCollectionView:(UICollectionView *)collectionV headerView:(UIView *)headerView refreshType:(XTWaterFallViewRefreshType)refreshType cellType:(XTWaterFallViewCellType)cellType;
- (void)reloadCollectionViewData;
/**
 *   刷新控件显示隐藏  yes，隐藏
 */
- (void)hidenTheHeaderView:(BOOL)hiden;
- (void)hidenTheFooterView:(BOOL)hiden;




/**
 *  停止刷新动画
 */
- (void)stopWaterViewAnimating;

/**
 *  开启下拉刷新动画
 */
- (void)waterViewTriggerRefresh;


@end
