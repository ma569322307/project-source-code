//
//  XTProgressView.h
//  tian
//
//  Created by loong on 15/7/4.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTProgressView : UIView

@property(nonatomic)CGFloat progress;

-(instancetype)initWithViewForShow:(UIView *)view;


-(void)hidden;

@end
