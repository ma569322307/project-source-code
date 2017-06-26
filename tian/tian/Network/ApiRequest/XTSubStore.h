//
//  XTSubStore.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/2/13.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DefaultLoadCount 24
@class XTOrderArtist;
@class XTOrderUserInfo;
@class XTAlbumInfo;
@class XTImageInfo;
@class XTUserFilesInfo;
/**
 * XTSubStore:
 *  提供艺人相关接口
 *
 */
@interface XTSubStore : NSObject

/**
 *  获取订阅的艺人动态
 */
- (id)fetchArtistDynamicFromLocation:(NSInteger)location
                            length:(NSInteger)length
                   completionBlock:(void (^)(NSArray *followItems, NSError *error))block;

/**
 *   获取我订阅的艺人列表
 */
- (id)fetchMySubArtistFromUserId:(NSInteger)userID
                        location:(NSInteger)location
                          length:(NSInteger)length
                 completionBlock:(void (^)(NSArray *artistItems, NSInteger totalCount, NSError *error))block;


/**
 *   获取某个艺人详情页
 */
- (id)fetchArtistShowFromArtistId:(NSInteger)artistLid
                  completionBlock:(void (^)(XTOrderArtist *artistInfo, NSError *error))block;

/**
 *   获取艺人最新更新
 */
- (id)fetchLatestUpdateFromArtistId:(NSInteger)artistId
                              maxId:(NSInteger)maxId
                            sinceId:(NSInteger)sinceId
                             length:(NSInteger)length
                    completionBlock:(void (^)(NSArray *imageItems, NSError *error))block;

/**
 *   获取艺人24小时最热
 */
- (id)fetchDaysHotFromArtistId:(NSInteger)artistID
                      location:(NSInteger)location
                        length:(NSInteger)length
               completionBlock:(void (^)(NSArray *imageItems, NSError *error))block;

/**
 *   获取艺人舔神列表
 */
- (id)fetchLickManitoFromArtistId:(NSInteger)artistID
                           fromId:(NSInteger)fromId
                         location:(NSInteger)location
                           length:(NSInteger)length
                  completionBlock:(void (^)(NSArray *imageItems, NSError *error))block;

/**
 *   获取艺人贡献榜
 */
- (id)fetchDedicateListFromArtistId:(NSInteger)artistID
                           Location:(NSInteger)location
                             length:(NSInteger)length
                    completionBlock:(void (^)(NSArray *artistItems, NSError *error))block;

/**
 *   列出可以订阅的推荐艺人列表
 */
- (id)fetchArtistRecommendFromLocation:(NSInteger)location
                                length:(NSInteger)length
                       completionBlock:(void (^)(NSArray *artistItems, NSError *error))block;


/**
 *  根据艺人类型作为搜索条件列出可以订阅的艺人列表
 *
 *  @param key                        关键字，可为空
 *  @param property                   艺人类型 (女艺人:Girl 男艺人:Boy 乐队组合:Combo 其他:Other)
 *  @param area                       艺人语种 (内地:ML 港台:HT 欧美:US 韩语:KR 日语:JP 二次元:ACG 其他:Other)
 *
 *  @return <#return value description#>
 */
- (id)fetchArtistSearchFromKeyWords:(NSString *)key
                           property:(NSString *)property
                               area:(NSString *)area
                           Location:(NSInteger)location
                             length:(NSInteger)length
                    completionBlock:(void (^)(id favoriteVideos, NSError *error))block;

/**
 *   获取一周内关注改艺人的6个用户数，点击进入最新关注列表
 */
- (id)fetchArtistNewFromArtistId:(NSInteger)artistLid
                    completionBlock:(void (^)(NSArray *orderItems, NSError *error))block;

/**
 *   艺人详情页点击近期订阅的用户头像banner条接口，跳转到订阅该艺人的粉丝列表页面，按照关注时间倒叙排列
 */
- (id)fetchFansFromArtistId:(NSInteger)artistLid
                        Location:(NSInteger)location
                          length:(NSInteger)length
                 completionBlock:(void (^)(id userItems, NSError *error))block;

/**
 *   用户发起订阅动作
 */
- (id)subscribeArtistFromArtistId:(NSInteger)artistLid
                 completionBlock:(void (^)(id data, NSError *error))block;

/**
 *   用户发起取消订阅动作
 */
- (id)deleteSubscribeArtistFromArtistId:(NSInteger)artistLid
                  completionBlock:(void (^)(id favoriteVideos, NSError *error))block;

/**
 *   订阅艺人列表页面
 */
- (id)fetchArtistListFromArtistId:(NSInteger)artistLid
                   Location:(NSInteger)location
                     length:(NSInteger)length
            completionBlock:(void (^)(id items, NSError *error))block;

/**
 *   最近关联过的艺人
 */
