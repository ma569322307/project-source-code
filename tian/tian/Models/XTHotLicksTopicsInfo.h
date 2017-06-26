//
//  XTHotLicksTopicsInfo.h
//  tian
//
//  Created by cc on 15/5/26.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "MTLModel.h"
#import "XTUserInfo.h"
#import <Mantle.h>
#import "XTTopicInfo.h"
/*created = 1432611196000;
 favoritesCount = 0;
 id = 119716048;
 image = "http://img1.yytcdn.com/others/admin/150518/0/-M-b4b56e356b862f8334d62b6ceb6356ea.png";
 postCount = 0;
 title = 111111111111111;
 uid = 35119334;
 viewCount = 2;*/
@interface XTHotLicksTopicsInfo : MTLModel<MTLJSONSerializing>

//基础字段
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) long created;
@property (nonatomic, assign) NSInteger favoritesCount;
@property (nonatomic, assign) NSInteger postCount;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, strong) NSURL *image;

//热舔瀑布流
@property (nonatomic, strong) XTTopicInfo *topic;

//详情字段
@property (nonatomic, strong) XTUserInfo *user;
@property (nonatomic, copy)   NSString *topicDescription;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, copy)   NSArray *favoriteUsers;
@property (nonatomic, copy) NSArray *tags;

//搜索字段
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *userHeadImg;
/*
 @property (nonatomic, assign) NSInteger id;
 @property (nonatomic, assign) NSInteger viewCount;
 @property (nonatomic, assign) NSInteger favoritesCount;
 @property (nonatomic, assign) NSInteger replaceid;
 @property (nonatomic, strong) NSString *title;
 @property (nonatomic, copy) NSString *image;
 @property (nonatomic, assign)NSInteger created;
 @property (nonatomic, assign) NSInteger favorited;
 @property (nonatomic, copy) NSString *descrip;
 @property (nonatomic, assign) NSInteger PostCount;
 @property (nonatomic, strong) NSArray *tags;
 @property (nonatomic,strong) NSDictionary *user;
 @property (nonatomic, assign) NSInteger type;
 @property (nonatomic, copy) NSString *nickName;
 @property (nonatomic, assign) NSInteger uid;
 @property (nonatomic, assign) NSInteger level;
 @property (nonatomic, copy) NSString *smallAvatar;
 @property (nonatomic, copy) NSString *bigAvatar;
 */

@end
