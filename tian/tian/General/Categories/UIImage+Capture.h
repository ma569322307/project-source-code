//
//  UIImage+Capture.h
//  tian
//
//  Created by Jiajun Zheng on 15/6/28.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Capture)
/**
 *  拉伸图片不变形
 *
 *  @param imgName 原始图片名称
 *
 *  @return 新的可拉伸图片
 */
+ (instancetype)resizeImage:(NSString *)imgName;
/**
 *  给图片合成为新的有水印的图片
 *
 *  @param imageName 需要添加水印的图片名称
 *  @param logoName  水印图片名称
 *
 *  @return 有水印的新图片
 */
+ (instancetype)watermarkRingImageWithImageName:(NSString *)imageName andLogoName:(NSString *)logoName;
/**
 *  根据给定的图片的大小给出最合适的圆形裁减图片
 *
 *  @param imageName 需要裁减的图片的名称
 *
 *  @return 新的裁减完的图片
 */
+ (instancetype)circleImageWithImageName:(NSString *)imageName;
/**
 *  裁减圆图像并且增加一个圆环
 *
 *  @param imageName          需裁减的图片名称
 *  @param circleBorderLength 外圆环的长度
 *  @param borderColor        外圆环颜色
 *
 *  @return 裁减完的图片
 */
+(instancetype)circleImageWithImageName:(NSString *)imageName withAdditionalCircle:(CGFloat)circleBorderLength withBorderColor:(UIColor *)borderColor;
/**
 *  截取给定的View的内容（截图）
 *
 *  @param view 需要截图的View
 *
 *  @return 截好的图片
 */
+(instancetype)captureShotWithView:(UIView *)view;
+ (instancetype)captureShotWithView:(UIView *)view inRect:(CGRect)rect;

//拼接图片
+ (UIImage *)mergedImageOnMainImage:(UIImage *)mainImg WithImageArray:(NSArray *)imgArray AndImagePointArray:(NSArray *)imgPointArray;

/**
 *  裁剪图片
 */
- (UIImage *)subImage:(CGRect)rect;

/**
 *  等比缩放
 */
- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *)scaleImageWithsize:(CGSize)size;

//给图片加圆角
- (UIImage *)roundedImageWithRadius:(CGFloat)radius andSize:(CGSize)size;

/**
 *  等比缩放图片，并缓存
 */
- (void)scaleImageWithWidth:(CGFloat)width
                   imageUrl:(NSURL *)imageUrl
            completionBlock:(void (^)(UIImage *scaleImage))block;

+ (UIImage *)shareOriginImageWithUrl:(NSURL *)imageUrl;

/**
 *  获取被裁图片，如果未被裁 则返回nil
 */
+ (UIImage *)scaledImageWithUrl:(NSURL *)imageUrl;

@end
