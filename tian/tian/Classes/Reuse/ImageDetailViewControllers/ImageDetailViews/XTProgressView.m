//
//  XTProgressView.m
//  tian
//
//  Created by loong on 15/7/4.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTProgressView.h"

@interface XTProgressView()

@property(nonatomic,strong)CAShapeLayer *shapelayer;

@end

@implementation XTProgressView



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shapelayer = [CAShapeLayer layer];
        
        self.shapelayer.frame = self.bounds;
        
        UIBezierPath *path_white = [UIBezierPath bezierPathWithArcCenter:self.center radius:CGRectGetWidth(self.frame) / 2- 4 startAngle:3*M_PI / 2 endAngle:3.5*M_PI clockwise:YES];
        self.shapelayer.path = path_white.CGPath;
        self.shapelayer.strokeColor = [UIColor whiteColor].CGColor;
        self.shapelayer.fillColor = [UIColor clearColor].CGColor;
        self.shapelayer.lineCap = kCALineCapRound;
        self.shapelayer.lineWidth = 4.0f;
        self.shapelayer.strokeStart = 0.0f;
        self.shapelayer.strokeEnd = 0.01f;
        [self.layer addSublayer:self.shapelayer];

    }
    return self;
}



-(void)setProgress:(CGFloat)aProgress{
    _progress = aProgress;
    
    self.shapelayer.strokeEnd = _progress;
}

-(instancetype)initWithViewForShow:(UIView *)view{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(CGRectGetWidth(view.frame) / 2 - 25, CGRectGetHeight(view.frame) / 2 - 25, 50, 50);
        self.layer.cornerRadius = 25;
        self.layer.masksToBounds = YES;
        NSLog(@"center === %@",NSStringFromCGPoint(self.center));
        self.backgroundColor = [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:0.5];
        self.shapelayer = [CAShapeLayer layer];
        
        self.shapelayer.frame = self.bounds;
        
        //self.shapelayer.backgroundColor = [UIColor magentaColor].CGColor;
        
        
        CGPoint center = CGPointMake(CGRectGetWidth(self.shapelayer.frame) / 2, CGRectGetHeight(self.shapelayer.frame) / 2);
        UIBezierPath *path_white = [UIBezierPath bezierPathWithArcCenter:center radius:CGRectGetWidth(self.frame) / 2 - 8 startAngle:3*M_PI / 2 endAngle:3.5*M_PI clockwise:YES];
        self.shapelayer.path = path_white.CGPath;
        self.shapelayer.strokeColor = [UIColor whiteColor].CGColor;
        self.shapelayer.fillColor = [UIColor clearColor].CGColor;
        self.shapelayer.lineCap = kCALineCapRound;
        self.shapelayer.lineWidth = 4.0f;
        self.shapelayer.strokeStart = 0.0f;
        self.shapelayer.strokeEnd = 0.01f;
        [self.layer addSublayer:self.shapelayer];
        
        [view addSubview:self];
    }
    return self;    
}


-(void)hidden{
    
    //[self removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
