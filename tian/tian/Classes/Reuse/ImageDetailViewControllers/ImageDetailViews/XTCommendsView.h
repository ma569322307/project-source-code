//
//  XTCommendsView.h
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTCommendsView;
@class XTUserInfo;
@protocol XTCommendsViewDelegate <NSObject>

@optional
-(void)commendActionWith:(XTCommendsView *)commendView;

-(void)cancelCommendActionWith:(XTCommendsView *)commendView;

-(void)tapActionWith:(XTUserInfo*)userInfo;

@end



@interface XTCommendsView : UIView

@property(nonatomic,strong)NSMutableArray *commendUsers;

@property(nonatomic)BOOL favorited;

@property(nonatomic,weak)IBOutlet id <XTCommendsViewDelegate> delegate;

@property(nonatomic) NSInteger commendCount;

-(NSArray *)commendSuccess;

-(void)cancelCommendSuccess;

@end
