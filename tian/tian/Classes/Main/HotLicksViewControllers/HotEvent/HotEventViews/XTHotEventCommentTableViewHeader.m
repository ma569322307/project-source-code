//
//  XTHotEventCommentTableViewHeader.m
//  tian
//
//  Created by huhuan on 15/7/6.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHotEventCommentTableViewHeader.h"
#import "XTCommentsModel.h"
#import "YYTUICommon.h"

@interface XTHotEventCommentTableViewHeader ()

@property (nonatomic, weak) IBOutlet UIView *headerBgView;
@property (nonatomic, weak) IBOutlet UIImageView *voteBgView;

@property (nonatomic, strong) UIImageView *poisonProgressView;
@property (nonatomic, strong) UIImageView *gladProgressView;

@property (nonatomic, strong) UILabel *poisonCountLabel;
@property (nonatomic, strong) UILabel *gladCountLabel;

@end

@implementation XTHotEventCommentTableViewHeader

+ (XTHotEventCommentTableViewHeader *)hotEventCommentTableViewHeaderWithCommentModel:(XTCommentsModel *)commentModel {
    XTHotEventCommentTableViewHeader *headerView = [[NSBundle mainBundle] loadNibNamed:@"XTHotEventCommentTableViewHeader" owner:self options:nil][0];
    headerView.commentModel = commentModel;
    return headerView;
}

- (IBAction)poisonClick:(id)sender {
    if(self.lickClickBlock) {
        self.lickClickBlock(YES);
    }
}

- (IBAction)gladClick:(id)sender {
    if(self.lickClickBlock) {
        self.lickClickBlock(NO);
    }
}

- (void)configureLickStatus {
    
    NSInteger poisonCount = [self.commentModel.pk[@"duCount"] integerValue];
    NSInteger gladCount = [self.commentModel.pk[@"tianCount"] integerValue];
    
    
    self.poisonCountLabel.text = [NSString stringWithFormat:@"%@",@(poisonCount)];
    self.gladCountLabel.text = [NSString stringWithFormat:@"%@",@(gladCount)];
    
    float voteBgWidth = self.voteBgView.frame.size.width;
    
    float poisonProgressWidth = 0.f;
    float gladProgressWidth = 0.f;
    if(poisonCount == 0 && gladCount == 0) {
        poisonProgressWidth = voteBgWidth/2.f;
        gladProgressWidth = voteBgWidth/2.f;
    }else {
        poisonProgressWidth = (float)poisonCount/(float)(poisonCount+gladCount)*voteBgWidth;
        gladProgressWidth = (float)gladCount/(float)(poisonCount+gladCount)*voteBgWidth;
        
        float minWidth = 50.f;
        if(poisonProgressWidth > voteBgWidth - minWidth) {
            poisonProgressWidth = voteBgWidth - minWidth;
            gladProgressWidth = minWidth;
        }else if (gladProgressWidth > voteBgWidth - minWidth) {
            gladProgressWidth = voteBgWidth - minWidth;
            poisonProgressWidth = minWidth;
        }
    }
    
    
    [self.poisonProgressView updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(2);
        make.bottom.offset(-2);
        make.width.equalTo(poisonProgressWidth-2);
    }];
    
    [self.gladProgressView updateConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.offset(2);
        make.bottom.offset(-2);
        make.width.equalTo(gladProgressWidth-2);
    }];
    
    [self.poisonCountLabel updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0., 0., 0., 10.));
    }];
    
    [self.gladCountLabel updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0., 10., 0., 0.));
    }];
}

- (void)configureHeaderView {
    if(self.poisonProgressView) {
        [self configureLickStatus];
        return;
    }
    //可变背景图片
    UIImage *poisonProgressBGImage = [UIImage imageNamed:@"vote_poisonProgress"];
    poisonProgressBGImage = [poisonProgressBGImage stretchableImageWithLeftCapWidth:1 topCapHeight:5];
    
    UIImage *gladProgressBGImage = [UIImage imageNamed:@"vote_gladProgress"];
    gladProgressBGImage = [gladProgressBGImage stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    self.poisonProgressView = [[UIImageView alloc] init];
    [self.poisonProgressView setImage:poisonProgressBGImage];
    [self.voteBgView addSubview:self.poisonProgressView];
    
    self.gladProgressView = [[UIImageView alloc] init];
    [self.gladProgressView setImage:gladProgressBGImage];
    [self.voteBgView addSubview:self.gladProgressView];
    
    self.poisonCountLabel = [[UILabel alloc] init];
    self.poisonCountLabel.textAlignment = NSTextAlignmentRight;
    self.poisonCountLabel.font = [UIFont boldSystemFontOfSize:10.f];
    self.poisonCountLabel.textColor = [UIColor whiteColor];
    [self.poisonProgressView addSubview:self.poisonCountLabel];
    
    self.gladCountLabel = [[UILabel alloc] init];
    self.gladCountLabel.textAlignment = NSTextAlignmentLeft;
    self.gladCountLabel.font = [UIFont boldSystemFontOfSize:10.f];
    self.gladCountLabel.textColor = COLOR_RGB_HEX(0xffe707);
    [self.gladProgressView addSubview:self.gladCountLabel];

    
    [self layoutIfNeeded];
    [self.headerBgView layoutIfNeeded];
    [self.voteBgView layoutIfNeeded];
    
    [self configureLickStatus];
    
}

@end
