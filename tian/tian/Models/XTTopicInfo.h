//
//  XTTopicInfo.h
//  tian
//
//  Created by 曹亚云 on 15-7-2.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
#import "XTUserInfo.h"
@interface XTTopicInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) double stateID;               //状态ID
@property (nonatomic, assign) double created;               //创建时间
@property (nonatomic, copy)   NSString *topicDescription;   //话题描述
@property (nonatomic, assign) NSInteger favorited;          //是否被我收藏
@property (nonatomic, assign) NSInteger favoritesCount;     //收藏数
@property (nonatomic, assign) double topicId;               //话题ID
@property (nonatomic, copy)   NSURL *imageUrl;              //话题头图
@property (nonatomic, assign) NSInteger postCount;          //帖子数
@property (nonatomic, copy)   NSArray *tags;                //话题标签数组
@property (nonatomic, copy)   NSString *title;              //话题标题
@property (nonatomic, strong) XTUserInfo *user;             //话题作者
@property (nonatomic, assign) NSInteger viewCount;          //浏览数
@property (nonatomic, copy)   NSString *type;               //数据类型

@end
