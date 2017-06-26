//
//  XTBaseModel.m
//  tian
//
//  Created by huhuan on 15/8/21.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTBaseModel.h"
#import "XTApiClient.h"

@implementation XTBaseModel

- (NSString *)baseUrl {
    return @"http://papi.yinyuetai.com/";
}

- (NSString *)requestUrl {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

//+ (NSURLSessionDataTask *)getRequestWithParameters:(NSDictionary *)parameters handleBlock:(DataHandleBlock)block {
//    return [apiClient GET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
//        [self hanleResponseData:responseObject handleBlock:block];
//        
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [self failureError:error task:task handleBlock:block];
//    }];
//}
//
//+ (NSURLSessionDataTask *)postRequestWithParameters:(NSDictionary *)parameters handleBlock:(DataHandleBlock)block {
//    return [apiClient POST:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
//        [self hanleResponseData:responseObject handleBlock:block];
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [self failureError:error task:task handleBlock:block];
//    }];
//}
//
//+ (void)failureError:(NSError *)error task:(NSURLSessionDataTask *)task handleBlock:(DataHandleBlock)block{
//    NSLog(@"%@",error.userInfo);
//    if (block) {
//        block(nil,error);
//    }
//    
//}
//
//
//+ (void)hanleResponseData:(id)responseObject
//              handleBlock:(DataHandleBlock)block  {
//    NSError *err = nil;
//    
//
//}

@end
