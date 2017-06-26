//
//  XTTopicIndexTableViewCell.m
//  tian
//
//  Created by huhuan on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTopicIndexTableViewCell.h"
#import "XTTopicInfo.h"
#import "XTImageInfo.h"
#import "NSString+TextSize.h"
#import "UIImage+Capture.h"
#import "NSString+TimeReversal.h"
#import "XTUserHomePageViewController.h"
#import "XTUserStore.h"

@interface XTTopicIndexTableViewCell ()

@property (nonatomic, weak  ) IBOutlet UIView      *bgView;
@property (nonatomic, weak  ) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak  ) IBOutlet UIImageView *vIconImageView;
@property (nonatomic, weak  ) IBOutlet UILabel     *nameLabel;
@property (nonatomic, weak  ) IBOutlet UILabel     *levelLabel;

@property (nonatomic, weak  ) IBOutlet UIView      *topicBgView;
@property (nonatomic, weak  ) IBOutlet UIImageView *topicImageView;
@property (nonatomic, weak  ) IBOutlet UILabel     *titleLabel;
@property (nonatomic, weak  ) IBOutlet UILabel     *descLabel;
@property (nonatomic, weak  ) IBOutlet UILabel     *statusLabel;
@property (nonatomic, weak  ) IBOutlet UILabel     *timeLabel;
@property (nonatomic, weak  ) IBOutlet UIView      *seperatorLine;

@property (nonatomic, strong) XTTopicInfo *topicModel;

@end

@implementation XTTopicIndexTableViewCell

- (void)awakeFromNib {
    [self layoutCell];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2;
    
    self.levelLabel.layer.masksToBounds = YES;
    self.levelLabel.layer.cornerRadius = 6.f;
}

- (void)configureCell:(XTTopicInfo *)topicModel{
    
    self.topicModel = topicModel;
    [self.headerImageView an_setImageWithURL:topicModel.user.bigAvatar];
    self.nameLabel.text = topicModel.user.nickName;
    self.levelLabel.text = [NSString stringWithFormat:@"lv%@", @(topicModel.user.level)];
    
    if(topicModel.user.vuser) {
        self.vIconImageView.hidden = NO;
    }else {
        self.vIconImageView.hidden = YES;
    }
    
    NSString *createTime = [NSString diffTimestamp:topicModel.created];
    self.timeLabel.text = createTime;
    
    self.statusLabel.text =topicModel.topicDescription;
    
    if([topicModel.type length] > 0) {
        NSString *descStr = topicModel.topicDescription;
        if ([topicModel.type isEqualToString:@"favorite"]) {
            descStr = @"收藏了话题";
        }else if ([topicModel.type isEqualToString:@"post"]) {
            descStr = @"参与了话题";
        }else if ([topicModel.type isEqualToString:@"topic"]) {
            descStr = @"发布了话题";
        }
        self.statusLabel.text = descStr;
    }
    
    int i = arc4random() % 6+1 ;
    NSString *placeholderImageName = [NSString stringWithFormat:@"placeholderImage%@",@(i)];
    
    [self.topicImageView an_setImageWithURL:topicModel.imageUrl placeholderImage:[UIImage imageNamed:placeholderImageName]];
    self.titleLabel.text = topicModel.title;
    self.descLabel.text = topicModel.topicDescription;
    
    float nameWidth = [topicModel.user.nickName textWidthWithFontSize:12 isBold:YES andHeight:16];
    float timeWidth = [createTime textWidthWithFontSize:11 isBold:NO andHeight:12];

    [self.nameLabel updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(nameWidth);
    }];
    
    [self.timeLabel updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(timeWidth);
    }];
    
    self.headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *headerSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHeaderSingleTap:)];
    headerSingleTap.numberOfTapsRequired = 1;
    [self.headerImageView addGestureRecognizer:headerSingleTap];

}

- (void)handleHeaderSingleTap:(id)sender {
    if(self.topicModel.user.uid == [[XTUserStore sharedManager].user.userID longLongValue]) {
        return;
    }
    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%@",@(self.topicModel.user.uid)];
    controller.type = XTUserHomePageTypeHis;
    controller.userType = XTAccountCommon;
    [[UIViewController topViewController] pushViewController:controller animated:YES];
}

- (void)clickImageView:(id)sender {

}

- (void)updateCellLayout {


}

- (void)layoutCell {
    [self.bgView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(10., 7., 0., 7.));
    }];
    
    [self.headerImageView updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(@0);
        make.width.height.equalTo(@45);
    }];
    
    [self.vIconImageView updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerImageView.mas_right);
        make.bottom.equalTo(self.headerImageView.mas_bottom);
        make.width.height.equalTo(@18);
    }];
    
    [self.nameLabel updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(@8);
        make.centerY.equalTo(self.headerImageView.mas_centerY).offset(-10);
        make.height.equalTo(@16);
        make.width.equalTo(@20);
    }];
    
    [self.levelLabel updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(@5);
        make.centerY.equalTo(self.nameLabel);
        make.height.equalTo(@12);
        make.width.equalTo(@28);
    }];
    
    [self.timeLabel updateConstraints:^(MASConstraintMaker *make) {
        make.right.offset(@-8);
        make.centerY.equalTo(self.nameLabel);
        make.height.equalTo(@12);
        make.width.equalTo(@30);
    }];
    
    [self.statusLabel updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(@2);
        make.height.equalTo(@15);
        make.right.offset(-10);
    }];
    
    [self.topicBgView updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(@1);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(@1);
        make.bottom.offset(-14);
        make.right.offset(-8);
    }];
    
    [self.topicImageView updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.width.equalTo(70);
    }];
    
    [self.titleLabel updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topicImageView.mas_right).offset(@9);
        make.top.offset(@15);
        make.right.offset(0);
        make.height.equalTo(@16);
    }];
    
    [self.descLabel updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(@4);
        make.right.offset(0);
        make.height.equalTo(@15);
    }];
    
    [self.seperatorLine updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.equalTo(@0.5);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
