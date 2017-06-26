//
//  XTHomePageStore.h
//  tian
//
//  Created by cc on 15/6/13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "XTOriginalViewController.h"
#import "XTPhotosListViewController.h"
@class XTOriginalViewController;
@interface XTHomePageStore : NSObject
@property (nonatomic, strong) XTOriginalViewController *originalViewController;
@property (nonatomic, assign)XTOriginalPageType type;//跳转要传的参数


@property (nonatomic,strong) XTPhotosListViewController *photosListViewController;
@property (nonatomic, assign)XTphotosListType photosListtype;
/**
 *   获取广场图片
 */
- (id)fetchHomePagePicListWithoffset:(NSInteger)offset size:(NSInteger)size CompletionBlock:(void(^)(id picList, NSError *error))block;
/**
 *   获取喜欢图片
 */
- (id)fetchHomePageLikeListWithoffset:(NSInteger)offset size:(NSInteger)size CompletionBlock:(void(^)(id picList,BOOL subArtist, NSError *error))block;
/**
 *   获取关注信息
 */
- (id)fetchHomePageAttentionListWithmaxId:(NSInteger)maxId sinceId:(NSInteger)sinceId size:(NSInteger)size CompletionBlock:(void(^)(id picList, NSError *error))block;
/*
 *标签列表
 */
- (id)fetchHomePagePicListWith:(NSString *)labelString andMaxId:(NSInteger)maxId CompletionBlock:(void(^)(id picList, NSError *error))block;
/*
 *获取图集列表的消息
 */
- (id)fetchHomePagePicListWith:(NSInteger)pictureId CompletionBlock:(void(^)(id picList, NSError *error))block;
/*
 *精选图集
 */
-(id)fetchHomePagePhotoListSpecial:(NSInteger)albumId andOffset:(NSInteger)offset andSize:(NSInteger)size CompletionBlock:(void(^)(id piclist, NSError *error))block;

/*
 *获取独家原创的消息
 */
-(id)fetchHomePageOriginalId:(NSInteger)pid andOffSet:(NSInteger)offset andSize:(NSInteger)size CompletionBlock:(void(^)(id picList, NSError *error))block;

@end
