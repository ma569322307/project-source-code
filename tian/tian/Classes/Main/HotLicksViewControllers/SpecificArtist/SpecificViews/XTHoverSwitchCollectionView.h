//
//  XTSpecificArtistSwitchCollectionView.h
//  tian
//
//  Created by huhuan on 15/7/2.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTTapCollectionView.h"
@class XTHotLicksCommonArtistInfo;
@class XTCommentsModel;

@interface XTHoverSwitchCollectionView : XTTapCollectionView

@property (nonatomic, copy  ) NSString                   *belongId;
@property (nonatomic, strong) XTHotLicksCommonArtistInfo *artistInfo;
@property (nonatomic, copy  ) XTCommentsModel            *commentInfo;

@property (nonatomic, copy  ) void (^pageChangeBlock)(NSInteger index);
@property (nonatomic, copy  ) void (^basicTableViewLoadMore)();
@property (nonatomic, copy  ) void (^commentTableViewLoadMore)();
@property (nonatomic, strong) NSLayoutConstraint *headerOriginYConstraint;

+ (XTHoverSwitchCollectionView *)hoverSwitchCollectionViewWithHeaderHeight:(float)height andHeaderView:(UIView *)headerView;

- (void)switchCollectViewToIndex:(NSInteger)index;
- (void)configureSwitchCollectionView;

- (void)refreshBasicTableViewIsLastLoad:(BOOL)isLastLoad;
- (void)refreshCommentTableViewIsLastLoad:(BOOL)isLastLoad;

@end
