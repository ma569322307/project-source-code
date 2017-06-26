//
//  XTHotLicksRecsInfo.h
//  tian
//
//  Created by 尚毅 杨 on 15/5/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@interface XTHotLicksRecsInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSURL *bigCover;
@property (nonatomic, strong) NSURL *cover;
@property (nonatomic, assign) NSInteger dateCreated;
//推荐类型，"series"为系列内容，"sole"为独家原创，"artist"为专属艺人内容，"hotevent"为热点事件，"hottopicset"为热点话题集合，"vuser"为大V宣传
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
