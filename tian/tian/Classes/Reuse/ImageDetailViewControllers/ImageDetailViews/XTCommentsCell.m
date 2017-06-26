//
//  XTImgCommentsCell.m
//  tian
//
//  Created by loong on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTCommentsCell.h"
#import "UIImageView+WebCache.h"
#import "XTCommentItemModel.h"
#import "XTUserInfo.h"
#import "XTSeriesContentStore.h"
#import "Define.h"
#import "NSString+TimeReversal.h"
#import "NSString+AttributedString.h"
#import "XTUserStore.h"
#import "XTAvatarView.h"
@interface XTCommentsCell()


@property (weak, nonatomic) IBOutlet XTAvatarView *avatarView;


@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;


@property (weak, nonatomic) IBOutlet UIButton *commendBtn;

@property (nonatomic,strong)XTCommentItemModel *model;

@property (weak, nonatomic) IBOutlet UILabel *commendCountLabel;

@end



@implementation XTCommentsCell

- (void)awakeFromNib {
    self.levelLabel.layer.cornerRadius = 6.0f;
    self.levelLabel.layer.masksToBounds = YES;

    
    UITapGestureRecognizer *avatarImgViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImgViewTapGesture:)];
    [self.avatarView addGestureRecognizer:avatarImgViewTap];
    
}

-(void)congfigurateDataWithModel:(XTCommentItemModel *)model{
    self.model = model;
    
    if (self.model.supported) {
        self.commendCountLabel.textColor = RGBA(253, 229, 13, 1);
        
    }else{
        self.commendCountLabel.textColor = [UIColor grayColor];
    }
    
    self.commendBtn.selected  = self.model.supported;
    
    //[self.avatarImgView sd_setImageWithURL:self.model.user.smallAvatar placeholderImage:UIIMAGE(@"placeholderImage4.png")];
    
    self.avatarView.avatarUrl = self.model.user.smallAvatar;
    
    self.avatarView.is_V_User = self.model.user.vuser;
    
    self.userNameLabel.text = self.model.user.nickName;
    
    self.levelLabel.text = [NSString stringWithFormat:@"  lv%ld  ",self.model.user.level];
    
    NSString *time = [NSString diffTimestamp:[self.model.createdAt doubleValue]];
    
    self.createdAtLabel.text = time;
    
    
    if (self.model.originalCommentNickName) {
        NSString *text = [NSString stringWithFormat:@"回复%@:%@",self.model.originalCommentNickName,self.model.text];
        self.commentLabel.attributedText = [text attributedStringWithSpecificString:self.model.originalCommentNickName];
    }else{
        self.commentLabel.text = self.model.text;
    }

    NSInteger commendCount = [self.model.commendCount integerValue];
    
    if (commendCount == 0) {
        self.commendCountLabel.text = @"";
    }else{
        self.commendCountLabel.text = [self.model.commendCount stringValue];
    }
}

-(void)congfigurateDataWithSeriesContentModel:(XTCommentItemModel *)model{
    self.model = model;
    
    if (self.model.supported) {
        self.commendCountLabel.textColor = RGBA(253, 229, 13, 1);
        
    }else{
        self.commendCountLabel.textColor = [UIColor grayColor];
    }
    self.commendBtn.selected  = self.model.supported;
    
    //[self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:self.model.headImg]];
    self.avatarView.avatarUrl = [NSURL URLWithString:self.model.headImg];
    self.avatarView.is_V_User = self.model.vuser;
    
    self.userNameLabel.text = self.model.userName;
    self.levelLabel.text = [NSString stringWithFormat:@"  lv%@  ", @(self.model.level)];
    
    NSString *createTime = [NSString diffTimestamp:[self.model.createdAt longLongValue]];
    self.createdAtLabel.text = createTime;
    
    self.commentLabel.text = self.model.text;
    
    NSInteger commendCount = [self.model.totalSupports integerValue];
    
    if (commendCount == 0) {
        self.commendCountLabel.text = @"";
    }else{
        self.commendCountLabel.text = [self.model.totalSupports stringValue];
    }

}


- (IBAction)commendBtnClick:(UIButton *)sender {
    if (!sender.selected) {
        if ([self.delegate respondsToSelector:@selector(commentCommendActionWith:)]) {
            [self.delegate commentCommendActionWith:self.index];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(cancelCommentCommendActionWith:)]) {
            [self.delegate cancelCommentCommendActionWith:self.index];
        }
    }
    sender.selected = !sender.selected;

}

-(void)avatarImgViewTapGesture:(UITapGestureRecognizer *)tap{
    XTUserAccountInfo *userAccountInfo = [XTUserStore sharedManager].user;
    
    XTUserInfo *userInfo = self.model.user;
    
    if (userInfo.uid == [userAccountInfo.userID integerValue]) {
        return;
    }
    
    
    if (self.model.userId == [userAccountInfo.userID integerValue]) {
        return;
    }
    
    id obj = userInfo ? userInfo : @(self.model.userId);

    if ([self.controllerDelegate respondsToSelector:@selector(tapAvatarImgViewActionWith:)]) {
        [self.controllerDelegate tapAvatarImgViewActionWith:obj];
        return;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
