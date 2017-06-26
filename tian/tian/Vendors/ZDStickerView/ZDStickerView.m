//
// ZDStickerView.m
//
// Created by Seonghyun Kim on 5/29/13.
// Copyright (c) 2013 scipi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ZDStickerView.h"
#import "SPGripViewBorderView.h"


#define kSPUserResizableViewGlobalInset 5.0
#define kSPUserResizableViewDefaultMinWidth 48.0
#define kSPUserResizableViewInteractiveBorderSize 10.0
#define kZDStickerViewControlSize 36.0



@interface ZDStickerView ()

@property (nonatomic, strong) SPGripViewBorderView *borderView;

@property (strong, nonatomic) UIImageView *resizingControl;
@property (strong, nonatomic) UIImageView *deleteControl;
@property (strong, nonatomic) UIImageView *customControl;

@property (nonatomic) BOOL preventsLayoutWhileResizing;

@property (nonatomic) CGFloat deltaAngle;
@property (nonatomic) CGPoint prevPoint;
@property (nonatomic) CGAffineTransform startTransform;

@property (nonatomic) CGPoint touchStart;
//@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@end



@implementation ZDStickerView
-(void)whetherHide:(BOOL)hide{
    self.resizingControl.hidden = hide;
    self.deleteControl.hidden = hide;
    self.borderView.hidden = hide;
    [self changeOtherFrame];
    [self setBorderViewBounds];
}

#ifdef ZDSTICKERVIEW_LONGPRESS
- (void)longPress:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidLongPressed:)])
        {
            [self.stickerViewDelegate stickerViewDidLongPressed:self];
        }
    }
}
#endif


- (void)singleTap:(UIPanGestureRecognizer *)recognizer
{
    
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidClose:)])
    {
        [self.stickerViewDelegate stickerViewDidClose:self];
    }
    
    if (NO == self.preventsDeleting)
    {
        UIView *close = (UIView *)[recognizer view];
        [close.superview removeFromSuperview];
    }
}



- (void)customTap:(UIPanGestureRecognizer *)recognizer
{
    if (NO == self.preventsCustomButton)
    {
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidCustomButtonTap:)])
        {
            [self.stickerViewDelegate stickerViewDidCustomButtonTap:self];
        }
    }
}



- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        
        
        [self enableTransluceny:YES];
        self.prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        // 发放开始的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kStickerViewBeginMovingNotification object:nil];
        
        [self enableTransluceny:YES];
        
        // preventing from the picture being shrinked too far by resizing
        if (self.bounds.size.width < self.minWidth || self.bounds.size.height < self.minHeight)
        {
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     self.bounds.size.width+1,
                                     self.bounds.size.height+1);
            self.resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                                   self.bounds.size.height-kZDStickerViewControlSize,
                                                   kZDStickerViewControlSize,
                                                   kZDStickerViewControlSize);
            self.deleteControl.frame = CGRectMake(0, 0,
                                                  kZDStickerViewControlSize, kZDStickerViewControlSize);
            self.customControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                                 0,
                                                 kZDStickerViewControlSize,
                                                 kZDStickerViewControlSize);
            self.prevPoint = [recognizer locationInView:self];
        }
        // Resizing
        else
        {
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0, hChange = 0.0;
            
            wChange = (point.x - self.prevPoint.x);
            float wRatioChange = (wChange/(float)self.bounds.size.width);
            
            if (self.isKeepHeight) {
                hChange = 0.0;
            }else{
                hChange = wRatioChange * self.bounds.size.height;
            }
            
            if (ABS(wChange) > 50.0f || ABS(hChange) > 50.0f)
            {
                self.prevPoint = [recognizer locationOfTouch:0 inView:self];
                return;
            }
            
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                     self.bounds.size.width + (wChange),
                                     self.bounds.size.height + (hChange));
//            self.resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
//                                                   self.bounds.size.height-kZDStickerViewControlSize,
//                                                   kZDStickerViewControlSize, kZDStickerViewControlSize);
//            self.deleteControl.frame = CGRectMake(0, 0,
//                                                  kZDStickerViewControlSize, kZDStickerViewControlSize);
//            self.customControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
//                                                 0,
//                                                 kZDStickerViewControlSize,
//                                                 kZDStickerViewControlSize);
            [self changeOtherFrame];
            self.prevPoint = [recognizer locationOfTouch:0 inView:self];
            
        }
        
        /* Rotation */
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x);
        
        float angleDiff = self.deltaAngle - ang;
        
        if (NO == self.preventsResizing)
        {
            self.transform = CGAffineTransformMakeRotation(-angleDiff);
        }
        
