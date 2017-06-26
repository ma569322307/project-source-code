//
//  UIImage+Size.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/28.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "UIImage+Size.h"

@implementation UIImage (Size)
-(UIImage *)scaleImageWithWidth:(CGFloat)width{
    CGSize size = [self scaleSizeWithWidth:width];
    // 开启图形上下文
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    return result;
}
-(UIImage *)scaleImageWithHeight:(CGFloat)height{
    CGSize size = [self scaleSizeWithHeight:height];
    // 开启图形上下文
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    return result;
}

-(CGSize)scaleSizeWithWidth:(CGFloat)width{
    CGFloat scale = self.size.width / self.size.height;
    return CGSizeMake(width, width / scale);
}
-(CGSize)scaleSizeWithHeight:(CGFloat)height{
    CGFloat scale = self.size.width / self.size.height;
    return CGSizeMake(height * scale, height);
}
@end
