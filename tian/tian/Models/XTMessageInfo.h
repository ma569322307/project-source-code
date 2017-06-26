//
//  XTMessageInfo.h
//  tian
//
//  Created by cc on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
#import "XTUserInfo.h"
#import "XTMessageInfo_followInfo.h"
#import "XTImageInfo.h"
#import "XTMessageInfo_postCommentInfo.h"
#import "XTMessageInfo_picCommendInfo.h"
#import "XTMessageInfo_postCommendInfo.h"
@interface XTMessageInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) long id;
@property (nonatomic, strong) NSString *source;//消息来源，picCommend（图片点赞）,picComment（图片评论）,award（打赏）,follow（被关注）,postCommend（帖子被点赞）,postComment（帖子被评论）
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) id data;//扩展字段,可以为空，根据source来确定data的实际意义，比如照片点赞消息，包括点赞的图片（pic）， 点赞用户数（userCount），点赞用户列表（userList）

@property (nonatomic, assign) double createdAt;

@property (nonatomic, strong) XTUserInfo *user;

@property (nonatomic, strong) NSString * dataId;
@end
