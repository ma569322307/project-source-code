//
//  XTCreateTopic.h
//  tian
//
//  Created by yyt on 15/7/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@interface XTCreateTopic : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) NSInteger favoritesCount;
@property (nonatomic, assign) NSInteger replaceid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign)NSInteger created;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, copy) NSString *descrip;
@property (nonatomic, assign) NSInteger PostCount;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic,strong) NSDictionary *user;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSString *smallAvatar;
@property (nonatomic, copy) NSString *bigAvatar;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;




@end
