//
//  XTActionBase.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/11.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTActionBase.h"

@implementation XTActionBase

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        ///添加点击返回手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAnimation)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
///退回动画
-(void)dismissAnimation{
    
}
@end
