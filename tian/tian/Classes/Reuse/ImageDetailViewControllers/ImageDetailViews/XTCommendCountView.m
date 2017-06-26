//
//  XTCommendCountView.m
//  tian
//
//  Created by loong on 15/8/3.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTCommendCountView.h"

@interface XTCommendCountView ()

@property(nonatomic,weak)IBOutlet UILabel *countLabel;

@end


@implementation XTCommendCountView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setCount:(NSInteger)aCount{
    _count = aCount;
    
    self.countLabel.text = [NSString stringWithFormat:@"%zd",_count];
    
}


@end
