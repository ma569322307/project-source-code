//
//  XTImgCommentsCell.h
//  tian
//
//  Created by loong on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTCommentItemModel;

@protocol XTCommentsCellDelegate <NSObject>
@optional
-(void)commentCommendActionWith:(NSInteger)index;

-(void)cancelCommentCommendActionWith:(NSInteger)index;

-(void)tapAvatarImgViewActionWith:(id)userInfo;

@end


@interface XTCommentsCell : UITableViewCell

-(void)congfigurateDataWithModel:(XTCommentItemModel *)model;

-(void)congfigurateDataWithSeriesContentModel:(XTCommentItemModel *)model;

@property(nonatomic)NSInteger index;

@property(nonatomic,weak)id <XTCommentsCellDelegate> delegate;

@property(nonatomic,weak)id controllerDelegate;

@end
