//
//  XTMapImagesView.h
//  tian
//
//  Created by loong on 15/7/11.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XTMapImagesViewDelegate <NSObject>

-(void)mapImageViewTapActionWith:(NSInteger)index;

-(void)firstImageLoadFinish;

@end


@interface XTMapImagesView : UIView


@property(nonatomic,strong)NSArray *arr;

@property(nonatomic,weak)id <XTMapImagesViewDelegate> delegate;


@end
