//
//  XTHTTPRequestOperationManager.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/2/12.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

/**
 * XTHTTPRequestOperationManager:
 * 1.提供统一的网络请求接口
 * 2.检测可到达状态并发送通知
 * 3.提供后台需要的所有设备、网络、app信息
 */
@interface XTHTTPRequestOperationManager : NSObject

+ (instancetype)sharedManager;

//- (void)setBaseURL:(NSURL *)baseURL;

- (void)setHTTPRequestHeaderField:(NSString *)headerField
                            value:(NSString *)value;

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (BOOL)reachable;

@end
