//
//  XTImgDetailLogic.m
//  tian
//
//  Created by loong on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTImgDetailLogic.h"
#import "XTImgDetailLogicModel.h"
#import "Define.h"
#import "XTSeriesContentStore.h"
#import "XTImgDetailLogicModel.h"
#import "XTCommentsModel.h"
#import "XTImgShowModel.h"

@interface XTImgDetailLogic()

@property(nonatomic,strong)NSMutableDictionary *logicModelDic;

@end


@implementation XTImgDetailLogic


- (instancetype)initWithPidArr:(NSArray *)arr{
    self = [super init];
    if (self) {
        self.logicModelDic = [NSMutableDictionary dictionary];
        self.imgPidArr = arr;
    }
    return self;
}

-(void)fatchLogicModelWith:(NSInteger )index fatchSuccess1:(void(^)(id))handler1 fatchSuccess2:(void(^)(id))handler2 andFailure:(void(^)(NSError *error))failureBlock{
    NSString *pid = self.imgPidArr[index];
    NSLog(@"**********^^^^^^^^^^^ImgDetailLogic^^^^^^^^^^^************%zd",index);
    
    XTImgDetailLogicModel *model = self.logicModelDic[pid];
    
    if (!model) {
        model = [[XTImgDetailLogicModel alloc] init];
        [self.logicModelDic setObject:model forKeyedSubscript:pid];
    }
    //__weak XTImgDetailLogicModel *weakModel = self.logicModelDic[pid];
    if (model.imgShowModel) {
        handler1(model.imgShowModel);
    }else{
        NSString *url = [XT_API stringByAppendingString:XT_PICTURESHOW];
        NSLog(@"url === %@",url);
        
        NSDictionary *dic = @{@"pid":pid};
        
        [XTSeriesContentStore fatchPicDetailWithUrl:url andParameters:dic successBlock:^(id responseObject) {
            model.imgShowModel = responseObject;
            
            handler1(model.imgShowModel);
            
        } failureBlock:^(NSError *error) {
            failureBlock(error);
        }];
    }
    

    if (model.commentsModel) {
        handler2(model.commentsModel);
    }else{
        NSString *url = [XT_API stringByAppendingString:XT_PICCOMMENTSSHOW];
        NSLog(@"url === %@",url);
        
        NSDictionary *dic = @{@"pid":pid};
        
        [XTSeriesContentStore fatchCommentsWithUrl:url andParameters:dic successBlock:^(id responseObject) {
            //NSLog(@"responseObject === %@",responseObject);
            model.commentsModel = responseObject;
            handler2(model.commentsModel);
        } failureBlock:^(NSError *error) {
            //failureBlock(error);
        }];
    }
}

-(void)insertCommentDataSourceWithPid:(NSString *)pid andModel:(id)model{
    
    XTImgDetailLogicModel *logicModel = self.logicModelDic[pid];
    
    XTImgShowModel *imageShowModel = logicModel.imgShowModel;
    
    NSInteger commentCount = [imageShowModel.commentCount integerValue];
    
    imageShowModel.commentCount = [NSNumber numberWithInteger:commentCount + 1];
    
    NSMutableArray *arr_m = [NSMutableArray arrayWithArray:logicModel.commentsModel.comments];
    
    [arr_m insertObject:model atIndex:0];
    
    logicModel.commentsModel.comments = [arr_m copy];
}


-(void)modifyCommendUsersWithPid:(NSString *)pid andArray:(NSArray *)arr{
    XTImgDetailLogicModel *logicModel = self.logicModelDic[pid];
    
    XTImgShowModel *imageShowModel = logicModel.imgShowModel;
    imageShowModel.commended = YES;
    
    imageShowModel.commendUsers = arr;
}


-(void)addNextPageCommnetDataSourceWithPid:(NSString *)pid andArray:(NSArray *)arr{
    XTImgDetailLogicModel *logicModel = self.logicModelDic[pid];
    
    logicModel.commentsModel.comments = arr;
}



-(void)dealloc{
    NSLog(@"XTImgDetailLogic >>>>>>> dealloc");
}

@end
