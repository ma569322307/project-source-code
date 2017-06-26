//
//  UIImage+Size.h
//  tian
//
//  Created by Jiajun Zheng on 15/6/28.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Size)
/// 根据指定的宽高缩放图片
-(UIImage *)scaleImageWithWidth:(CGFloat)width;
-(UIImage *)scaleImageWithHeight:(CGFloat)height;
@end
