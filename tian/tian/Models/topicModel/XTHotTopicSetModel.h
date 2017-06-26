//
//  XTHotTopicSetModel.h
//  tian
//
//  Created by loong on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
@class XTUserInfo;
@interface XTHotTopicSetModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,strong)NSNumber *itemID;

@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSString *des;

@property(nonatomic,strong)NSArray *users;

@property(nonatomic,strong)NSArray *images;

@property(nonatomic,strong)NSNumber *userCount;

@property(nonatomic,strong)NSURL *image;


@property(nonatomic,strong)NSNumber *postCount;

@property(nonatomic,strong)NSNumber *viewCount;

@property(nonatomic,strong)NSNumber *favoritesCount;

@property(nonatomic,strong)XTUserInfo *user;


@end
