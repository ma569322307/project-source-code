//
//  XTSelectCoverTableViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-7-1.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSelectCoverTableViewCell.h"

@implementation XTSelectCoverTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self titleLabel];
        [self coverImageView];
        [self arrowImageView];
        [self buttomLineView];
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = UIColorFromRGB(0x595959);
        _titleLabel.text = @"更换图册封面";
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(@5);
            make.bottom.equalTo(self.buttomLineView.top).offset(@-5);
            make.left.equalTo(self.contentView).offset(@10);
            make.right.equalTo(self.coverImageView.left).offset(@-10);
        }];
    }
    return _titleLabel;
}

- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        _coverImageView.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_coverImageView];
        
        [_coverImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.right.equalTo(self.arrowImageView.left).offset(@-10);
            make.width.height.equalTo(@40);
        }];
    }
    return _coverImageView;
}


- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.backgroundColor = [UIColor clearColor];
        _arrowImageView.image = [UIImage imageNamed:@"set_arrows"];
        [self.contentView addSubview:_arrowImageView];
        
        [_arrowImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).offset(@-10);
            make.width.equalTo(@10);
            make.height.equalTo(@14);
        }];
    }
    
    return _arrowImageView;
}

- (UIView *)buttomLineView{
    if (!_buttomLineView) {
        _buttomLineView = [UIView new];
        _buttomLineView.backgroundColor = UIColorFromRGB(0xececec);
        [self.contentView addSubview:_buttomLineView];
        
        [_buttomLineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.equalTo(@5);
        }];
    }
    return _buttomLineView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
