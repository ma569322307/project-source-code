//
//  XTTitleSliderBar.h
//  tian
//	UINavgitionController上的滑动组件
//  Created by sz42c on 15/6/4.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTUnreadCountView.h"
#define XTTitleSliderAnimationTime 0.5

#define XTTitleSliderBarHeight 44.0f

typedef void (^TitleSliderBarSelectedBlock)(NSInteger index);

@interface XTTitleSliderBar : UIView

@property(nonatomic, copy) TitleSliderBarSelectedBlock tilteSliderBarSelectedBlock;

@property (nonatomic, strong)XTUnreadCountView *privateUnreadView;
@property (nonatomic, strong)XTUnreadCountView *messageUnreadView;
@property (nonatomic, strong)XTUnreadCountView *notificationUnreadView;

//通过字符串数组创建SliderBar
- (id)initWIthTitleArray:(NSArray*)titleArray;

//获取当前控件宽度
- (CGFloat)getTitleSliderBarWidth;

//跳到index指定位置
- (void)animationToNext:(NSInteger)index;

//判断是否是动画进行中
- (BOOL)titleSliderBarIsAnimation;

//移动横线
- (void)bottomLineScrollToButtonCenterWith:(float)x;

@end
