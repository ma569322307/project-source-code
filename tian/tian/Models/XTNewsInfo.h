//
//  XTNewsInfo.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/7.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Mantle.h>
//id	int	图文编号
//title	string	图文标题
//cover	string	图文封面
//supportNum	string	点赞数
//commentNum	string	评论数
//dateCreated	string	创建时间

/**
 *
 *     图文详情类
 */
@interface XTNewsInfo : MTLModel<MTLJSONSerializing>

@property (assign, nonatomic) long pid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSURL *coverURL;
@property (strong, nonatomic) NSString *supportNum;
@property (strong, nonatomic) NSString *commentNum;
@property (assign, nonatomic) NSTimeInterval dateCreated;
@property (assign, nonatomic) BOOL supported;
@property (strong, nonatomic) NSArray *detailsList;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSURL *cover;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic ,copy) NSString *type;
@property (nonatomic,copy) NSString *bigCover;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
