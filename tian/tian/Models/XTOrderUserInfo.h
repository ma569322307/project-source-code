//
//  XTOrderUserInfo.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/6.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Mantle.h>

/**
 *  订阅用户模型类
 *
 */
@interface XTOrderUserInfo : MTLModel<MTLJSONSerializing>
@property (assign, nonatomic) int uid;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSURL *smallAvatarURL;
@property (assign, nonatomic) BOOL subStatus;
@property (assign, nonatomic) int prestigeValue;
@end
