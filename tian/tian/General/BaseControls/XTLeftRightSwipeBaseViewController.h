//
//  XTLeftRightSlipBaseViewController.h
//  tian
//  左右滑动视图---只适合左右都是UICollectionView的界面结构
//  Created by 刘佳 on 15/6/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTBaseSwipeViewController.h"
typedef NS_ENUM(NSInteger, tagSelectItemType) {
    
    tagSelect_item_left = 0,
    tagSelect_item_right
    
};

@interface XTLeftRightSwipeBaseViewController : XTBaseSwipeViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView*      _leftCollectionView;
    UICollectionView*      _rightCollectionView;
}

@property(nonatomic, assign) tagSelectItemType      currentSelectTag;//设置当前要显示的视图（左视图、右视图）
@property(nonatomic, strong) NSMutableArray*        leftArray;
@property(nonatomic, strong) NSMutableArray*        rightArray;


//子类需重写以下方法!!!!!!!!!!!!
/*
 *返回Nav滑动组件的名字(例：@[@"粉丝", @"关注"])
 */
- (NSArray*)titleArray;

/*
 *左右是否开始下拉刷新(如果有下拉刷新重写此方法)
 */
- (void)leftBeginRefreshing;
- (void)rightBeginRefreshing;

/*
 *创建左右collection视图
 */
- (UICollectionView*)leftCollectionView;
- (UICollectionView*)rightCollectionView;

/*
 *创建或重置左右collection cell
 */
- (UICollectionViewCell*)leftCellWith:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath;
- (UICollectionViewCell*)rightCellWith:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath;
@end
