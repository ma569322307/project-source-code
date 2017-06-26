//
//  XTBigImageViewCell.m
//  tian
//
//  Created by loong on 15/7/2.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTBigImageViewCell.h"
#import "UIImageView+WebCache.h"
#import "XTOriginImgModel.h"
#import "XTProgressView.h"
@interface XTBigImageViewCell()<UIScrollViewDelegate>

@property (strong, nonatomic) UIImageView *imageView;

@property(nonatomic,strong)UIScrollView *scrollView;

//@property(nonatomic,strong)UIActivityIndicatorView *aiView;

@end


@implementation XTBigImageViewCell



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"rect === %@",NSStringFromCGRect(self.contentView.frame));
        //[self layoutIfNeeded];
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) - 10, CGRectGetHeight(self.frame))];
        
        //self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame));
        
        self.scrollView.backgroundColor = [UIColor clearColor];
        
        self.scrollView.delegate = self;
        self.scrollView.maximumZoomScale=2.0;
        
        self.scrollView.minimumZoomScale=1.0f;
        
        //self.scrollView.backgroundColor = [UIColor cyanColor];
        
        [self addSubview:self.scrollView];
        
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
        
        self.imageView.backgroundColor = [UIColor clearColor];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.imageView.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:self.imageView];
        
        
//        self.aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        
//        self.aiView.center = self.center;
//        //[self.aiView startAnimating];
//        //self.aiView.hidesWhenStopped = YES;
//        self.aiView.backgroundColor = [UIColor magentaColor];
//        [self addSubview:self.aiView];
        

    }
    return self;
}

/*
-(void)setModel:(XTOriginImgModel *)aModel{
    
    _model = aModel;
    NSLog(@"scrollview.frame ==== %@",NSStringFromCGRect(self.scrollView.frame));
    self.scrollView.zoomScale = 1.0f;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) - 10, CGRectGetHeight(self.frame));
    self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    
    BOOL isExists = [imageManager cachedImageExistsForURL:_model.originalPic];
    
    if (isExists){
        [self.imageView sd_setImageWithURL:_model.originalPic placeholderImage:UIIMAGE(@"placeholderImage4.png") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if ([self.delegate respondsToSelector:@selector(scrollActionWithOriginalImg:andCurImg:)]) {
                [self.delegate scrollActionWithOriginalImg:isExists andCurImg:image];
            }
        }];
    }else{
        [self.imageView sd_setImageWithURL:_model.middlePic placeholderImage:UIIMAGE(@"placeholderImage4.png") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if ([self.delegate respondsToSelector:@selector(scrollActionWithOriginalImg:andCurImg:)]) {
                [self.delegate scrollActionWithOriginalImg:isExists andCurImg:image];
            }
        }];
    }
    
}
*/

-(void)configureModel:(XTOriginImgModel *)model andPlaceholderImage:(UIImage *)placeHolderImage{
    
    //[self.aiView startAnimating];

    NSLog(@"scrollview.frame ==== %@",NSStringFromCGRect(self.scrollView.frame));
    self.scrollView.zoomScale = 1.0f;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) - 10, CGRectGetHeight(self.frame));
    self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    
    BOOL isExists = [imageManager cachedImageExistsForURL:model.originalPic];
    
    UIImage *pi = placeHolderImage ? placeHolderImage : UIIMAGE(@"placeholderImage4.png");
    
    
    if (isExists){
        [self.imageView sd_setImageWithURL:model.originalPic placeholderImage:pi completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //[self.aiView stopAnimating];
            if ([self.delegate respondsToSelector:@selector(scrollActionWithOriginalImg:andCurImg:)]) {
                [self.delegate scrollActionWithOriginalImg:isExists andCurImg:image];
            }
        }];
    }else{
        [self.imageView sd_setImageWithURL:model.middlePic placeholderImage:pi completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //[self.aiView stopAnimating];
            if ([self.delegate respondsToSelector:@selector(scrollActionWithOriginalImg:andCurImg:)]) {
                [self.delegate scrollActionWithOriginalImg:isExists andCurImg:image];
            }
        }];
    }

}






-(void)configureOriginalImg:(NSURL *)imgUrl existsBlock:(void(^)())exists{
    
    
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    
    if ([imageManager cachedImageExistsForURL:imgUrl]) {
        NSLog(@"已经下载好了");
        [self.imageView sd_setImageWithURL:imgUrl placeholderImage:nil];
        exists();
        return;
    }
    
    XTProgressView *progressView = [[XTProgressView alloc] initWithViewForShow:self];
    [[SDWebImageManager sharedManager] downloadImageWithURL:imgUrl options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //NSLog(@"receivedSize === %ld  expectedSize ==== %ld",receivedSize,expectedSize);
        
        NSLog(@"receivedSize / expectedSize ==== %f",(CGFloat)receivedSize/expectedSize);
        
        CGFloat percentage = (CGFloat)receivedSize / expectedSize;
        
        if (percentage < 0.01) {
            return;
        }
        
        progressView.progress = percentage;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [progressView hidden];
        if (!image) {
            return ;
        }
        
        self.imageView.image = image;
        exists();
    }];
    
    
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    NSLog(@"scale ＝＝＝＝ %f",scrollView.zoomScale);
    if (scrollView.zoomScale < 1) {
        CGFloat x = -(CGRectGetWidth(scrollView.frame) - (CGRectGetWidth(scrollView.frame) * scrollView.zoomScale))/2;
        CGFloat y = -(CGRectGetHeight(scrollView.frame) - (CGRectGetHeight(scrollView.frame) * scrollView.zoomScale))/2;
        scrollView.contentOffset = CGPointMake(x, y);
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    NSLog(@"view === %@",view);
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    NSLog(@"scrle === %f",scale);
    NSLog(@"scrollview.frame ==== %@",NSStringFromCGRect(self.scrollView.frame));
    if (scale < 1) {
        self.scrollView.zoomScale = 1.0f;
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) - 10, CGRectGetHeight(self.frame));
        self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    }
}



@end

