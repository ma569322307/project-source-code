//
//  XTSearchAllCollectionView.h
//  tian
//
//  Created by huhuan on 15/6/23.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTWaterFallControl.h"
@class XTSearchAllModel;

@interface XTSearchAllCollectionView : UICollectionView

@property (nonatomic, strong) XTSearchAllModel *searchAllModel;
@property (nonatomic, strong) XTWaterFallControl *waterFallControl;
@property (nonatomic, copy) void (^loadMore)();

+ (XTSearchAllCollectionView *)searchAllCollectionView;

- (void)configureSearchAllCollectionView;

@end