//
//  UIImage+rn_Blur.h
//  YYT_iPhone
//
//  Created by ShangYi.Yang on 14-10-14.
//  Copyright (c) 2014年 YinYueTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (rn_Blur)
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
- (UIImage *)imageFromColor:(UIColor *)color;

@end
