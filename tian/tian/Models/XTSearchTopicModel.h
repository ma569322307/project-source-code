//
//  XTSearchTopicModel.h
//  tian
//
//  Created by huhuan on 15/6/13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"

@interface XTSearchTopicModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) long topicId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) long topics;
@property (nonatomic, assign) long favorites;

@end
