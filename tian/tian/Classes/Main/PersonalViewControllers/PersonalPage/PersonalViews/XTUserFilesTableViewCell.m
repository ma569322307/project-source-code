//
//  XTUserFilesTableViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-6-10.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUserFilesTableViewCell.h"

@implementation XTUserFilesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.contentView.backgroundColor = [UIColor lightGrayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self iconImageView];
        [self titleLabel];
        [self contentLabel];
        [self valueLabel];
        [self buttomLineView];
        
        //设置label1的content hugging 为1000
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired
                                       forAxis:UILayoutConstraintAxisHorizontal];
        
        //设置label1的content compression 为1000
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                     forAxis:UILayoutConstraintAxisHorizontal];
        
        //设置label1的content hugging 为1000
        [_contentLabel setContentHuggingPriority:UILayoutPriorityRequired
                                         forAxis:UILayoutConstraintAxisHorizontal];
        
        //设置label1的content compression 为250
        [_contentLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                                       forAxis:UILayoutConstraintAxisHorizontal];
        
        //设置右边的label2的content hugging 为1000
        [_valueLabel setContentHuggingPriority:UILayoutPriorityRequired
                                       forAxis:UILayoutConstraintAxisHorizontal];
        //设置右边的label2的content compression 为1000
        [_valueLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                     forAxis:UILayoutConstraintAxisHorizontal];
        
    }
    
    return self;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_iconImageView];
        
        [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.contentView).offset(@10);
            make.width.height.equalTo(@21);
        }];
    }
    
    return _iconImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = UIColorFromRGB(0x595959);
        _titleLabel.text = @"声望";
        //_titleLabel.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_iconImageView);
            make.left.equalTo(_iconImageView.right).offset(@5);
            make.height.equalTo(@15);
        }];
    }
    
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = UIColorFromRGB(0x7b7b7b);
        _contentLabel.text = @"苦国是奔黑暗者苦国";
        //_contentLabel.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_iconImageView);
            make.left.equalTo(_titleLabel.right).offset(@30);
            make.height.equalTo(@15);
        }];
    }
    return _contentLabel;
}

- (UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [UILabel new];
        _valueLabel.font = [UIFont systemFontOfSize:12];
        _valueLabel.textColor = UIColorFromRGB(0xfe3168);
        _valueLabel.text = @"今日+60";
        //_valueLabel.backgroundColor = [UIColor yellowColor];
        _valueLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_valueLabel];
        
        [_valueLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_iconImageView);
            make.left.greaterThanOrEqualTo(_contentLabel.right).offset(@5);
            make.right.equalTo(self.contentView).offset(@-10);
            make.height.equalTo(@15);
        }];
    }
    return _valueLabel;
}

- (UIView *)buttomLineView{
    if (!_buttomLineView) {
        _buttomLineView = [UIView new];
        _buttomLineView.backgroundColor = UIColorFromRGB(0xececec);
        [self.contentView addSubview:_buttomLineView];
        
        [_buttomLineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.equalTo(@0.5);
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
