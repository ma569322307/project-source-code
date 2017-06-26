//
//  XTSearchUserModel.h
//  tian
//
//  Created by huhuan on 15/6/12.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"

@interface XTSearchUserModel : MTLModel<MTLJSONSerializing>

/**
 *   友尽列表添加 shipendId
 */
@property (nonatomic, assign) long      shipendId;

@property (nonatomic, assign) long      userId;
@property (nonatomic, copy  ) NSString  *name;
@property (nonatomic, copy  ) NSString  *headImg;
@property (nonatomic, copy  ) NSString  *follow;
@property (nonatomic, copy  ) NSString  *like;
@property (nonatomic, copy  ) NSString  *black;
@property (nonatomic, copy  ) NSString  *level;
@property (nonatomic, copy  ) NSString  *levelName;
@property (nonatomic, copy  ) NSString  *sex;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) long      fans;

@end
