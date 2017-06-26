//
//  XTAttentionInfo.h
//  tian
//
//  Created by cc on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
#import "XTAttentionImageInfo.h"
@interface XTAttentionInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) double createdAt;
@property (nonatomic, assign) long id;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) long userId;
@property (nonatomic, strong) NSString *userNickName;
@property (nonatomic, strong) NSURL *userSmallAvatar;
@property (nonatomic, assign) NSInteger commendCount;
@property (nonatomic, assign) NSInteger commentCount;
@end
