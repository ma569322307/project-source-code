//
//  XTBaseModel.h
//  tian
//
//  Created by huhuan on 15/8/21.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "MTLModel.h"

typedef void(^DataHandleBlock)(id data,  NSError *error);

@interface XTBaseModel : MTLModel

+ (NSURLSessionDataTask *)getRequestWithParameters:(NSDictionary *)parameters handleBlock:(DataHandleBlock)block;

+ (NSURLSessionDataTask *)postRequestWithParameters:(NSDictionary *)parameters handleBlock:(DataHandleBlock)block;

@end
