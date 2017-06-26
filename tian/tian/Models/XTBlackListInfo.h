//
//  XTBlackListInfo.h
//  StarPicture
//
//  Created by cc on 15-3-4.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@interface XTBlackListInfo : MTLModel<MTLJSONSerializing>
//艺人集合
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSURL *smallAvatar;
//标签集合
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) NSInteger fans;
@property (nonatomic, assign) NSInteger pics;
@end
