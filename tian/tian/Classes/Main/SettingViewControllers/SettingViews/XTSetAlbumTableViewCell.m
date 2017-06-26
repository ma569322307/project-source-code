//
//  XTSetAlbumTableViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-6-30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSetAlbumTableViewCell.h"
#import "XTUserStore.h"
#import "XTBindApnsStore.h"
#import "NSError+XTError.h"
@implementation XTSetAlbumTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self titleLabel];
        [self messageSwitch];
        [self buttomLineView];
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = UIColorFromRGB(0x595959);
        _titleLabel.text = @"设置为私密图册";
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

- (UISwitch *)messageSwitch{
    if (!_messageSwitch) {
        _messageSwitch = [UISwitch new];
        _messageSwitch.onTintColor = UIColorFromRGB(0xffe707);
        [self.contentView addSubview:_messageSwitch];
        
        [_messageSwitch makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).offset(@-10);
        }];
        [_messageSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _messageSwitch;
}
-(void)switchChange:(UISwitch *)sender{
    if (self.switchBlock) {
        self.switchBlock();
    }
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
