//
//  XTGeneralMessageTypeOneCell.m
//  tian
//
//  Created by cc on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTGeneralMessageTypeOneCell.h"
#import "NSString+TimeReversal.h"
#import "XTMessageInfo.h"
#import <UIButton+WebCache.h>
#define XTUserAvatarHeight 35
#define XTUserAvatarSpace 4
@implementation XTGeneralMessageTypeOneCell

- (void)awakeFromNib {
    // Initialization code
    self.topicBtn.layer.cornerRadius = 8;
    self.topicBtn.layer.masksToBounds = YES;
    self.topicBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 4);
    
    self.rightBtnImage.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.rightBtnImage.imageView.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addUserListBtnWith:(NSArray *)userlistArray
{
    NSInteger cou = userlistArray.count>5?5:userlistArray.count;
    
    for (int i=0; i<cou; i++) {
        XTUserInfo *uInfo = [userlistArray objectAtIndex:i];
        UIButton *userAvatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        userAvatarBtn.frame = CGRectMake(i*(XTUserAvatarHeight + XTUserAvatarSpace), 0, XTUserAvatarHeight, XTUserAvatarHeight);
        [userAvatarBtn sd_setBackgroundImageWithURL:uInfo.smallAvatar forState:UIControlStateNormal];
        [userAvatarBtn addTarget:self action:@selector(clickUserAvatarBtn:) forControlEvents:UIControlEventTouchUpInside];
        userAvatarBtn.tag = uInfo.uid;
        CHANGETOFILLET(userAvatarBtn);
        
        [self.userAvatarBgView addSubview:userAvatarBtn];
        if (uInfo.vuser) {
            UIImageView *vuserImageV = [[UIImageView alloc]initWithFrame:CGRectMake(userAvatarBtn.frame.origin.x + CGRectGetWidth(userAvatarBtn.frame)-12,userAvatarBtn.frame.origin.y+ CGRectGetHeight(userAvatarBtn.frame)-12, 12, 12)];
            vuserImageV.image = [UIImage imageNamed:@"HomePage_V"];
            [self.userAvatarBgView addSubview:vuserImageV];
            
        }
        
    }
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath andWithModel:(XTMessageInfo *)model
{
    self.rightBtnImage.hidden = NO;
    self.topicBtn.hidden = NO;
    self.creatTimeLabel.hidden = NO;
    for (UIView *v in self.userAvatarBgView.subviews) {
        [v removeFromSuperview];
    }
    
    
    if ([model.source isEqualToString:@"picCommend"]) {
        XTMessageInfo_picCommendInfo *picCommendinfo = (XTMessageInfo_picCommendInfo *)model.data;
        
        [self addUserListBtnWith:picCommendinfo.userList];
        self.userCountLabel.text =[NSString stringWithFormat:@"共%zd位用户",picCommendinfo.userCount];
      //  [self.rightBtnImage sd_setBackgroundImageWithURL:picCommendinfo.pic.url forState:UIControlStateNormal];
        [self.rightBtnImage sd_setImageWithURL:picCommendinfo.pic.url forState:UIControlStateNormal];
        self.rightBtnImage.tag = indexPath.row;
        self.topicBtn.hidden = YES;
    }else if ([model.source isEqualToString:@"follow"])
    {
        XTMessageInfo_followInfo *followInfo = (XTMessageInfo_followInfo*)model.data;
        
        [self addUserListBtnWith:followInfo.userList];
        self.userCountLabel.text =[NSString stringWithFormat:@"共%zd位用户",followInfo.userCount];
        self.creatTimeLabel.hidden = YES;
        self.rightBtnImage.hidden = YES;
        self.topicBtn.hidden = YES;
        
    }else if ([model.source isEqualToString:@"postCommend"])
    {
        XTMessageInfo_postCommendInfo *postCommendInfo = (XTMessageInfo_postCommendInfo *)model.data;
        
        [self addUserListBtnWith:postCommendInfo.userList];
        self.userCountLabel.text =[NSString stringWithFormat:@"共%zd位用户",postCommendInfo.userCount];
//        [self.rightBtnImage sd_setBackgroundImageWithURL:postCommendInfo.post.imageUrl forState:UIControlStateNormal];
        
        [self.rightBtnImage sd_setImageWithURL:postCommendInfo.post.imageUrl forState:UIControlStateNormal];
        self.rightBtnImage.tag = indexPath.row;
        self.topicBtn.hidden = NO;
        [self.topicBtn setTitle:[NSString stringWithFormat:@"#%@#",postCommendInfo.post.title] forState:UIControlStateNormal];
        self.topicBtn.tag = indexPath.row;
    }
    
    self.contentLabel.text = model.content;
    self.creatTimeLabel.text = [NSString diffTimestampOfPrivateMessageTime:model.createdAt];

    
}
- (void)clickUserAvatarBtn:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickGeneralMessageCellUserAvatarBtnWithIndexRow:)]) {
        [self.delegate clickGeneralMessageCellUserAvatarBtnWithIndexRow:sender.tag];
    }
}
- (IBAction)clickRightImageBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickGeneralMessageCellImageViewWithindex:)]) {
        [self.delegate clickGeneralMessageCellImageViewWithindex:btn.tag];
    }
}

- (IBAction)clickTopicBtn:(id)sender {
    UIButton *topicBtn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCellTopicBtnWithIndexRow:)]) {
        [self.delegate clickCellTopicBtnWithIndexRow:topicBtn.tag];
    }
    CLog(@"点击了cell上得话题");
}
@end
