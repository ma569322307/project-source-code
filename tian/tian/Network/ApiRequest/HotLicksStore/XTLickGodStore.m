//
//  XTLickGodStore.m
//  tian
//
//  Created by cc on 15/6/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTLickGodStore.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTLickGodPropsInfo.h"
#import "XTWaterFallPicInfo.h"

#define XTLickGodPropsKey @"picture/god/props.json"
#define XTLickGodShowPicKey @"picture/god/index.json"
#define XTGodPicturesListKey @"picture/god/list.json"
@implementation XTLickGodStore
- (id)fetchGodPropsWithOffset:(NSInteger)offset size:(NSInteger)size CompletionBlock:(void(^)(id hotLickInfo, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"offSet":[NSNumber numberWithInteger:offset],
                                 @"size" :[NSNumber numberWithInteger:size]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTLickGodPropsKey parameters:parameters success:^(AFHTTPRequestOperation *operation, id  responseObject) {
        NSError *err = nil;
        NSArray *resultArray = [MTLJSONAdapter modelsOfClass:[XTLickGodPropsInfo class] fromJSONArray:responseObject error:&err];

        if (block) {
            block(resultArray,err);
        }
        NSLog(@"舔神属性获取的信息==%@",operation.responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"舔神属性失败结果==%@",error);
        if (block) {
            block(nil,error);
        }
    }];

}

- (id)fetchGodPicsWithUserId:(NSInteger)uid offset:(NSInteger)offset size:(NSInteger)size fromId:(NSInteger)lastAlbumId CompletionBlock:(void(^)(id hotLickInfo, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"userId":[NSNumber numberWithInteger:uid],
                                 @"fromId":[NSNumber numberWithInteger:lastAlbumId],
                                 @"offSet":[NSNumber numberWithInteger:offset],
                                 @"size" :[NSNumber numberWithInteger:size]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTLickGodShowPicKey parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        NSArray *resultArr = [MTLJSONAdapter modelsOfClass:[XTWaterFallPicInfo class] fromJSONArray:responseObject error:&err];
        
        if (block) {
            block(resultArr,err);
        }
        NSLog(@"舔神推荐图片获取的信息==%@",operation.responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"舔神推荐图片失败结果==%@",error);
        if (block) {
            block(nil,error);
        }
    }];
    
}

//舔神分类
- (id)fetchGodPictureListWithPropId:(NSInteger)propId offset:(NSInteger)offset size:(NSInteger)size fromId:(NSInteger)lastAlbumId CompletionBlock:(void(^)(id hotLickInfo, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"propId":[NSNumber numberWithInteger:propId],
                                 @"fromId":[NSNumber numberWithInteger:lastAlbumId],
                                 @"offSet":[NSNumber numberWithInteger:offset],
                                 @"size" :[NSNumber numberWithInteger:size]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTGodPicturesListKey parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        NSArray *resultArr = [MTLJSONAdapter modelsOfClass:[XTWaterFallPicInfo class] fromJSONArray:responseObject error:&err];
        
        if (block) {
            block(resultArr,err);
        }
        NSLog(@"舔神分类获取的信息==%@",operation.responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"舔神分类失败结果==%@",error);
        if (block) {
            block(nil,error);
        }
    }];
    
}

@end

