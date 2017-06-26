//
//  YYTButton.m
//  StarPicture
//
//  Created by 曹亚云 on 15-2-12.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "YYTButton.h"
#import "YYTUICommon.h"
#import "TTTAttributedLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface YYTButton()
@property (nonatomic, strong) TTTAttributedLabel *attributedLabel;
@end

@implementation YYTButton
@synthesize animationDuration = _animationDuration;
@synthesize animating = _animating;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

+ (YYTButton *)buttonWithImageName:(NSString *)baseName {
    NSString *img_name = baseName;
    NSString *img_focus_name = [NSString stringWithFormat:@"%@_focus", baseName];
    
    UIImage *img = [UIImage imageNamed:img_name];
    UIImage *img_focus = [UIImage imageNamed:img_focus_name];
    YYTButton *btn = [YYTButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [btn setImage:img forState:UIControlStateNormal];
    [btn setImage:img_focus forState:UIControlStateHighlighted];
    [btn setImage:img_focus forState:UIControlStateSelected];
    
    return btn;
}

+ (YYTButton *)buttonWithImageName:(NSString *)imgName focusImageName:(NSString *)focusImgName {
    UIImage *img = [UIImage imageNamed:imgName];
    UIImage *img_focus = [UIImage imageNamed:focusImgName];
    YYTButton *btn = [YYTButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [btn setImage:img forState:UIControlStateNormal];
    [btn setImage:img_focus forState:UIControlStateHighlighted];
    [btn setImage:img_focus forState:UIControlStateSelected];
    
    return btn;
}

- (void)setButtonImageName:(NSString *)baseName {
    NSString *img_name = baseName;
    NSString *img_focus_name = [NSString stringWithFormat:@"%@_focus", baseName];
    
    UIImage *img = [UIImage imageNamed:img_name];
    UIImage *img_focus = [UIImage imageNamed:img_focus_name];
    
    [self setImage:img forState:UIControlStateNormal];
    [self setImage:img_focus forState:UIControlStateHighlighted];
    [self setImage:img_focus forState:UIControlStateSelected];
}

#pragma mark - attribute label
- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[TTTAttributedLabel class]]) {
            view.frame = self.bounds;
        }
    }
}

- (TTTAttributedLabel *)buildAttributedLabel:(NSString *)title attribute:(NSDictionary *)attr {
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] init];
    
    label.backgroundColor = COLOR_CLEAR;
    label.font = [attr objectForKey:@"font"];
    label.textColor = [attr objectForKey:@"color"];
    label.textAlignment = NSTextAlignmentCenter;
    label.autoresizingMask = 0xff;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.userInteractionEnabled = NO;
    
    NSArray *texts = [title componentsSeparatedByString:@"`"];
    NSString *dst_text = [title stringByReplacingOccurrencesOfString:@"`" withString:@""];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:dst_text];
    NSInteger text_offset = 0;
    NSInteger text_length = 0;
    for (int i=0; i<[texts count]; i++) {
        NSString *tmp_text = [texts objectAtIndex:i];
        text_length = [tmp_text length];
        if (i % 2) {
            NSRange emphasize_range = NSMakeRange(text_offset, text_length);
            UIFont *emphasize_font = [attr objectForKey:@"emphasize_font"];
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)emphasize_font.fontName, emphasize_font.pointSize, NULL);
            
            if (font) {
                [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(font) range:emphasize_range];
            }
            
            UIColor *emphasize_color = [attr objectForKey:@"emphasize_color"];
            [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)emphasize_color.CGColor range:emphasize_range];
        } else {
            NSRange normal_range = NSMakeRange(text_offset, text_length);
            UIFont *normal_font = [attr objectForKey:@"font"];
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)normal_font.fontName, normal_font.pointSize, NULL);
            
            if (font) {
                [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(font) range:normal_range];
            }
            
            UIColor *normal_color = [attr objectForKey:@"color"];
            [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)normal_color.CGColor range:normal_range];
        }
        
        text_offset += text_length;
    }
    
    [label setText:attributedString];
    
    return label;
    
}

- (void)setAttributeTitle:(NSString *)title attribute:(NSDictionary *)attr {
    TTTAttributedLabel *label = [self buildAttributedLabel:title attribute:attr];
    
    label.frame = self.bounds;
    
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[TTTAttributedLabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    [self addSubview:label];
}

#pragma mark - animation
- (void)setAnimating:(BOOL)animating {
    _animating = animating;
    if (_animating) {
        [self startAnimating];
    }
    else {
        [self stopAnimating];
    }
}

- (BOOL)isAnimating {
    CAAnimation *spinAnimation = [self.layer animationForKey:@"spinAnimation"];
    return (_animating || spinAnimation);
}

- (void)startAnimating {
    _animating = YES;
    [self spin];
}

- (void)stopAnimating {
    [self.layer removeAnimationForKey:@"spinAnimation"];
    _animating = NO;
}

- (void)spin {
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.byValue = [NSNumber numberWithFloat:UINT32_MAX * M_PI];
    spinAnimation.duration = self.animationDuration;
    spinAnimation.delegate = self;
    [self.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
}

#pragma mark - Animation Delegates

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if (_animating) {
        [self spin];
    }
}

#pragma mark - Property Methods

- (CGFloat)animationDuration {
    if (!_animationDuration) {
        _animationDuration = UINT32_MAX * 1.0f;
    }
    return _animationDuration;
}

@end
