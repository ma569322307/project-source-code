//
//  RPViewController.m
//  RoundProgress
//
//  Created by Arun Kumar.P on 20/03/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "SlideTableView.h"

@interface SlideTableView()

@end

@implementation SlideTableView

@synthesize tState;


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if(self.tableViewCellStyle == XTTopicTableViewCellStyleOwn) {
        CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        
        State checkState = kDockDown;
        if ([self.stateDelegate respondsToSelector:@selector(SlideTableViewCheckState:)]) {
            checkState = [self.stateDelegate SlideTableViewCheckState:self];
        }
        
        NSLog(@"shoulde begin++++++++++++++%f,%f,%f,%f",velocity.x,velocity.y,translation.x,translation.y);
        if (velocity.y > 0 && checkState == kDockUp && self.contentOffset.y <= 0) {
            return NO;
        }else if(velocity.y != 0 && checkState == kDockDown && self.contentOffset.y <= 0) {
            return NO;
        }
    }
    
    return YES;
}
@end
