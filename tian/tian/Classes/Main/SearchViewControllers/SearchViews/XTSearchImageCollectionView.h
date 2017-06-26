//
//  XTSearchImageCollectionView.h
//  tian
//
//  Created by huhuan on 15/6/17.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTWaterFallControl.h"

@interface XTSearchImageCollectionView : UICollectionView

@property (nonatomic, copy) NSArray *imageArray;
@property (nonatomic, strong) XTWaterFallControl *waterFallControl;
@property (nonatomic, copy) void (^loadMore)();

+ (XTSearchImageCollectionView *)imageCollectionView;

- (void)reloadCollectView;

@end
