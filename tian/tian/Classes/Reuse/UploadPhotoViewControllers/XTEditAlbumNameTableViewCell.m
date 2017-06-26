//
//  XTEditAlbumNameTableViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-6-30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTEditAlbumNameTableViewCell.h"
@interface XTEditAlbumNameTableViewCell()<XTTextNumberControlViewDelegate>
@property (nonatomic, strong) UIView *lineView;
@end

@implementation XTEditAlbumNameTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self titleLabel];
        [self textView];
        //[self testTextView];
        [self lineView];
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"名称";
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = UIColorFromRGB(0x595959);
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(@5);
            make.left.equalTo(@10);
            make.bottom.equalTo(self.contentView).offset(@-10);
        }];
    }
    return _titleLabel;
}

- (XTTextNumberControlView *)textView {
    if (!_textView) {
        _textView = [[XTTextNumberControlView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = UIColorFromRGB(0x7b7b7b);
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.count = 30;
        _textView.countDelegate = self;
        [self.contentView addSubview:_textView];
        [_textView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).offset(@-10);
            make.left.equalTo(self.titleLabel.right).offset(@20);
            make.height.equalTo(@30);
        }];
    }
    return _textView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = UIColorFromRGB(0xececec);
        [self.contentView addSubview:_lineView];
        
        [_lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(@0.5);
        }];
    }
    return _lineView;
}

-(void)textNumberControlView:(XTTextNumberControlView *)textView
                numberOfText:(NSInteger)numberOfText
{
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
