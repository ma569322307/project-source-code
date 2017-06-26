//
//  XTMessageInfo_postCommentInfo.h
//  tian
//
//  Created by cc on 15/7/7.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
#import "XTTopicInfo.h"
#import "XTImageInfo.h"
@interface XTMessageInfo_postCommentInfo : MTLModel<MTLJSONSerializing>
@property(nonatomic, strong) NSArray * images;
@property(nonatomic, strong) XTTopicInfo *topic;
@property(nonatomic, strong) XTUserInfo *user;
@property(nonatomic, strong) NSString *pDescription;
@property(nonatomic, assign) NSInteger shareCount;
@property(nonatomic, assign) NSInteger commentCount;
@property(nonatomic, assign) NSInteger commendCount;
@property(nonatomic, assign) NSInteger top;
@property(nonatomic, assign) NSInteger cid;
@property(nonatomic, assign) long created;
@property(nonatomic, assign) long id;
@property(nonatomic, assign) long topicId;




@end
