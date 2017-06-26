//
//  XTBlacklistStore.h
//  StarPicture
//
//  Created by cc on 15-3-4.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BlackList_key @"picture/sub/blacklist.json"
#define BlackListAdd_key @"public/blacklist/add.json"
#define BlackListDel_key @"public/blacklist/del.json"

/**
 *  屏蔽相关
 */
@interface XTBlacklistStore : NSObject
@property (nonatomic, strong)NSMutableArray *userBlackListArray;
+ (instancetype)sharedManager;
/**
 *  所有屏蔽艺人
 *
 *  @param uid  登陆用户id
 *
 */
- (id)fetchBlackListWith:(NSInteger)uid
         completionBlock:(void(^)(NSArray* blacklist, NSError *error)) block;
/**
 *  添加屏蔽艺人
 *
 *  @param bid   被屏蔽的id
 *  @param type  1 艺人 2 标签
 *
 */
- (id)blackListAddWith:(NSInteger)bid
                          type:(NSInteger)type
               completionBlock:(void(^)(id result,NSError *error))block;
/**
 *  删除屏蔽艺人
 *
 *  @param bid   id
 *  @param type  1 艺人 2 标签
 *
 */
- (id)blackListDelWith:(NSInteger)bid
                          type:(NSInteger)type
               completionBlock:(void(^)(id result,NSError *error))block;
@end
