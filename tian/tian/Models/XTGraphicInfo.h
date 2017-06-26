//
//  XTGraphicInfo.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/7.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Mantle.h>

//id	Object	图文详情编号
//picId	int	图文详情图片编号
//picUrl	int	图文详情图片URL
//content	string	图文详情图片描述
//displayOrder	string	图文详情图片显示顺序
//dateCreatedString	string	图文详情图片创建时间

/**
 *  
 *     图文详情子类
 */
@interface XTGraphicInfo : MTLModel<MTLJSONSerializing>

@property (assign, nonatomic) long gid;
@property (assign, nonatomic) long picId;
@property (strong, nonatomic) NSURL *picURL;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *displayOrder;
@property (strong, nonatomic) NSString *dateCreatedString;
@property (assign, nonatomic) NSTimeInterval dateCreated;

@end
