//
//  XTHotLicksStore.m
//  tian
//
//  Created by 尚毅 杨 on 15/5/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHotLicksStore.h"
#import "XTHTTPRequestOperationManager.h"
#define XTOperatePageKey @"/operate/page.json"
#define XTOperateShowPicKey @"/operate/show/pic.json"

#define XTTopicPostsHotKey @"/topic/posts/hot.json"
@implementation XTHotLicksStore
- (id)fetchHotLicksInfoCompletionBlock:(void(^)(id hotLickInfo, NSError *error))block
{

    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTOperatePageKey parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSError *err = nil;
         NSLog(@"热舔获取的信息==%@",responseObject);
        XTHotLicksInfo *hotLicksInfo = [MTLJSONAdapter modelOfClass:[XTHotLicksInfo class] fromJSONDictionary:responseObject error:&err];
        
        if (block) {
            block(hotLicksInfo,err);
        }
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"热舔失败结果==%@",error);
        if (block) {
            block(nil,error);
        }
    }];

}

- (id)fetchShowPicWithRecId:(NSInteger)recid offset:(NSInteger)offset size:(NSInteger)size CompletionBlock:(void(^)(id hotLickInfo, NSError *error))block
{
        NSDictionary *parameters = @{
                                     @"recId" :[NSNumber numberWithInteger:recid],
                                     @"offset":[NSNumber numberWithInteger:offset],
                                     @"size" :[NSNumber numberWithInteger:size]
                                     };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTOperateShowPicKey parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *err = nil;
        
        XTHotLicksInfo *hotLicksInfo = [MTLJSONAdapter modelOfClass:[XTHotLicksInfo class] fromJSONDictionary:responseObject error:&err];
        if (block) {
            block(hotLicksInfo,err);
        }
        NSLog(@"推荐图片获取的信息==%@",operation.responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"推荐图片失败结果==%@",error);
        if (block) {
            block(nil,error);
        }
    }];
    
}
//热门帖子
- (id)fetchHotTopicListWithoffset:(NSInteger)offset size:(NSInteger)size CompletionBlock:(void(^)(id array, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"offset":[NSNumber numberWithInteger:offset],
                                 @"size" :[NSNumber numberWithInteger:size]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:XTTopicPostsHotKey parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        
        NSArray *dataArray = [MTLJSONAdapter modelsOfClass:[XTWaterFallPicInfo class] fromJSONArray:responseObject error:&err];
        if (block) {
            block(dataArray,err);
        }
        NSLog(@"热门帖子的信息==%@",operation.responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"热门帖子的失败结果==%@",error);
        if (block) {
            block(nil,error);
        }
    }];
    
}
@end
