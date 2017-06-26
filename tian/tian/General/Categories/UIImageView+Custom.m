//
//  UIImageView+Custom.m
//  tian
//
//  Created by loong on 15/7/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "UIImageView+Custom.h"
#import <SDWebImage/SDWebImageManager.h>
#import "UIImage+Capture.h"

@implementation UIImageView (Custom)

static CGRect oldframe;
+ (void)showImage:(UIImageView*)magnifyImageView{
    if (!magnifyImageView.image)
        return;
    
    
    UIImage *image=magnifyImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[magnifyImageView convertRect:magnifyImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}
+ (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

- (void)showHeaderWithUrl:(NSURL *)headerUrl {
    NSString *sdCacheKey = [NSString stringWithFormat:@"sd_%@",headerUrl.absoluteString];
    SDImageCache *sdCache = [SDImageCache sharedImageCache];
    UIImage *cacheImage = [sdCache imageFromMemoryCacheForKey:sdCacheKey];
    if(cacheImage) {
        self.image = cacheImage;
    }else {
        self.image = [UIImage imageNamed:@"HomePage_headImage_default"];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:headerUrl options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if(image){
                UIImage *roundedImage = [image roundedImageWithRadius:image.size.width/2 andSize:CGSizeMake(65., 65.)];
                [sdCache storeImage:roundedImage forKey:sdCacheKey];
                [self setImage:roundedImage];
            }else {
                [self setImage:[UIImage imageNamed:@"HomePage_headImage_default"]];
            }
        }];
    }
}

@end
