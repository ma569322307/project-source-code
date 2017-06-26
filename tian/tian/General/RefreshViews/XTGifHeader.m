//
//  XTGifHeader.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/17.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTGifHeader.h"

@interface XTGifHeader ()
@property (weak, nonatomic) UIImageView *gifView;
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;
@property (nonatomic, assign) CGFloat refershY;
@property (nonatomic, strong) NSArray *endPullingImages;
@property (nonatomic, assign) NSInteger indexOfPullingImage;
//放手时候拉拽百分比
@property (nonatomic, assign) CGFloat endPullingPercent;
@end

@implementation XTGifHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=7; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Refresh%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStatePulling];
    [self setImages:@[idleImages[0]] forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Refreshing%zd", i]];
        [refreshingImages addObject:image];
    }
    for (NSUInteger i = 4; i>=2; i--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Refreshing%zd", i]];
        [refreshingImages addObject:image];
    }
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
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
-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.mj_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.mj_h;
    self.refershY = normal2pullingOffsetY;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.mj_h;
    //强行将头留在最顶部
    CGFloat stayY = offsetY > normal2pullingOffsetY? normal2pullingOffsetY : offsetY;
    self.frame = CGRectMake(self.frame.origin.x, stayY, self.frame.size.width, self.frame.size.height);
    // 在刷新的refreshing状态
    if (self.state == MJRefreshStateRefreshing) {
        // sectionheader停留解决
        CGFloat stayY = offsetY > normal2pullingOffsetY + self.mj_h? normal2pullingOffsetY + self.mj_h : offsetY;
        self.frame = CGRectMake(self.frame.origin.x, stayY, self.frame.size.width, self.frame.size.height);
        return;
    }
    
    // 如果是向上滚动到看不见头部控件，直接返回
    if (offsetY >= happenOffsetY) return;
    
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.state == MJRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = MJRefreshStatePulling;
        } else if (self.state == MJRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
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
-(void)scrollViewPanStateDidChange:(NSDictionary *)change{
    NSInteger panState = [change[@"new"] integerValue];
    if (panState == 3) {
        self.endPullingPercent = self.pullingPercent;
        NSLog(@"停止百分比%f",self.endPullingPercent);
    }
}
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.gifView.frame = self.bounds;
    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
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
-(NSArray *)setEndPullingImages{
    if (self.endPullingPercent >= 2.0) {
        return self.endPullingImages;
    }else{
        return @[[UIImage imageNamed:@"Refresh11"]];
    }
}
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    CGFloat animationTime;
    NSArray *deceleratingImages = [self deceleratingImages];
    animationTime = deceleratingImages ? MJRefreshFastAnimationDuration * 2: 0;
    if (state == MJRefreshStateRefreshing && animationTime > 0) {
        NSArray *images = [self setEndPullingImages];
        if (images.count == 0) return;
        
        [self.gifView stopAnimating];
        if (images.count == 1) { // 单张图片
            self.gifView.image = [images lastObject];
            animationTime = 0.1;
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
            self.gifView.image = [UIImage imageNamed:@"Refresh11"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((animationTime + 0.1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *images = self.stateImages[@(state)];
                if (images.count == 0) return;
                
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
    }
}

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
