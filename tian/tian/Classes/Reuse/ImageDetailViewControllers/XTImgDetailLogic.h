//
//  XTImgDetailLogic.h
//  tian
//
//  Created by loong on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XTFATCHLOGICTYPE) {
    XTFATCHDEFAULT,
    XTFATCHIMAGEDETAIL,
    XTFATCHCOMMENTS,
};

@interface XTImgDetailLogic : NSObject


@property(nonatomic,strong)NSArray *imgPidArr;



//@property(nonatomic)XTFATCHLOGICTYPE fatchLogicType;

- (instancetype)initWithPidArr:(NSArray *)arr;

-(void)fatchLogicModelWith:(NSInteger )index fatchSuccess1:(void(^)(id))handler1 fatchSuccess2:(void(^)(id))handler2 andFailure:(void(^)(NSError *error))failureBlock;

-(void)insertCommentDataSourceWithPid:(NSString *)pid andModel:(id)model;

-(void)modifyCommendUsersWithPid:(NSString *)pid andArray:(NSArray *)arr;

-(void)addNextPageCommnetDataSourceWithPid:(NSString *)pid andArray:(NSArray *)arr;


@end