- (id)fetchContactArtistWithLocation:(NSInteger)location
                              length:(NSInteger)length
                     completionBlock:(void (^)(NSArray *artistItems, NSError *error))block;

/**
 *   标签搜索
 */
- (id)fetchTagWithKeyword:(NSString *)Keyword
                     type:(NSString *)type
          completionBlock:(void (^)(NSDictionary *tagItems, NSError *error))block;

/**
 *   获取热门标签
 */
- (id)fetchHotTagsWithCompletionBlock:(void (^)(NSArray *tagItems, NSError *error))block;

/**
 *   获取常用标签
 */
- (id)fetchUsedTagsWithCompletionBlock:(void (^)(NSArray *tagItems, NSError *error))block;

/**
 *   新建图册
 */
- (id)newAlbumWithTitle:(NSString *)title
            description:(NSString *)description
             isPersonal:(BOOL)isPersonal
                   tags:(NSString *)tags
        completionBlock:(void (^)(XTAlbumInfo *albumInfo, NSError *error))block;

/**
 *   新建图册
 */
- (id)newAlbumWithAlbumInfo:(XTAlbumInfo *)albumInfo
            completionBlock:(void (^)(XTAlbumInfo *albumInfo, NSError *error))block;


/**
 *   修改图册
 */
- (id)editAlbumWithAlbumID:(NSInteger)albumID
                     title:(NSString *)title
               description:(NSString *)description
                isPersonal:(BOOL)isPersonal
                      tags:(NSString *)tags
                     cover:(NSString *)cover
           completionBlock:(void (^)(id favoriteVideos, NSError *error))block;

/**
 *   修改图册
 */
- (id)editAlbumWithAlbumInfo:(XTAlbumInfo *)albumInfo
             completionBlock:(void (^)(id favoriteVideos, NSError *error))block;


/**
 *   删除图册
 */
- (id)deleteAlbumWithAlbumID:(NSInteger)albumID
                   isDelPics:(BOOL)isDelPics
             completionBlock:(void (^)(id results, NSError *error))block;
/**
 *   批量删除图册图片
 */
- (id)deleteAlbumPicturesWithAlbumID:(NSInteger)albumID
                   pids:(NSSet *)pids
             completionBlock:(void (^)(id results, NSError *error))block;

/**
 *   批量移动图册图片到指定相册
 */
- (id)movePicturesFromAlbumID:(NSInteger)oldAlbumID toAlbumID:(NSInteger)newAlbumID
                                pids:(NSSet *)pids
                     completionBlock:(void (^)(id results, NSError *error))block;

/**
 *   获取指定图册详情
 */
- (id)fetchAlbumDetailWithAlbumID:(NSInteger)albumID
                  completionBlock:(void (^)(id albumDetail, NSError *error))block;

/**
 *   获取指定相册图片列表
 */
- (id)fetchAlbumPictureListWithAlbumID:(NSInteger)albumID
                                 maxID:(NSInteger)maxID
                               sinceID:(NSInteger)sinceID
                       completionBlock:(void (^)(id albumDetail, NSError *error))block;

/**
 *   获取用户所有图册信息
 */
- (id)fetchUserAlbumFromUserId:(NSInteger)userID
                      Location:(NSInteger)location
                        length:(NSInteger)length
               completionBlock:(void (^)(NSArray *albumItems, NSError *error))block;

/**
 *   获取用户所有图片信息
 */
- (id)fetchUserImageFromUserId:(NSInteger)userID
                         maxId:(NSInteger)maxId
                       sinceId:(NSInteger)sinceId
                        length:(NSInteger)length
               completionBlock:(void (^)(NSArray *imageItems, NSError *error))block;

/**
 *   获取粉丝话题信息
 */
- (id)fetchUserTopicFromUserId:(NSInteger)userID
                         maxId:(NSInteger)maxId
                       sinceId:(NSInteger)sinceId
                        length:(NSInteger)length
               completionBlock:(void (^)(NSArray *topicItems, NSError *error))block;

/**
 *   获取粉丝资料信息
 */
- (id)fetchUserFilesWithUserId:(NSInteger)userID
               completionBlock:(void (^)(XTUserFilesInfo *userFilesInfo, NSError *error))block;

/**
 *   修改粉丝资料信息
 */
- (id)editUserFilesWithUserFiles:(XTUserFilesInfo *)userFiles
                 completionBlock:(void (^)(BOOL isSucceed, NSError *error))block;

/**
 *   修改粉丝头像
 */
- (id)editUserFilesWithHeadImg:(NSURL *)headImg
               completionBlock:(void (^)(BOOL isSucceed, NSError *error))block;

/**
 *   修改用户头像背景
 */
- (id)editUserHeadPortraitBg:(NSString *)userHeadPortraitBg
             completionBlock:(void (^)(BOOL isSucceed, NSError *error))block;

/**
 *   创建话题
 */
- (id)createTopic:(NSDictionary *)parameters
  completionBlock:(void (^)(BOOL isSucceed, NSError *error))block;

