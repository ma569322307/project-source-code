//
//  XTNotificationMessageCell.m
//  tian
//
//  Created by cc on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTNotificationMessageCell.h"
#import "NSString+TimeReversal.h"
#import "XTMessageInfo.h"
@implementation XTNotificationMessageCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    CHANGETOFILLET(self.userAvatarBtn);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBgView:)];
    
    [self.bgView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath andWithModel:(XTMessageInfo *)model
{
//    [self.userAvatarBtn sd_setBackgroundImageWithURL:model.user.smallAvatar forState:UIControlStateNormal];
//    self.userAvatarBtn.tag = indexPath.row;
//    self.userNameLabel.text = model.user.nickName;
    self.descriptionLabel.text = model.content;
    self.creatTimeLabel.text = [NSString diffTimestampOfPrivateMessageTime:model.createdAt];
    self.bgView.tag = indexPath.row;
}

- (void)clickBgView:(UIGestureRecognizer *)ges
{
    UIView * view = ges.view;
    NSInteger viewTag = view.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickNotificationMessageCellBgViewWithIndexpathRow:)]) {
        [self.delegate clickNotificationMessageCellBgViewWithIndexpathRow:viewTag];
    }
    
}
- (IBAction)clickUserAvatarBtn:(id)sender {
    
    UIButton * btn = (UIButton *)sender;
    NSInteger viewTag = btn.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickNotificationMessageCellUserAvatarBtnWithIndexpathRow:)]) {
        [self.delegate clickNotificationMessageCellUserAvatarBtnWithIndexpathRow:viewTag];
    }
}
@end
