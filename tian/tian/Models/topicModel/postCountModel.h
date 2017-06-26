//
//  postCountModel.h
//  tian
//
//  Created by kobe on 15/8/6.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "MTLModel.h"

@interface postCountModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger postCount;
+ (NSDictionary *)JSONKeyPathsByPropertyKey;

@end
