//
//  XTImgDetailRightItemsView.m
//  tian
//
//  Created by loong on 15/7/13.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTImgDetailRightItemsView.h"

@interface XTImgDetailRightItemsView()


@property (weak, nonatomic) IBOutlet UIButton *favoritedBtn;


@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;

@end


@implementation XTImgDetailRightItemsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setFavorited:(BOOL)aFavorited{
    _favorited = aFavorited;
    self.favoritedBtn.selected = _favorited;
}

-(void)setDownLoadEnabled:(BOOL)aDownLoadEnabled{
    _downLoadEnabled = aDownLoadEnabled;
    self.downLoadBtn.enabled = _downLoadEnabled;
}


- (IBAction)downLoadBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(downLoadAction:)]) {
        [self.delegate downLoadAction:self.image];
    }
}


- (IBAction)collectBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(collectAction:)]) {
        [self.delegate collectAction:sender.selected];
    }
    
    sender.selected = !sender.selected;
}
- (IBAction)addBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addAction)]) {
        [self.delegate addAction];
    }
}


@end
