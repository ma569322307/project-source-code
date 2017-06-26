//
//  XTGeneralMessageTypeTwoCell.m
//  tian
//
//  Created by cc on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTGeneralMessageTypeTwoCell.h"
#import "NSString+TimeReversal.h"
#import "XTMessageInfo.h"
@implementation XTGeneralMessageTypeTwoCell

- (void)awakeFromNib {
    // Initialization code
    CHANGETOFILLET(self.userAvatarBtn);
    self.topicBtn.layer.cornerRadius = 8;
    self.topicBtn.layer.masksToBounds = YES;
    self.topicBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 4);
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
    self.commentBtn.tag = indexPath.row;
    self.imgCountLabel.hidden = YES;
    self.topicBtn.hidden = YES;
    if ([model.source isEqualToString:@"postComment"]) {
        self.descriptionLabel.text = @"评论了你的话题";
        XTMessageInfo_postCommentInfo *postCommentinfo = (XTMessageInfo_postCommentInfo *)model.data;
        self.topicBtn.hidden = NO;
        [self.topicBtn setTitle:[NSString stringWithFormat:@"#%@#",postCommentinfo.topic.title] forState:UIControlStateNormal];
        self.topicBtn.tag = indexPath.row;
        XTImageInfo *firstImgInfo = [postCommentinfo.images firstObject];
        [self.rightImageView sd_setImageWithURL:firstImgInfo.url forState:UIControlStateNormal];
        self.rightImageView.tag = indexPath.row;
        if (postCommentinfo.images.count>1) {
            self.imgCountLabel.hidden = NO;
            self.imgCountLabel.text = [NSString stringWithFormat:@" %zd ",postCommentinfo.images.count];
        }
        
        [self.userAvatarBtn sd_setBackgroundImageWithURL:model.user.smallAvatar forState:UIControlStateNormal];
        self.userAvatarBtn.tag = model.user.uid;
        self.userNameLabel.text = model.user.nickName;
        if (model.user.vuser) {
            self.VuserImageView.hidden = NO;
        }else
        {
            self.VuserImageView.hidden = YES;
        }
    }else if ([model.source isEqualToString:@"picComment"]) {
        self.descriptionLabel.text = @"评论了你的图片";
        XTImageInfo *imgInfo = (XTImageInfo *)model.data;
        

        [self.rightImageView sd_setImageWithURL:imgInfo.middlePic forState:UIControlStateNormal];
        self.rightImageView.tag = indexPath.row;
        
        [self.userAvatarBtn sd_setBackgroundImageWithURL:model.user.smallAvatar forState:UIControlStateNormal];
        self.userAvatarBtn.tag = model.user.uid;
        self.userNameLabel.text = model.user.nickName;
        if (model.user.vuser) {
            self.VuserImageView.hidden = NO;
        }else
        {
            self.VuserImageView.hidden = YES;
        }

    }

    
    self.contentLabel.text = model.content;
    self.cteatTimeLabel.text = [NSString diffTimestampOfPrivateMessageTime:model.createdAt];
    
}

- (IBAction)clickTopicBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickGeneralMessageTypeTwoCellTopicBtnWithIndexpthRow:)])
    {
        [self.delegate clickGeneralMessageTypeTwoCellTopicBtnWithIndexpthRow:btn.tag];
    }
}

- (IBAction)clickUserAvatarBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickGeneralMessageTypeTwoCellUserAvatarBtnWithIndexpthRow:)])
    {
        [self.delegate clickGeneralMessageTypeTwoCellUserAvatarBtnWithIndexpthRow:btn.tag];
    }
}

- (IBAction)clickCommentBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickGeneralMessageTypeTwoCellUserAvatarBtnWithIndexpthRow:)])
    {
        [self.delegate clickGeneralMessageTypeTwoCellCommentBtnWithIndexpthRow:btn.tag];
    }
}

- (IBAction)clickRightImageViewBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickGeneralMessageTypeTwoCellUserAvatarBtnWithIndexpthRow:)])
    {
        [self.delegate clickGeneralMessageTypeTwoCellRightImageViewBtnWithIndexpthRow:btn.tag];
    }
}
@end
