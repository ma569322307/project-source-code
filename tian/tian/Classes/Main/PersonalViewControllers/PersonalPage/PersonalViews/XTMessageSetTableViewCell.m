//
//  XTMessageSetTableViewCell.m
//  StarPicture
//
//  Created by 曹亚云 on 15-3-13.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTMessageSetTableViewCell.h"

@implementation XTMessageSetTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self buttomLineView];
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
