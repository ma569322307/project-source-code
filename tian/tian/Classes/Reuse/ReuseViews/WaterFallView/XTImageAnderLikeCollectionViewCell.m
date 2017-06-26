//
//  XTImageAnderLikeCollectionViewCell.m
//  tian
//
//  Created by cc on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTImageAnderLikeCollectionViewCell.h"
#import "XTImageInfo.h"
#import "NSString+TimeReversal.h"
#import "UIImage+Capture.h"
@implementation XTImageAnderLikeCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath andWithModel:(XTImageInfo *)model withCellType:(ImageAnderLikeCollectionViewCellType)type
{
    self.countLabel.hidden = YES;
    
    NSString *placeholderImageName = [NSString stringWithFormat:@"placeholderImage%ld",indexPath.row%6+1];
    CGFloat itemWidth = CGRectGetWidth(self.bounds);
    //    [self.topImageView sd_setImageWithURL:model.url placeholderImage:UIIMAGE(placeholderImageName)];
    
    self.descriptionLabel.text = model.text;
    
    if (model.height > 0 && model.width > 0) {
        if (model.height>model.width*1.5) {
            self.constraint_imageHeight.constant = CGRectGetWidth(self.bounds)*1.5*model.width/model.width;
            self.topImageView.contentMode = UIViewContentModeTop;
            [self.topImageView an_setImageWithURL:model.url placeholderImage:UIIMAGE(placeholderImageName)  options:SDWebImageRetryFailed | SDWebImageLowPriority /*| SDWebImageProgressiveDownload*/ beforeDisplayed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 
                 CGFloat width = CGRectGetWidth(self.bounds);
                 [image scaleImageWithWidth:width imageUrl:imageURL completionBlock:^(UIImage *scaleImage) {
                     //self.imgPic.image = scaleImage;
                     
                     [self.topImageView setImageWithAnimation:scaleImage withURL:imageURL completedBlock:nil];
                 }];
                 
             }];
        }else{
            self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.constraint_imageHeight.constant = itemWidth * model.height/model.width;
            [self.topImageView an_setImageWithURL:model.url placeholderImage:UIIMAGE(placeholderImageName) options:SDWebImageRetryFailed];
        }
    }else
    {
        self.constraint_imageHeight.constant = 200;
    }
    
    NSString *picUrl = [model.url absoluteString];
    NSString *fileType = [picUrl pathExtension];
    if([[fileType uppercaseString] isEqualToString:@"GIF"])
    {
        self.countLabel.hidden = NO;
    }
    
    switch (type) {
        case ImageAnderLikeCollectionView_LikeCellType:
        {
            self.leftIconImageV.image = UIIMAGE(@"like");
            break;
        }
        case ImageAnderLikeCollectionView_CollectionCellType:
        {
            self.leftIconImageV.image = UIIMAGE(@"collect");
            break;
        }
        default:
            break;
    }
    
}
@end
