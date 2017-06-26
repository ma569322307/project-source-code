//
//  SlideCollectionView.m
//  tian
//
//  Created by 曹亚云 on 15-6-5.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "SlideCollectionView.h"

@implementation SlideCollectionView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
    CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
    State checkState = kDockDown;
    if ([self.stateDelegate respondsToSelector:@selector(SlideCollectionViewCheckState:)]) {
        checkState = [self.stateDelegate SlideCollectionViewCheckState:self];
    }
    
    NSLog(@"shoulde begin++++++++++++++%f,%f,%f,%f",velocity.x,velocity.y,translation.x,translation.y);
    if (velocity.y > 0 && checkState == kDockUp && self.contentOffset.y <= 0) {
        return NO;
    }else if(velocity.y != 0 && checkState == kDockDown && self.contentOffset.y <= 0) {
        return NO;
    }
    
    return YES;
}

@end
