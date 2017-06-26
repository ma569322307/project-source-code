//
//  SlideCollectionView.h
//  tian
//
//  Created by 曹亚云 on 15-6-5.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTUserHomePageViewController.h"
@class SlideCollectionView;
@protocol SlideCollectionViewDelegate <NSObject>

-(State)SlideCollectionViewCheckState:(SlideCollectionView *)SlideCollectionView;

@end

@interface SlideCollectionView : UICollectionView
@property (nonatomic, assign) State tState;
@property (nonatomic, weak) id<SlideCollectionViewDelegate> stateDelegate;
@end
