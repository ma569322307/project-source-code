//
//  XTRenownInfo.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/9.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Mantle.h>
/**
 *
 *     用户排行模型类
 */
//nickName = "\U7d20\U96f7\U96f7\U96f7";
//ranking = 2;
//renown = 98;
//smallAvatar = "http://img3.yytcdn.com/uploads/default/headImg/header94.gif";
//uid = 7615150;
@interface XTRenownInfo : MTLModel<MTLJSONSerializing>
@property (assign, nonatomic) long uid;
@property (assign, nonatomic) int ranking; //排名
@property (assign, nonatomic) int renown;   //声望
@property (strong, nonatomic) NSURL *smallAvatarURL; //头像
@property (strong, nonatomic) NSString *nickName; //昵称
@end
