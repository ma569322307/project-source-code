//
//  XTMyTopicHeaderCell.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTMyTopicHeaderCell.h"

@interface XTMyTopicHeaderCell ()
@property (weak, nonatomic) IBOutlet UIButton *headerView;

@end

@implementation XTMyTopicHeaderCell

- (void)awakeFromNib {
    // Initialization code
}
// 发送通知，让控制器做图片选择
- (IBAction)headerClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:kHeaderClickNotification object:nil];
}
// 设置图片
-(void)setHeaderImage:(UIImage *)headerImage{
    _headerImage = headerImage;
    // 如果没有图片，使用默认图片
    if (_headerImage) {
        [self.headerView setImage:headerImage forState:UIControlStateNormal];
    }else{
        [self.headerView setImage:[UIImage imageNamed:@"MyTopicAddPhoto"] forState:UIControlStateNormal];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
