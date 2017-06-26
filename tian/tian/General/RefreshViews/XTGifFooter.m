//
//  XTGifFooter.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/21.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTGifFooter.h"

@interface XTGifFooter ()
@property (weak, nonatomic) UIImageView *gifView;
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;
@property (nonatomic, assign) NSInteger indexOfPullingImage;
@property (nonatomic, strong) NSArray *endPullingImages;
@end

@implementation XTGifFooter
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=7; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"RefreshUp%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStatePulling];
    [self setImages:@[idleImages[0]] forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"RefreshingUp%zd", i]];
        [refreshingImages addObject:image];
    }
    for (NSUInteger i = 4; i>=2; i--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"RefreshingUp%zd", i]];
        [refreshingImages addObject:image];
    }
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    self.stateLabel.hidden = YES;
}
#pragma mark - 懒加载
- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

- (NSMutableDictionary *)stateImages
{
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

#pragma mark - 公共方法
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state
{
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) {
        self.mj_h = image.size.height;
    }
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state
{
    [self setImages:images duration:images.count * 0.1 forState:state];
}

#pragma mark - 实现父类的方法
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    if (self.scrollView.isDragging) {
        pullingPercent = pullingPercent - 1;
        NSArray *images = self.stateImages[@(MJRefreshStatePulling)];
        if (self.state == MJRefreshStateIdle || images.count == 0) return;
        // 停止动画
        [self.gifView stopAnimating];
        // 设置当前需要显示的图片
        NSUInteger index =  images.count * pullingPercent;
        if (index >= images.count) index = images.count - 1;
        self.gifView.image = images[index];
        self.indexOfPullingImage = index;
    }
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.gifView.frame = self.bounds;
    if (self.stateLabel.hidden) {
        self.gifView.contentMode = UIViewContentModeCenter;
    } else {
        self.gifView.contentMode = UIViewContentModeRight;
        self.gifView.mj_w = self.mj_w * 0.5 - 90;
    }
}

-(NSArray *)deceleratingImages{
    if (self.indexOfPullingImage == 0) {
        return nil;
    }
    NSMutableArray *deceleratingImages = [NSMutableArray array];
    return deceleratingImages.copy;
}
#pragma mark - 实现父类的方法
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.mj_offsetY;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY + self.mj_h;
    CGFloat delta = self.scrollView.frame.size.height;
    //强行将头留在最底部
    CGFloat stayY = currentOffsetY < normal2pullingOffsetY? normal2pullingOffsetY + delta: currentOffsetY + delta;
    // 如果正在刷新，直接返回
    if (self.state == MJRefreshStateRefreshing)
    {
        CGFloat stayY = currentOffsetY < normal2pullingOffsetY - self.mj_h? normal2pullingOffsetY + delta: currentOffsetY + delta;
        if ([self.scrollView isKindOfClass:[UITableView class]]) {
            self.frame = CGRectMake(self.frame.origin.x, stayY - self.mj_h, self.frame.size.width, self.frame.size.height);
        }else
        {
//            self.frame = CGRectMake(self.frame.origin.x, stayY - self.mj_h, self.frame.size.width, self.frame.size.height);
        }
        return;
    }
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        self.frame = CGRectMake(self.frame.origin.x, stayY - self.mj_h, self.frame.size.width, self.frame.size.height);
    }else{
//        self.frame = CGRectMake(self.frame.origin.x, stayY - self.mj_h, self.frame.size.width, self.frame.size.height);
    }
    _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) return;
    
    CGFloat pullingPercent = (currentOffsetY - happenOffsetY) / self.mj_h;
    
    // 如果已全部加载，仅设置pullingPercent，然后返回
    if (self.state == MJRefreshStateNoMoreData) {
        self.pullingPercent = pullingPercent;
        return;
    }
    
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        
        if (self.state == MJRefreshStateIdle && currentOffsetY > normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = MJRefreshStatePulling;
        } else if (self.state == MJRefreshStatePulling && currentOffsetY <= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = MJRefreshStateIdle;
        }
    } else if (self.state == MJRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}
//
//- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
//    [super scrollViewContentSizeDidChange:change];
////    NSLog(@"scrollViewContentSizeDidChange%@",change);
//}
//- (void)scrollViewContentInsetDidChange:(NSDictionary *)change{
//    [super scrollViewContentInsetDidChange:change];
////    NSLog(@"scrollViewContentInsetDidChange%@",change);
//}
//- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
//    [super scrollViewPanStateDidChange:change];
//    NSLog(@"手势状态改变%@",change);
//}
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    CGFloat animationTime;
    NSArray *deceleratingImages = [self deceleratingImages];
    animationTime = deceleratingImages ? MJRefreshFastAnimationDuration * 2: 0;
    if (state == MJRefreshStateRefreshing && animationTime > 0) {
        NSArray *images = self.endPullingImages;
        if (images.count == 0) return;
        
        [self.gifView stopAnimating];
        if (images.count == 1) { // 单张图片
            self.gifView.image = [images lastObject];
        } else { // 多张图片
            self.gifView.animationImages = images;
            self.gifView.animationDuration = images.count * 0.1;
            [self.gifView startAnimating];
            animationTime = self.gifView.animationDuration - 0.1;
        }
    }
    // 根据状态做事情
    if (state == MJRefreshStateRefreshing) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.gifView stopAnimating];
            self.gifView.image = [UIImage imageNamed:@"RefreshUp11"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((animationTime + 0.1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *images = self.stateImages[@(state)];
                if (images.count == 0) return;
                
                self.gifView.hidden = NO;
                [self.gifView stopAnimating];
                if (images.count == 1) { // 单张图片
                    self.gifView.image = [images lastObject];
                } else { // 多张图片
                    self.gifView.animationImages = images;
                    self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
                    [self.gifView startAnimating];
                }

            });
        });
    }else if (state == MJRefreshStateIdle) {
        self.gifView.hidden = NO;
    } else if (state == MJRefreshStateNoMoreData) {
        self.gifView.hidden = YES;
    }
}
#pragma mark - 私有方法
#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.y
- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}

- (NSInteger)totalDataCountInScrollView
{
    NSInteger totalCount = 0;
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.scrollView;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self.scrollView;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}
#pragma mark 懒加载
-(NSArray *)endPullingImages{
    if (_endPullingImages == nil) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSUInteger i = 7; i<=11; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Refresh%zd", i]];
            [arrayM addObject:image];
        }
        _endPullingImages = arrayM.copy;
    }
    return _endPullingImages;
}
@end
