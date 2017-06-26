//
//  XTHomePageStore.m
//  tian
//
//  Created by cc on 15/6/13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHomePageStore.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTImageInfo.h"
#import "XTAttentionInfo.h"
#import "XTPostInfo.h"
#import "XTOriginalViewController.h"
#import "XTHotLicksRecsInfo.h"
#import "XTHotLicksCommonArtistInfo.h"
#import "XTOriginalViewController.h"
#define XTPublicListKey @"public/list.json"
#define XTLikeListKey @"picture/sub/list/hot.json"
#define XTAttentionKey @"statuses/timeline/friends2.json"
#define XTTUJILIST @"picture/list/status.json"//图集列表的接口
#define XTDUJIAYUANCHUANG @"operate/show/sole.json"//独家原创的接口
#define XTTUCEList @"picture/album/show.json"//获取单个图册详细信息
#define XTLAbLEPHOTOSLIST @"picture/list/tag.json"//获取打开了某个标签的图片列表
#define XTPhotosListSpecialURL @"http://papi.yinyuetai.com/operate/album/detail.json"

@implementation XTHomePageStore
/*
 *标签列表
 */
- (id)fetchHomePagePicListWith:(NSString *)labelString andMaxId:(NSInteger)maxId CompletionBlock:(void(^)(id picList, NSError *error))block{
    
    NSDictionary *paramDic =@{@"tag":labelString,@"maxId":@(maxId)};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTLAbLEPHOTOSLIST parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        NSArray *dataArray = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:responseObject error:&err];
        if (block) {
            block(dataArray,err);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

/*
 *精选图集
 */
-(id)fetchHomePagePhotoListSpecial:(NSInteger)albumId andOffset:(NSInteger)offset andSize:(NSInteger)size CompletionBlock:(void(^)(id piclist, NSError *error))block{
    NSDictionary *paramDic = @{@"albumId":[NSNumber numberWithInteger:albumId],
                               @"offset":[NSNumber numberWithInteger:offset],
                               @"size":[NSNumber numberWithInteger:size]};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTPhotosListSpecialURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *err = nil;
        NSArray *dataArray = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:[responseObject objectForKey:@"pics"] error:nil];
        
        if (block) {
            block(dataArray,err);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];

}
/*
 *图集列表
 */
- (id)fetchHomePagePicListWith:(NSInteger)pictureId CompletionBlock:(void(^)(id picList, NSError *error))block{
    NSDictionary *paramOtherDic = @{@"sid":[NSString stringWithFormat:@"%ld",pictureId]};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTTUJILIST parameters:paramOtherDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *err = nil;
        NSArray *dataArray = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:responseObject error:&err];
        if (block) {
            block(dataArray,err);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}
/*
 *独家原创
 */
-(id)fetchHomePageOriginalId:(NSInteger)pid andOffSet:(NSInteger)offset andSize:(NSInteger)size CompletionBlock:(void(^)(id picList, NSError *error))block{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    NSDictionary *paramOriginalDic = @{@"id":[NSNumber numberWithInteger:pid]};
    
    return [manager GET:XTDUJIAYUANCHUANG parameters:paramOriginalDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *err = nil;
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        NSDictionary *albumDic= [responseObject objectForKey:@"album"];
        NSDictionary *basicDic = [responseObject objectForKey:@"basic"];
        NSArray *picturesArr = [responseObject objectForKey:@"pictures"];
        
        if (basicDic&&picturesArr&&albumDic) {
            [tempArray addObject:albumDic];
            [tempArray addObject:basicDic];
            [tempArray addObjectsFromArray:picturesArr];
        }
            if (block) {
                block(tempArray, err);
            }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if(block){
            block(nil,error);
        }
    }];
}

- (id)fetchHomePagePicListWithoffset:(NSInteger)offset size:(NSInteger)size CompletionBlock:(void(^)(id picList, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"offset":[NSNumber numberWithInteger:offset],
                                 @"size" :[NSNumber numberWithInteger:size]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTPublicListKey parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        
        NSArray *dataArray = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:responseObject error:&err];

        if (block) {
            block(dataArray,err);
        }
        NSLog(@"广场图片获取的信息==%@",operation.responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"广场图片失败结果==%@",error);
        if (block) {
            block(nil,error);
        }
    }];

}
- (id)fetchHomePageLikeListWithoffset:(NSInteger)offset size:(NSInteger)size CompletionBlock:(void(^)(id picList,BOOL subArtist, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"offset":[NSNumber numberWithInteger:offset],
                                 @"size" :[NSNumber numberWithInteger:size]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTLikeListKey parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        
        NSArray *dataArray = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:[responseObject objectForKey:@"hotPictureModels"] error:&err];
        BOOL subartist = [[responseObject objectForKey:@"subArtist"] boolValue];
        
        if (block) {
            block(dataArray,subartist,err);
        }
        NSLog(@"广场喜欢获取的信息==%@",operation.responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"广场喜欢失败结果==%@",error);
        if (block) {
            block(nil,NO,error);
        }
    }];
    
}

