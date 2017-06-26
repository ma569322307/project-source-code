//
//  XTUIButton.m
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/7.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTUIButton.h"
#import "XTCommonMacro.h"
@implementation XTUIButton
- (UIButton*)configureForBackButtonWithTitle:(NSString*)title target:(id)target action:(SEL)action
                                   normalImg:(UIImage*)normalImg clickedImg:(UIImage*)clickedImg
{
    // Experimentally determined
    CGFloat padTRL[3] = {6, 8, 12};
    
    // Text must be put in its own UIView, s.t. it can be positioned to mimic system buttons
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    [label sizeToFit];
    
    // The underlying art files must be added to the project
    UIImage* norm = [normalImg stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage* click = [clickedImg stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [self setImage:norm forState:UIControlStateNormal];
    [self setImage:click forState:UIControlStateHighlighted];
    //	[self setBackgroundImage:norm forState:UIControlStateHighlighted];
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // Calculate dimensions
    CGSize labelSize = label.frame.size;
    CGFloat controlWidth = labelSize.width+padTRL[1]+padTRL[2];
    controlWidth = controlWidth>=norm.size.width?controlWidth:norm.size.width;
    
    // Assemble and size the views
    self.frame = CGRectMake(0, 0, controlWidth, 30);
    [self addSubview:label];
    label.frame = CGRectMake(padTRL[2], padTRL[0], labelSize.width, labelSize.height);
    
    // Clean up
    
    return self;
}
/**
 *  开始倒计时
 */
- (void)countdownBegin
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(countdown)
                                                userInfo:nil
                                                 repeats:YES];
    }
    if ([self.delegate respondsToSelector:@selector(countdownBeginning)]) {
        [self.delegate countdownBeginning];
    }
}
/**
 *  结束倒计时
 */
- (void)countdownEnd
{
    [_timer invalidate];
    _timer = nil;
    
    if ([self.delegate respondsToSelector:@selector(countdownEnding)]) {
        [self.delegate countdownEnding];
    }
}

- (void)cancleTime {
    [_timer invalidate];
    _timer = nil;
    self.delegate = nil;
}


- (void)countdown
{
    if (_countdownNum <= 1) {
        _countdownNum = 0;
        [self countdownEnd];
        return;
    }
    _countdownNum --;
    NSLog(@"%ld", (long)_countdownNum);
    NSLog(@"thread ==== %@",[NSThread currentThread]);
    
    
    [self setTitle:[NSString stringWithFormat:@"重新获取 (%ld)",(_countdownNum < 0 ? 1 : _countdownNum)] forState:UIControlStateNormal];
}
- (void)dealloc {
    NSLog(@"%s",__func__);
}
@end
