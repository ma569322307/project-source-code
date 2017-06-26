//
//  XTImgDetailView.h
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTImgShowModel;
@class XTUserInfo;

@protocol XTImgDetailViewDelegate <NSObject>
@optional
-(void)tapImgActionWith:(NSInteger )index andRect:(NSValue *)rect andImage:(UIImage *)image;

-(void)shareBtnAction:(UIImage *)image andModel:(XTImgShowModel *)model;

-(void)avatarImgViewTapAction:(XTUserInfo *)userInfo;


@end

@interface XTImgDetailView : UIView


@property(nonatomic,strong)XTImgShowModel *model;

@property(nonatomic,weak)id  delegate;



@property(nonatomic)NSInteger index;

@property(nonatomic)NSInteger commentsCount;


@property(nonatomic,strong)NSURL *placeholderImageURL;

@property(nonatomic,copy)void(^imgLoadFinish)(UIImage *image);

@end
