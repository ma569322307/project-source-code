//
//  XTHTTPResponseError.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/2/12.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Mantle.h>

@interface XTHTTPResponseError : MTLModel<MTLJSONSerializing>
typedef NS_ENUM(NSUInteger, YYTHTTPResponseErrorCode) {
    YYTHTTPResponseErrorCodeInvalidToken = 20314,
    YYTHTTPResponseErrorCodeInvalidationUser = 20006
};
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSString *reason;
@property (nonatomic, readonly) NSNumber *code;
@property (nonatomic, readonly) NSURL *requestURL;

@end
