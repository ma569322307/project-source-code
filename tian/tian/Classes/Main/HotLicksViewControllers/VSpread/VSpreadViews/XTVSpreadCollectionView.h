//
//  XTVSpreadCollectionView.h
//  tian
//
//  Created by huhuan on 15/7/7.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTWaterFallControl.h"
@class XTHotLicksCommonArtistInfo;

@interface XTVSpreadCollectionView : UICollectionView

@property (nonatomic, strong) XTWaterFallControl *waterFallControl;
@property (nonatomic, copy) void (^loadMore)();

+ (XTVSpreadCollectionView *)spreadCollectionView;

- (void)configureSpreadCollectionViewWithCommonArtistInfo:(XTHotLicksCommonArtistInfo *)artistInfo;

@end
