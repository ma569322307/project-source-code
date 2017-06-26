//
//  NSError+XTError.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/2/12.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, ErrorType) {
    ErrorTypeNetwork = 0,   //网络错误
    ErrorTypeServer         //服务器错误
};

@interface NSError (XTError)

//服务器操作失败
+ (NSError *)xtServerFailureWithJSON:(NSDictionary *)jsonDic;

//错误信息（文案）
- (NSString *)xtErrorMessage;

//错误类型
- (ErrorType)errorType;
@end
