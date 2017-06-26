//
//  UIImageView+Custom.h
//  tian
//
//  Created by loong on 15/7/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Custom)

+ (void)showImage:(UIImageView*)magnifyImageView;

- (void)showHeaderWithUrl:(NSURL *)headerUrl;

@end
