//
//  XTHotLicksRankInfo.h
//  tian
//
//  Created by 尚毅 杨 on 15/5/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@interface XTHotLicksRankInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSURL *headImg;
@property (nonatomic, assign) NSInteger belongId;
//类型，"power"为舔力榜，"god"为舔神榜，"star"为明星榜，"topic"话题榜
@property (nonatomic, strong) NSString *type;

@end
