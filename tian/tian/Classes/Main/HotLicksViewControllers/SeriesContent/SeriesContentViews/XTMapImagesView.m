//
//  XTMapImagesView.m
//  tian
//
//  Created by loong on 15/7/11.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTMapImagesView.h"

#import "XTMapImageView.h"
#import "XTCommonMacro.h"


@interface XTMapImagesView ()<XTMapImageViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContraints;

@end

@implementation XTMapImagesView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setArr:(NSArray *)aArr{
    _arr  = aArr;
    
    CGFloat width = (SCREEN_SIZE.width - 26 - 50) / 3;
    
    CGFloat y = 0;
    for (int i = 0; i < self.arr.count; i ++) {
        CGFloat x = ((i) % 3) * (width + 12);
        y = ((i) / 3) * (width + 34);
        
        id obj = self.arr[i];
        XTMapImageView *view = [[XTMapImageView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = i;
        view.model = obj;
        view.delegate = self;
        [self addSubview:view];
        
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(x);
            make.top.offset(y);
            make.height.equalTo(width + 22);
            make.width.equalTo(width);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [view addGestureRecognizer:tap];
    }
    
    self.heightContraints.constant = y + width + 22;
    
    [self layoutIfNeeded];
}

#pragma -mark XTMapImageViewDelegate
-(void)imageLoadFinishWithIndex:(NSInteger)idx{
    if (idx == 0) {
        if([self.delegate respondsToSelector:@selector(firstImageLoadFinish)]){
            [self.delegate firstImageLoadFinish];
        }
    }
}

-(void)tapGesture:(UITapGestureRecognizer *)tap{

    
    NSInteger index = tap.view.tag;
    if ([self.delegate respondsToSelector:@selector(mapImageViewTapActionWith:)]) {
        [self.delegate mapImageViewTapActionWith:index];
    }
}



@end