//        self.borderView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset);
//        [self.borderView setNeedsDisplay];
//        
//        [self setNeedsDisplay];
        [self setBorderViewBounds];
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded || [recognizer state] == UIGestureRecognizerStateCancelled || [recognizer state] == UIGestureRecognizerStateFailed)
    {
        // 发放结束通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kStickerViewEndMovingNotification object:nil];
        
        [self enableTransluceny:NO];
        self.prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
}

-(void)changeOtherFrame{
    self.resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                           self.bounds.size.height-kZDStickerViewControlSize,
                                           kZDStickerViewControlSize, kZDStickerViewControlSize);
    self.deleteControl.frame = CGRectMake(0, 0,
                                          kZDStickerViewControlSize, kZDStickerViewControlSize);
    self.customControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                         0,
                                         kZDStickerViewControlSize,
                                         kZDStickerViewControlSize);
}

-(void)setBorderViewBounds{
    self.borderView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset);
    [self.borderView setNeedsDisplay];
    
    [self setNeedsDisplay];
}
- (void)setupDefaultAttributes
{
    self.borderView = [[SPGripViewBorderView alloc] initWithFrame:CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset)];
    [self.borderView setHidden:YES];
    [self addSubview:self.borderView];
    
    if (kSPUserResizableViewDefaultMinWidth > self.bounds.size.width*0.5)
    {
        self.minWidth = kSPUserResizableViewDefaultMinWidth;
        self.minHeight = self.bounds.size.height * (kSPUserResizableViewDefaultMinWidth/self.bounds.size.width);
    }
    else
    {
        self.minWidth = self.bounds.size.width*0.5;
        self.minHeight = self.bounds.size.height*0.5;
    }
    
    if (self.isKeepHeight) {
        self.minWidth = 100;
        self.minHeight = 40;
    }
    
    
    self.preventsPositionOutsideSuperview = YES;
    self.preventsLayoutWhileResizing = YES;
    self.preventsResizing = NO;
    self.preventsDeleting = NO;
    self.preventsCustomButton = YES;
    self.translucencySticker = YES;
    
#ifdef ZDSTICKERVIEW_LONGPRESS
    UILongPressGestureRecognizer*longpress = [[UILongPressGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(longPress:)];
    [self addGestureRecognizer:longpress];
#endif
    
    self.deleteControl = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                                      kZDStickerViewControlSize, kZDStickerViewControlSize)];
    self.deleteControl.backgroundColor = [UIColor clearColor];
    self.deleteControl.image = [UIImage imageNamed:@"upload_close"];
    self.deleteControl.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(singleTap:)];
    [self.deleteControl addGestureRecognizer:singleTap];
    [self addSubview:self.deleteControl];
    
    self.resizingControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-kZDStickerViewControlSize,
                                                                        self.frame.size.height-kZDStickerViewControlSize,
                                                                        kZDStickerViewControlSize, kZDStickerViewControlSize)];
    self.resizingControl.backgroundColor = [UIColor clearColor];
    self.resizingControl.userInteractionEnabled = YES;
    self.resizingControl.image = [UIImage imageNamed:@"upload_adjust"];
    UIPanGestureRecognizer*panResizeGesture = [[UIPanGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(resizeTranslate:)];
    [self.resizingControl addGestureRecognizer:panResizeGesture];
    [self addSubview:self.resizingControl];
    
    self.customControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-kZDStickerViewControlSize,
                                                                      0,
                                                                      kZDStickerViewControlSize, kZDStickerViewControlSize)];
    self.customControl.backgroundColor = [UIColor clearColor];
    self.customControl.userInteractionEnabled = YES;
    self.customControl.image = nil;
    UITapGestureRecognizer *customTapGesture = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(customTap:)];
    [self.customControl addGestureRecognizer:customTapGesture];
    [self addSubview:self.customControl];
    
    self.deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                            self.frame.origin.x+self.frame.size.width - self.center.x);
}



- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setupDefaultAttributes];
//        [self addGestureRecognizer:self.pan];
        
    }
    
    return self;
}



- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setupDefaultAttributes];
    }
    
    return self;
}



- (void)setContentView:(UIView *)newContentView
{
    [self.contentView removeFromSuperview];
    _contentView = newContentView;
    
    self.contentView.frame = CGRectInset(self.bounds,
                                         kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2,
                                         kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:self.contentView];
    
    for (UIView *subview in [self.contentView subviews])
    {
        [subview setFrame:CGRectMake(0, 0,
                                     self.contentView.frame.size.width,
                                     self.contentView.frame.size.height)];
        
        subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    [self bringSubviewToFront:self.borderView];
    [self bringSubviewToFront:self.resizingControl];
    [self bringSubviewToFront:self.deleteControl];
    [self bringSubviewToFront:self.customControl];
}



- (void)setFrame:(CGRect)newFrame
{
    [super setFrame:newFrame];
    self.contentView.frame = CGRectInset(self.bounds,
                                         kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2,
                                         kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    for (UIView *subview in [self.contentView subviews])
    {
        [subview setFrame:CGRectMake(0, 0,
                                     self.contentView.frame.size.width,
                                     self.contentView.frame.size.height)];
        
        subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    self.borderView.frame = CGRectInset(self.bounds,
                                        kSPUserResizableViewGlobalInset,
                                        kSPUserResizableViewGlobalInset);
    
    self.resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                           self.bounds.size.height-kZDStickerViewControlSize,
                                           kZDStickerViewControlSize,
                                           kZDStickerViewControlSize);
    
    self.deleteControl.frame = CGRectMake(0, 0,
                                          kZDStickerViewControlSize, kZDStickerViewControlSize);
    
    self.customControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                         0,
                                         kZDStickerViewControlSize,
                                         kZDStickerViewControlSize);
    
    [self.borderView setNeedsDisplay];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self whetherHide:NO];
    
    if ([self isEditingHandlesHidden])
    {
        return;
    }
    
    [self enableTransluceny:YES];
    
    UITouch *touch = [touches anyObject];
    self.touchStart = [touch locationInView:self.superview];
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidBeginEditing:)])
    {
        [self.stickerViewDelegate stickerViewDidBeginEditing:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 发放结束通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kStickerViewEndMovingNotification object:nil];
    
    [self enableTransluceny:NO];
    
    // Notify the delegate we've ended our editing session.
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidEndEditing:)])
    {
        [self.stickerViewDelegate stickerViewDidEndEditing:self];
    }
}



- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"MovingCancelled");
    // 发放结束通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kStickerViewEndMovingNotification object:nil];
    
    [self enableTransluceny:NO];
    
    // Notify the delegate we've ended our editing session.
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidCancelEditing:)])
    {
        [self.stickerViewDelegate stickerViewDidCancelEditing:self];
    }
}



- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - self.touchStart.x,
                                    self.center.y + touchPoint.y - self.touchStart.y);
    
    if (self.preventsPositionOutsideSuperview)
    {
        // Ensure the translation won't cause the view to move offscreen.
        CGFloat midPointX = CGRectGetMidX(self.bounds);
        if (newCenter.x > self.superview.bounds.size.width - midPointX)
        {
            newCenter.x = self.superview.bounds.size.width - midPointX;
        }
        
        if (newCenter.x < midPointX)
        {
            newCenter.x = midPointX;
        }
        
        CGFloat midPointY = CGRectGetMidY(self.bounds);
        if (newCenter.y > self.superview.bounds.size.height - midPointY)
        {
            newCenter.y = self.superview.bounds.size.height - midPointY;
        }
        
        if (newCenter.y < midPointY)
        {
            newCenter.y = midPointY;
        }
    }
    if (![self checkContinueMoveWithNewCenter:newCenter]) {
        return;
    }
    self.center = newCenter;
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 开始移动通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kStickerViewBeginMovingNotification object:nil];
    
    if ([self isEditingHandlesHidden])
    {
        return;
    }
    
    [self enableTransluceny:YES];
    
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.resizingControl.frame, touchLocation))
    {
        return;
    }
    
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    [self translateUsingTouchLocation:touch];
    self.touchStart = touch;
}



- (void)hideDelHandle
{
    self.deleteControl.hidden = YES;
}



- (void)showDelHandle
{
    self.deleteControl.hidden = NO;
}



