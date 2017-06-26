//
//  XTLoveAndCollectCollectionView.h
//  tian
//
//  Created by 刘佳 on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTWaterFallControl.h"

@interface XTLoveAndCollectCollectionView : UICollectionView<XTWaterFallViewControlDelegate>

@property (nonatomic, strong) XTWaterFallControl *waterFallControl;

@property (nonatomic, copy) void (^loadRefreshBlock)();
@property (nonatomic, copy) void (^loadMoreBlock)();
@property (nonatomic, copy) void (^clickCellIndexRowBlock)(NSInteger row);

+ (XTLoveAndCollectCollectionView *)loveAndCollectCollectionViewWithCellType:(XTWaterFallViewCellType)type;

- (void)configureCollectionViewWithArray:(NSArray*)array;

@end