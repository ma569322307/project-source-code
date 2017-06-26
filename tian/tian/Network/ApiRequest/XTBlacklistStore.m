//
//  XTBlacklistStore.m
//  StarPicture
//
//  Created by cc on 15-3-4.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTBlacklistStore.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTBlackListInfo.h"
#import "XTOrderArtist.h"

@implementation XTBlacklistStore
+ (instancetype)sharedManager
{
    static XTBlacklistStore *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[self alloc] init];
    });
    return _shareManager;
}
- (id)init {
    self = [super init];
    if (self) {
        _userBlackListArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}
- (id)fetchBlackListWith:(NSInteger)uid
         completionBlock:(void(^)(NSArray* blacklist, NSError *error)) block
{
    NSDictionary *parameters = @{
                                 @"uid":[NSNumber numberWithInteger:uid],
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:BlackList_key parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"屏蔽艺人列表成功结果==%@",responseObject);
        
        NSError *artistsError = nil;
        NSArray *artistsArray = [MTLJSONAdapter modelsOfClass:[XTOrderArtist class] fromJSONArray:responseObject error:&artistsError];

        if (block) {
            block(artistsArray,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"屏蔽艺人列表失败结果==%@",error);
        
        if (block) {
            block(nil,error);
        }
    }];
}
- (id)blackListAddWith:(NSInteger)bid
                          type:(NSInteger)type
               completionBlock:(void(^)(id result,NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"id":[NSNumber numberWithInteger:bid],
                                 @"type":[NSNumber numberWithInteger:type]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:BlackListAdd_key parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"add屏蔽艺人成功结果==%@",responseObject);
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"add屏蔽艺人失败结果==%@",error);
        if (block) {
            block(nil,error);
        }
    }];
}
- (id)blackListDelWith:(NSInteger)bid
                          type:(NSInteger)type
               completionBlock:(void(^)(id result,NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"ids":[NSNumber numberWithInteger:bid],
                                 @"type":[NSNumber numberWithInteger:type]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager POST:BlackListDel_key parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"del屏蔽艺人成功结果==%@",responseObject);
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"del屏蔽艺人失败结果==%@",error);
        if (block) {
            block(nil,error);
        }
    }];
    
}

@end
