//
//  XTOrderArtist.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/4.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Mantle.h>

@interface XTOrderArtist : MTLModel<MTLJSONSerializing>

//id	int	艺人编号
//name	string	艺人名称
//headImg	string	艺人封面
//picNum	int	图片数量
//subNum	int	用户订阅数量

//搜索用户model
/*
fans = 0;
headImg = "http://qzapp.qlogo.cn/qzapp/204269/0DBC7F5C68FAD28B96E23975A0A5E6AA/100";
id = 9411871;
name = "\U67f3\U6697\U82b1\U660e";
pics = 0;
 */

/**
 *
 *     艺人模型类
 */
@property (assign, nonatomic) int       artistId;//艺人ID
@property (strong, nonatomic) NSString  *artistName;//艺人名称
@property (strong, nonatomic) NSString  *headImg;//艺人小头像
@property (assign, nonatomic) int       bigvNum;//舔神数量
@property (assign, nonatomic) int       subNum;//粉丝订阅数量
@property (assign, nonatomic) BOOL      subStatus;//是否喜欢
@property (assign, nonatomic) BOOL      black;//是否嫌弃
@property (strong, nonatomic) NSString  *bigAvatar;//艺人大头像
@property (strong, nonatomic) NSString  *thumbnailPic;//艺人背景图
@property (assign, nonatomic) BOOL      selected;//用于判断cell上的按钮是否被选中

//搜索用户添加字段
@property (assign, nonatomic) NSInteger fans;
@property (assign, nonatomic) NSInteger picCount;
@property (copy,   nonatomic) NSArray   *pics;
@property (assign, nonatomic) BOOL      follow;//是否关注
@end
