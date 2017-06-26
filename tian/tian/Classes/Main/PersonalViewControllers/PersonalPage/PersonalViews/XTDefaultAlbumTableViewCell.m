//
//  XTDefaultAlbumTableViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-6-24.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTDefaultAlbumTableViewCell.h"
#define SeparateLineHeight 0.5

@implementation XTDefaultAlbumTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self separateLineView];
        [self headPortraitImageView];
        [self titleLabel];
    }
    
    return self;
}

- (UIImageView *)headPortraitImageView{
    if (!_headPortraitImageView) {
        _headPortraitImageView = [UIImageView new];
        _headPortraitImageView.image = [UIImage imageNamed:@"upload_defaultAlbum"];
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
        _titleLabel.text = @"无（暂时不建图册）";
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headPortraitImageView.centerY);
            make.left.equalTo(_headPortraitImageView.right).offset(@20);
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
            make.left.bottom.right.equalTo(self.contentView);
            make.height.equalTo(SeparateLineHeight);
        }];
    }
    
    return _separateLineView;
}

@end
