//
//  XTGuideImageCreateCell.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/8.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTGuideImageCreateCell.h"
#import "XTSingleSelectionController.h"
#define kKnownButtonWidth (87.0 * kRation)
#define kKnownButtonHeight (24.0 * kRation)
@interface XTGuideImageCreateCell ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIButton *clearButton;
@end

@implementation XTGuideImageCreateCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addConstraints];
    }
    return self;
}
-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}
-(void)addConstraints{
    @weakify(self);
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.left).with.offset(@0);
        make.bottom.equalTo(self.bottom).with.offset(@0);
        make.top.equalTo(self.top).with.offset(@0);
        make.right.equalTo(self.right).with.offset(@0);
    }];
    [self.clearButton makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.top).with.offset(@0);
        make.right.equalTo(self.right).with.offset(@0);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [self.knownButton makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.bottom).with.offset(@(-12.0 / 667.0 * kUploadScreenHight));
        make.centerX.equalTo(self.centerX).with.offset(@0);
        make.width.equalTo(@(kKnownButtonWidth));
        make.height.equalTo(@(kKnownButtonHeight));
    }];
}
-(void)closeClick{
    if (self.closeClickBlock) {
        self.closeClickBlock();
    }
}
#pragma mark 懒加载
-(UIImageView *)imageView{
    if (_imageView == nil) {
        UIImageView *imageView= [[UIImageView alloc] init];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}
-(UIButton *)clearButton{
    if (_clearButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"GuideCreateImageClose"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:btn];
        _clearButton = btn;
    }
    return _clearButton;
}
-(UIButton *)knownButton{
    if (_knownButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"GuideCreateImageKnown"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"GuideCreateImageKnown_sel"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [btn sizeToFit];
        [self addSubview:btn];
        _knownButton = btn;
    }
    return _knownButton;
}
@end
