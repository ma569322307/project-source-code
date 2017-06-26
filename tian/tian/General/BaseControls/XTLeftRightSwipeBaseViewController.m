//
//  XTLeftRightSlipBaseViewController.m
//  tian
//
//  Created by 刘佳 on 15/6/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTLeftRightSwipeBaseViewController.h"
#import "XTTitleSliderBar.h"
#import "XTTabBarController.h"

@interface XTLeftRightSwipeBaseViewController ()

@property(nonatomic, assign) BOOL isComeToRefreshLeft; //是否刷新左视图
@property(nonatomic, assign) BOOL isComeToRefreshRight;//是否刷新右视图

@end

@implementation XTLeftRightSwipeBaseViewController

- (void)initMembers
{
    self.leftArray = [NSMutableArray arrayWithCapacity:8];
    self.rightArray = [NSMutableArray arrayWithCapacity:8];
}

- (void)createSubViews
{
    [self addTitleBar];
    
    [self addItems];
    
    if (self.currentSelectTag == tagSelect_item_left) {
        self.isComeToRefreshLeft = NO;
        self.isComeToRefreshRight = YES;
        [self.view addSubview:self.leftCollectionView];
        [self leftBeginRefreshing];
    }else if(self.currentSelectTag == tagSelect_item_right){
        self.isComeToRefreshLeft = YES;
        self.isComeToRefreshRight = NO;
        [self.view addSubview:self.rightCollectionView];
        [self rightBeginRefreshing];
        [self.titleSliderBar animationToNext:tagSelect_item_right];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initMembers];
    
    [self createSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.navigationController setNavigationBarHidden:NO];
    
    XTTabBarController *tabBarCtr = (XTTabBarController *)self.parentViewController.parentViewController;
    [tabBarCtr hideBottomViewWhenPushed];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[self.navigationController setNavigationBarHidden:YES];
}

- (void)addItems
{
    UIImage* img = UIIMAGE(@"na_back_brown");
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:img forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [leftBtn addTarget:self action:@selector(backButtonEvnet:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}

- (void)addTitleBar
{
    NSArray* titleArray = [self titleArray];//@[@"粉丝", @"关注"];
    
    [self addTitleSliderBarByArray:titleArray];
    
    __block XTLeftRightSwipeBaseViewController* _self = self;
    self.titleSliderBar.tilteSliderBarSelectedBlock = ^(NSInteger index) {
        
        if (index > _self.currentSelectTag) {
            [_self changeToSelectView:index];
        } else {
            [_self changeToSelectView:index];
        }
    };
}

- (void)backButtonEvnet:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Gesture
- (void)onSwipeLeftEvent:(UISwipeGestureRecognizer*)gesture
{
    //如果动画没有执行完成返回
    if ([self.titleSliderBar titleSliderBarIsAnimation])
        return;
    
    //如果在最右返回
    if (self.currentSelectTag == tagSelect_item_right)
        return;
    
    NSInteger tag = self.currentSelectTag + 1;
    
    if (tag > tagSelect_item_right)
        tag = tagSelect_item_right;
    
    if (tag == self.currentSelectTag)
        return;
    
    [self changeSelectState:tag];
}

- (void)onSwipeRightEvent:(UISwipeGestureRecognizer*)gesture
{
    //如果动画没有执行完成返回
    if ([self.titleSliderBar titleSliderBarIsAnimation])
        return;
    
    //如果在最左返回
    if (self.currentSelectTag == tagSelect_item_left)
        return;
    
    NSInteger tag = self.currentSelectTag - 1;
    
    if (tag < tagSelect_item_left)
        tag = tagSelect_item_left;
    
    if (tag == self.currentSelectTag)
        return;
    
    [self changeSelectState:tag];
}

#pragma mark 处理滑动或者选择顶部控件时的操作
- (void)changeSelectState:(NSInteger)selectTag
{
    //设置顶部slider位置
    [self.titleSliderBar animationToNext:selectTag];
    
    //切换视图
    [self changeToSelectView:selectTag];
    
}

- (void)changeToSelectView:(NSInteger)selectTag
{
    UIView* curView = nil;
    UIView* selectView = nil;
    
    if (self.currentSelectTag == tagSelect_item_left) {
        curView = self.leftCollectionView;
    } else{
        curView = self.rightCollectionView;
    }
    
    if (selectTag == tagSelect_item_left) {
        
        selectView = self.leftCollectionView;
        
        if (self.isComeToRefreshLeft) {
            
            self.isComeToRefreshLeft = NO;
            
            [self leftBeginRefreshing];
        }
        
    } else {
        
        selectView = self.rightCollectionView;
        
        if (self.isComeToRefreshRight) {
            
            self.isComeToRefreshRight = NO;
            
            [self rightBeginRefreshing];
        }
    }
    
    NSInteger directionFlag = (selectTag > self.currentSelectTag) ? 1 : -1;
    
    //重置当前选中
    self.currentSelectTag = selectTag;
    
    [self.view addSubview:selectView];
    
    CGFloat startY = 0.0f; //起始点
    CGFloat sortH = SCREEN_SIZE.height - 64.0f;
    CGFloat sortW = SCREEN_SIZE.width;
    
    selectView.frame = CGRectMake(sortW*directionFlag, startY, sortW, sortH);
    
    [UIView animateWithDuration:XTTitleSliderAnimationTime animations:^{
        
        selectView.frame = CGRectMake(0, startY, sortW, sortH);
        curView.frame = CGRectMake(-sortW * directionFlag, startY, sortW, sortH);
        
    } completion:^(BOOL finished) {
        
        [curView removeFromSuperview];
    }];
}

#pragma mark
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.leftCollectionView) {
        return self.leftArray == nil ? 0 : [self.leftArray count];
    } else {
        return self.rightArray == nil ? 0 : [self.rightArray count];
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = nil;
    
    if (collectionView == self.leftCollectionView) {
        cell = [self leftCellWith:collectionView indexPath:indexPath];
    } else {
        cell = [self rightCellWith:collectionView indexPath:indexPath];
    }
    
    return cell;
}


#pragma mark 计算用户区域 高度
- (CGFloat)calculateUserAreaHight
{
    return SCREEN_SIZE.height - 64.0f;
}

#pragma mark需要复写的方法
- (NSArray*)titleArray
{
    return @[@"left", @"right"];
}

- (void)leftBeginRefreshing
{
    
}

- (void)rightBeginRefreshing
{
    
}

- (UICollectionView*)leftCollectionView
{
    return nil;
}

- (UICollectionView*)rightCollectionView
{
    return nil;
}

- (UICollectionViewCell*)leftCellWith:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath
{
    return nil;
}

- (UICollectionViewCell*)rightCellWith:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath
{
    return nil;
}
@end
