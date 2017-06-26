//
//  XTMessageStore.m
//  tian
//
//  Created by cc on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTMessageStore.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTMessageInfo.h"
#import "XTNotifyInfo.h"
#import "XTSearchUserModel.h"
#import "XTMessageInfo_awardInfo.h"

#define XTMessageListKey   @"notifies/message.json"
#define XTNotifyListKey    @"notifies/notify.json"
#define XTNotifyDeleteKey  @"notifies/delete.json"
#define XTGetUserInfo      @"account/user/show.json"
#define XTShipendListKey   @"shipend/list.json"
#define XTRemoveShipendKey @"shipend/remove.json"
#define XTAddShipendKey    @"shipend/add.json"
#define XTGetRongTokenKey  @"yim/user/token.json"

@implementation XTMessageStore
- (id)fetchMessageListWithoffset:(NSInteger)offset size:(NSInteger)size CompletionBlock:(void(^)(id notiList, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"offset":[NSNumber numberWithInteger:offset],
                                 @"size" :[NSNumber numberWithInteger:size]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTMessageListKey parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        
        NSArray *dataArray = [MTLJSONAdapter modelsOfClass:[XTMessageInfo class] fromJSONArray:[responseObject objectForKey:@"notifications"] error:&err];
        //消息来源，picCommend（图片点赞）,picComment（图片评论）,award（打赏）,follow（被关注）,postCommend（帖子被点赞）,postComment（帖子被评论）
        for (XTMessageInfo * messageInfo in dataArray) {
            if ([messageInfo.source isEqualToString:@"picCommend"]) {
                NSError *terror = nil;
                XTMessageInfo_picCommendInfo *picCommendInfo = [MTLJSONAdapter modelOfClass:[XTMessageInfo_picCommendInfo class] fromJSONDictionary:messageInfo.data error:&terror];
                messageInfo.data = picCommendInfo;
            }else if ([messageInfo.source isEqualToString:@"picComment"])
            {
                NSError *terror= nil;
                XTImageInfo *imageinfo = [MTLJSONAdapter modelOfClass:[XTImageInfo class] fromJSONDictionary:[messageInfo.data objectForKey:@"pic"] error:&terror];
                imageinfo.cid = [[messageInfo.data objectForKey:@"cid"] integerValue];
                messageInfo.data = imageinfo;
            }else if ([messageInfo.source isEqualToString:@"award"])
            {
                NSError *terror= nil;
                XTMessageInfo_awardInfo *awardInfo = [MTLJSONAdapter modelOfClass:[XTMessageInfo_awardInfo class] fromJSONDictionary:messageInfo.data error:&terror];
                messageInfo.data = awardInfo;
            }else if ([messageInfo.source isEqualToString:@"follow"])
            {
                NSError *terror = nil;
                XTMessageInfo_followInfo *followInfo = [MTLJSONAdapter modelOfClass:[XTMessageInfo_followInfo class] fromJSONDictionary:messageInfo.data error:&terror];
                messageInfo.data = followInfo;
            }else if ([messageInfo.source isEqualToString:@"postCommend"])
            {
                NSError *terror = nil;
                XTMessageInfo_postCommendInfo *postCommendinfo = [MTLJSONAdapter modelOfClass:[XTMessageInfo_postCommendInfo class] fromJSONDictionary:messageInfo.data error:&terror];
                messageInfo.data = postCommendinfo;
                
            }else if ([messageInfo.source isEqualToString:@"postComment"])
            {
                NSError * terror = nil;
                XTMessageInfo_postCommentInfo *postCommentinfo = [MTLJSONAdapter modelOfClass:[XTMessageInfo_postCommentInfo class] fromJSONDictionary:[messageInfo.data objectForKey:@"post"] error:&terror];
                postCommentinfo.cid = [[messageInfo.data objectForKey:@"cid"] integerValue];
                messageInfo.data = postCommentinfo;

            }
        }
        
        if (block) {
            block(dataArray,err);
        }
        NSLog(@"消息列表==%@",operation.responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"消息列表==%@",error);
        if (block) {
            block(nil,error);
        }
    }];
    
}


