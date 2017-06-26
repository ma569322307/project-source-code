//
//  XTUserInfo.h
//  StarPicture
//
//  Created by cc on 15-3-4.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
/**
 *  用户info
 */
@interface XTUserInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSURL    *smallAvatar;
@property (nonatomic, strong) NSURL    *bigAvatar;
@property (nonatomic, assign) long     uid;
@property (nonatomic, assign) long     level;
@property (nonatomic, assign) BOOL     vuser;
@property (nonatomic, copy) NSString   *title;
@property (nonatomic, assign) BOOL     follow;
@property (nonatomic, copy  ) NSArray  *medals;
@property (nonatomic, assign) long     prestigeValue;
@property (nonatomic, assign) long     ranking;
@property (nonatomic)NSInteger type;
@end
