//
//  XTSpecificPictureTableViewCell.m
//  tian
//
//  Created by huhuan on 15/7/6.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSpecificPictureTableViewCell.h"
#import "XTImageInfo.h"

@interface XTSpecificPictureTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *contentImageView;
@property (nonatomic, weak) IBOutlet UIImageView *gifIcon;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentImageViewHeightConstraint;

@end

@implementation XTSpecificPictureTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureCell:(XTImageInfo *)imageInfo {
    
    int i = arc4random() % 6+1 ;
    NSString *placeholderImageName = [NSString stringWithFormat:@"placeholderImage%@",@(i)];
    
    [self.contentImageView an_setImageWithURL:imageInfo.url placeholderImage:[UIImage imageNamed:placeholderImageName]];
    self.contentLabel.text = imageInfo.text;
    
    if([imageInfo.url.absoluteString hasSuffix:@".gif"]) {
        self.gifIcon.hidden = NO;
    }else {
        self.gifIcon.hidden = YES;
    }
    
    float imageHeight = imageInfo.height/imageInfo.width*(SCREEN_SIZE.width-20);
    float maxImageHeight = (SCREEN_SIZE.width-20)*1.5;
    
    if(imageHeight<maxImageHeight) {
        self.contentImageViewHeightConstraint.constant = imageHeight;
    }else {
        self.contentImageViewHeightConstraint.constant = maxImageHeight;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
