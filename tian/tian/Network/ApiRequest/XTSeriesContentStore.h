//
//  XTSeriesContentStore.h
//  tian
//
//  Created by loong on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTSeriesContentStore : NSObject

/**系列内容页面 上方图片集**/
+(void)fatchMapImageSetWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure;

/** 系列内容等页面的评论 **/
+(void)fatchOperateCommentListWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure;


/** 系列内容 提交评论**/
+(void)operateCommentCreateWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObjdect))success failureBlock:(void(^)(NSError *error))failure;


/** 系列内容点赞 **/
+(void)operateCommentSupportWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure;

/** 系列内容取消点赞 **/
+(void)operateCommentCancelSupportWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure;


/**热门话题页面**/
+(void)fatchHotTopicSetWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure;


/**图片详情**/
+(void)fatchPicDetailWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure;

/** 图片详情页 对图片进行点赞 **/
+(void)pictureCommendWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure;

/** 图片详情 取消对片点赞 **/
+(void)pictureCommendCancelWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure;


/**图片详情页面评论**/
+(void)fatchCommentsWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure;

/**图片详情 对评论点赞**/
+(void)pictureCommentsCommendWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure;


/**图片详情 取消对评论点赞**/
+(void)pictureCommentsCommendCancelWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure;


/**大图展示页，根据pid，获取大图**/
+(void)fatchImgOriginalWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure;

/**对图片进行评论**/
+(void)commentsPostWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure;


/**图片打赏**/
+(void)pictureAwardWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure;

/** 将别人的图片添加到自己的相册 **/
+(void)pictureAddWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure;

/**图片举报**/
+(void)pictureComplaintWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure;


/**话题详情**/
+(void)topicDetailWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure;

/**话题点赞**/
+(void)topicPostCommendWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure;


/**话题取消点赞**/
+(void)topicPostCancelCommentWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure;


/** 话题评论列表 **/
+(void)topicCommentListWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure;

/** 话题详情页 对评论点赞 **/
+(void)topicPostCommentCommendWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure;

/** 话题详情页 取消对评论点赞 **/
+(void)topicPostsCommentsCommendCancelWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure;


/** 从话题详情页面 跳转大图展示页面，调用的 查看原图接口**/
+(void)topicPostsImagesWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure;


/** 话题提交评论 **/
+(void)topicPostCommentsWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id respobseObjdect))success failureBlock:(void(^)(NSError *error))failure;

/** 收藏一张图片 **/
+(void)picFavoritesAddWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure;

/** 取消收藏一张图片 **/
+(void)picfavoritesDeleteWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure;




@end
