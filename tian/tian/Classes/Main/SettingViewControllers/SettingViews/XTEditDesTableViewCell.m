//
//  XTEditDesTableViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-6-30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTEditDesTableViewCell.h"

@interface XTEditDesTableViewCell ()
@property (nonatomic, strong) UIView *lineView;
@end

@implementation XTEditDesTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self titleLabel];
        [self contentLabel];
        [self arrowImageView];
        [self buttomLineView];
        [self lineView];
        //设置label1的content hugging 为1000
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired
                                       forAxis:UILayoutConstraintAxisHorizontal];

        //设置label1的content compression 为250
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                     forAxis:UILayoutConstraintAxisHorizontal];

        //设置label1的content hugging 为1000
        [_contentLabel setContentHuggingPriority:UILayoutPriorityRequired
                                         forAxis:UILayoutConstraintAxisHorizontal];

        //设置label1的content compression 为1000
        [_contentLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                                       forAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = UIColorFromRGB(0x595959);
        _titleLabel.text = @"声望";
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(@5);
            make.bottom.equalTo(self.buttomLineView.top).offset(@-5);
            make.left.equalTo(self.contentView).offset(@10);
        }];
    }
    
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = UIColorFromRGB(0x7b7b7b);
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel);
            make.left.greaterThanOrEqualTo(_titleLabel.right).offset(@20);
            make.right.equalTo(self.arrowImageView.left).offset(@-10);
        }];
    }
    return _contentLabel;
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
//分割线线条
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = UIColorFromRGB(0xececec);
        [self.contentView addSubview:_lineView];
        
        [_lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return _lineView;
}
@end
