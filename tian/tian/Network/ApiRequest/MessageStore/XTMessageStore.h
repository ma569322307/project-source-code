//
//  XTMessageStore.h
//  tian
//
//  Created by cc on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTMessageInfo.h"
#import "XTNotifyInfo.h"
@interface XTMessageStore : NSObject
/**
 *   获取消息列表
 */
- (id)fetchMessageListWithoffset:(NSInteger)offset size:(NSInteger)size CompletionBlock:(void(^)(id notiList, NSError *error))block;
/**
 *   获取通知列表
 */
- (id)fetchNotifyMessageListWithoffset:(NSInteger)offset size:(NSInteger)size CompletionBlock:(void(^)(id notiList, NSError *error))block;
/**
 *   删除通知
 */
- (id)deleteNotifyMessageWithId:(NSInteger)nId CompletionBlock:(void(^)(BOOL success, NSError *error))block;
/**
 *   获取用户信息
 */
- (id)fetchUserInfoWithUserId:(NSString *)uid onlyGet:(NSArray *)onlyGetArray CompletionBlock:(void(^)(id userinfo, NSError *error))block;

/**
 *   友尽列表
 */
- (id)fetchBlackListWithUserId:(NSString *)uid offset:(NSInteger)offset size:(NSInteger)size CompletionBlock:(void(^)(id userinfoArr, NSError *error))block;
/**
 *   恢复友尽好友
 */
- (id)removeShipendWithId:(long)shipendId CompletionBlock:(void(^)(BOOL removeSuccess,NSError *error))block;
/**
 *   添加友尽用户
 */
- (id)addShipendWithSelfUserId:(long )selfUserid FriendUserId:(long)friendUserId CompletionBlock:(void(^)(BOOL addSuccess,NSError *error))block;


/**
 *   获取融云Token
 */
- (id)fetchRongTokenWithUserId:(NSString *)uid userName:(NSString *)uName CompletionBlock:(void(^)(id token, NSError *error))block;
@end
