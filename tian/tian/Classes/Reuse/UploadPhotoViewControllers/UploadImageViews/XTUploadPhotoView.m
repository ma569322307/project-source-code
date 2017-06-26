//
//  XTUploadPhotoView.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUploadPhotoView.h"
#import "ZDStickerView.h"

@implementation XTUploadPhotoView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (ZDStickerView *stickerView in self.subviews) {
        [stickerView whetherHide:YES];
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }
}
@end
