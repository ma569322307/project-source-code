//
//  XTAlbumCollectionViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-6-5.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTAlbumCollectionViewCell.h"
#define cellWidth (SCREEN_SIZE.width-48)/2
#define thumbImageWidth (cellWidth-15)/4
#define labelHeight (cellWidth*0.5-thumbImageWidth-15)/2
@implementation XTAlbumCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        self.backgroundColor = [UIColor whiteColor];
        [self firstCoverImageView];
        [self secondCoverImageView];
        [self thirdCoverImageView];
        [self fourthCoverImageView];
        [self fifthCoverImageView];
        [self albumNameLabel];
        [self imageCountLabel];
        [self albumCreateDateLabel];
        [self secretIconImageView];
        
        //设置label1的content hugging 为1000
        [_albumNameLabel setContentHuggingPriority:UILayoutPriorityRequired
                                           forAxis:UILayoutConstraintAxisHorizontal];
        
        //设置label1的content compression 为250
        [_albumNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                                         forAxis:UILayoutConstraintAxisHorizontal];
        //设置右边的label2的content hugging 为1000
        [_imageCountLabel setContentHuggingPriority:UILayoutPriorityRequired
                                            forAxis:UILayoutConstraintAxisHorizontal];
        //设置右边的label2的content compression 为1000
        [_imageCountLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                          forAxis:UILayoutConstraintAxisHorizontal];
        
    }
    return self;
}

- (UIImageView *)firstCoverImageView{
    if (!_firstCoverImageView) {
        _firstCoverImageView = [UIImageView new];
        _firstCoverImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_firstCoverImageView];
        [_firstCoverImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(@3);
            make.right.equalTo(self).offset(@-3);
            make.height.equalTo(_firstCoverImageView.width);
        }];
    }
    return _firstCoverImageView;
}

- (UIImageView *)secondCoverImageView{
    if (!_secondCoverImageView) {
        _secondCoverImageView = [UIImageView new];
        _secondCoverImageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_secondCoverImageView];
        [_secondCoverImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_firstCoverImageView.bottom).offset(@3);
            make.left.equalTo(_firstCoverImageView);
            make.size.equalTo(CGSizeMake(thumbImageWidth, thumbImageWidth));
        }];
    }
    return _secondCoverImageView;
}

- (UIImageView *)thirdCoverImageView{
    if (!_thirdCoverImageView) {
        _thirdCoverImageView = [UIImageView new];
        _thirdCoverImageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_thirdCoverImageView];
        [_thirdCoverImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_firstCoverImageView.bottom).offset(@3);
            make.left.equalTo(self.secondCoverImageView.right).offset(@3);
            make.size.equalTo(CGSizeMake(thumbImageWidth, thumbImageWidth));
        }];
    }
    return _thirdCoverImageView;
}

- (UIImageView *)fourthCoverImageView{
    if (!_fourthCoverImageView) {
        _fourthCoverImageView = [UIImageView new];
        _fourthCoverImageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_fourthCoverImageView];
        [_fourthCoverImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_firstCoverImageView.bottom).offset(@3);
            make.left.equalTo(self.thirdCoverImageView.right).offset(@3);
            make.size.equalTo(CGSizeMake(thumbImageWidth, thumbImageWidth));
        }];
    }
    return _fourthCoverImageView;
}

- (UIImageView *)fifthCoverImageView{
    if (!_fifthCoverImageView) {
        _fifthCoverImageView = [UIImageView new];
        _fifthCoverImageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_fifthCoverImageView];
        [_fifthCoverImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_secondCoverImageView);
            make.right.equalTo(_firstCoverImageView);
            make.size.equalTo(CGSizeMake(thumbImageWidth, thumbImageWidth));
        }];
    }
    return _fifthCoverImageView;
}

- (UILabel *)albumNameLabel{
    if (!_albumNameLabel) {
        _albumNameLabel = [UILabel new];
        _albumNameLabel.backgroundColor = [UIColor clearColor];
        _albumNameLabel.text = @"默认相册";
        _albumNameLabel.font = [UIFont systemFontOfSize:11];
        _albumNameLabel.textColor = UIColorFromRGB(0x595959);
        [self.contentView addSubview:_albumNameLabel];
        [_albumNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_secondCoverImageView.bottom).offset(@5);
            make.left.equalTo(_secondCoverImageView.left);
            make.height.equalTo(labelHeight);
        }];
    }
    return _albumNameLabel;
}

- (UILabel *)imageCountLabel{
    if (!_imageCountLabel) {
        _imageCountLabel = [UILabel new];
        _imageCountLabel.backgroundColor = [UIColor clearColor];
        _imageCountLabel.textAlignment = NSTextAlignmentRight;
        _imageCountLabel.text = @"（221）";
        _imageCountLabel.font = [UIFont systemFontOfSize:11];
        _imageCountLabel.textColor = UIColorFromRGB(0x7f7f7f);
        [self.contentView addSubview:_imageCountLabel];
        [_imageCountLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_secondCoverImageView.bottom).offset(@5);
            make.left.equalTo(_albumNameLabel.right).offset(@3);
            make.right.equalTo(_firstCoverImageView.right);
            make.height.equalTo(labelHeight);
        }];
    }
    return _imageCountLabel;
}

- (UILabel *)albumCreateDateLabel{
    if (!_albumCreateDateLabel) {
        _albumCreateDateLabel = [UILabel new];
        _albumCreateDateLabel.backgroundColor = [UIColor clearColor];
        _albumCreateDateLabel.text = @"2015-06-09";
        _albumCreateDateLabel.font = [UIFont systemFontOfSize:10];
        _albumCreateDateLabel.textColor = UIColorFromRGB(0x7f7f7f);
        [self.contentView addSubview:_albumCreateDateLabel];
        [_albumCreateDateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(labelHeight);
            make.left.equalTo(_firstCoverImageView);
            make.top.equalTo(_albumNameLabel.bottom).offset(@2);
        }];
    }
    return _albumCreateDateLabel;
}

- (UIImageView *)secretIconImageView{
    if (!_secretIconImageView) {
        _secretIconImageView = [UIImageView new];
        _secretIconImageView.backgroundColor = [UIColor clearColor];
        _secretIconImageView.image = [UIImage imageNamed:@"homePage_secretIcon"];
        [self.contentView addSubview:_secretIconImageView];
        [_secretIconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@9);
            make.left.equalTo(_albumCreateDateLabel.right).offset(@5);
            make.right.equalTo(_firstCoverImageView);
            make.centerY.equalTo(_albumCreateDateLabel);
        }];
    }
    return _secretIconImageView;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
