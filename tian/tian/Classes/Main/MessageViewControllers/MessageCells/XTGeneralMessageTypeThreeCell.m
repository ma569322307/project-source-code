//
//  XTGeneralMessageTypeThreeCell.m
//  tian
//
//  Created by cc on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTGeneralMessageTypeThreeCell.h"
#import "NSString+TimeReversal.h"
#import "XTMessageInfo.h"
#import "XTMessageInfo_awardInfo.h"
@implementation XTGeneralMessageTypeThreeCell

- (void)awakeFromNib {
    // Initialization code
    CHANGETOFILLET(self.userAvatarBtn);
    
    self.rightImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.rightImageView.imageView.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath andWithModel:(XTMessageInfo *)model
{
    if ([model.source isEqualToString:@"award"]) {
        XTMessageInfo_awardInfo *awardInfo = (XTMessageInfo_awardInfo *)model.data;
        
        // self.bottomContentLabel.text =
        self.topContentLabel.text = [NSString stringWithFormat:@"给你打赏了%zd点积分",awardInfo.g];
        
         self.bottomContentLabel.text = [NSString stringWithFormat:@"你获得了%zd点积分及%zd点声望",awardInfo.gc,awardInfo.gr];

        [self.rightImageView sd_setImageWithURL:awardInfo.pic.url forState:UIControlStateNormal];
        self.rightImageView.tag = awardInfo.pic.id;

    }else
    {
    XTImageInfo *imgInfo = (XTImageInfo *)model.data;
   // self.bottomContentLabel.text =
    self.topContentLabel.text = model.content;
    self.bottomContentLabel.text = @"";

    [self.rightImageView sd_setImageWithURL:imgInfo.url forState:UIControlStateNormal];
    self.rightImageView.tag = imgInfo.id;
    }
    [self.userAvatarBtn sd_setBackgroundImageWithURL:model.user.bigAvatar forState:UIControlStateNormal];
    self.userAvatarBtn.tag = model.user.uid;
    self.userName.text = model.user.nickName;
    self.creatTimeLabel.text = [NSString diffTimestampOfPrivateMessageTime:model.createdAt];
    if (model.user.vuser) {
        self.VuserImageView.hidden = NO;
    }else
    {
        self.VuserImageView.hidden = YES;
    }
    
}


- (IBAction)clickUserAvatarBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickXTGeneralMessageTypeThreeCellUserAvatarBtnWithIndexpathRow:)]) {
        [self.delegate clickXTGeneralMessageTypeThreeCellUserAvatarBtnWithIndexpathRow:btn.tag];
    }
}

- (IBAction)clickRightImageViewBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickXTGeneralMessageTypeThreeCellUserAvatarBtnWithIndexpathRow:)]) {
        [self.delegate clickXTGeneralMessageTypeThreeCellRightImageViewBtnWithIndexpathRow:btn.tag];
    }
}
@end
