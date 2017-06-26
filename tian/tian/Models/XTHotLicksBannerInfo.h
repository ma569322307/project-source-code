//
//  XTHotLicksBannerInfo.h
//  tian
//
//  Created by 尚毅 杨 on 15/5/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@interface XTHotLicksBannerInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSURL *cover;
@property (nonatomic, assign) long id;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *title;

/**
 *   推荐类型，"series"为系列内容，"sole"为独家原创，"artist"为专属艺人内容，"hotevent"为热点事件，"hottopicset"为热点话题集合，"hottopic"为热点话题，"vuser"为大V宣传，"webview"为网页视图
 */
@property (nonatomic, strong) NSString *type;

@end
