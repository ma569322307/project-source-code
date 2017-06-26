//
//  XTBatchSettingImageCell.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/14.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTBatchSettingImageCell.h"
#import "XTPictureInfoModel.h"
@interface XTBatchSettingImageCell ()
///背景图片
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation XTBatchSettingImageCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //自定义
        [self setup];
    }
    return self;
}
-(void)setup{
    [self.contentView addSubview:self.imageView];
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
-(void)setNeedButton:(BOOL)needButton{
    _needButton = needButton;
    //需要选择按钮
    if (needButton) {
        [self.contentView addSubview:self.selectButton];
        [self.selectButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(@-5);
        }];
    }
}
-(void)setModel:(XTPictureInfoModel *)model{
    _model = model;
    NSURL *imageURL = [NSURL URLWithString:model.picUrl];
    NSString *placeholderImageName = [NSString stringWithFormat:@"placeholderImage%ld",model.id%6+1];
    [self.imageView an_setImageWithURL:imageURL placeholderImage:UIIMAGE(placeholderImageName) options:SDWebImageRetryFailed];
    self.selectButton.selected = model.selected;
}
#pragma mark 懒加载
-(UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return _imageView;
}
-(UIButton *)selectButton
{
    if (_selectButton == nil) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"upload_check_default"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"upload_check_selected"] forState:UIControlStateSelected];
        _selectButton.userInteractionEnabled = NO;
    }
    return _selectButton;
}
@end
