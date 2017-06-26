//
//  XTImgDetailRightItemsView.h
//  tian
//
//  Created by loong on 15/7/13.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XTImgDetailRightItemViewDelegate <NSObject>

@optional

-(void)downLoadAction:(UIImage *)image;

-(void)collectAction:(BOOL)selected;

-(void)addAction;

@end


@interface XTImgDetailRightItemsView : UIView


@property(nonatomic)BOOL favorited;

@property(nonatomic)BOOL downLoadEnabled;

@property(nonatomic,weak)UIImage *image;

@property(nonatomic,weak)id <XTImgDetailRightItemViewDelegate> delegate;

@end
