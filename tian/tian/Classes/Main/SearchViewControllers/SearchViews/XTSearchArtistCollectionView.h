//
//  XTSearchArtistCollectionView.h
//  tian
//
//  Created by huhuan on 15/6/23.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTWaterFallControl.h"
@class XTSearchArtistModel;

@interface XTSearchArtistCollectionView : UICollectionView

@property (nonatomic, strong) XTSearchArtistModel *artistModel;
@property (nonatomic, strong) XTWaterFallControl *waterFallControl;
@property (nonatomic, copy) void (^loadMore)();

+ (XTSearchArtistCollectionView *)searchArtistCollectionView;

- (void)configureSearchArtistCollectionView;

@end
