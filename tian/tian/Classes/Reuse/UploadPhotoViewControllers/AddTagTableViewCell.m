//
//  AddTagTableViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-5-26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "AddTagTableViewCell.h"
@interface AddTagTableViewCell()<HKKTagWriteViewDelegate>
@property (nonatomic, strong) UIView *lineView;
@end


@implementation AddTagTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self titleLabel];
        [self placeholderLabel];
        [self tagView];
        [self addTagBtn];
        [self lineView];
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(BOOL)type{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.isUnableEdit = type;
        [self titleLabel];
        [self placeholderLabel];
        [self tagView];
        [self addTagBtn];
        [self lineView];
    }
    return self;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"标签";
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = UIColorFromRGB(0x595959);        
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(@5);
            make.bottom.equalTo(self.lineView.top).offset(@-5);
            make.left.equalTo(self.contentView).offset(@10);
        }];
    }
    return _titleLabel;
}

- (HKKTagWriteView *)tagView{
    if (!_tagView) {
        _tagView = [[HKKTagWriteView alloc] initWithFrame:CGRectMake(0, 0, 0, 42)
                                              withTagType:self.isUnableEdit ? XTTagTypeReadOnlyHorizontalText : XTTagTypeHorizontalText];
        _tagView.tagBackgroundColor = [UIColor clearColor];
        _tagView.delegate = self;
        [self.contentView addSubview:_tagView];
        
        [_tagView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.height.equalTo(self.titleLabel);
            make.left.equalTo(self.titleLabel.right).offset(@5);
            make.right.equalTo(self.addTagBtn.left).offset(@-5);
        }];
    }
    return _tagView;
}

- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [UILabel new];
        _placeholderLabel.text = @"贴几个标签吧.";
        _placeholderLabel.font = [UIFont systemFontOfSize:12];
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        [self.tagView addSubview:_placeholderLabel];
        
        [_placeholderLabel makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.tagView);
        }];
    }
    return _placeholderLabel;
}

- (UIButton *)addTagBtn{
    if (!_addTagBtn) {
        _addTagBtn = [[UIButton alloc] init];
        [_addTagBtn setImage:[UIImage imageNamed:@"upload_addTag"] forState:UIControlStateNormal];
        [_addTagBtn setImage:[UIImage imageNamed:@"upload_addTag_sel"] forState:UIControlStateHighlighted];
        [_addTagBtn addTarget:self action:@selector(addTagBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addTagBtn];
        
        [_addTagBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.width.height.equalTo(@35);
            make.right.equalTo(self.contentView).offset(@-10);
        }];
    }
    return _addTagBtn;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = UIColorFromRGB(0xececec);
        [self.contentView addSubview:_lineView];
        
        [_lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return _lineView;
}

- (void)addTagBtn:(UIButton *)button{
    if (self.delegate) {
        [_delegate clickAddTagBtn:button];
    }
}

- (void)tagWriteView:(HKKTagWriteView *)view didRemoveTag:(NSString *)tag{
    if (self.delegate) {
        [_delegate tagWriteView:view didRemoveTag:tag];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
