//
//  XTUnreadCountView.m
//  tian
//
//  Created by cc on 15/7/16.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTUnreadCountView.h"
@implementation XTUnreadCountView
- (id)init
{
    self = [super init];
    if (self) {
        UIImageView *bgImgView = [[UIImageView alloc]init];
        
        UIImage *bgImg = UIIMAGE(@"unreadCountLabel");
        [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8) resizingMode:UIImageResizingModeTile];
        [bgImgView setImage:bgImg];
        [self addSubview:bgImgView];
        [bgImgView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
        
        
        self.countLabel = [[UILabel alloc]init];
        self.countLabel.textColor = [UIColor whiteColor];
        self.countLabel.backgroundColor = [UIColor clearColor];
        self.countLabel.font = [UIFont systemFontOfSize:10];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        [bgImgView addSubview:self.countLabel];
        [self.countLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
        
    }
    return self;
}

- (void)setUnreadCountLabelText:(NSInteger)unreadCount
{
    
    if (unreadCount>0&&unreadCount<100) {
        self.hidden = NO;
        self.countLabel.text = [NSString stringWithFormat:@"%d",unreadCount];
    }else if (unreadCount>=100)
    {
        self.countLabel.text = @"...";
    }
    else{
        self.hidden = YES;
        self.countLabel.text = @"";
    }
}

- (NSInteger)getTheUnreadCount
{
    return [self.countLabel.text integerValue];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
