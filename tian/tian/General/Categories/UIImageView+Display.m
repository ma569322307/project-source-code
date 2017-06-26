//
//  UIImageView+Display.m
//  tian
//
//  Created by Jiajun Zheng on 15/8/7.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "UIImageView+Display.h"

@implementation UIImageView (Display)
- (void)an_setImageWithURL:(NSURL *)url{
    [self an_setImageWithURL:url placeholderImage:nil options:0 completed:nil];
}
- (void)an_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    [self an_setImageWithURL:url placeholderImage:placeholder options:0 completed:nil];
}

- (void)an_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage  options:(SDWebImageOptions)options{
    [self an_setImageWithURL:url placeholderImage:placeholderImage options:options completed:nil];
}
- (void)an_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage  options:(SDWebImageOptions)options beforeDisplayed:(SDWebImageCompletionBlock)beforeDisplayBlock{
    [self an_setImageWithURL:url placeholderImage:placeholderImage options:options beforeDisplayed:beforeDisplayBlock completed:nil];
}

- (void)an_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage  options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock{
    [self an_setImageWithURL:url placeholderImage:placeholderImage options:options beforeDisplayed:nil completed:completedBlock];
}

- (void)an_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage  options:(SDWebImageOptions)options beforeDisplayed:(SDWebImageCompletionBlock)beforeBlock completed:(SDWebImageCompletionBlock)completedBlock{
    if ([url isKindOfClass:NSString.class]) {
        url = [NSURL URLWithString:(NSString *)url];
    }
    
    // Prevents app crashing on argument type error like sending NSNull instead of NSURL
    if (![url isKindOfClass:NSURL.class]) {
        url = nil;
    }
    
    if ([self isCachedWithURL:url]) {
        [self sd_setImageWithURL:url];
        UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:url.absoluteString];
        if (beforeBlock) {
            beforeBlock(image,nil,0,url);
        }else {
            if (completedBlock) {
                completedBlock(image,nil,0,url);
            }
        }
        return;
    }
    
    [self sd_setImageWithURL:url placeholderImage:placeholderImage options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    
    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (beforeBlock) {
            beforeBlock(image,error,cacheType,imageURL);
        }else{
            [self setImageWithAnimation:image withURL:nil completedBlock:^{
                if (completedBlock) {
                    completedBlock(image,error,cacheType,imageURL);
                }
            }];
        }
    }];

}
-(void)setImageWithAnimation:(UIImage *)image withURL:(NSURL *)url completedBlock:(void(^)())completedBlock{
    [self setImage:image];
    if ([self isCachedWithURL:url]) {
        if (completedBlock) {
            completedBlock();
        }
        return;
    }
    self.alpha = 0.0;
    [UIView animateWithDuration:1.0f
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         if (completedBlock) {
                             completedBlock();
                         }
                     }];
//    if (completedBlock) {
//        completedBlock();
//    }
}
-(BOOL)isCachedWithURL:(NSURL *)url{
    if (url == nil) {
        return NO;
    }
    BOOL result = [[SDWebImageManager sharedManager].imageCache diskImageExistsWithKey:url.absoluteString];
    NSLog(@"%zd",result);
    return [[SDWebImageManager sharedManager].imageCache diskImageExistsWithKey:url.absoluteString];
}
@end
