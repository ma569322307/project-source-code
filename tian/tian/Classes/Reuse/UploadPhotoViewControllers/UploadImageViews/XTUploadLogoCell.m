//
//  XTUploadLogoCell.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUploadLogoCell.h"
#import "XTUploadSingleModel.h"
#import "XTLocalImageStoreManage.h"

@interface XTUploadLogoCell ()
// imageView
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation XTUploadLogoCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        self.imageView = imageView;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        
        // 添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteItem:)];
        longPress.minimumPressDuration = 1;
        [self addGestureRecognizer:longPress];
    }
    return self;
}

-(void)deleteItem:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(uploadLogoCellDidLongPressed:)]) {
            [self.delegate uploadLogoCellDidLongPressed:self];
        }
    }
}

-(void)setSingle:(XTUploadSingleModel *)single{
    _single = single;
    // 获取图片
    self.imageView.image = [[XTLocalImageStoreManage sharedLocalImageStoreManage] logoImageWithName:single.smallName];
}

-(void)layoutSubviews{
    self.imageView.frame = self.bounds;
}
@end
