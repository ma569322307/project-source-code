//
//  YYTBlankView.m
//  tian
//
//  Created by huhuan on 15/7/24.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "YYTBlankView.h"
#import "NSString+TextSize.h"
#import "NSError+XTError.h"

@interface YYTBlankView ()

@property (nonatomic, strong) UIView        *blankSuperView;
@property (nonatomic, weak) IBOutlet UIImageView        *headImageView;
@property (nonatomic, weak) IBOutlet UILabel            *contentLabel;
@property (nonatomic, weak) IBOutlet UIButton           *eventButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tipTopConstraint;

@property (nonatomic, copy) void (^eventBlock)();

@property (nonatomic, assign) YYTBlankViewStyle  blankStyle;

@end


@implementation YYTBlankView

+ (YYTBlankView *)showBlankInView:(UIView *)view
                            style:(YYTBlankViewStyle)style
                       eventClick:(void(^)())eventBlock {
    
    [self hideFromView:view];
    
    YYTBlankView *blankView = [[NSBundle mainBundle] loadNibNamed:@"YYTBlankView" owner:self options:nil][0];
    blankView.blankStyle         = style;
    blankView.eventBlock         = eventBlock;
    blankView.eventButton.hidden = YES;
    blankView.blankSuperView     = view;

    [blankView configureBlankView];
    [view addSubview:blankView];

    
    if(VERSION < 8) {
        blankView.frame              = CGRectMake(0., 0., SCREEN_SIZE.width, 215);
        blankView.center             = CGPointMake(SCREEN_SIZE.width/2, view.center.y-30);
    }else {
        [blankView configureAutolayoutWithView:view];
    }
    
    return blankView;
}

+ (void)hideFromView:(UIView *)view {
    for(UIView *v in [view subviews]) {
        if([v isKindOfClass:[self class]]) {
            [v removeFromSuperview];
        }
    }
}

- (IBAction)eventClick:(id)sender {
    if(self.eventBlock) {
        self.eventBlock();
    }
}

- (void)setNeedAutolayout:(BOOL)needAutolayout {
    if(needAutolayout) {
        self.frame = CGRectZero;
        [self configureAutolayoutWithView:self.blankSuperView];
    }
    _needAutolayout = needAutolayout;
}

- (void)setHeaderStyle:(YYTBlankHeaderStyle)headerStyle {
    _headerStyle = headerStyle;
    [self adjustHeaderImage];
}

- (void)setTipString:(NSString *)tipString {
    _tipString             = tipString;
    self.contentLabel.text = tipString;
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle            = buttonTitle;
    self.eventButton.hidden = NO;
//    float eventWidth        = [buttonTitle textWidthWithFontSize:16 isBold:NO andHeight:20];
    [self.eventButton setTitle:buttonTitle forState:UIControlStateNormal];
//    self.buttonWidthConstraint.constant = eventWidth + 20;
}

- (void)setError:(NSError *)error {
    _error = error;
    if([error errorType] == ErrorTypeNetwork) {
        self.tipString   = @"网络异常……";
    }else {
        self.tipString   = @"服务器开小差啦";
    }
}

- (void)configureAutolayoutWithView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:SCREEN_SIZE.width]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:215]];

}

- (void)configureBlankView {
    switch (self.blankStyle) {
        case YYTBlankViewStyleNetworkError:
        {
            self.headerStyle = YYTBlankHeaderStyleForbid;
            self.tipString   = @"网络异常……";
            self.buttonTitle = @"刷新";
        }
            break;
        case YYTBlankViewStyleBlank:
        {
            self.headerStyle = YYTBlankHeaderStyleBowl;
            self.tipString   = @"无数据";
        }
            break;
            
        default:
            break;
    }
}

- (void)adjustHeaderImage {
    self.tipTopConstraint.constant = 13.f;
    switch (self.headerStyle) {
        case YYTBlankHeaderStyleCry:
        {
            [self.headImageView setImage:[UIImage imageNamed:@"blank_cry"]];
        }
            break;
        case YYTBlankHeaderStyleLike:
        {
            [self.headImageView setImage:[UIImage imageNamed:@"blank_like"]];
        }
            break;
        case YYTBlankHeaderStyleFear:
        {
            [self.headImageView setImage:[UIImage imageNamed:@"blank_sweat"]];
        }
            break;
        case YYTBlankHeaderStyleUnhappy:
        {
            [self.headImageView setImage:[UIImage imageNamed:@"blank_unhappy"]];
        }
            break;
        case YYTBlankHeaderStyleForbid:
        {
            [self.headImageView setImage:[UIImage imageNamed:@"blank_forbid"]];
        }
            break;
        case YYTBlankHeaderStyleBowl:
        {
            [self.headImageView setImage:[UIImage imageNamed:@"blank_bowl"]];
            self.tipTopConstraint.constant = -10.f;
            
        }
            break;
    }
}
@end
