//
//  XTPostTopicImageCell.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTPostTopicImageCell.h"
#import "XTLocalPhotoModel.h"
#import "XTLocalImageStoreManage.h"

@interface XTPostTopicImageCell ()
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation XTPostTopicImageCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MyTopicAddPhoto"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        self.imageView = imageView;
        [self.contentView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

-(void)setModel:(XTLocalPhotoModel *)model{
    _model = model;
    if (model.smallName == nil) {
        // 添加cell
        self.imageView.image = [UIImage imageNamed:@"MyTopicAddPhoto"];
    }else{
        self.imageView.image = [[XTLocalImageStoreManage sharedLocalImageStoreManage] photoImageWithName:model.smallName];
    }
}
@end
