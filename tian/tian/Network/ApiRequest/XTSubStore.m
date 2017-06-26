//
//  XTSubStore.m
//  StarPicture
//
//  Created by 尚毅 杨 on 15/2/13.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTSubStore.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTUserStore.h"
#import "XTUserAccountInfo.h"
#import "XTOrderArtist.h"
#import "XTFollowInfo.h"
#import "XTOrderUserInfo.h"
#import "XTAlbumInfo.h"
#import "XTUserFriendTrendsInfo.h"
#import "XTPlazaWaterFallInfo.h"
#import "XTImageInfo.h"
#import "XTUserFilesInfo.h"
#import "XTPostInfo.h"
#import "XTArtistImageInfo.h"
XTOrderArtist *parseArtist(NSDictionary *JSONArtist)
{
    NSError *error = nil;
    XTOrderArtist *artist = [MTLJSONAdapter modelOfClass:[XTOrderArtist class] fromJSONDictionary:JSONArtist error:&error];
    if (error) {
        [NSException raise:@"ParseOrderArtistItemsFailured" format:@"%@",[error localizedDescription]];
    }
    return artist;
}
@interface XTSubStore ()
{
    NSArray *(^getArtistItems)(NSArray *jsonArray);
}
@end
@implementation XTSubStore

- (id)init
{
    self = [super init];
    if (self) {
        getArtistItems = ^NSArray *(NSArray *jsonArray) {
            NSMutableArray *artistItems = nil;
            if (jsonArray && jsonArray.count > 0) {
                artistItems = [NSMutableArray array];
                for (NSDictionary *jsonArtist in jsonArray) {
                    XTOrderArtist *artist = parseArtist(jsonArtist);
                    [artistItems addObject:artist];
                }
            }
            return artistItems;
        };
    }
    return self;
}

/**
 *  获取订阅的艺人动态
 */
- (id)fetchArtistDynamicFromLocation:(NSInteger)location
                              length:(NSInteger)length
                     completionBlock:(void (^)(NSArray *followItems, NSError *error))block
{
    if ([[XTUserStore sharedManager] isLogin]) {
//        XTUserAccountInfo *user = [XTUserStore sharedManager].user;
        NSDictionary *parameters = @{
                                     @"offset": [NSNumber numberWithInteger:location],
                                     @"size": [NSNumber numberWithInteger:length]
                                     };
        XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
        return [manager GET:@"picture/sub/list/all.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"%@,   %@", operation.responseObject,responseObject);
            NSError *error = nil;
            NSArray *followItems = [MTLJSONAdapter modelsOfClass:[XTFollowInfo class] fromJSONArray:responseObject error:&error];
            if (block) block(followItems, error);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (block) block(nil, error);
        }];
    } else {
        return nil;
    }
}

- (id)fetchMySubArtistFromUserId:(NSInteger)userID
                        location:(NSInteger)location
                          length:(NSInteger)length
                 completionBlock:(void (^)(NSArray *artistItems, NSInteger totalCount, NSError *error))block
{
    if ([[XTUserStore sharedManager] isLogin]) {
        NSDictionary *parameters = @{
                                     @"uid":[NSNumber numberWithInteger:userID],
                                     @"offset": [NSNumber numberWithInteger:location],
                                     @"size": [NSNumber numberWithInteger:length]
                                     };
        XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
        return [manager GET:@"picture/sub/list/mysub.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"%@,   %@", operation.responseObject,responseObject);
            NSArray* dicArray = responseObject[@"simpleArtistSubModels"];
            NSInteger totalCount = [responseObject[@"totalCount"] integerValue];
            NSArray *artistItems = getArtistItems(dicArray);
            if (block) block(artistItems, totalCount, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (block) block(nil, 0, error);
        }];
    } else {
        return nil;
    }
}

/**
 *   获取某个艺人详情页
 */
