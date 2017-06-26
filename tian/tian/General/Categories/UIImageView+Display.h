//
//  UIImageView+Display.h
//  tian
//
//  Created by Jiajun Zheng on 15/8/7.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIImageView (Display)
- (void)an_setImageWithURL:(NSURL *)url;
- (void)an_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)an_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage  options:(SDWebImageOptions)options;
- (void)an_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage  options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;
- (void)an_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage  options:(SDWebImageOptions)options beforeDisplayed:(SDWebImageCompletionBlock)beforeBlock;
- (void)an_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage  options:(SDWebImageOptions)options beforeDisplayed:(SDWebImageCompletionBlock)beforeBlock completed:(SDWebImageCompletionBlock)completedBlock;
// 动画方法
-(void)setImageWithAnimation:(UIImage *)image withURL:(NSURL *)url completedBlock:(void(^)())completedBlock;
@end
