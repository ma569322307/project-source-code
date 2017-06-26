//
//  XTAlbumInfo.h
//  StarPicture
//
//  Created by cc on 15-3-5.
//  Copyright (c) 2015年 cc. All rights reserved.
//
/*搜索
 {
 cover = "";
 dateCreated = 1424937343000;
 id = 8;
 personal = 0;
 picNum = 19;
 tags =             (
 "\U52a8\U6f2b",
 "\U6d77\U8d3c"
 );
 title = "\U6211\U7684\U76f8\U518c";
 user =             {
 nickName = sunquan;
 smallAvatar = "http://img4.yytcdn.com/user/avatar/130724/8195152/452F01400E80F1B61144D954577C1C14_20x20.jpeg";
 uid = 8195152;
 };
 }
 */
#import "MTLModel.h"
#import <Mantle.h>
#import "XTUserInfo.h"

typedef NS_ENUM(NSInteger, AlbumType) {
    AlbumTypePublic, //公开类型
    AlbumTypeSecret, //私密类型
};

/**
 *  相册
 */
@interface XTAlbumInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) AlbumType type;
@property (nonatomic, strong) NSDate *createTime;       //相册创建日期
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *cover;
@property (nonatomic, assign) long id;
@property (nonatomic, assign) NSInteger picCount;
@property (nonatomic, strong) NSArray *pics;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSString *des;

@property (nonatomic, strong) XTUserInfo *user;
@end