- (id)fetchHomePageAttentionListWithmaxId:(NSInteger)maxId sinceId:(NSInteger)sinceId size:(NSInteger)size CompletionBlock:(void(^)(id picList, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"maxId":[NSNumber numberWithInteger:maxId],
                                 @"sinceId" :[NSNumber numberWithInteger:size],
                                 @"size" :[NSNumber numberWithInteger:size]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTAttentionKey parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        NSArray *objectArray = [NSArray arrayWithArray:responseObject];
        NSMutableArray *tempArray  = [NSMutableArray array];
        /*@property (nonatomic, assign) double stateID;               //状态ID
         @property (nonatomic, assign) double postId;
         @property (nonatomic, assign) double topicId;
         @property (nonatomic, strong) XTTopicInfo *topic;
         @property (nonatomic, assign) BOOL top;
         @property (nonatomic, copy)   NSArray *images;
         @property (nonatomic, copy)   NSString *postDescription;
         @property (nonatomic, strong) XTUserInfo *user;
         @property (nonatomic, assign) NSInteger commentCount;
         @property (nonatomic, assign) NSInteger commendCount;
         @property (nonatomic, assign) NSInteger shareCount;
         @property (nonatomic, assign) double created;
         @property (nonatomic, copy)   NSString *type;*/
        for (NSDictionary *objecDic in objectArray) {
            NSString *type = [objecDic objectForKey:@"type"];
            double stateId = [[objecDic objectForKey:@"id"] doubleValue];
            XTPostInfo *postInfo = [[XTPostInfo alloc]init];
            postInfo.stateID = stateId;
            postInfo.type = type;
            
            
            if ([type isEqualToString:@"pic"]) {
                NSError *err = nil;
                XTImageInfo *imgInfo = [MTLJSONAdapter modelOfClass:[XTImageInfo class] fromJSONDictionary:[objecDic objectForKey:@"data"] error:&err];
                postInfo.images = [NSArray arrayWithObject:imgInfo];
                postInfo.created = [[[objecDic objectForKey:@"data"] objectForKey:@"createdAt"] doubleValue];
                XTUserInfo *userInfo = [MTLJSONAdapter modelOfClass:[XTUserInfo class] fromJSONDictionary:[[objecDic objectForKey:@"data"] objectForKey:@"user"] error:&err];
                postInfo.user = userInfo;
                postInfo.commendCount = [imgInfo.commendCount integerValue];
                postInfo.commentCount = [imgInfo.commentCount integerValue];
                postInfo.postDescription = [[objecDic objectForKey:@"data"] objectForKey:@"text"];
                
                [tempArray addObject:postInfo];
                
            }else if ([type isEqualToString:@"status"])
            {
                NSError *err = nil;
                NSArray *imgsArray = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:[[objecDic objectForKey:@"data"] objectForKey:@"images"] error:&err];
                XTUserInfo * userInfo = [MTLJSONAdapter modelOfClass:[XTUserInfo class] fromJSONDictionary:[[objecDic objectForKey:@"data"] objectForKey:@"user"] error:&err];
                postInfo.images = imgsArray;
                postInfo.user = userInfo;
                postInfo.created = [[[objecDic objectForKey:@"data"] objectForKey:@"createdAt"] doubleValue];
                postInfo.commendCount = [[[objecDic objectForKey:@"data"] objectForKey:@"commendCount"] doubleValue];
                postInfo.commentCount = [[[objecDic objectForKey:@"data"] objectForKey:@"commentCount"] doubleValue];
                postInfo.postDescription = [[objecDic objectForKey:@"data"] objectForKey:@"text"];
                
                [tempArray addObject:postInfo];
            }else if ([type isEqualToString:@"post"])
            {
                NSError *err = nil;
                XTPostInfo *newPostInfo = [MTLJSONAdapter modelOfClass:[XTPostInfo class] fromJSONDictionary:[objecDic objectForKey:@"data"] error:&err];
                newPostInfo.stateID = postInfo.stateID;
                newPostInfo.type = postInfo.type;
                
                [tempArray addObject:newPostInfo];
                
            }else if ([type isEqualToString:@"topic"])
            {
                NSError *err = nil;
                XTTopicInfo *topicInfo = [MTLJSONAdapter modelOfClass:[XTTopicInfo class] fromJSONDictionary:[objecDic objectForKey:@"data"] error:&err];
                topicInfo.stateID = postInfo.stateID;
                topicInfo.type = postInfo.type;
                [tempArray addObject:topicInfo];
                
            }else if ([type isEqualToString:@"favorite"])
            {
                
            }
        }
        
//        NSArray *dataArray = [MTLJSONAdapter modelsOfClass:[XTAttentionInfo class] fromJSONArray:[responseObject objectForKey:@"statuses"] error:&err];
//        
        
        if (block) {
            block(tempArray,err);
        }
        NSLog(@"广场关注获取的信息==%@",operation.responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"广场关注失败结果==%@",error);
        if (block) {
            block(nil,error);
        }
    }];
    
}

@end
