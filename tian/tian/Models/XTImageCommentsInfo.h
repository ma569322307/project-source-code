//
//  XTImageCommentsInfo.h
//  StarPicture
//
//  Created by cc on 15-3-4.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@class XTUserInfo;
/*
 {
 audioDuration = 0;
 audioUrl = "";
 createdAt = 1425718415000;
 id = 39523712;
 sid = 112751959;
 text = "\U8fd9\U5c31kopsdkfgl;kdsl;fgkdls;fkg;ldkfgl;fgk'l;dsfg\U662f\U6211sdfgdsfgsdfgdsfgdsfgdsfgdfgsdfg\U7684\U8bc4\U8bba\Uff0c\U5475sdfgsdfgsdfgsdfgsdfg\U5475\U54c8\U54c8\U3002";
 top = 1;
 user =             {
 nickName = "\U6d41\U901d\U7684\U9752\U6625";
 smallAvatar = "http://img0.yytcdn.com/uploads/default/persons/header999_20x20.jpg";
 uid = 21605147;
 };
 },
 */
@interface XTImageCommentsInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) long id;
@property (nonatomic, assign) long sid;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, assign) BOOL commended;
@property (nonatomic, assign) NSInteger commendCount;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) XTUserInfo *user;
@property (nonatomic, strong) XTImageCommentsInfo * originalComment;


@end
