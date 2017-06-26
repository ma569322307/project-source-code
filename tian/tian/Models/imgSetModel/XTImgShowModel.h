//
//  XTImgShowModel.h
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
@class XTUserInfo;
@class XTAlbumModel;
@interface XTImgShowModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,strong)NSNumber *itemID;

@property(nonatomic,strong)NSString *text;

@property(nonatomic,strong)NSString *picUrl;

@property(nonatomic,strong)NSNumber *width;

@property(nonatomic,strong)NSNumber *height;

@property(nonatomic,strong)NSNumber *createdAt;

@property(nonatomic,strong)NSNumber *commentCount;//评论数

@property(nonatomic,strong)NSNumber *commendCount; //点赞数

@property(nonatomic,strong)NSArray *commendUsers;//最近点赞的人的列表

@property(nonatomic)BOOL commended;

@property(nonatomic,strong)XTUserInfo *user;

@property(nonatomic,strong)XTAlbumModel *album;

@property(nonatomic,strong)NSArray *tags;

@property(nonatomic)BOOL favorited;

@property(nonatomic,strong)NSArray *artists;

@property(nonatomic,strong)NSArray *tagsNew;


//-(NSArray *)collocateTags;




@end
