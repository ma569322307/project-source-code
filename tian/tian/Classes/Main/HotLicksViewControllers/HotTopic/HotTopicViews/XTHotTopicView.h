//
//  XTHotTopicView.h
//  tian
//
//  Created by loong on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTHotTopicSetModel;

@protocol XTHotTopicViewDelegate <NSObject>

-(void)hotTopicViewTapAction;

@end


@interface XTHotTopicView : UIView


@property(nonatomic,strong)XTHotTopicSetModel *model;

@property(nonatomic,weak) id delegate;

-(UIImage *)getShareImage;

@end
