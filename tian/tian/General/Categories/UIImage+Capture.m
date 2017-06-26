//
//  UIImage+Capture.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/28.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "UIImage+Capture.h"
#import "UIImage+Size.h"

@implementation UIImage (Capture)
#pragma mark - 拉伸图片
+ (instancetype)resizeImage:(NSString *)imgName
{
    // 根据图片名获取图片
    UIImage *img = [UIImage imageNamed:imgName];
    // 判断是否存在该图片
    if (img == nil) {
        NSLog(@"%s : There is no such image called: “%@”,Please check the image name", __func__, img);
        return nil;
    }
    // 返回可拉伸图片
    return [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
}
#pragma mark - 给图片打水印
+(instancetype)watermarkRingImageWithImageName:(NSString *)imageName andLogoName:(NSString *)logoName
{
    // 获取无水印图片
    UIImage *originalImage = [UIImage imageNamed:imageName];
    // 根据给定的名称判断是否有该图片
    if (originalImage == nil) {
        // 没有就提示检查是否是名称输入错误
        NSLog(@"%s:There is no such image called: “%@” in waterMarkImageWithImageName: method, Please check the image name", __func__, imageName);
        return nil;
    }
    // 获取水印标志
    UIImage *logoImage = [UIImage imageNamed:logoName];
    // 根据给定的名称判断是否有该图片
    if (logoImage == nil) {
        // 没有就提示检查是否是名称输入错误
        NSLog(@"%s:There is no such image called: “%@” in waterMarkImageWithImageName: method, Please check the logo name", __func__,logoName);
        return nil;
    }
    
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, 0.0);
    
    // 添加无水印图片到上下文
    [originalImage drawInRect:CGRectMake(0, 0, originalImage.size.width, originalImage.size.height)];
    
    // 计算水印位置
    CGFloat w = logoImage.size.width * 0.5;
    CGFloat h = logoImage.size.height * 0.5;
    CGFloat x = originalImage.size.width - w;
    CGFloat y = originalImage.size.height - h;
    // 添加水印
    [logoImage drawInRect:CGRectMake(x, y, w, h)];
    
    // 从上下文中获取新图片
    UIImage *waterImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    // 返回结果图片
    return waterImage;
    
}
#pragma mark - 裁减图片成为一个圆图片
+(instancetype)circleImageWithImageName:(NSString *)imageName
{
    // 读取需要裁减的图片
    UIImage *originalImage = [UIImage imageNamed:imageName];
    // 根据给定的名称判断是否有该图片
    if (originalImage == nil) {
        // 没有就提示检查是否是名称输入错误
        NSLog(@"%s:There is no such image called: “%@” in circleImageWithImageName: method, Please check the image name", __func__, imageName);
        return nil;
    }
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, 0.0);
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 设置圆的属性
    CGFloat centerX = originalImage.size.width * 0.5;
    CGFloat centerY = originalImage.size.height * 0.5;
    // 根据长宽中最短的一个的一半作为半径
    CGFloat radius = MIN(originalImage.size.width, originalImage.size.height) * 0.5;
    // 添加圆
    CGContextAddArc(ctx, centerX, centerY, radius, 0, M_PI * 2, 1);
    // 根据圆裁减现在的上下文
    CGContextClip(ctx);
    
    // 在已裁减的上下文基础上添加图片
    [originalImage drawInRect:CGRectMake(0, 0, originalImage.size.width, originalImage.size.height)];
    
    // 获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    // 返回结果图片
    return newImage;
}
#pragma mark - 裁减图片额外加圆环
+(instancetype)circleImageWithImageName:(NSString *)imageName withAdditionalCircle:(CGFloat)circleBorderLength withBorderColor:(UIColor *)borderColor
{
    // 读取需要裁减的图片
    UIImage *originalImage = [UIImage imageNamed:imageName];
    // 根据给定的名称判断是否有该图片
    if (originalImage == nil) {
        // 没有就提示检查是否是名称输入错误
        NSLog(@"%s: There is no such image called: “%@” in circleImageWithImageName:withAdditionalCircle: method, Please check the image name", __func__, imageName);
        return nil;
    }
    // 图片大小
    CGFloat imageWidth = originalImage.size.width;
    CGFloat imageHeight = originalImage.size.height;
    // 计算上下文大小(额外增加额外的长度)
    CGFloat contextWidth = imageWidth + 2 * circleBorderLength;
    CGFloat contextHeight = imageHeight + 2 * circleBorderLength;
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(contextWidth, contextHeight), NO, 0.0);
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 添加大圆用于圆环
    // 设置圆的属性
    CGFloat centerBigX = contextWidth * 0.5;
    CGFloat centerBigY = contextHeight * 0.5;
    // 根据长宽中最短的一个的一半作为半径
    CGFloat radiusBig = MIN(contextWidth, contextHeight) * 0.5;
    // 添加圆
    CGContextAddArc(ctx, centerBigX, centerBigY, radiusBig, 0, M_PI * 2, 1);
    // 设置圆的颜色
    [borderColor setFill];
    // 渲染
    CGContextFillPath(ctx);
    
    // 设置小圆用于裁减
    // 设置圆的属性
    CGFloat centerSmallX = centerBigX;
    CGFloat centerSmallY = centerBigY;
    // 根据长宽中最短的一个的一半作为半径
    CGFloat radiusSmall = MIN(imageWidth, imageHeight) * 0.5;
    // 添加圆
    CGContextAddArc(ctx, centerSmallX, centerSmallY, radiusSmall, 0, M_PI * 2, 1);
    // 裁减小圆
    CGContextClip(ctx);
    
    // 添加图片
    [originalImage drawInRect:CGRectMake(circleBorderLength, circleBorderLength, imageWidth, imageHeight)];
    // 从上下文提取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    // 返回新图片
    return newImage;
}
#pragma mark - 截图
+ (instancetype)captureShotWithView:(UIView *)view
{
    // 判断给的view是否存在
    if (view == nil) {
        NSLog(@"%s: There is no View in captureShotWithView, Please check the view", __func__);
        return nil;
    }
    // 开启图片上下文(根据需要裁减的view给出大小)
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 根据View的图层提取截图(将视图的图层粉刷到上下文)
    [view.layer renderInContext:ctx];
    // 从上下文获取截图图片
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    // 返回截图
    return screenShot;
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
//    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
}

