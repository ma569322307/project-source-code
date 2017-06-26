//
//  XTSpecificArtistHeaderView.m
//  tian
//
//  Created by huhuan on 15/7/1.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHoverSwitchHeaderView.h"
#import "XTHotLicksRecsInfo.h"
#import "NSString+TextSize.h"

@interface XTHoverSwitchHeaderView ()

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UIView *lineView;
@property (nonatomic, weak) IBOutlet UIButton *introButton;
@property (nonatomic, weak) IBOutlet UIButton *commentButton;
@property (nonatomic, weak) IBOutlet UIView *bottomLine;
@property (nonatomic, weak) IBOutlet UIView *seperatorLine;

@property (nonatomic, assign) XTHoverSwitchHeaderViewStyle headerStyle;

@end

@implementation XTHoverSwitchHeaderView

+ (XTHoverSwitchHeaderView *)hoverHeaderViewWithRecInfo:(XTHotLicksRecsInfo *)recsInfo andHeaderStyle:(XTHoverSwitchHeaderViewStyle)style {
    XTHoverSwitchHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"XTHoverSwitchHeaderView" owner:self options:nil] objectAtIndex:0];
    
    [headerView.headerImageView an_setImageWithURL:recsInfo.bigCover];
    headerView.contentLabel.text = recsInfo.content;
    headerView.isIntroStatus = YES;
    headerView.headerStyle = style;
    [headerView configureHeaderButton];
    [headerView layoutViews];
    
    float textWidth = SCREEN_SIZE.width - 20;
    headerView.headerHeight = 319+[recsInfo.content textHeightWithFontSize:12 isBold:NO andWidth:textWidth]-15;
    
    return headerView;
}

- (void)layoutViews {
    
    [self.headerImageView updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(0);
        make.height.equalTo(215);
    }];
    
    [self.contentLabel updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(10);
    }];
    
    [self.lineView updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(15);
        make.height.equalTo(0.5);
    }];
    
    [self.introButton updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@65);
        make.top.equalTo(self.lineView.mas_bottom).offset(8);
        make.width.equalTo(@60);
        make.height.equalTo(@50);
    }];
    
    [self.commentButton updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-65);
        make.top.equalTo(self.lineView.mas_bottom).offset(8);
        make.width.equalTo(@60);
        make.height.equalTo(@50);
    }];
    
    [self.bottomLine updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.introButton);
        make.top.equalTo(self.introButton.mas_bottom).offset(3);
        make.width.equalTo(@20);
        make.height.equalTo(@1);
    }];
    
    [self.seperatorLine updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(@1);
        make.height.equalTo(@0.5);
    }];
    
    [self layoutIfNeeded];
}


- (IBAction)introClick:(id)sender {
    if(!self.isIntroStatus) {
        self.isIntroStatus = YES;
        [self switchHeaderViewStatus];
        if(self.pageChangeBlock) {
            self.pageChangeBlock(0);
        }
    }
}

- (IBAction)commentClick:(id)sender {
    if(self.isIntroStatus) {
        self.isIntroStatus = NO;
        [self switchHeaderViewStatus];
        if(self.pageChangeBlock) {
            self.pageChangeBlock(1);
        }
    }
}

- (void)switchHeaderViewStatus {

    [self configureHeaderButton];
    if(self.isIntroStatus) {

        [self.bottomLine layoutIfNeeded];
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.bottomLine remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.introButton);
                make.top.equalTo(self.introButton.mas_bottom).offset(3);
                make.width.equalTo(@20);
                make.height.equalTo(@1);
            }];
            [self.bottomLine layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    }else {
        
        [self.bottomLine layoutIfNeeded];

        [UIView animateWithDuration:0.3 animations:^{
            [self.bottomLine remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.commentButton);
                make.top.equalTo(self.commentButton.mas_bottom).offset(3);
                make.width.equalTo(@20);
                make.height.equalTo(@1);
            }];
            [self.bottomLine layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

- (void)configureHeaderButton {
    NSString *introButtonNormal = nil;
    NSString *introButtonHighlight = nil;
    
    NSString *commentButtonNormal = nil;
    NSString *commentButtonHighlight = nil;
    
    if(self.headerStyle == XTHoverSwitchHeaderViewStyleSpecific) {
        introButtonNormal = @"intro_normal";
        introButtonHighlight = @"intro_highlight";
        
        commentButtonNormal = @"comment_normal";
        commentButtonHighlight = @"comment_highlight";
    }else if(self.headerStyle == XTHoverSwitchHeaderViewStyleHotEvent) {
        introButtonNormal = @"content_normal";
        introButtonHighlight = @"content_highlight";
        
        commentButtonNormal = @"pk_normal";
        commentButtonHighlight = @"pk_highlight";
    }
    
    if(self.isIntroStatus) {
        [self.introButton setImage:[UIImage imageNamed:introButtonHighlight] forState:UIControlStateNormal];
        [self.introButton setImage:[UIImage imageNamed:introButtonNormal] forState:UIControlStateHighlighted];
        
        [self.commentButton setImage:[UIImage imageNamed:commentButtonNormal] forState:UIControlStateNormal];
        [self.commentButton setImage:[UIImage imageNamed:commentButtonHighlight] forState:UIControlStateHighlighted];
    }else {
        [self.introButton setImage:[UIImage imageNamed:introButtonNormal] forState:UIControlStateNormal];
        [self.introButton setImage:[UIImage imageNamed:introButtonHighlight] forState:UIControlStateHighlighted];
        
        [self.commentButton setImage:[UIImage imageNamed:commentButtonHighlight] forState:UIControlStateNormal];
        [self.commentButton setImage:[UIImage imageNamed:commentButtonNormal] forState:UIControlStateHighlighted];
    }
    
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return nil;
    }
    return view;
}

@end
