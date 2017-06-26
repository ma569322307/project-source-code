//
//  UIView+JKPicker.m
//  JKImagePicker
//
//  Created by Jecky on 15/1/11.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import "UIView+JKPicker.h"

@implementation UIView (JKPicker)

- (CGFloat)xtleft {
    return self.frame.origin.x;
}

- (void)setXtleft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)xttop {
    return self.frame.origin.y;
}

- (void)setXttop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)xtright {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setXtright:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)xtbottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setXtbottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)xtcenterX {
    return self.center.x;
}

- (void)setXtcenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)xtcenterY {
    return self.center.y;
}

- (void)setXtcenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)xtwidth {
    return self.frame.size.width;
}

- (void)setXtwidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)xtheight {
    return self.frame.size.height;
}

- (void)setXtheight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)xtorigin {
    return self.frame.origin;
}

- (void)setXtorigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)xtsize {
    return self.frame.size;
}

- (void)setXtsize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end

