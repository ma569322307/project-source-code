//
//  XTUploadSingleCell.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUploadSingleCell.h"
#import "XTUploadSingleModel.h"

@interface XTUploadSingleCell()
// imageView
@property (nonatomic, weak) UIImageView *imageView;
@end
@implementation XTUploadSingleCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        self.imageView = imageView;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

-(void)setSingle:(XTUploadSingleModel *)single{
    _single = single;
    // 获取图片
    self.imageView.image = [UIImage imageNamed:single.smallName];
}

@end
