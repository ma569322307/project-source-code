//
//  XTPrivateMessageDataSource.h
//  tian
//
//  Created by cc on 15/7/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

#define XTPMessageDataSource [XTPrivateMessageDataSource shareInstance]

@interface XTPrivateMessageDataSource : NSObject<RCIMUserInfoDataSource,RCIMGroupInfoDataSource>

+(XTPrivateMessageDataSource *) shareInstance;

///*
// * 当客户端第一次运行时，调用此接口初始化所有用户数据。
// */
//- (void)cacheAllData:(void(^)())completion;
///*
// * 获取所有用户信息
// */
//- (NSArray *)getAllUserInfo:(void(^)())completion;
///*
// * 获取所有群组信息
// */
//- (NSArray *)getAllGroupInfo:(void(^)())completion;
/*
 * 获取所有好友信息
 */
//- (NSArray *)getAllFriends:(void(^)())completion;
@end
