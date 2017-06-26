//
//  XTMessageListNotifiesInfo.h
//  StarPicture
//
//  Created by cc on 15-3-15.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
#import "XTUserInfo.h"
#import "XTMessageDataInfo.h"
@interface XTMessageListNotifiesInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) long id;
@property (nonatomic, strong) NSString * source;
@property (nonatomic, strong) NSString * sourceName;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, strong) XTUserInfo * user;
@property (nonatomic, strong) XTMessageDataInfo *data;

@end
