//
//  XTUserInfo.m
//  StarPicture
//
//  Created by cc on 15-3-4.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTUserInfo.h"

@interface XTUserInfo ()
//兼容字段
@property (nonatomic, assign) long     userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSURL    *headImg;
@property (nonatomic, assign) BOOL     v;

@end

@implementation XTUserInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}
//string类型转换成NSURL
+ (NSValueTransformer *)smallAvatarJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

//string类型转换成NSURL
+ (NSValueTransformer *)bigAvatarJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

//string类型转换成NSURL
+ (NSValueTransformer *)headImgJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (void)setUserId:(long)userId {
    self.uid = userId;
}

- (void)setUserName:(NSString *)userName {
    self.nickName = userName;
}

- (void)setHeadImg:(NSURL *)headImg {
    self.bigAvatar = headImg;
}

- (void)setV:(BOOL)v {
    self.vuser = v;
}

@end
