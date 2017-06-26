//  XTSeriesContentStore.m
//  tian
//
//  Created by loong on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSeriesContentStore.h"
#import "XTHTTPRequestOperationManager.h"
#import "MTLJsonAdapter.h"
#import "XTMapImageSetViewModel.h"
//#import "XTHotTopicSetModel.h"
#import "XTHotTopicModel.h"
#import "XTImgShowModel.h"
#import "XTCommentsModel.h"
#import "XTOriginImgModel.h"
#import "XTCommentItemModel.h"
#import "XTTopicDetailModel.h"
@implementation XTSeriesContentStore

/**系列内容页面 上方图片集**/
+(void)fatchMapImageSetWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure{
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
//        NSDictionary *dic = responseObject;
//        NSLog(@"dic ==== %@",dic);
        XTMapImageSetViewModel *model = [MTLJSONAdapter modelOfClass:[XTMapImageSetViewModel class] fromJSONDictionary:responseObject error:&error];
        success(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"广场图片失败结果==%@",error);
        if (failure) {
            failure(error);
        }
    }];
}

/** 系列内容等页面的评论 **/
+(void)fatchOperateCommentListWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        //NSDictionary *dic = responseObject;
        //NSLog(@"dic ==== %@",dic);

        XTCommentsModel *model = [MTLJSONAdapter modelOfClass:[XTCommentsModel class] fromJSONDictionary:responseObject error:&error];
        
        success(model);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**系列内容 提交评论 **/

+(void)operateCommentCreateWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObjdect))success failureBlock:(void(^)(NSError *error))failure{
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSDictionary *dic = responseObject;
        NSError *error = nil;
            XTCommentItemModel *model = [MTLJSONAdapter modelOfClass:[XTCommentItemModel class] fromJSONDictionary:responseObject error:&error];
        
        if (model) {
            success(model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

/** 系列内容 评论点赞 **/
+(void)operateCommentSupportWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure{
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject;====%@",responseObject);
        NSDictionary *dic = responseObject;
        
        if ([dic[@"rs"] integerValue] == 200) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**系列内容 对评论取消点赞**/
+(void)operateCommentCancelSupportWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject;====%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


/**热门话题页面**/
+(void)fatchHotTopicSetWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure{
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSDictionary *dic = responseObject;
        NSError *error = nil;

        XTHotTopicModel *model = [MTLJSONAdapter modelOfClass:[XTHotTopicModel class] fromJSONDictionary:responseObject error:&error];
        
//        NSArray *arr = [MTLJSONAdapter modelsOfClass:[XTHotTopicSetModel class] fromJSONArray:dic[@"topics"] error:&error];
        
        success(model);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


/**图片详情**/

+(void)fatchPicDetailWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        XTImgShowModel *model = [MTLJSONAdapter modelOfClass:[XTImgShowModel class] fromJSONDictionary:responseObject error:&error];
        
        success(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**图片详情页面评论**/
+(void)fatchCommentsWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        XTCommentsModel *model = [MTLJSONAdapter modelOfClass:[XTCommentsModel class] fromJSONDictionary:responseObject error:&error];
        success(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/** 图片详情页 对图片进行点赞 **/
+(void)pictureCommendWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"rs"] integerValue] == 200) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/** 图片详情 取消对片点赞 **/
+(void)pictureCommendCancelWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"rs"] integerValue] == 200) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/**图片详情 对评论点赞**/
+(void)pictureCommentsCommendWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"rs"] integerValue] == 200) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/**图片详情 取消对评论点赞**/
+(void)pictureCommentsCommendCancelWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"rs"] integerValue] == 200) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}


/**大图展示页，根据pid，获取大图**/
+(void)fatchImgOriginalWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSArray *arr = [MTLJSONAdapter modelsOfClass:[XTOriginImgModel class] fromJSONArray:responseObject error:&error];
        
        success(arr);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**对图片进行评论**/
+(void)commentsPostWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        XTCommentItemModel *model = [MTLJSONAdapter modelOfClass:[XTCommentItemModel class] fromJSONDictionary:responseObject error:&error];
        success(model);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

/**图片打赏**/
+(void)pictureAwardWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure{
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"rs"] integerValue] == 200) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

/** 将别人的图片添加到自己的相册 **/
+(void)pictureAddWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure{
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"rs"] integerValue] == 200) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}


/**图片举报**/
+(void)pictureComplaintWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure{
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"rs"] integerValue] == 200) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/**话题详情**/
+(void)topicDetailWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        
        NSError *error = nil;
        XTTopicDetailModel *model = [MTLJSONAdapter modelOfClass:[XTTopicDetailModel class] fromJSONDictionary:dic error:&error];
        success(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**话题点赞**/
+(void)topicPostCommendWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"rs"] integerValue] == 200) {
            success();
        }
        NSLog(@"dic ==== %@",dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**话题取消点赞**/
+(void)topicPostCancelCommentWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        
        if ([dic[@"rs"] integerValue] == 200) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/** 话题评论列表 **/
+(void)topicCommentListWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSArray *arr = [MTLJSONAdapter modelsOfClass:[XTCommentItemModel class] fromJSONArray:responseObject error:&error];
        
        success(arr);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/** 话题详情页 对评论点赞 **/
+(void)topicPostCommentCommendWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure{
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        
        if ([dic[@"rs"] integerValue] == 200) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/** 话题详情页 取消对评论点赞 **/
+(void)topicPostsCommentsCommendCancelWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        
        if ([dic[@"rs"] integerValue] == 200) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/** 话题提交评论 **/

+(void)topicPostCommentsWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id respobseObjdect))success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        XTCommentItemModel *model = [MTLJSONAdapter modelOfClass:[XTCommentItemModel class] fromJSONDictionary:responseObject error:&error];
        success(model);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


/** 从话题详情页面 跳转大图展示页面，调用的 查看原图接口**/
+(void)topicPostsImagesWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSArray *arr = [MTLJSONAdapter modelsOfClass:[XTOriginImgModel class] fromJSONArray:responseObject error:&error];
        
        success(arr);        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/** 收藏一张图片 **/
+(void)picFavoritesAddWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSError *error = nil;
        NSDictionary *dic = responseObject;
        
        if ([dic[@"rs"] integerValue] == 200) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/** 取消收藏一张图片 **/
+(void)picfavoritesDeleteWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters successBlock:(void(^)())success failureBlock:(void(^)(NSError *error))failure{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        
        if ([dic[@"rs"] integerValue] == 200) {
            success();
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}




@end
