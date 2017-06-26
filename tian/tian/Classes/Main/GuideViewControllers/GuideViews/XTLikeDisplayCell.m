//
//  XTLikeDisplayCell.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/6.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTLikeDisplayCell.h"
#import "XTSearchUserModel.h"
#import <Mantle/EXTScope.h>
#import "XTUserCollectionView.h"
#import "UIImageView+Custom.h"
@interface XTLikeDisplayCell ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIButton *clearButton;
@end

@implementation XTLikeDisplayCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addConstraints];
        self.contentView.clipsToBounds = NO;
    }
    return self;
}
-(void)addConstraints{
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    @weakify(self);
    [self.clearButton makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.top).with.offset(@-12);
        make.trailing.equalTo(self.trailing).with.offset(@16);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
}
-(void)setAddName:(NSString *)addName{
    _addName = addName;
    self.imageView.image = [UIImage imageNamed:addName];
    self.clearButton.hidden = YES;
}
-(void)setModel:(MTLModel *)model{
    _model = model;
    self.clearButton.hidden = NO;
    //设置头像
    //暂时换成
    XTSearchUserModel *sModel = (XTSearchUserModel *)model;
    [self.imageView showHeaderWithUrl:[NSURL URLWithString:[sModel headImg]]];
}
-(void)closeClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCancelLikeNotification object:self userInfo:@{
                                                                                                             @"model" : self.model,
                                                                                                             @"selected" : @(0)
                                                                                                             }];
    //删除模型
    if (self.cancelClick) {
        self.cancelClick(self.model);
    }
}
#pragma mark 懒加载
-(UIImageView *)imageView{
    if (_imageView == nil) {
        UIImageView *imageView= [[UIImageView alloc] init];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:imageView];
        _imageView = imageView;
        imageView.layer.cornerRadius = kItemWidthHeight * 0.5;
        imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}
-(UIButton *)clearButton{
    if (_clearButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"upload_delete"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"upload_delete_sel"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:btn];
        _clearButton = btn;
    }
    return _clearButton;
}
@end
