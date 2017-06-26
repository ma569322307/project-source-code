//
//  XTBaseSwipeViewController.h
//  tian
//	视图滑动基类
//  Created by sz42c on 15/6/11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"

@class XTTitleSliderBar;
@interface XTBaseSwipeViewController : XTRootViewController

@property(nonatomic, strong) XTTitleSliderBar*	titleSliderBar;

- (void)addTitleSliderBarByArray:(NSArray*)titleArray;

@end
