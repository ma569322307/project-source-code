//
//  XTImgSetView.h
//  tian
//
//  Created by loong on 15/7/7.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XTImgSetViewDelegate <NSObject>

-(void)imgSetViewTapActionWith:(NSInteger)index andRect:(NSValue *)rectValue;

@end

@interface XTImgSetView : UIView


@property(nonatomic,strong)NSArray *arr;

//@property(nonatomic)CGFloat height;

@property(nonatomic,weak) id <XTImgSetViewDelegate> delegate;

@end
