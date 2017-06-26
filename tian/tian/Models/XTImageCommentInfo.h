//
//  XTImageCommentInfo.h
//  StarPicture
//
//  Created by cc on 15-3-7.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@class XTUserInfo;
@interface XTImageCommentInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) long pid;
@property (nonatomic, assign) long cid;
@property (nonatomic, assign) BOOL commend;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) XTUserInfo *user;

@end
