//
//  XTCommentItemModel.h
//  tian
//
//  Created by loong on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
@class XTUserInfo;

@interface XTCommentItemModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,strong)NSNumber *itemID;

@property(nonatomic,strong)NSNumber *sid;

@property (nonatomic, strong) NSString   *text;

@property (nonatomic, strong) NSNumber   *createdAt;

@property (nonatomic, strong) NSNumber   *commendCount;

@property (nonatomic, copy)   NSString   *headImg;

@property (nonatomic, assign) long       userId;

@property (nonatomic, copy)   NSString   *userName;

@property (nonatomic, assign) NSInteger  level;

@property (nonatomic, assign) BOOL       supported;

@property (nonatomic, strong) NSNumber *totalSupports;

@property (nonatomic, copy)   NSString   *supportType;

@property (nonatomic, strong) XTUserInfo *user;

@property (nonatomic,strong)NSString *originalCommentNickName;

@property (nonatomic)BOOL vuser;
@end
