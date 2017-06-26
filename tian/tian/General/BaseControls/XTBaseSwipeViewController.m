//
//  XTBaseSwipeViewController.m
//  tian
//	视图滑动基类
//  Created by sz42c on 15/6/11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTBaseSwipeViewController.h"
#import "XTTitleSliderBar.h"

@interface XTBaseSwipeViewController ()<UIGestureRecognizerDelegate>

@end

@implementation XTBaseSwipeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self addSwipeGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)addTitleSliderBarByArray:(NSArray*)titleArray
{
	self.titleSliderBar = [[XTTitleSliderBar alloc] initWIthTitleArray:titleArray];
	CGFloat width = [self.titleSliderBar getTitleSliderBarWidth];
	[self.titleSliderBar setFrame:CGRectMake(0, 0, width, XTTitleSliderBarHeight)];
	
	self.navigationItem.titleView = self.titleSliderBar;
}

#pragma mark 增加左右滑动手势
- (void)addSwipeGestureRecognizer
{
	UISwipeGestureRecognizer* swipeRecog = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeLeftEvent:)];
	swipeRecog.cancelsTouchesInView = YES;
	[swipeRecog setDirection:UISwipeGestureRecognizerDirectionLeft];
	swipeRecog.delegate = self;
	[self.view addGestureRecognizer:swipeRecog];
	
	swipeRecog = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeRightEvent:)];
	[swipeRecog setDirection:(UISwipeGestureRecognizerDirectionRight)];
	swipeRecog.delegate = self;
	[self.view addGestureRecognizer:swipeRecog];
}

- (void)onSwipeLeftEvent:(UISwipeGestureRecognizer*)gesture
{
	//子类视图覆盖此方法
}

- (void)onSwipeRightEvent:(UISwipeGestureRecognizer*)gesture
{
	//子类视图覆盖此方法
}
@end
