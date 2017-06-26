//
//  XTImageAnderUserAvatarCollectionViewCell.m
//  tian
//
//  Created by cc on 15/6/10.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTImageAnderUserAvatarCollectionViewCell.h"
#import "XTWaterFallPicInfo.h"
#import "XTCommonMacro.h"
#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>
#import "UIImage+Capture.h"
@implementation XTImageAnderUserAvatarCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    CHANGETOFILLET(self.userAvatarBtn);
}
- (IBAction)clickUserAvatarBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickImgAndUserCellUserAvatarBtn:)]) {
        [self.delegate clickImgAndUserCellUserAvatarBtn:btn.tag];
    }
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath andWithModel:(XTWaterFallPicInfo *)model
{
    NSString *placeholderImageName = [NSString stringWithFormat:@"placeholderImage%ld",indexPath.row%6+1];
    CGFloat itemWidth = CGRectGetWidth(self.bounds);
    //    [self.topImageView sd_setImageWithURL:model.imgUrl placeholderImage:UIIMAGE(placeholderImageName)];
    
    
    [self.userAvatarBtn sd_setBackgroundImageWithURL:model.headImg forState:UIControlStateNormal];
    self.userAvatarBtn.tag = model.userId;
    self.userNameLabel.text = model.name;
    self.descriptionLabel.text = model.comment;
    
    
    NSString *picUrl = [model.imgUrl absoluteString];
    NSString *fileType = [picUrl pathExtension];
    if (model.count>1)
    {
        self.countLabel.hidden = NO;
        self.countLabel.text = [NSString stringWithFormat:@"%ld",model.count];
        if (model.count>=100) {
            _countLabel_layout.constant = 20;
        }else
        {
            _countLabel_layout.constant = 15;
        }
    }else if([[fileType uppercaseString] isEqualToString:@"GIF"])
    {
        self.countLabel.text = @"GIF";
        _countLabel_layout.constant = 20;
    }
    else
    {
        self.countLabel.hidden = YES;
    }
    
    
    if (model.height > 0 && model.width > 0) {
        if (model.height>model.width*1.5) {
            self.constraint_TopImageViewHeight.constant = CGRectGetWidth(self.bounds)*1.5*model.width/model.width;
            self.topImageView.contentMode = UIViewContentModeTop;
            [self.topImageView an_setImageWithURL:model.imgUrl placeholderImage:UIIMAGE(placeholderImageName)  options:SDWebImageRetryFailed | SDWebImageLowPriority /*| SDWebImageProgressiveDownload*/ beforeDisplayed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 
                 CGFloat width = CGRectGetWidth(self.bounds);
                 [image scaleImageWithWidth:width imageUrl:imageURL completionBlock:^(UIImage *scaleImage) {
                     //self.imgPic.image = scaleImage;
                     
                     [self.topImageView setImageWithAnimation:scaleImage withURL:imageURL completedBlock:nil];
                 }];
                 
             }];
            
        }else{
            self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.constraint_TopImageViewHeight.constant = itemWidth * model.height/model.width;
            [self.topImageView an_setImageWithURL:model.imgUrl placeholderImage:UIIMAGE(placeholderImageName) options:SDWebImageRetryFailed];
        }
    }else
    {
        self.constraint_TopImageViewHeight.constant = 200;
    }
    
}

@end
