//
//  XTUnReadInfo.h
//  StarPicture
//
//  Created by cc on 15-3-31.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@interface XTUnReadInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) NSInteger msgCount;
@property (nonatomic, assign) NSInteger notifyCount;
@property (nonatomic, assign) NSInteger newFriendStatus;
@end
