//
//  XTShareCell.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/10.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTShareCell.h"
#import "XTShareModel.h"
#import "XTShareButton.h"
#import "XTShareCollectionView.h"
@interface XTShareCell ()
@property (nonatomic, strong) XTShareButton *button;
@end

@implementation XTShareCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addConstraints];
    }
    return self;
}
-(void)addConstraints{
    //图片约束
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.contentView addConstraints:@[top,right,left,bottom]];
}
-(void)setModel:(XTShareModel *)model{
    _model = model;
    [self.button setTitle:model.title forState:UIControlStateNormal];
    [self.button setTitleColor:UIColorFromRGB(0x6f6f6f) forState:UIControlStateNormal];
    [self.button setTitleColor:UIColorFromRGB(0xFEE535) forState:UIControlStateHighlighted];
    [self.button setImage:[UIImage imageNamed:model.imageName] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:model.imageNameSelected] forState:UIControlStateHighlighted];
    self.button.tag = model.index + 1;
}
///点击事件
-(void)btnClick:(XTShareButton *)btn{
    if (self.btnBlock) {
        self.btnBlock(btn.tag);
    }
}
#pragma mark 懒加载
-(XTShareButton *)button
{
    if (_button == nil) {
        _button = [XTShareButton buttonWithType:UIButtonTypeCustom];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:kShareCollectionViewButtonTextSize];
        [_button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
    }
    return _button;
}
@end
