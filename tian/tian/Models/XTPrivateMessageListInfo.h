//
//  XTPrivateMessageListInfo.h
//  StarPicture
//
//  Created by cc on 15-3-15.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
#import "XTUserInfo.h"
#import "XTPrivateMessageInfo.h"
@interface XTPrivateMessageListInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) NSInteger unreadCount;
@property (nonatomic, strong) XTUserInfo * user;
@property (nonatomic, strong) XTPrivateMessageInfo * lastMsg;
@end
