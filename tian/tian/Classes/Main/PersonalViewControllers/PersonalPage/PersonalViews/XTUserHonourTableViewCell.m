//
//  XTUserHonourTableViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-6-15.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUserHonourTableViewCell.h"

@implementation XTUserHonourTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.contentView.backgroundColor = [UIColor lightGrayColor];
        [self lineView];
        [self iconImageView];
        [self titleLabel];
        [self separateLineView];
        [self contentLabel];
    }
    
    return self;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.image = [UIImage imageNamed:@"HomePage_headImage_default"];
        _iconImageView.layer.cornerRadius = 37.5f;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        
        [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(@5);
            make.bottom.equalTo(_lineView.top).offset(@-5);
            make.width.equalTo(_iconImageView.height);
        }];
    }
    
    return _iconImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = UIColorFromRGB(0x595959);
        _titleLabel.text = @"捕神";
        //_titleLabel.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_iconImageView);
            make.left.equalTo(_iconImageView.right).offset(@10);
            make.height.equalTo(@15);
        }];
    }
    
    return _titleLabel;
}

- (UIView *)separateLineView{
    if (!_separateLineView) {
        _separateLineView = [UIView new];
        _separateLineView.backgroundColor = UIColorFromRGB(0xececec);
        [self.contentView addSubview:_separateLineView];
        
        [_separateLineView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.bottom).offset(@5);
            make.left.equalTo(_titleLabel);
            make.right.equalTo(self.contentView).offset(@-10);
            make.height.equalTo(@0.5);
        }];
    }
    return _separateLineView;
}


- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = UIColorFromRGB(0x7b7b7b);
        _contentLabel.text = @"大数据已经从概念阶段上升到了实际使用阶段，越来越多的企业在通过大数据进行产品开发和营销指导，而通信运营商也开始对手里握着的金矿感兴趣";
        //_contentLabel.backgroundColor = [UIColor yellowColor];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_separateLineView.bottom).offset(@5);
            make.left.equalTo(_titleLabel);
            make.bottom.equalTo(_iconImageView);
            make.right.equalTo(_separateLineView);
        }];
    }
    return _contentLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorFromRGB(0xececec);
        [self.contentView addSubview:_lineView];
        
        [_lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.equalTo(@0.5);
        }];
    }
    return _lineView;
}

@end
