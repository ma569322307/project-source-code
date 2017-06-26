//
//  XTTopicListModel.h
//  tian
//
//  Created by yyt on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@interface XTTopicListModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger topicId;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
+ (NSDictionary *)JSONKeyPathsByPropertyKey;
@end
