//
//  XTGuideImageCreateView.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/8.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTSingleSelectionController.h"
#define kGuideImageCreateItemWidth (217.0 * kRation)
#define kGuideImageCreateItemHeight (293.0 * kRation)
#define kGuideImageCreateItemSize CGSizeMake(kGuideImageCreateItemWidth, kGuideImageCreateItemHeight)
@class XTGuideImageCreateView;
@protocol XTGuideImageCreateViewDelegate <NSObject>
//点击了关闭
-(void)guideImageCreateViewClickClose:(XTGuideImageCreateView *)guideImageCreateView;
//正在查看第几个图片
-(void)guideImageCreateView:(XTGuideImageCreateView *)guideImageCreateView showingCellIndex:(NSInteger)index;
@end

@interface XTGuideImageCreateView : UICollectionView
//创建展示
+(instancetype)guideImageCreateView;
@property (nonatomic, weak) id<XTGuideImageCreateViewDelegate> indexDelegate;
@end
