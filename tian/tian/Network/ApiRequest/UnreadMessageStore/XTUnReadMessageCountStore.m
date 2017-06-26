//
//  XTUnReadMessageCountStore.m
//  StarPicture
//
//  Created by cc on 15-3-31.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTUnReadMessageCountStore.h"
#import "XTHTTPRequestOperationManager.h"

@implementation XTUnReadMessageCountStore
+(XTUnReadMessageCountStore*)getInstance
{
    static XTUnReadMessageCountStore *sharedMySingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMySingleton = [[self alloc]init];
    });
    return sharedMySingleton;
}
- (id)init
{
    self = [super init];
    if (self) {
        _unreadInfo = [[XTUnReadInfo alloc]init];
    }
    return self;
}
- (id)fetchUnReadMessageCount
{
//    NSDictionary *parameters = @{
//                                 @"uid":[NSNumber numberWithLong:1],
//                                 @"offset":[NSNumber numberWithInteger:1],
//                                 @"size":[NSNumber numberWithInteger:1]
//                                 };
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:UnReadCount_key parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error=nil;
        _unreadInfo = [MTLJSONAdapter modelOfClass:[XTUnReadInfo class] fromJSONDictionary:responseObject error:&error];
        if (!error) {
            NSLog(@"消息未读数获取成功===%@",responseObject);
            [[NSNotificationCenter defaultCenter] postNotificationName:kUnReadCountKey object:_unreadInfo];
            if (_unreadInfo.notifyCount>0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationkey object:_unreadInfo];
            }else if (_unreadInfo.msgCount>0)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kMessagekey object:_unreadInfo];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"消息未读数获取失败");
    }];
}
@end
