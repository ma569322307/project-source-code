//
//  XTUserFavorateCollectionView.h
//  tian
//
//  Created by huhuan on 15/6/11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTUserCollectionViewCell.h"

#define kCellButtonClickNotification @"CellButtonClickNotification"
#define kCancelLikeNotification @"CancelLikeNotification"
/**
 *  collection类型：0:横向滚动 1：纵向滚动
 */
typedef NS_ENUM (NSUInteger, XTUserCollectionViewStyle) {
    XTUserCollectionViewStyleHorizontal = 0,
    XTUserCollectionViewStyleVertical
};

@class XTUserCollectionView;
@protocol XTUserCollectionViewDelegate <NSObject>
-(BOOL)sholdChangeInfo;
@end

@interface XTUserCollectionView : UICollectionView

@property (nonatomic, copy) NSArray *userArray;
@property (nonatomic, assign) BOOL needDelay;
@property (nonatomic, assign) BOOL isArtist;
@property (nonatomic, assign) BOOL isRequesting;
@property (nonatomic, copy) void (^pageNum)(NSString *pageNum);
@property (nonatomic, copy) void (^shouldRefresh)();
@property (nonatomic, weak) id<XTUserCollectionViewDelegate> infoDelegate;

+ (XTUserCollectionView *)userCollectionViewWithPageStyle:(XTUserCollectionViewStyle)pageStyle CellStyle:(XTUserCollectionViewCellStyle)cellStyle buttonStyle:(XTUserCollectionViewCellButtonStyle)buttonStyle;

@end