#pragma mark - 截图
+ (instancetype)captureShotWithView:(UIView *)view inRect:(CGRect)rect
{
    // 判断给的view是否存在
    if (view == nil) {
        NSLog(@"%s: There is no View in captureShotWithView, Please check the view", __func__);
        return nil;
    }
    // 开启图片上下文(根据需要裁减的view给出大小)
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 设置裁减区域
    CGContextAddRect(ctx, rect);
    // 裁减区域
    CGContextClip(ctx);
    // 根据View的图层提取截图(将视图的图层粉刷到上下文)
    [view.layer renderInContext:ctx];
    // 从上下文获取截图图片
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    // 返回截图
    return screenShot;
}

- (UIImage*)subImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

- (UIImage*)scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

//缩放图片，并截取中间位置显示
- (UIImage*)scaleImageWithsize:(CGSize )size {
    CGSize imgSize = self.size; //原图大小
    CGSize viewSize = size;          //视图大小
    CGFloat imgwidth = 0;            //缩放后的图片宽度
    CGFloat imgheight = 0;          //缩放后的图片高度
    //视图横长方形及正方形
    if (viewSize.width >= viewSize.height) {
        //缩小
        if (imgSize.width > viewSize.width && imgSize.height > viewSize.height) {
            imgwidth = viewSize.width;
            imgheight = imgSize.height/(imgSize.width/imgwidth);
        }
        //放大
        if(imgSize.width < viewSize.width){
            imgwidth = viewSize.width;
            imgheight = (viewSize.width/imgSize.width)*imgSize.height;
        }
        //判断缩放后的高度是否小于视图高度
        imgheight = imgheight < viewSize.height?viewSize.height:imgheight;
    }
    //视图竖长方形
    if (viewSize.width < viewSize.height) {
        //缩小
        if (imgSize.width > viewSize.width && imgSize.height > viewSize.height) {
            imgheight = viewSize.height;
            imgwidth = imgSize.width/(imgSize.height/imgheight);
        }
        //放大
        if(imgSize.height < viewSize.height){
            imgheight = viewSize.width;
            imgwidth = (viewSize.height/imgSize.height)*imgSize.width;
        }
        //判断缩放后的高度是否小于视图高度
        imgwidth = imgwidth < viewSize.width?viewSize.width:imgwidth;
    }
    //重新绘制图片大小
    UIImage *i;
    UIGraphicsBeginImageContext(CGSizeMake(imgwidth, imgheight));
    [self drawInRect:CGRectMake(0, 0, imgwidth, imgheight)];
    i=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //截取中间部分图片显示
    if (imgwidth > 0) {
        CGImageRef newImageRef = CGImageCreateWithImageInRect(i.CGImage, CGRectMake((imgwidth-viewSize.width)/2, (imgheight-viewSize.height)/2, viewSize.width, viewSize.height));
        return [UIImage imageWithCGImage:newImageRef];
    }else{
        CGImageRef newImageRef = CGImageCreateWithImageInRect(self.CGImage, CGRectMake((imgwidth-viewSize.width)/2, (imgheight-viewSize.height)/2, viewSize.width, viewSize.height));
        return [UIImage imageWithCGImage:newImageRef];
    }
}

