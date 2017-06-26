//
//  XTSetFootView.m
//  StarPicture
//
//  Created by 曹亚云 on 15-3-13.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTSetFootView.h"

@implementation XTSetFootView

- (IBAction)clickBtn:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(clickDeleteBtn:)]) {
        [self.delegate clickDeleteBtn:button];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
