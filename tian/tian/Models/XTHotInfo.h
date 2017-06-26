//
//  XTHotInfo.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/5.
//  Copyright (c) 2015年 cc. All rights reserved.
//


#import <Mantle.h>

//id	int	热门推荐编号
//title	string	热门推荐标题
//cover	string	热门推荐封面
//viewType	string	热门推荐类型，"1"为图文，"2"为图册，"3"为图片
//viewId	int	热门推荐内容编号，为图册或图文的编号
//dateCreated	long	创建时间

/**
 *
 *     热门模型类
 */
@interface XTHotInfo : MTLModel<MTLJSONSerializing>
@property (assign, nonatomic) int hid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *cover;
@property (assign, nonatomic) int viewId;
@property (assign, nonatomic) int viewType;
@property (assign, nonatomic) NSTimeInterval dateCreated;
@end