- (id)fetchArtistShowFromArtistId:(NSInteger)artistLid
                  completionBlock:(void (^)(XTOrderArtist *artistInfo, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"artistId": [NSNumber numberWithInteger:artistLid],
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/sub/artist.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        XTOrderArtist *artist = [MTLJSONAdapter modelOfClass:[XTOrderArtist class] fromJSONDictionary:responseObject error:&error];
        if (block) block(artist, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchLatestUpdateFromArtistId:(NSInteger)artistId
                              maxId:(NSInteger)maxId
                            sinceId:(NSInteger)sinceId
                             length:(NSInteger)length
                    completionBlock:(void (^)(NSArray *imageItems, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"artistId": [NSNumber numberWithInteger:artistId],
                                 @"maxId": [NSNumber numberWithInteger:maxId],
                                 @"sinceId": [NSNumber numberWithInteger:sinceId],
                                 @"size": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"statuses/timeline/artist.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSError *error = nil;
        NSArray *trendsItems = [MTLJSONAdapter modelsOfClass:[XTArtistImageInfo class] fromJSONArray:responseObject error:&error];
        
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
        
        for (NSDictionary *dic in responseObject) {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            XTImageInfo *topicInfo = [MTLJSONAdapter modelOfClass:[XTImageInfo class] fromJSONDictionary:dataDic error:&error];
            [dataArray addObject:topicInfo];
        }
        
        for (int i = 0 ; i <[trendsItems count]; i++) {
            XTArtistImageInfo *info = [trendsItems objectAtIndex:i];
            info.imageInfo = (XTImageInfo *)[dataArray objectAtIndex:i];
        }
    
        if (block) block(trendsItems, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchDaysHotFromArtistId:(NSInteger)artistID
                      location:(NSInteger)location
                        length:(NSInteger)length
               completionBlock:(void (^)(NSArray *imageItems, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"artistId": [NSNumber numberWithInteger:artistID],
                                 @"offset":   [NSNumber numberWithInteger:location],
                                 @"size":     [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"charts/hot/list.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSArray *dedicateUserItems = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:responseObject error:&error];
        if (block) block(dedicateUserItems, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchLickManitoFromArtistId:(NSInteger)artistID
                           fromId:(NSInteger)fromId
                         location:(NSInteger)location
                           length:(NSInteger)length
                  completionBlock:(void (^)(NSArray *imageItems, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"artistId": [NSNumber numberWithInteger:artistID],
                                 @"fromId": [NSNumber numberWithInteger:fromId],
                                 @"offSet":   [NSNumber numberWithInteger:location],
                                 @"size":     [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/god/artist.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%@",responseObject);
        NSError *error = nil;
        NSArray *dedicateUserItems = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:responseObject error:&error];
        if (block) block(dedicateUserItems, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchDedicateListFromArtistId:(NSInteger)artistID
                           Location:(NSInteger)location
                             length:(NSInteger)length
                    completionBlock:(void (^)(NSArray *artistItems, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"artistId": [NSNumber numberWithInteger:artistID],
                                 @"offset":   [NSNumber numberWithInteger:location],
                                 @"size":     [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"charts/contribution/list.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSArray *dedicateUserItems = [MTLJSONAdapter modelsOfClass:[XTUserInfo class] fromJSONArray:responseObject error:&error];
        if (block) block(dedicateUserItems, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchArtistRecommendFromLocation:(NSInteger)location
                                length:(NSInteger)length
                       completionBlock:(void (^)(NSArray *artistItems, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"offset": [NSNumber numberWithInteger:location],
                                 @"size": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:@"picture/sub/list/recommend.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"推荐明星 = %@",responseObject);
        NSArray *artistItems = getArtistItems(responseObject);
        if (block) block(artistItems, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchArtistSearchFromKeyWords:(NSString *)key
                           property:(NSString *)property
                               area:(NSString *)area
                           Location:(NSInteger)location
                             length:(NSInteger)length
                    completionBlock:(void (^)(id favoriteVideos, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"key": key,
                                 @"property":property,
                                 @"area":area,
                                 @"offset": [NSNumber numberWithInteger:location],
                                 @"size": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/sub/list/search.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *artistItems = getArtistItems(responseObject);
        if (block) block(artistItems, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        if (block) block(nil, error);
    }];
}


/**
 *   获取一周内关注改艺人的6个用户数，点击进入最新关注列表
 */
- (id)fetchArtistNewFromArtistId:(NSInteger)artistLid
                 completionBlock:(void (^)(NSArray *orderItems, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"artistId": [NSNumber numberWithInteger:artistLid],
                                 @"offset":[NSNumber numberWithInteger:0],
                                 @"size":[NSNumber numberWithInteger:6]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/sub/new.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSArray *orderItems = [MTLJSONAdapter modelsOfClass:[XTOrderUserInfo class] fromJSONArray:responseObject error:&error];
        if (block) block(orderItems, error);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchFansFromArtistId:(NSInteger)artistLid
                   Location:(NSInteger)location
                     length:(NSInteger)length
            completionBlock:(void (^)(id userItems, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"artistId": [NSNumber numberWithInteger:artistLid],
                                 @"offset": [NSNumber numberWithInteger:location],
                                 @"size": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/sub/list/user.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSArray *orderItems = [MTLJSONAdapter modelsOfClass:[XTOrderUserInfo class] fromJSONArray:responseObject error:&error];
        if (block) block(orderItems, error);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)subscribeArtistFromArtistId:(NSInteger)artistLid
                  completionBlock:(void (^)(id data, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"artistId": [NSNumber numberWithInteger:artistLid],
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"picture/sub/create.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}


- (id)deleteSubscribeArtistFromArtistId:(NSInteger)artistLid
                        completionBlock:(void (^)(id favoriteVideos, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"artistId": [NSNumber numberWithInteger:artistLid],
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"picture/sub/delete.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchArtistListFromArtistId:(NSInteger)artistLid
                         Location:(NSInteger)location
                           length:(NSInteger)length
                  completionBlock:(void (^)(id items, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"artistId": [NSNumber numberWithInteger:artistLid],
                                 @"offset": [NSNumber numberWithInteger:location],
                                 @"code": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/sub/list/artist.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSArray *array = [MTLJSONAdapter modelsOfClass:[XTPlazaWaterFallInfo class] fromJSONArray:responseObject error:&error];
        if (block) block(array, error);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchContactArtistWithLocation:(NSInteger)location
                              length:(NSInteger)length
                     completionBlock:(void (^)(NSArray *artistItems, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"offset": [NSNumber numberWithInteger:location],
                                 @"code": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/artists/used.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSArray *artistItems = getArtistItems([responseObject objectForKey:@"artists"]);
        if (block) block(artistItems, error);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchTagWithKeyword:(NSString *)Keyword
                     type:(NSString *)type
          completionBlock:(void (^)(NSDictionary *tagItems, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"keyword": Keyword,
                                 @"soType": type
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"search/suggest.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSLog(@"标签搜索返回结果:%@",responseObject);
        if (block) block(responseObject, error);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchHotTagsWithCompletionBlock:(void (^)(NSArray *tagItems, NSError *error))block{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"tags/hot/list.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSLog(@"热门标签返回结果:%@",responseObject);
        if (block) block(responseObject, error);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchUsedTagsWithCompletionBlock:(void (^)(NSArray *tagItems, NSError *error))block{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/tags/used.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSArray *tagsArray = [(NSDictionary *)responseObject objectForKey:@"tags"];
        NSLog(@"常用标签返回结果:%@",tagsArray);
        if (block) block(tagsArray, error);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)newAlbumWithTitle:(NSString *)title
            description:(NSString *)description
             isPersonal:(BOOL)isPersonal
                   tags:(NSString *)tags
        completionBlock:(void (^)(XTAlbumInfo *albumInfo, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"title": title,
                                 @"description": description,
                                 @"isPersonal": [NSNumber numberWithBool:isPersonal],
                                 @"tags": tags
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"picture/album/create.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        XTAlbumInfo *albumInfo = [MTLJSONAdapter modelOfClass:[XTAlbumInfo class] fromJSONDictionary:responseObject error:&error];
        if (block) block(albumInfo, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)editAlbumWithAlbumID:(NSInteger)albumID
                     title:(NSString *)title
               description:(NSString *)description
                isPersonal:(BOOL)isPersonal
                      tags:(NSString *)tags
                     cover:(NSString *)cover
           completionBlock:(void (^)(id favoriteVideos, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"albumId": [NSNumber numberWithInteger:albumID],
                                 @"title": title,
                                 @"description": description,
                                 @"isPersonal": [NSNumber numberWithBool:isPersonal],
                                 @"tags": tags,
                                 @"cover": cover
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"picture/album/update.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)newAlbumWithAlbumInfo:(XTAlbumInfo *)albumInfo
            completionBlock:(void (^)(XTAlbumInfo *albumInfo, NSError *error))block{
    NSMutableString *tagStr = [[NSMutableString alloc] initWithCapacity:0];
    if ([albumInfo.tags count] > 0) {
        for (NSString *tag in albumInfo.tags) {
            [tagStr appendString:[NSString stringWithFormat:@"%@,",tag]];
        }
        [tagStr deleteCharactersInRange:NSMakeRange(tagStr.length-1, 1)];
    }
    NSDictionary *parameters = @{
                                 @"title": albumInfo.title,
                                 @"description": albumInfo.des,
                                 @"isPersonal": [NSNumber numberWithInteger:albumInfo.type],
                                 @"tags": tagStr
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"picture/album/create.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        XTAlbumInfo *albumInfo = [MTLJSONAdapter modelOfClass:[XTAlbumInfo class] fromJSONDictionary:responseObject error:&error];
        if (block) block(albumInfo, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)editAlbumWithAlbumInfo:(XTAlbumInfo *)albumInfo
             completionBlock:(void (^)(id favoriteVideos, NSError *error))block{
    NSMutableString *tagStr = [[NSMutableString alloc] initWithCapacity:0];
    if ([albumInfo.tags count] > 0) {
        for (NSString *tag in albumInfo.tags) {
            [tagStr appendString:[NSString stringWithFormat:@"%@,",tag]];
        }
        [tagStr deleteCharactersInRange:NSMakeRange(tagStr.length-1, 1)];
    }
    NSDictionary *parameters = @{
                                 @"albumId": [NSNumber numberWithLong:albumInfo.id],
                                 @"title": albumInfo.title,
                                 @"description": albumInfo.des,
                                 @"isPersonal": [NSNumber numberWithInteger:albumInfo.type],
                                 @"tags": tagStr,
                                 @"cover": [albumInfo.cover absoluteString]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"picture/album/update.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}


- (id)deleteAlbumWithAlbumID:(NSInteger)albumID
                   isDelPics:(BOOL)isDelPics
             completionBlock:(void (^)(id results, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"albumId": [NSNumber numberWithInteger:albumID],
                                 @"isPersonal": [NSNumber numberWithBool:isDelPics],
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"picture/album/delete.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)deleteAlbumPicturesWithAlbumID:(NSInteger)albumID
                                pids:(NSSet *)pids
                     completionBlock:(void (^)(id results, NSError *error))block{
    NSDictionary *parameters;
    if (pids.count == 1) {
        parameters = @{
                         @"albumId": [NSNumber numberWithInteger:albumID],
                         @"pid": [pids anyObject],
                         };
    }else{
        parameters = @{
                         @"albumId": [NSNumber numberWithInteger:albumID],
                         @"pids": pids,
                         };
    }
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"picture/delete.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)movePicturesFromAlbumID:(NSInteger)oldAlbumID toAlbumID:(NSInteger)newAlbumID
                         pids:(NSSet *)pids
              completionBlock:(void (^)(id results, NSError *error))block{
    NSDictionary *parameters;
//    if (pids.count == 1) {
//        parameters = @{
//                       @"albumId": [NSNumber numberWithInteger:albumID],
//                       @"pid": [pids anyObject],
//                       };
//    }else{
        parameters = @{
                       @"albumId": [NSNumber numberWithInteger:oldAlbumID],
                       @"targetAlbumId": [NSNumber numberWithInteger:newAlbumID],
                       @"pids": pids,
                       };
//    }
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"picture/move.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}


- (id)fetchAlbumDetailWithAlbumID:(NSInteger)albumID
                  completionBlock:(void (^)(id albumDetail, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"albumId": [NSNumber numberWithInteger:albumID],
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/album/show.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchAlbumPictureListWithAlbumID:(NSInteger)albumID
                                 maxID:(NSInteger)maxID
                               sinceID:(NSInteger)sinceID
                       completionBlock:(void (^)(id albumDetail, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"albumId": [NSNumber numberWithInteger:albumID],
                                 @"maxId": [NSNumber numberWithInteger:maxID],
                                 @"size" : [NSNumber numberWithInteger:40]
                                 };
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:@"picture/list/album.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}


- (id)fetchUserAlbumFromUserId:(NSInteger)userID
                      Location:(NSInteger)location
                        length:(NSInteger)length
               completionBlock:(void (^)(NSArray *albumItems, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"userId": [NSNumber numberWithInteger:userID],
                                 @"offset": [NSNumber numberWithInteger:location],
                                 @"size": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/album/list.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSArray *albumItems = [MTLJSONAdapter modelsOfClass:[XTAlbumInfo class] fromJSONArray:[responseObject objectForKey:@"albums"] error:&error];
        if (block) block(albumItems, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchUserImageFromUserId:(NSInteger)userID
                         maxId:(NSInteger)maxId
                       sinceId:(NSInteger)sinceId
                        length:(NSInteger)length
               completionBlock:(void (^)(NSArray *imageItems, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"uid": [NSNumber numberWithInteger:userID],
                                 @"maxId": [NSNumber numberWithInteger:maxId],
                                 @"sinceId": [NSNumber numberWithInteger:sinceId],
                                 @"size": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/list/user.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSError *error = nil;
        NSArray *trendsItems = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:responseObject error:&error];
        if (block) block(trendsItems, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchUserTopicFromUserId:(NSInteger)userID
                         maxId:(NSInteger)maxId
                       sinceId:(NSInteger)sinceId
                        length:(NSInteger)length
               completionBlock:(void (^)(NSArray *topicItems, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"uid": [NSNumber numberWithInteger:userID],
                                 @"maxId": [NSNumber numberWithInteger:maxId],
                                 @"sinceId": [NSNumber numberWithInteger:sinceId],
                                 @"size": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"topic/timeline.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSError *error = nil;
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:10];
        for (NSDictionary *dic in responseObject) {
            if ([[dic objectForKey:@"type"] isEqualToString:@"topic"]) {
                NSDictionary *dataDic = [dic objectForKey:@"data"];
                XTTopicInfo *topicInfo = [MTLJSONAdapter modelOfClass:[XTTopicInfo class] fromJSONDictionary:dataDic error:&error];
                topicInfo.type = [dic objectForKey:@"type"];
                topicInfo.stateID = [[dic objectForKey:@"id"] doubleValue];
                [dataArray addObject:topicInfo];
            }else if ([[dic objectForKey:@"type"] isEqualToString:@"post"]){
                NSDictionary *dataDic = [dic objectForKey:@"data"];
                XTPostInfo *postInfo = [MTLJSONAdapter modelOfClass:[XTPostInfo class] fromJSONDictionary:dataDic error:&error];
                postInfo.type = [dic objectForKey:@"type"];
                postInfo.stateID = [[dic objectForKey:@"id"] doubleValue];
                [dataArray addObject:postInfo];
            }
        }
        
        NSArray *topicItems = [NSArray arrayWithArray:dataArray];
        if (block) block(topicItems, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchUserFilesWithUserId:(NSInteger)userID
               completionBlock:(void (^)(XTUserFilesInfo *userFilesInfo, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"uid": [NSNumber numberWithInteger:userID]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"account/user/showArchives.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%@",responseObject);
        XTUserFilesInfo *userFilesInfo = nil;
        NSError *error = nil;
        userFilesInfo = [MTLJSONAdapter modelOfClass:[XTUserFilesInfo class]
                         fromJSONDictionary:responseObject error:&error];
        if (error) {
            [NSException raise:@"XTUserFilesInfo Parse Error" format:@"can't parse: %@", responseObject];
        }
        
        if (block) block(userFilesInfo, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)editUserFilesWithUserFiles:(XTUserFilesInfo *)userFiles
                 completionBlock:(void (^)(BOOL isSucceed, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"headImg": [userFiles.headImg absoluteString],
                                 @"nickName": userFiles.nickName,
                                 @"gender": userFiles.gender?([userFiles.gender isEqualToString:@"男"]?@"Boy":@"Girl"):@"",
                                 @"age": [NSNumber numberWithInt:[userFiles.age intValue]],
                                 @"star": userFiles.star?userFiles.star:@"",
                                 @"province": userFiles.province?userFiles.province:@"",
                                 @"city": userFiles.city?userFiles.city:@"",
                                 @"qingGan": userFiles.qingGan?userFiles.qingGan:@"",
                                 @"brief": userFiles.brief?userFiles.brief:@"",
                                 @"beiZhu": userFiles.beiZhu?userFiles.beiZhu:@""
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"account/user/updateArchives.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject count] > 0) {
            if (block) block(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(NO, error);
    }];
}

- (id)editUserFilesWithHeadImg:(NSURL *)headImg
               completionBlock:(void (^)(BOOL isSucceed, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"headImg": [headImg absoluteString],
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"account/user/updateArchives.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject count] > 0) {
            if (block) block(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(NO, error);
    }];
}

- (id)editUserHeadPortraitBg:(NSString *)userHeadPortraitBg
             completionBlock:(void (^)(BOOL isSucceed, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"bgImgUrl": userHeadPortraitBg,
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"account/user/update.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject count] > 0) {
            if (block) block(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(NO, error);
    }];
}

- (id)createTopic:(NSDictionary *)parameters
  completionBlock:(void (^)(BOOL isSucceed, NSError *error))block{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"topic/create.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject count] > 0) {
            if (block) block(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(NO, error);
    }];
}

- (id)updateTopic:(NSDictionary *)parameters
  completionBlock:(void (^)(BOOL isSucceed, NSError *error))block{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"topic/update.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject count] > 0) {
            if (block) block(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(NO, error);
    }];
}

- (id)updateTopicBgImage:(NSDictionary *)parameters
         completionBlock:(void (^)(BOOL isSucceed, NSError *error))block{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"topic/bg/set.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject count] > 0) {
            if (block) block(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(NO, error);
    }];
}

- (id)uploadImageToAlbum:(NSDictionary *)parameters
         completionBlock:(void (^)(BOOL isSucceed, NSError *error))block
{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"statuses/post.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject count] > 0) {
            if (block) block(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(NO, error);
    }];
}

- (id)uploadImageToTopic:(NSDictionary *)parameters
         completionBlock:(void (^)(BOOL isSucceed, NSError *error))block
{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"topic/posts/create.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject count] > 0) {
            if (block) block(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(NO, error);
    }];
}

- (id)fetchUserTagsWithLocation:(NSInteger)location
                         length:(NSInteger)length
                completionBlock:(void (^)(id tagsInfo, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"offset": [NSNumber numberWithInteger:location],
                                 @"size": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/tags/used.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if (block) block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchUserFriendTrendsWithMaxId:(NSInteger)maxId
                             sinceId:(NSInteger)sinceId
                              length:(NSInteger)length
                     completionBlock:(void (^)(NSArray *trendsItems, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"maxId": [NSNumber numberWithInteger:maxId],
                                 @"sinceId": [NSNumber numberWithInteger:sinceId],
                                 @"size": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"statuses/timeline/friends.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSError *error = nil;
        NSArray *trendsItems = [MTLJSONAdapter modelsOfClass:[XTUserFriendTrendsInfo class] fromJSONArray:[responseObject objectForKey:@"statuses"] error:&error];
        if (block) block(trendsItems, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)fetchFriendshipsFromUserId:(NSInteger)userID
                        location:(NSInteger)location
                          length:(NSInteger)length
                 completionBlock:(void (^)(NSArray *userItems, NSInteger totalCount, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"uid": [NSNumber numberWithInteger:userID],
                                 @"offset": [NSNumber numberWithInteger:location],
                                 @"size": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"friendships/friends.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSArray *userItems = [MTLJSONAdapter modelsOfClass:[XTUserAccountInfo class] fromJSONArray:[responseObject objectForKey:@"users"] error:&error];
		NSInteger totalCount = [responseObject[@"totalCount"] integerValue];
		if (block) block(userItems, totalCount, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, 0, error);
    }];
}

- (id)fetchFansListFromUserId:(NSInteger)userID
                     location:(NSInteger)location
                       length:(NSInteger)length
              completionBlock:(void (^)(NSArray *userItems, NSInteger totalCount, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"uid": [NSNumber numberWithInteger:userID],
                                 @"offset": [NSNumber numberWithInteger:location],
                                 @"size": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"friendships/followers.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSArray *userItems = [MTLJSONAdapter modelsOfClass:[XTUserAccountInfo class] fromJSONArray:[responseObject objectForKey:@"users"] error:&error];
		NSInteger totalCount = [responseObject[@"totalCount"] integerValue];
		if (block) block(userItems, totalCount, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, 0 , error);
    }];
}

- (id)fetchLickManitoListFromArtistId:(NSInteger)artistID
                             location:(NSInteger)location
                               length:(NSInteger)length
                      completionBlock:(void (^)(NSArray *userItems, NSInteger totalCount, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"artistId": [NSNumber numberWithInteger:artistID],
                                 @"offSet": [NSNumber numberWithInteger:location],
                                 @"size": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/god/users.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSArray *userItems = [MTLJSONAdapter modelsOfClass:[XTUserAccountInfo class] fromJSONArray:[responseObject objectForKey:@"users"] error:&error];
        NSInteger totalCount = [responseObject[@"totalCount"] integerValue];
        if (block) block(userItems, totalCount, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, 0 , error);
    }];
}

- (id)fetchFansListFromArtistId:(NSInteger)artistID
                       location:(NSInteger)location
                         length:(NSInteger)length
                completionBlock:(void (^)(NSArray *userItems, NSInteger totalCount, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"artistId": [NSNumber numberWithInteger:artistID],
                                 @"offset": [NSNumber numberWithInteger:location],
                                 @"size": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/sub/list/fans.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSArray *userItems = [MTLJSONAdapter modelsOfClass:[XTUserAccountInfo class] fromJSONArray:[responseObject objectForKey:@"users"] error:&error];
        NSInteger totalCount = [responseObject[@"totalCount"] integerValue];
        if (block) block(userItems, totalCount, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, 0 , error);
    }];
}

/**
 *
 *    用户关注用户
 */
- (id)fetchUserSubFromUserId:(NSInteger)userID
             completionBlock:(void (^)(id data, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"uid": [NSNumber numberWithInteger:userID],
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"friendships/create.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

/**
 *
 *    用户取消关注用户
 */
- (id)fetchUserDeleteSubFromUserId:(NSInteger)userID
                   completionBlock:(void (^)(id data, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"uid": [NSNumber numberWithInteger:userID],
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"friendships/delete.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

/**
 *   获取用户相册图片列表
 */
- (id)fetchAlbumListFromSource:(NSInteger)albumId
                         maxId:(NSInteger)maxId
                       sinceId:(NSInteger)sinceId
                        length:(NSInteger)length
               completionBlock:(void (^)(id items, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"albumId": [NSNumber numberWithInteger:albumId],
                                 @"maxId": [NSNumber numberWithInteger:maxId],
                                 @"sinceId": [NSNumber numberWithInteger:sinceId],
                                 @"size": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/list/album.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            NSError *error = nil;
            NSArray *renownItems = [MTLJSONAdapter modelsOfClass:[XTFollowInfo class] fromJSONArray:responseObject error:&error];
            block(renownItems, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

/**
 *   获取与指定艺人关联的图片列表
 */
- (id)fetchArtistListFromSource:(NSInteger)artistId
                          maxId:(NSInteger)maxId
                        sinceId:(NSInteger)sinceId
                         length:(NSInteger)length
                completionBlock:(void (^)(id items, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"artistId": [NSNumber numberWithInteger:artistId],
                                 @"maxId": [NSNumber numberWithInteger:maxId],
                                 @"sinceId": [NSNumber numberWithInteger:sinceId],
                                 @"size": [NSNumber numberWithInteger:length]
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/list/artist.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            NSError *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[XTPlazaWaterFallInfo class] fromJSONArray:responseObject error:&error];
            block(array, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

/*
 *  获取用户图片点赞列表(爱过)
 */
- (id)fetchUserCommendWithUserId:(NSInteger)userId
                          offset:(NSInteger)offset
                            size:(NSInteger)size
                 completionBlock:(void (^)(NSArray* array, NSError *error))block
{
    NSDictionary *parameters = @{@"uid": @(userId), @"offset": @(offset), @"size": @(size)};
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/list/commend.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (block) {
            
            NSError *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:responseObject error:&error];
            
            block(array, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (block)
            block(nil, error);
    }];
}

/*
 *  获取用户图片收藏列表(收藏)
 */
- (id)fetchUserFavoriteWithUserId:(NSInteger)userId
                           offset:(NSInteger)offset
                             size:(NSInteger)size
                  completionBlock:(void (^)(NSArray* array, NSError *error))block
{
    NSDictionary *parameters = @{@"uid": @(userId), @"offset": @(offset), @"size": @(size)};
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/list/favorite.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (block) {
            
            NSError *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:responseObject error:&error];
            
            block(array, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (block)
            block(nil, error);
    }];
}

/*
 * 获取舔神列表数据(艺人主页跳入)
 */
- (id)fetchLickGodWithUserId:(NSInteger)userId
                      offset:(NSInteger)offset
                        size:(NSInteger)size
             completionBlock:(void (^)(NSArray* array, NSInteger totalCount, NSError *error))block
{
    NSDictionary *parameters = @{@"userId": @(userId), @"offSet": @(offset), @"size": @(size)};
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager GET:@"picture/god/users.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSArray *userItems = [MTLJSONAdapter modelsOfClass:[XTUserAccountInfo class] fromJSONArray:[responseObject objectForKey:@"users"] error:&error];
        NSInteger totalCount = [responseObject[@"totalCount"] integerValue];
        
        if (block) block(userItems, totalCount, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (block)
            block(nil, 0, error);
    }];
}
//修改密码
-(id)fetchUserChangePassWord:(NSString *)password newPassword:(NSString *)newPassword comletionBlock:(void(^)(id responseObject,NSError *error))block{
    NSDictionary *paramDic = @{@"access_token":[XTUserStore sharedManager].user.access_token,
                               @"password":password,
                               @"newPassword":newPassword};
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
   return  [manager POST:@"http://capi.yinyuetai.com/common/account/change_password.json" parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        if (block) {
            block(responseObject,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
            
        }
        
    }];

}
/**
 *   分享统计
 */
- (id)shareStatisticWithPlatform:(NSString *)platform
                        datatype:(NSString *)dataype
                          dataid:(NSInteger)dataid
                 completionBlock:(void (^)(id results, NSError *error))block{
    NSDictionary *paramDic = @{@"platform":platform,
                               @"datatype":dataype,
                               @"dataid":[NSNumber numberWithInteger:dataid]};
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return  [manager POST:@"http://statistics.yinyuetai.com/share/statistics.json" parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (block) {
            block(responseObject,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
            
        }
        
    }];
}
@end
