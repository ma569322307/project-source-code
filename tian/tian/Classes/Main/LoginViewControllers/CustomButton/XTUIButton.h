//
//  XTUIButton.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/7.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XTUIButtonDelegate;

@interface XTUIButton : UIButton
{
    NSTimer *_timer;
}
@property (nonatomic, assign) NSInteger countdownNum;
@property (nonatomic, weak) id<XTUIButtonDelegate> delegate;

/**
 *  开始倒计时
 */
- (void)countdownBegin;
/**
 *  结束倒计时
 */
- (void)countdownEnd;
- (void)cancleTime;
@end

@protocol XTUIButtonDelegate <NSObject>
- (void)countdownBeginning;
- (void)countdownEnding;
@end