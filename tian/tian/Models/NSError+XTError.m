//
//  NSError+XTError.m
//  StarPicture
//
//  Created by 尚毅 杨 on 15/2/12.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "NSError+XTError.h"
#import <AFNetworking.h>

NSString * const YYTErrorDomain = @"YYTErrorDomain";
NSString * const YYTServerErrorDomain = @"YYTServerErrorDomain";

@implementation NSError (XTError)

/*
 "display_message" = "\U8bf7\U767b\U5f55\U540e\U8fdb\U884c\U64cd\U4f5c";
 error = "Not login";
 "error_code" = 20006;
 request = "/box/subscribe/me.json";
 */
+ (NSError *)xtServerFailureWithJSON:(NSDictionary *)jsonDic
{
    NSString *message = jsonDic[@"display_message"];
    NSNumber *errorCode = jsonDic[@"error_code"];
    NSString *error = jsonDic[@"error"];
    NSString *path = jsonDic[@"request"];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
    [userInfo setValue:error forKey:NSLocalizedFailureReasonErrorKey];
    [userInfo setValue:message forKey:NSLocalizedDescriptionKey];
    [userInfo setValue:path forKey:NSURLErrorFailingURLStringErrorKey];
    
    return [NSError errorWithDomain:YYTServerErrorDomain code:[errorCode integerValue] userInfo:userInfo];
}

- (NSString *)xtErrorMessage
{
    if ([self.domain isEqualToString:YYTErrorDomain]) {
        return self.localizedDescription;
    }
    else if ([self.domain isEqualToString:AFURLRequestSerializationErrorDomain]) {
        NSDictionary *userInfo = self.userInfo;
        NSString *suggestion = [userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
        NSError *parseErr = nil;
        NSDictionary *newSuggestion = [NSJSONSerialization JSONObjectWithData:[suggestion dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&parseErr];
        if (parseErr) {
            return self.localizedDescription;
        }
        return [newSuggestion objectForKey:@"display_message"];
    }
    else if ([self.domain isEqualToString:NSURLErrorDomain]) {
        NSString *message = [self URLErrorMessage];
        return message;
    }
    
    return self.localizedDescription;
}

- (ErrorType)errorType {
    if ([self.domain isEqualToString:NSURLErrorDomain]) {
        return ErrorTypeNetwork;
    }else {
        return ErrorTypeServer;
    }
}

- (NSString *)URLErrorMessage
{
    NSString *message = nil;
    switch (self.code) {
        case kCFURLErrorTimedOut:
            message = @"请求超时，请检查您的网络连接";
            break;
        case kCFURLErrorCannotConnectToHost:
            message = @"无法连接服务器";
            break;
        case kCFURLErrorNotConnectedToInternet:
            message = @"无法连接到网络";
            break;
        default:
            message = [NSString stringWithFormat:@"网络错误：%d",(int)self.code];
            break;
    }
    
    return message;
}
@end
