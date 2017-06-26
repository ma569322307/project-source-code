//
//  XTTopicCell.m
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTopicCell.h"
#import "XTHotTopicSetModel.h"
#import "UIImageView+WebCache.h"
#import "XTUserInfo.h"
@interface XTTopicCell()


@property(nonatomic,weak) IBOutlet UIImageView *imgView;

@property(nonatomic,weak) IBOutlet UILabel *titleLabel;

@property(nonatomic,weak) IBOutlet UILabel *contentLabel;

@property(nonatomic,weak) IBOutlet UILabel *scanNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;


@end




@implementation XTTopicCell

- (void)awakeFromNib {
    // Initialization code
    self.avatarImgView.layer.cornerRadius = 11.0f;
    self.avatarImgView.layer.masksToBounds = YES;
}


-(void)configerDataWithModel:(XTHotTopicSetModel *)model andIndex:(NSInteger)index{
    
    [self.imgView an_setImageWithURL:model.image placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"placeholderImage%zd.png",index]]];
    
    self.titleLabel.text = model.title;
    
    self.contentLabel.text = model.des;
    
    self.scanNumLabel.text = [NSString stringWithFormat:@"%@",model.viewCount];
    
    self.nickNameLabel.text = model.user.nickName;
    
    [self.avatarImgView an_setImageWithURL:model.user.bigAvatar placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"placeholderImage%zd.png",index]]];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
