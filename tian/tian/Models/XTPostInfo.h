//
//  XTPostInfo.h
//  tian
//
//  Created by huhuan on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
#import "XTUserInfo.h"
#import "XTTopicInfo.h"
@interface XTPostInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) double stateID;               //状态ID
@property (nonatomic, assign) double postId;
@property (nonatomic, assign) double topicId;
@property (nonatomic, strong) XTTopicInfo *topic;
@property (nonatomic, assign) BOOL top;
@property (nonatomic, copy)   NSArray *images;
@property (nonatomic, copy)   NSString *postDescription;
@property (nonatomic, strong) XTUserInfo *user;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger commendCount;
@property (nonatomic, assign) NSInteger shareCount;
@property (nonatomic, assign) NSInteger picCount;
@property (nonatomic, assign) double created;
@property (nonatomic, copy)   NSString *type;

@end
