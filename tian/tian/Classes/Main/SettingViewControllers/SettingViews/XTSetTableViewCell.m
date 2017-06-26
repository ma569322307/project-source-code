//
//  XTSetTableViewCell.m
//  StarPicture
//
//  Created by 曹亚云 on 15-2-24.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTSetTableViewCell.h"
#import "UIViewAdditions.h"
@implementation XTSetTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self titleLabel];
        [self contentLabel];
        [self arrowImageView];
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
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = UIColorFromRGB(0x595959);
        _titleLabel.text = @"声望";
        _titleLabel.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            //make.centerY.equalTo(self.contentView).offset(-self.buttomLineView.height);
            make.top.equalTo(self.contentView).offset(@5);
            make.bottom.equalTo(self.buttomLineView.top).offset(@-5);
            make.left.equalTo(self.contentView).offset(@10);
//            make.right.equalTo(self.contentLabel.left).offset(@-10);
//            make.width.equalTo(@50);
        }];
    }
    
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.backgroundColor = [UIColor redColor];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = UIColorFromRGB(0x7b7b7b);
        _contentLabel.text = @"苦国是奔黑暗者苦国";
        //_contentLabel.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel);
            make.left.equalTo(_titleLabel.right).offset(@100);
            //make.right.equalTo(self.arrowImageView.left).offset(@-20);
//            make.height.equalTo(@15);
//            make.width.equalTo(@50);
        }];
    }
    return _contentLabel;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.backgroundColor = [UIColor redColor];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
