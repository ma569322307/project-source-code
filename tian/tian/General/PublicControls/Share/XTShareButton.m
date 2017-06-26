//
//  XTShareButton.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/10.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTShareButton.h"
#import "XTShareSheet.h"
@implementation XTShareButton
-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(0, self.imageView.frame.size.height + kShareCollectionViewLineSpacing, self.frame.size.width, self.titleLabel.frame.size.height);
}
@end
