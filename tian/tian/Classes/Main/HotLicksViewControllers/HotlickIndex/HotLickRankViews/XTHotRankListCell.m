//
//  XTHotfourTableViewCell.m
//  tian
//
//  Created by yyt on 15-6-8.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHotRankListCell.h"
#import <UIImageView+WebCache.h>
#import "XTLickRankingModel.h"
@implementation XTHotRankListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self separateLineView];
        [self headPortraitImageView];
        [self VImageView];
        [self nickNameLabel];
        [self levelLabel];
        [self titleLabel];
        [self contentLabel];
        [self valueLabel];
        
        //设置label1的content hugging 为1000
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired
                                       forAxis:UILayoutConstraintAxisHorizontal];
        
        //设置label1的content compression 为250
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

- (UIImageView *)headPortraitImageView{
    if (!_headPortraitImageView) {
        _headPortraitImageView = [UIImageView new];
        _headPortraitImageView.image = [UIImage imageNamed:@"HomePage_headImage_default"];
        _headPortraitImageView.layer.cornerRadius = 32.5f;
        _headPortraitImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_headPortraitImageView];
        
        [_headPortraitImageView makeConstraints:^(MASConstraintMaker *make) {
            //make.centerY.equalTo(self.contentView).offset(-self.separateLineView.h)
            make.top.left.equalTo(self.contentView).offset(@10);
            make.bottom.equalTo(_separateLineView.top).offset(@-10);
            make.width.equalTo(_headPortraitImageView.height);
        }];
    }
    
    return _headPortraitImageView;
}

- (UIImageView *)VImageView{
    if (!_VImageView) {
        _VImageView = [UIImageView new];
        _VImageView.image = [UIImage imageNamed:@"HomePage_V"];
        [self.contentView addSubview:_VImageView];
        
        [_VImageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@18);
            make.bottom.equalTo(_headPortraitImageView);
            make.right.equalTo(_headPortraitImageView).offset(@-5);
        }];
    }
    
    return _VImageView;
}

- (UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [UILabel new];
        _nickNameLabel.text = @"流苏的旧时光";
        _nickNameLabel.font = [UIFont boldSystemFontOfSize:12];
        _nickNameLabel.textColor = UIColorFromRGB(0x595959);
        [self.contentView addSubview:_nickNameLabel];
        
        [self.nickNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.headPortraitImageView.centerY).offset(@-3);
            make.left.equalTo(_headPortraitImageView.right).offset(@20);
            make.height.equalTo(@15);
        }];
    }
    
    return _nickNameLabel;
}

- (UILabel *)levelLabel{
    if (!_levelLabel) {
        _levelLabel = [UILabel new];
        _levelLabel.backgroundColor = UIColorFromRGB(0xffe707);
        _levelLabel.layer.cornerRadius = 5.0f;
        _levelLabel.layer.masksToBounds = YES;
        _levelLabel.text = @"lv7";
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        _levelLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_levelLabel];
        
        [self.levelLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_nickNameLabel.centerY);
            make.left.equalTo(self.nickNameLabel.right).offset(@5);
            make.size.equalTo(CGSizeMake(30, 10));
        }];
    }
    
    return _levelLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor = UIColorFromRGB(0x595959);
        _titleLabel.text = @"贡献声望:";
        [self.contentView addSubview:_titleLabel];
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headPortraitImageView.centerY).offset(@3);
            make.left.equalTo(_nickNameLabel);
            make.height.equalTo(@10);
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
        [self.contentView addSubview:_contentLabel];
        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel);
            make.left.equalTo(_titleLabel.right).offset(@5);
            make.height.equalTo(@15);
        }];
    }
    return _contentLabel;
}

- (UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [UILabel new];
        _valueLabel.font = [UIFont systemFontOfSize:28];
        _valueLabel.text = @"1";
        _valueLabel.textAlignment = NSTextAlignmentRight;
        _valueLabel.textColor = UIColorFromRGB(0x595959);
        [self.contentView addSubview:_valueLabel];
        
        [_valueLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headPortraitImageView);
            make.left.greaterThanOrEqualTo(_contentLabel.right).offset(@5);
            make.right.equalTo(self.contentView).offset(@-20);
            make.height.equalTo(@25);
        }];
    }
    return _valueLabel;
}

- (UIView *)separateLineView{
    if (!_separateLineView) {
        _separateLineView = [UIView new];
        _separateLineView.backgroundColor = UIColorFromRGB(0xececec);
        [self.contentView addSubview:_separateLineView];
        
        [_separateLineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.equalTo(@0.5);
        }];
    }
    
    return _separateLineView;
}

- (void)awakeFromNib {
    // Initialization code
    
}
-(void)configWithHotFourTbaleViewCell:(NSIndexPath *)index andmodel:(XTLickRankingModel *)model{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    CLog(@"------%@",model);

    
    [self.headPortraitImageView an_setImageWithURL:[NSURL URLWithString:model.HeadImg] placeholderImage:nil];
    //判断如果是大用户就显示大v用户的标志图片
    if (model.vuser == YES) {
        self.VImageView.image = [UIImage imageNamed:@"HomePage_V"];
    }else{
        self.VImageView.image = nil;
    }
    self.nickNameLabel.text = model.userName;
    
    self.levelLabel.text = [NSString stringWithFormat:@"lv%@",@(model.level)];
    self.valueLabel.text = [NSString stringWithFormat:@"%@",@(index.row+1)];
    if (index.row == 0) {
        self.valueLabel.textColor = UIColorFromRGB(0xff9600);
    }else if (index.row == 1){
        self.valueLabel.textColor = UIColorFromRGB(0xffc000);
    }else if (index.row == 2){
        self.valueLabel.textColor = UIColorFromRGB(0xffd34b);
    }else{
        self.valueLabel.textColor = UIColorFromRGB(0x9a9a9a);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
