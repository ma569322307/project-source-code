//
//  XTSignInView.m
//  tian
//
//  Created by 曹亚云 on 15-5-14.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSignInView.h"
#import "XTNoHighLightedButton.h"
@interface XTSignInView ()

@property (nonatomic, strong) UILabel *signInCountLabel;

@end


@implementation XTSignInView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init
{
    self = [super init];
    if (self) {
        self.signInButton = [XTNoHighLightedButton new];
        [_signInButton setImage:[UIImage imageNamed:@"HomePage_signIn"] forState:UIControlStateNormal];
        [_signInButton setImage:[UIImage imageNamed:@"HomePage_NoSignIn"] forState:UIControlStateSelected];
        [self addSubview:_signInButton];
        
        self.signInCountLabel = [UILabel new];
        //_signInCountLabel.backgroundColor = [UIColor blackColor];
        _signInCountLabel.text = @"0";
        _signInCountLabel.font = [UIFont systemFontOfSize:12];
        _signInCountLabel.textColor = UIColorFromRGB(0x4f242b);
        _signInCountLabel.numberOfLines = 1;
        _signInCountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_signInCountLabel];
        
        [self.signInButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.bottom.equalTo(@0);
            make.right.equalTo(@0);
        }];
        
        [self.signInCountLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.signInButton.centerX).offset(-15);
            make.centerY.equalTo(self.signInButton.centerY);
        }];
    }
    return self;
}

- (void)fillUesrInformation:(XTUserAccountInfo *)user{
    self.signInCountLabel.text = user.continueDays;
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [dateFormatter stringFromDate:date];
    NSString *signInDate =[dateFormatter stringFromDate:user.lastSignDate];
    if ([signInDate isEqualToString:currentDate]) {
        //self.signInButton.enabled = NO;
        self.signInButton.selected = YES;
        self.isSigned = YES;
        _signInCountLabel.textColor = [UIColor whiteColor];
    }
}



@end
