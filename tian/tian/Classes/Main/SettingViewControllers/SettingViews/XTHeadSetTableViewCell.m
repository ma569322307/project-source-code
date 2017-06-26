//
//  XTHeadSetTableViewCell.m
//  StarPicture
//
//  Created by 曹亚云 on 15-3-13.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTHeadSetTableViewCell.h"
#import "UIViewAdditions.h"
@implementation XTHeadSetTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.headImageView.layer.cornerRadius = 25;
    self.headImageView.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)clickBtn:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(clickHeadImageBtn:)]) {
        [self.delegate clickHeadImageBtn:button];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