/**
 *   更新话题
 */
- (id)updateTopic:(NSDictionary *)parameters
  completionBlock:(void (^)(BOOL isSucceed, NSError *error))block;

/**
 *   更新话题背景图片
 */
- (id)updateTopicBgImage:(NSDictionary *)parameters
         completionBlock:(void (^)(BOOL isSucceed, NSError *error))block;

/**
 *   将图片上传到指定图册
 */
- (id)uploadImageToAlbum:(NSDictionary *)parameters
         completionBlock:(void (^)(BOOL isSucceed, NSError *error))block;

/**
 *   将图片上传到指定话题
 */
- (id)uploadImageToTopic:(NSDictionary *)parameters
         completionBlock:(void (^)(BOOL isSucceed, NSError *error))block;

/**
 *   用户最近关联过的标签列表
 */
- (id)fetchUserTagsWithLocation:(NSInteger)location
                         length:(NSInteger)length
               completionBlock:(void (^)(id favoriteVideos, NSError *error))block;

/**
 *   获取当前登录用户及其所关注用户的最新状态
 */
- (id)fetchUserFriendTrendsWithMaxId:(NSInteger)maxId
                             sinceId:(NSInteger)sinceId
                              length:(NSInteger)length
                     completionBlock:(void (^)(NSArray *trendsItems, NSError *error))block;

/**
 *   获取用户关注列表
 */
- (id)fetchFriendshipsFromUserId:(NSInteger)userID
                        location:(NSInteger)location
                          length:(NSInteger)length
                 completionBlock:(void (^)(NSArray *userItems, NSInteger totalCount, NSError *error))block;

/**
 *   获取用户粉丝列表
 */
- (id)fetchFansListFromUserId:(NSInteger)userID
                     location:(NSInteger)location
                       length:(NSInteger)length
              completionBlock:(void (^)(NSArray *userItems, NSInteger totalCount, NSError *error))block;

/**
 *   获取艺人舔神列表
 */
- (id)fetchLickManitoListFromArtistId:(NSInteger)artistID
                             location:(NSInteger)location
                               length:(NSInteger)length
                      completionBlock:(void (^)(NSArray *userItems, NSInteger totalCount, NSError *error))block;

/**
 *   获取艺人粉丝列表
 */
- (id)fetchFansListFromArtistId:(NSInteger)artistID
                       location:(NSInteger)location
                         length:(NSInteger)length
                completionBlock:(void (^)(NSArray *userItems, NSInteger totalCount, NSError *error))block;

/**
 *
 *    用户关注用户
 */
- (id)fetchUserSubFromUserId:(NSInteger)userID
             completionBlock:(void (^)(id data, NSError *error))block;

/**
 *
 *    用户取消关注用户
 */
- (id)fetchUserDeleteSubFromUserId:(NSInteger)userID
                   completionBlock:(void (^)(id data, NSError *error))block;
/**
 *   获取用户相册图片列表
 */
- (id)fetchAlbumListFromSource:(NSInteger)albumId
                         maxId:(NSInteger)maxId
                       sinceId:(NSInteger)sinceId
                        length:(NSInteger)length
               completionBlock:(void (^)(id items, NSError *error))block;


/**
 *   获取与指定艺人关联的图片列表
 */
- (id)fetchArtistListFromSource:(NSInteger)artistId
                         maxId:(NSInteger)maxId
                       sinceId:(NSInteger)sinceId
                        length:(NSInteger)length
               completionBlock:(void (^)(id items, NSError *error))block;

/*
 *  获取用户图片点赞列表(爱过)
 */
- (id)fetchUserCommendWithUserId:(NSInteger)userId
                          offset:(NSInteger)offset
                            size:(NSInteger)size
                 completionBlock:(void (^)(NSArray* array, NSError *error))block;

/*
 *  获取用户图片收藏列表(收藏)
 */
- (id)fetchUserFavoriteWithUserId:(NSInteger)userId
                           offset:(NSInteger)offset
                             size:(NSInteger)size
                  completionBlock:(void (^)(NSArray* array, NSError *error))block;

/*
 * 获取舔神列表数据(艺人主页跳入)
 */
- (id)fetchLickGodWithUserId:(NSInteger)userId
                      offset:(NSInteger)offset
                        size:(NSInteger)size
             completionBlock:(void (^)(NSArray* array, NSInteger totalCount, NSError *error))block;
/*
 *修改密码
 */
-(id)fetchUserChangePassWord:(NSString *)password newPassword:(NSString *)newPassword comletionBlock:(void(^)(id responseObject,NSError *error))block;

/**
 *   分享统计
 */
- (id)shareStatisticWithPlatform:(NSString *)platform
                        datatype:(NSString *)dataype
                          dataid:(NSInteger)dataid
                 completionBlock:(void (^)(id results, NSError *error))block;
@end
