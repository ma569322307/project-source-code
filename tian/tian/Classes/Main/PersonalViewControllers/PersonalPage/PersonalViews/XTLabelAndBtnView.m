//
//  XTLabelAndBtnView.m
//  tian
//
//  Created by 曹亚云 on 15-6-13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTLabelAndBtnView.h"

@implementation XTLabelAndBtnView
- (id)init
{
    self = [super init];
    if (self) {
        [self titleLabel];
        [self contentLabel];
        [self clickButton];
        
        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.left.equalTo(_titleLabel.right);
        }];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.right.equalTo(_contentLabel.left);
        }];
        
        [_clickButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.and.right.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"大神:";
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = [UIColor yellowColor];
        [self addSubview:_contentLabel];
    }
    
    return _contentLabel;
}

- (UIButton *)clickButton{
    if (!_clickButton) {
        _clickButton = [UIButton new];
        _clickButton.backgroundColor = [UIColor clearColor];
        [self addSubview:_clickButton];
    }
    
    return _clickButton;
}


@end
