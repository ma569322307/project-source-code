//
//  XTTopicDetailModel.h
//  tian
//
//  Created by loong on 15/7/7.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
@class XTUserInfo;
//@class XTImgsModel;

@interface XTTopicDetailModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSString *des;

@property(nonatomic,strong)NSArray *images;

@property(nonatomic,strong)NSArray *commendUsers;

@property(nonatomic,strong)XTUserInfo *user;

//@property(nonatomic)BOOL favorited;

@property(nonatomic)NSInteger commendCount;

@property(nonatomic,strong)NSNumber *commentCount;

@property(nonatomic)BOOL commended;

@property(nonatomic,strong)NSNumber *created;

@end
