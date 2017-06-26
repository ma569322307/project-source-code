//
//  XTImageAndDescriptionCollectionViewCell.m
//  tian
//
//  Created by cc on 15/6/10.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTImageAndDescriptionCollectionViewCell.h"
#import "XTWaterFallPicInfo.h"
#import "UIImage+Capture.h"
@interface XTImageAndDescriptionCollectionViewCell ()

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) XTImageInfo *model;

@end

@implementation XTImageAndDescriptionCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath andWithModel:(XTImageInfo *)model
{
    CLog(@"广场图片 URL = %@",model.url);
    self.indexPath = indexPath;
    self.model = model;
    NSString *placeholderImageName = [NSString stringWithFormat:@"placeholderImage%ld",indexPath.row%6+1];
    //    [self.topImageView sd_setImageWithURL:model.url placeholderImage:UIIMAGE(placeholderImageName)];
    
    self.countLabel.hidden = NO;
    self.commentCountLabel.text = model.commentCount;
    self.likeCountLabel.text = model.commendCount;
    self.descriptionHeight.constant = 24;
    self.likeHeight.constant = 24;
    self.bottomView.hidden = NO;
    self.descriptionLabel.hidden = NO;
    self.likeBgView.hidden = NO;
    self.commentCountLabel.hidden = NO;
    self.likeCountLabel.hidden = NO;
    self.commentImg.hidden = NO;
    self.likeImg.hidden = NO;
    
    //去除两端空格和回车
    NSString *ttext = [model.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.descriptionLabel.text = ttext;
    
    BOOL needSpace = YES;
    //没有描述
    if (ttext == nil||ttext.length<1||[ttext isEqualToString:@""])
    {
        self.descriptionLabel.hidden = YES;
        self.descriptionHeight.constant = 0;
        self.likeHeight.constant = 42;
        needSpace = NO;
        
    }
    //没有评论点赞
    if ((([model.commendCount isEqualToString:@"0"]) && ([model.commentCount isEqualToString:@"0"])) || (!model.commendCount && !model.commentCount))
    {
        self.likeBgView.hidden = YES;
        self.descriptionHeight.constant = 42;
        needSpace = NO;
    }
    //都没有
    if (needSpace) {
        
    }
    
    
    NSString *picUrl = [model.url absoluteString];
    NSString *fileType = [picUrl pathExtension];
    if (model.imgCount>1)
    {
        self.countLabel.text = [NSString stringWithFormat:@"%ld",model.imgCount];
        if (model.imgCount>=100) {
            _countLabel_layout.constant = 20;
        }else
        {
            _countLabel_layout.constant = 15;
        }
    }else if([[fileType uppercaseString] isEqualToString:@"GIF"])
    {
        self.countLabel.text = @"GIF";
        _countLabel_layout.constant = 20;
    }else
    {
        self.countLabel.hidden = YES;
    }
    
    if (model.type == 1) {
        self.fancyIconImage.hidden = NO;
    }else
    {
        self.fancyIconImage.hidden = YES;
    }
    
    if (model.height > 0 && model.width > 0) {
        self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
        if (model.height>model.width*1.5) {
            self.constraint_topImageHeight.constant = CGRectGetWidth(self.bounds)*1.5*model.width/model.width;
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
            
            self.constraint_topImageHeight.constant =CGRectGetWidth(self.bounds)*model.height/model.width;
            
            [self.topImageView an_setImageWithURL:model.url placeholderImage:UIIMAGE(placeholderImageName) options:SDWebImageRetryFailed | SDWebImageLowPriority];
        }
    }else
    {
        self.constraint_topImageHeight.constant = 200;
    }
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topImageSingleClick:)];
    singleTap.numberOfTapsRequired = 1;
    [self.topImageView addGestureRecognizer:singleTap];
    
}


- (void)topImageSingleClick:(UIGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCellTopImage:)]) {
        [self.delegate clickCellTopImage:self.indexPath.row];
    }
}

#pragma mark - XHTansitionWaterfallGridViewProtocol

- (UIView *)snapShotForTransition {
    XTImageAndDescriptionCollectionViewCell *cell = (XTImageAndDescriptionCollectionViewCell *)[[NSBundle mainBundle] loadNibNamed:@"XTImageAndDescriptionCollectionViewCell" owner:self options:nil][0];
    cell.frame = self.frame;
    [cell configureCellWithIndexPath:self.indexPath andWithModel:self.model];
    return cell;
}

@end
