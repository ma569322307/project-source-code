//
//  XTMapImage.h
//  tian
//
//  Created by loong on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTMapImageViewModel;

@protocol XTMapImageViewDelegate <NSObject>

-(void)imageLoadFinishWithIndex:(NSInteger)idx;

@end


@interface XTMapImageView : UIView

@property(nonatomic,strong)XTMapImageViewModel *model;

@property(nonatomic,strong)UIImage *image;

@property(nonatomic,weak)id delegate;

@end
