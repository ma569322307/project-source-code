//
//  XTSpecificCommentTableViewCell.m
//  tian
//
//  Created by huhuan on 15/7/4.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSpecificCommentTableViewCell.h"
#import "XTCommentItemModel.h"
#import "NSString+TimeReversal.h"
#import "NSString+TextSize.h"
#import "XTUserHomePageViewController.h"
#import "UIViewController+Extend.h"
#import "XTUserStore.h"
#import "XTUserInfo.h"
#import "JKUtil.h"

@interface XTSpecificCommentTableViewCell ()

@property (nonatomic, weak) IBOutlet UIView      *bgView;
@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak) IBOutlet UIImageView *vIconImageView;
@property (nonatomic, weak) IBOutlet UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel     *levelLabel;
@property (nonatomic, weak) IBOutlet UILabel     *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel     *contentLabel;
@property (nonatomic, weak) IBOutlet UIButton    *praiseButton;
@property (nonatomic, weak) IBOutlet UIImageView *lickImageView;
@property (nonatomic, weak) IBOutlet UIView      *seperateLine;

@property (nonatomic, strong) XTCommentItemModel *commentItemModel;

@end

@implementation XTSpecificCommentTableViewCell

- (void)awakeFromNib {
    [self layoutCell];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2;
    
    self.levelLabel.layer.masksToBounds = YES;
    self.levelLabel.layer.cornerRadius = 6.f;

}

- (IBAction)praiseClick:(id)sender {
    if(self.praiseClickBlock) {
        self.praiseClickBlock(self.commentItemModel);
    }
}

- (void)configureCell:(XTCommentItemModel *)itemModel {
    self.commentItemModel = itemModel;
    
    [self.headerImageView an_setImageWithURL:[NSURL URLWithString:itemModel.headImg]];
    self.nameLabel.text = itemModel.userName;
    self.levelLabel.text = [NSString stringWithFormat:@"lv%@", @(itemModel.level)];
    self.contentLabel.text = itemModel.text;
    
    NSString *createTime = [NSString diffTimestamp:[itemModel.createdAt longLongValue]];
    self.timeLabel.text = createTime;
    
    if(itemModel.vuser) {
        self.vIconImageView.hidden = NO;
    }else {
        self.vIconImageView.hidden = YES;
    }

    if(!itemModel.supportType) {
        self.praiseButton.hidden = NO;
        self.lickImageView.hidden = YES;
        
        if(itemModel.supported) {
            [self.praiseButton setImage:[UIImage imageNamed:@"sc_like_y"] forState:UIControlStateNormal];
            [self.praiseButton setTitleColor:RGBA(253, 229, 13, 1) forState:UIControlStateNormal];
        }else {
            [self.praiseButton setImage:[UIImage imageNamed:@"sc_like_n"] forState:UIControlStateNormal];
            [self.praiseButton setTitleColor:[JKUtil getColor:@"7f7f7f"] forState:UIControlStateNormal];
        }
        if([itemModel.totalSupports integerValue] > 0) {
            [self.praiseButton setTitle:[NSString stringWithFormat:@"%@",itemModel.totalSupports] forState:UIControlStateNormal];
            [self.praiseButton updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.timeLabel.mas_right).offset(10);
            }];
        }else {
            [self.praiseButton setTitle:@"" forState:UIControlStateNormal];
            [self.praiseButton updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.timeLabel.mas_right).offset(12);
            }];
        }
    }else {
        self.praiseButton.hidden = YES;
        self.lickImageView.hidden = NO;
        
        if([itemModel.supportType isEqualToString:@"du"]) {
            [self.lickImageView setImage:[UIImage imageNamed:@"vote_poisonTag"]];
        }else {
            [self.lickImageView setImage:[UIImage imageNamed:@"vote_gladTag"]];
        }
    }
    
    float nameWidth = [itemModel.userName textWidthWithFontSize:11 isBold:NO andHeight:14];
    float timeWidth = [createTime textWidthWithFontSize:11 isBold:NO andHeight:12];
    
    [self.nameLabel updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(nameWidth);
    }];
    
    [self.timeLabel updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(timeWidth);
    }];
    
    self.headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.headerImageView addGestureRecognizer:singleTap];
}

- (void)handleSingleTap:(id)sender {

    if(self.commentItemModel.userId == [[XTUserStore sharedManager].user.userID longLongValue]) {
        return;
    }
    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%@",@(self.commentItemModel.userId)];
    controller.type = XTUserHomePageTypeHis;
    controller.userType = XTAccountCommon;
    [[UIViewController topViewController] pushViewController:controller animated:YES];
}

- (void)layoutCell {
    [self.bgView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0., 8., 0., 8.));
    }];
    
    [self.headerImageView updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(@8);
        make.width.height.equalTo(@35);
    }];
    
    [self.vIconImageView updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerImageView);
        make.bottom.equalTo(self.headerImageView);
        make.width.height.equalTo(@9);
    }];
    
    [self.nameLabel updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(@8);
        make.centerY.equalTo(self.headerImageView);
        make.height.equalTo(@14);
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
    
    [self.contentLabel updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.headerImageView.mas_bottom);
        make.right.equalTo(self.praiseButton.mas_left).offset(-2);
        make.bottom.offset(-18.5);
    }];
    
    [self.praiseButton updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom);
        make.right.equalTo(self.timeLabel.mas_right).offset(12);
        make.width.height.equalTo(40);
    }];
    
    [self.lickImageView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(2);
        make.right.offset(-8);
        make.width.height.equalTo(28);
    }];

    [self.seperateLine updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.equalTo(0.5);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