- (id)fetchNotifyMessageListWithoffset:(NSInteger)offset size:(NSInteger)size CompletionBlock:(void(^)(id notiList, NSError *error))block
{
   
    NSDictionary *parameters = @{
                                 @"offset":[NSNumber numberWithInteger:offset],
                                 @"size" :[NSNumber numberWithInteger:size]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTNotifyListKey parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        
        NSArray *dataArray = [MTLJSONAdapter modelsOfClass:[XTMessageInfo class] fromJSONArray:[responseObject objectForKey:@"notifications"] error:&err];


        if (block) {
            block(dataArray,err);
        }
        NSLog(@"通知消息列表==%@",operation.responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"通知消息列表==%@",error);
        if (block) {
            block(nil,error);
        }
    }];
    
}
- (id)deleteNotifyMessageWithId:(NSInteger)nId CompletionBlock:(void(^)(BOOL success, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"id":[NSNumber numberWithInteger:nId]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager POST:XTNotifyDeleteKey parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        
        BOOL deleteSuccess = [[responseObject objectForKey:@"success"] boolValue];
        
        if (block) {
            block(deleteSuccess,err);
        }
        NSLog(@"删除通知==%@",operation.responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"删除通知失败==%@",error);
        if (block) {
            block(NO,error);
        }
    }];
}


- (id)fetchUserInfoWithUserId:(NSString *)uid onlyGet:(NSArray *)onlyGetArray CompletionBlock:(void(^)(id userinfo, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"uid":uid,
                                 @"onlyGet":onlyGetArray
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTGetUserInfo parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        
        if (block) {
            block(responseObject,err);
        }
        NSLog(@"私信用户信息==%@",operation.responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"私信用户信息失败==%@",error);
        if (block) {
            block(nil,error);
        }
    }];

}


- (id)fetchBlackListWithUserId:(NSString *)uid offset:(NSInteger)offset size:(NSInteger)size CompletionBlock:(void(^)(id userinfoArr, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"userId":uid,
                                 @"offSet":[NSNumber numberWithInteger:offset],
                                 @"size" :[NSNumber numberWithInteger:size]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTShipendListKey parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        NSLog(@"友尽列表用户信息==%@",operation.responseObject);
        NSMutableArray *responseMuArray = [NSMutableArray array];
        
        NSArray *resultArray = [NSArray arrayWithArray:responseObject];
        for (NSDictionary *dic in resultArray) {
            XTSearchUserModel *userModel = [[XTSearchUserModel alloc]init];
            userModel.shipendId = [[dic objectForKey:@"id"] longValue];
            userModel.userId = [[dic objectForKey:@"userId"] longValue];
            userModel.name = [dic objectForKey:@"userName"];
            userModel.headImg = [dic objectForKey:@"userImg"];
            [responseMuArray addObject:userModel];
        }
        
        if (block) {
            block(responseMuArray,err);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"友尽列表信息失败==%@",error);
        if (block) {
            block(nil,error);
        }
    }];
}
- (id)removeShipendWithId:(long)shipendId CompletionBlock:(void(^)(BOOL removeSuccess,NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"id":[NSNumber numberWithLong:shipendId]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager POST:XTRemoveShipendKey parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL success = [responseObject objectForKey:@"success"];
        if (block) {
            block(success,nil);
        }
        NSLog(@"移除友尽列表==%@",operation.responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"移除友尽列表失败==%@",error);
        if (block) {
            block(nil,error);
        }
    }];
}
- (id)addShipendWithSelfUserId:(long )selfUserid FriendUserId:(long)friendUserId CompletionBlock:(void(^)(BOOL addSuccess,NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"userId":[NSNumber numberWithLong:selfUserid],
                                 @"friendUserId":[NSNumber numberWithLong:friendUserId]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager POST:XTAddShipendKey parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL success = [responseObject objectForKey:@"success"];
        if (block) {
            block(success,nil);
        }
        NSLog(@"添加友尽列表==%@",operation.responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"添加友尽列表失败==%@",error);
        if (block) {
            block(nil,error);
        }
    }];
    
}

- (id)fetchRongTokenWithUserId:(NSString *)uid userName:(NSString *)uName CompletionBlock:(void(^)(id token, NSError *error))block
{
    
    NSDictionary *parameters = @{
                                 @"userId":uid,
                                 @"username":uName
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTGetRongTokenKey parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"融云Token==%@",operation.responseObject);
        NSString *dataStr = [responseObject objectForKey:@"data"];
        
        NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        if (err) {
            CLog(@"解析失败——%@",err);
            if (block) {
                block(nil,err);
            }
        }else
        {
            if (block) {
                block([dic objectForKey:@"token"],nil);
            }
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"融云Token失败==%@",error);
        if (block) {
            block(nil,error);
        }
    }];

}
@end
