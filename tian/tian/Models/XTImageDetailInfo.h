//
//  XTImageDetailInfo.h
//  StarPicture
//
//  Created by cc on 15-3-4.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
#import "XTUserInfo.h"
#import "XTAlbumInfo.h"
/*
 album =     {
 cover = "";
 id = 8;
 picCount = 0;
 title = "\U6211\U7684\U76f8\U518c";
 };
 artists =     (
 {
 headImg = "http://img3.yytcdn.com/uploads/artists/1/RC302014A207D68B714ED2EE9CB456532.jpg";
 id = 1;
 name = "\U6ee8\U5d0e\U6b65";
 },
 {
 headImg = "http://img1.yytcdn.com/uploads/artists/2/RF2ED0136827CDC4CE17A238E43FDF4D6.png";
 id = 2;
 name = "\U8303\U6653\U8431";
 }
 );
 commendCount = 0;
 commended = 0;
 commentCount = 0;
 createdAt = 1425370709000;
 id = 112651759;
 picUrl = "http://img4.yytcdn.com/others/admin/150212/0/-M-e5e480f2c784372cedc9b127d5879c3d.jpg";
 tags =     (
 tag1,
 tag2
 );
 text = "\U56fe\U7247\U6d4b\U8bd5\Uff0c\U56fe\U7247\U6d4b\U8bd5\Uff0c\U56fe\U7247\U6d4b\U8bd5\Uff0c\U56fe\U7247\U6d4b\U8bd5";
 user =     {
 nickName = sunquan;
 smallAvatar = "http://img4.yytcdn.com/user/avatar/130724/8195152/452F01400E80F1B61144D954577C1C14_20x20.jpeg";
 uid = 8195152;
 };

 */
@interface XTImageDetailInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSURL *picUrl;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) float width;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger commendCount;
@property (nonatomic, assign) BOOL commended;
@property (nonatomic, strong) XTUserInfo *user;
@property (nonatomic, strong) XTAlbumInfo *album;
@property (nonatomic, strong) NSArray * artists;
@property (nonatomic, strong) NSArray *tags;

@end
