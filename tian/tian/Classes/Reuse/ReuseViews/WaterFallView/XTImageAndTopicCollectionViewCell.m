//
//  XTImageAndTopicCollectionViewCell.m
//  tian
//
//  Created by cc on 15/6/9.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTImageAndTopicCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "UIImage+Capture.h"
@interface XTImageAndTopicCollectionViewCell ()

@property (nonatomic, strong) NSIndexPath *cellIndexPath;

@end

@implementation XTImageAndTopicCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)clickTopicBtn:(id)sender {
    UIButton * btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCellOfTopicBtn:)]) {
        [self.delegate clickCellOfTopicBtn:btn.tag];
    }
}

- (void)topImageSingleClick:(UIGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCellTopImage:)]) {
        [self.delegate clickCellTopImage:self.cellIndexPath.row];
    }
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath andWithModel:(XTWaterFallPicInfo *)model
{
    self.cellIndexPath = indexPath;
    NSString *placeholderImageName = [NSString stringWithFormat:@"placeholderImage%zd",indexPath.row%6+1];
    XTImageInfo *imgInfo = [model.images firstObject];
    //    [self.topImageView sd_setImageWithURL:imgInfo.url placeholderImage:UIIMAGE(placeholderImageName)];
    
    [self.topicBtn setTitle:[NSString stringWithFormat:@"#%@#",model.topic.title] forState:UIControlStateNormal];
    self.topicBtn.tag = indexPath.row;
    if (imgInfo.width > 0 && imgInfo.height > 0) {
        if (imgInfo.height>imgInfo.width*1.5) {
            self.constraint_imageHeight.constant = CGRectGetWidth(self.bounds)*1.5*imgInfo.width/imgInfo.width;
            self.topImageView.contentMode = UIViewContentModeTop;
            
            [self.topImageView an_setImageWithURL:imgInfo.url placeholderImage:UIIMAGE(placeholderImageName)  options:SDWebImageRetryFailed | SDWebImageLowPriority /*| SDWebImageProgressiveDownload*/ beforeDisplayed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 
                 CGFloat width = CGRectGetWidth(self.bounds);
                 [image scaleImageWithWidth:width imageUrl:imageURL completionBlock:^(UIImage *scaleImage) {
                     //self.imgPic.image = scaleImage;
                     
                     [self.topImageView setImageWithAnimation:scaleImage withURL:imageURL completedBlock:nil];
                 }];
                 
             }];
        }else{
            self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.constraint_imageHeight.constant = CGRectGetWidth(self.bounds)*imgInfo.height/imgInfo.width;
            [self.topImageView an_setImageWithURL:imgInfo.url placeholderImage:UIIMAGE(placeholderImageName) options:SDWebImageRetryFailed | SDWebImageLowPriority];
        }
        
    }else
    {
        self.constraint_imageHeight.constant = 200;
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topImageSingleClick:)];
    singleTap.numberOfTapsRequired = 1;
    [self.topImageView addGestureRecognizer:singleTap];
    
}
@end
