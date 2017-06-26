//
//  XTPrivateMessageDataSource.m
//  tian
//
//  Created by cc on 15/7/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTPrivateMessageDataSource.h"
#import "XTMessageStore.h"

@implementation XTPrivateMessageDataSource
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        [[RCIM sharedRCIM] setGroupInfoDataSource:self];
        
    }
    return self;
}
+(XTPrivateMessageDataSource *) shareInstance
{
    static XTPrivateMessageDataSource * instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc]init];
    });
    return instance;
}

-(void) startServiceWithAppKey:(NSString *) appKey
                     userToken:(NSString *) userToken
{
    //初始化RongCloud SDK
    [[RCIM sharedRCIM] initWithAppKey:appKey];
    
    //登陆RongCloud Server
    [[RCIM sharedRCIM] connectWithToken:userToken
     
                                success:^(NSString *userId) {
                                    NSAssert(userId, @"connect success!");
                                } error:^(RCConnectErrorCode status) {
                                    
                                }
                         tokenIncorrect:^{
                             
                         }];
}


//-(void) syncGroups
//{
//    
//    //开发者调用自己的服务器接口获取所属群组信息，同步给融云服务器，也可以直接
//    //客户端创建，然后同步
//    [RCDHTTPTOOL getMyGroupsWithBlock:^(NSMutableArray *result) {
//        if ([result count]) {
//            //同步群组
//            [[RCIMClient sharedRCIMClient] syncGroups:result
//                                              success:^{
//                                                  //DebugLog(@"同步成功!");
//                                              } error:^(RCErrorCode status) {
//                                                  //DebugLog(@"同步失败!  %ld",(long)status);
//                                                  
//                                              }];
//        }
//    }];
//    
//    [RCDHTTPTOOL getAllGroupsWithCompletion:^(NSMutableArray *result) {
//        
//    }];
//    
//}

#pragma mark - GroupInfoFetcherDelegate
- (void)getGroupInfoWithGroupId:(NSString*)groupId completion:(void (^)(RCGroup*))completion
{
    if ([groupId length] == 0)
        return;
    
    //开发者调自己的服务器接口根据userID异步请求数据
//    [RCDHTTPTOOL getGroupByID:groupId
//            successCompletion:^(RCGroup *group)
//     {
//         completion(group);
//     }];
    
}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString*)userId completion:(void (^)(RCUserInfo*))completion
{
    CLog(@"调用了用户信息------------=======");
    RCUserInfo *uInfo;
    
//    if ([userId length] == 0)
//        return;
    
    __block RCUserInfo *weakUserinfo = uInfo;
    [[[XTMessageStore alloc]init] fetchUserInfoWithUserId:userId onlyGet:@[@"nickName",@"smallAvatar"] CompletionBlock:^(id userinfo, NSError *error) {
        if (!error) {
            if (userinfo) {
                weakUserinfo = [[RCUserInfo alloc]initWithUserId:userId name:[userinfo objectForKey:@"nickName"] portrait:[userinfo objectForKey:@"smallAvatar"]];
            }
            completion(weakUserinfo);
        }
        
    }];
    
    //    RCUserInfo *userInfo=[[RCDataBaseManager shareInstance] getUserByUserId:userId];
    //    if (userInfo==nil) {
    //开发者调自己的服务器接口根据groupID异步请求数据
    /*
    [RCDHTTPTOOL getUserInfoByUserID:userId
                          completion:^(RCUserInfo *user) {
                              if (user) {
                                  //[[RCDataBaseManager shareInstance] insertUserToDB:user];
                                  completion(user);
                              }
                          }];
     */
    //    }else
    //    {
    //        completion(userInfo);
    //    }
    //
}
@end
