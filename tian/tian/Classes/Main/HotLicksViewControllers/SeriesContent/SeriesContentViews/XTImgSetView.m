//
//  XTImgSetView.m
//  tian
//
//  Created by loong on 15/7/7.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTImgSetView.h"
#import "XTImgsModel.h"
#import "UIImageView+WebCache.h"
#import "XTCommonMacro.h"
@interface XTImgSetView()

@property(nonatomic,weak)IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation XTImgSetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setArr:(NSArray *)aArr{

    _arr = aArr;
    
    NSInteger count = _arr.count > 2 ? 3 : _arr.count;
    
    
    CGFloat width = ((SCREEN_SIZE.width - 46) - (count - 1)*13) / count;
    CGFloat height = 0;
    if (count == 1) {
        XTImgsModel *model = _arr[0];
        CGFloat percent_w_h = [model.height integerValue] / [model.width integerValue];
        if (percent_w_h > 1.5) {
            height = width * 1.5;
        }else{
            CGFloat scale = width / [model.width integerValue];
            height = scale * [model.height integerValue];
        }
    }else{
        height = width;
    }
    
    UIImageView *imageView = nil;
    
    for (int i = 0; i < _arr.count; i++) {
        XTImgsModel *model = _arr[i];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i % count) * (width + 13), (i / count) * (width + 13), width, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled  = YES;
        imageView.tag  = i;
        
        [imageView sd_setImageWithURL:model.url placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"placeholderImage%zd.png",i+1]] options:SDWebImageRetryFailed |
         SDWebImageLowPriority];
        [self addSubview:imageView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgSetViewTapActionWith:)];
        
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:tap];
        
    }
    self.heightConstraint.constant = CGRectGetMaxY(imageView.frame);
    //self.height = self.heightConstraint.constant = CGRectGetMaxY(imageView.frame);
}

-(void)imgSetViewTapActionWith:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag;
    
    UIImageView *imgView = (UIImageView *)tap.view;
    
    
    CGRect rect = [imgView convertRect:imgView.bounds toView:nil];
    NSLog(@"rect === %@",NSStringFromCGRect(rect));
    
    
    if ([self.delegate respondsToSelector:@selector(imgSetViewTapActionWith:andRect:)]) {
        [self.delegate imgSetViewTapActionWith:index andRect:[NSValue valueWithCGRect:rect]];
    }
}

@end
