//
//  XTAlbumListTableViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-6-24.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTAlbumListTableViewCell.h"

@implementation XTAlbumListTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.contentView.backgroundColor = [UIColor lightGrayColor];
        [self separateLineView];
        [self headPortraitImageView];
        [self titleLabel];
        [self contentLabel];
    }
    return self;
}

- (UIImageView *)headPortraitImageView{
    if (!_headPortraitImageView) {
        _headPortraitImageView = [UIImageView new];
        _headPortraitImageView.image = [UIImage imageNamed:@"HomePage_headImage_default"];
        _headPortraitImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_headPortraitImageView];
        
        [_headPortraitImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(@5);
            make.bottom.equalTo(_separateLineView.top).offset(@-5);
            make.width.equalTo(_headPortraitImageView.height);
        }];
    }
    
    return _headPortraitImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = UIColorFromRGB(0x595959);
        _titleLabel.text = @"贡献声望:";
        //_titleLabel.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.headPortraitImageView.centerY).offset(@-5);
            make.left.equalTo(_headPortraitImageView.right).offset(@20);
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
        _contentLabel.text = @"21213";
        //_contentLabel.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headPortraitImageView.centerY).offset(@5);
            make.left.equalTo(_titleLabel);
            make.height.equalTo(@15);
        }];
    }
    return _contentLabel;
}

- (UIView *)separateLineView{
    if (!_separateLineView) {
        _separateLineView = [UIView new];
        _separateLineView.backgroundColor = UIColorFromRGB(0xececec);
        [self.contentView addSubview:_separateLineView];
        
        [_separateLineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.equalTo(@8);
        }];
    }
    
    return _separateLineView;
}

@end