- (void)hideEditingHandles
{
    self.resizingControl.hidden = YES;
    self.deleteControl.hidden = YES;
    self.customControl.hidden = YES;
    [self.borderView setHidden:YES];
}



- (void)showEditingHandles
{
    if (NO == self.preventsCustomButton)
    {
        self.customControl.hidden = NO;
    }
    else
    {
        self.customControl.hidden = YES;
    }
    
    if (NO == self.preventsDeleting)
    {
        self.deleteControl.hidden = NO;
    }
    else
    {
        self.deleteControl.hidden = YES;
    }
    
    if (NO == self.preventsResizing)
    {
        self.resizingControl.hidden = NO;
    }
    else
    {
        self.resizingControl.hidden = YES;
    }
    
    [self.borderView setHidden:NO];
}



- (void)showCustomHandle
{
    self.customControl.hidden = NO;
}



- (void)hideCustomHandle
{
    self.customControl.hidden = YES;
}



- (void)setButton:(ZDSTICKERVIEW_BUTTONS)type image:(UIImage*)image
{
    switch (type)
    {
        case ZDSTICKERVIEW_BUTTON_RESIZE:
            self.resizingControl.image = image;
            break;
        case ZDSTICKERVIEW_BUTTON_DEL:
            self.deleteControl.image = image;
            break;
        case ZDSTICKERVIEW_BUTTON_CUSTOM:
            self.customControl.image = image;
            break;
            
        default:
            break;
    }
}



- (BOOL)isEditingHandlesHidden
{
    return self.borderView.hidden;
}



- (void)enableTransluceny:(BOOL)state
{
    if (self.translucencySticker == YES)
    {
        if (state == YES)
        {
            self.alpha = 0.65;
        }
        else
        {
            self.alpha = 1.0;
        }
    }
}
//- (void)moving:(UIPanGestureRecognizer *)pan{
//    if (pan.state == UIGestureRecognizerStateBegan) {
//        [self whetherHide:NO];
//        
//        if ([self isEditingHandlesHidden])
//        {
//            return;
//        }
//        
//        [self enableTransluceny:YES];
//        
////        UITouch *touch = [touches anyObject];
//        self.touchStart = [pan locationInView:self.superview];
//        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidBeginEditing:)])
//        {
//            [self.stickerViewDelegate stickerViewDidBeginEditing:self];
//        }
//        return;
//    }
//    if (pan.state == UIGestureRecognizerStateChanged) {
//        // 开始移动通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:kStickerViewBeginMovingNotification object:nil];
//        
//        if ([self isEditingHandlesHidden])
//        {
//            return;
//        }
//        
//        [self enableTransluceny:YES];
//        
//        //        CGPoint touchLocation = [[touches anyObject] locationInView:self];
//        CGPoint touchLocation = [pan locationInView:self];
//        if (CGRectContainsPoint(self.resizingControl.frame, touchLocation))
//        {
//            return;
//        }
//        
//        //        CGPoint touch = [[touches anyObject] locationInView:self.superview];
//        CGPoint touch = [pan locationInView:self.superview];
//        [self translateUsingTouchLocation:touch];
//        self.touchStart = touch;
//        return;
//    }
//    if (pan.state == UIGestureRecognizerStateCancelled) {
//        // 发放结束通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:kStickerViewEndMovingNotification object:nil];
//        
//        [self enableTransluceny:NO];
//        
//        // Notify the delegate we've ended our editing session.
//        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidCancelEditing:)])
//        {
//            [self.stickerViewDelegate stickerViewDidCancelEditing:self];
//        }
//        return;
//    }
//    if (pan.state == UIGestureRecognizerStateEnded) {
//        // 发放结束通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:kStickerViewEndMovingNotification object:nil];
//        
//        [self enableTransluceny:NO];
//        
//        // Notify the delegate we've ended our editing session.
//        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidCancelEditing:)])
//        {
//            [self.stickerViewDelegate stickerViewDidCancelEditing:self];
//        }
//        return;
//    }
//}

-(BOOL)checkContinueMoveWithNewCenter:(CGPoint)newCenter{
    CGPoint center = newCenter;
    CGRect superFrame = self.superview.bounds;
    return CGRectContainsPoint(superFrame, center);
}
#pragma mark 懒加载
//-(UIPanGestureRecognizer *)pan
//{
//    if (_pan == nil) {
//        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moving:)];;
//    }
//    return _pan;
//}

@end
