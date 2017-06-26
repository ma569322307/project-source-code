//
//  XTParticipate.h
//  tian
//
//  Created by loong on 15/7/15.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTUserInfo;
@protocol XTParticipateViewDelegate <NSObject>

-(void)tapActionWith:(XTUserInfo *)userInfo;

@end


@interface XTParticipateView : UIView


@property(nonatomic,strong)NSArray *arr;

@property(nonatomic,strong)NSNumber *participateConut;

@property(nonatomic,weak)id <XTParticipateViewDelegate> delegate;
@end
