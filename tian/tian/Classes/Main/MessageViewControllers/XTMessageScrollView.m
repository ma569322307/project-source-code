//
//  XTMessageScrollView.m
//  tian
//
//  Created by huhuan on 15/7/21.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTMessageScrollView.h"

@implementation XTMessageScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.state != 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