- (UIImage *)roundedImageWithRadius:(CGFloat)radius andSize:(CGSize)size{

    UIImage *resultImage = nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [[UIBezierPath bezierPathWithRoundedRect:rect
                                cornerRadius:radius] addClip];
    [self drawInRect:rect];
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+ (UIImage *)mergedImageOnMainImage:(UIImage *)mainImg WithImageArray:(NSArray *)imgArray AndImagePointArray:(NSArray *)imgPointArray {
    @autoreleasepool {
        
        UIGraphicsBeginImageContext(mainImg.size);
        
        [mainImg drawInRect:CGRectMake(0, 0, mainImg.size.width, mainImg.size.height)];
        int i = 0;
        for (UIImage *img in imgArray) {
            [img drawInRect:CGRectMake([[imgPointArray objectAtIndex:i] floatValue],
                                       [[imgPointArray objectAtIndex:i+1] floatValue],
                                       img.size.width,
                                       img.size.height)];
            
            i+=2;
        }
        
        CGImageRef NewMergeImg = CGImageCreateWithImageInRect(UIGraphicsGetImageFromCurrentImageContext().CGImage,
                                                              CGRectMake(0, 0, mainImg.size.width, mainImg.size.height));
        
        UIGraphicsEndImageContext();
        
        
        return [UIImage imageWithCGImage:NewMergeImg];
    }
}

+ (UIImage *)shareOriginImageWithUrl:(NSURL *)imageUrl {
    NSString *sdOriginCacheKey = [NSString stringWithFormat:@"%@",imageUrl.absoluteString];
    NSString *sdScaleOriginCacheKey = [NSString stringWithFormat:@"Origin_%@",imageUrl.absoluteString];
    
    SDImageCache *sdCache = [SDImageCache sharedImageCache];
    UIImage *scaleOriginCacheImage = [sdCache imageFromMemoryCacheForKey:sdScaleOriginCacheKey];
    if(scaleOriginCacheImage) {
        return scaleOriginCacheImage;
    }else {
        UIImage *originCacheImage = [sdCache imageFromMemoryCacheForKey:sdOriginCacheKey];
        return originCacheImage;
    }

}

+ (UIImage *)scaledImageWithUrl:(NSURL *)imageUrl {
    NSString *sdScaleCacheKey = [NSString stringWithFormat:@"Scale_%@",imageUrl.absoluteString];
    SDImageCache *sdCache = [SDImageCache sharedImageCache];
    UIImage *scaleCacheImage = [sdCache imageFromMemoryCacheForKey:sdScaleCacheKey];
    if(scaleCacheImage) {
        return scaleCacheImage;
    }
    return  nil;
}

- (void)scaleImageWithWidth:(CGFloat)width
                   imageUrl:(NSURL *)imageUrl
            completionBlock:(void (^)(UIImage *scaleImage))block {
    
    NSString *sdScaleCacheKey = [NSString stringWithFormat:@"Scale_%@",imageUrl.absoluteString];
    SDImageCache *sdCache = [SDImageCache sharedImageCache];
    UIImage *scaleCacheImage = [sdCache imageFromMemoryCacheForKey:sdScaleCacheKey];
    
    if(scaleCacheImage) {
        if(block) {
            block(scaleCacheImage);
        }
    }else {


            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *resultImage = resultImage = [self scaleImageWithWidth:width];
                [sdCache storeImage:resultImage forKey:sdScaleCacheKey];
                if(block) {
                    block(resultImage);
                }
            });
        
    }

}



@end
