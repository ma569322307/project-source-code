//
//  XTSelectPhotoCollectionViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-6-27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSelectPhotoCollectionViewCell.h"
@interface XTSelectPhotoCollectionViewCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *checkButton;
@end


@implementation XTSelectPhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        self.backgroundColor = [UIColor clearColor];
        [self imageView];
        [self checkButton];
    }
    
    return self;
}

#pragma mark - setter/getter
- (void)setAsset:(NSURL *)asset
{
    __weak XTSelectPhotoCollectionViewCell *wself = self;
//    [wself.imageView sd_setImageWithURL:asset placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [wself.imageView setImage:image];
//        [wself.imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//        [wself.imageView setContentMode:UIViewContentModeScaleAspectFill];
//        [wself.imageView setClipsToBounds:YES];
//        wself.imageView.alpha = 0.0;
//        [UIView animateWithDuration:1.0f animations:^{
//            wself.imageView.alpha = 1.0;
//        }];
//    }];
    [wself.imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    [wself.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [wself.imageView setClipsToBounds:YES];
    [wself.imageView an_setImageWithURL:asset placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        [self.contentView addSubview:_imageView];
        
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.and.right.equalTo(self.contentView);
        }];
    }
    return _imageView;
}

- (UIButton *)checkButton{
    if (!_checkButton) {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img = [UIImage imageNamed:@"upload_check_default"];
        UIImage *imgH = [UIImage imageNamed:@"upload_check_selected"];
        [_checkButton setBackgroundImage:img forState:UIControlStateNormal];
        [_checkButton setBackgroundImage:imgH forState:UIControlStateSelected];
        [_checkButton addTarget:self action:@selector(photoDidChecked)
               forControlEvents:UIControlEventTouchUpInside];
        _checkButton.exclusiveTouch = YES;
        [self.imageView addSubview:_checkButton];
        
        [_checkButton makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(img.size.width);
            make.height.equalTo(img.size.height);
            make.bottom.right.equalTo(self.imageView);
        }];
        
    }
    return _checkButton;
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    self.checkButton.selected = isSelected;
}

- (void)photoDidChecked
{
    if (self.checkButton.selected) {
        if ([_delegate respondsToSelector:@selector(didDeselectItemAssetsViewCell:)]) {
            [_delegate didDeselectItemAssetsViewCell:self];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(didSelectItemAssetsViewCell:)]) {
            [_delegate didSelectItemAssetsViewCell:self];
        }
    }
}

@end
