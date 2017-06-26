//
//  XTTopicDetailView.h
//  tian
//
//  Created by loong on 15/7/7.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTTopicDetailModel;
@class XTUserInfo;
@protocol XTTopicDetailViewDelegate <NSObject>

-(void)tapAction;

-(void)topicDetailViewShareBtnAction:(XTTopicDetailModel *)model andImg:(UIImage *)image;

-(void)topicDetailViewAvatarViewTapActionWith:(XTUserInfo *)userInfo;

@end


@interface XTTopicDetailView : UIView

@property(nonatomic,strong)XTTopicDetailModel *model;

@property(nonatomic,weak) id delegate;

@property(nonatomic)NSInteger commentCount;
@end
