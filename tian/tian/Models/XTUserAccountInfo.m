//
//  XTUserAccountInfo.m
//  StarPicture
//
//  Created by 尚毅 杨 on 15/2/13.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTUserAccountInfo.h"
#import <Foundation/Foundation.h>
@interface XTUserAccountInfo()
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL subStatus;
@end

@implementation XTUserAccountInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"userID":         @"uid",
             @"nickname":       @"nickName",
             @"smallAvatarURL": @"smallAvatar",
             @"bigAvatarURL":   @"largeAvatar",
             @"createTime":     @"createdAt",
			 @"levelName":		@"title",
             };
}

//int类型转换成NSString
+ (NSValueTransformer *)userIdJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *objID) {
        return [objID stringValue];
    }];
}

- (void)setUserId:(NSString *)userId{
    if (userId) {
        _userID = userId;
    }
}

- (void)setSubStatus:(BOOL)subStatus{
    _hasFollowed = subStatus;
}

+ (NSValueTransformer *)userIDJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *objID) {
        return [objID stringValue];
    }];
}

+ (NSValueTransformer *)genderJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"Boy": @"男",
                                                                           @"Girl": @"女",
                                                                           @"Secret": @"保密"
                                                                           }];
}

//string类型转换成NSURL
+ (NSValueTransformer *)smallAvatarURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)bigAvatarURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

//long类型转换成NSDate
+ (NSValueTransformer *)createTimeJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *timeInMillisecond) {
        return [NSDate dateWithTimeIntervalSince1970:[timeInMillisecond doubleValue] / 1000];
    }];
}

//long类型转换成NSDate
+ (NSValueTransformer *)birthdayJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *timeInMillisecond) {
        return [NSDate dateWithTimeIntervalSince1970:[timeInMillisecond doubleValue] / 1000];
    }];
}

+ (NSValueTransformer *)friendsCountJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *friendsCount) {
        return [friendsCount stringValue];
    }];
}

+ (NSValueTransformer *)fansCountJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *fansCount) {
        return [fansCount stringValue];
    }];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.phone = [coder decodeObjectForKey:@"phone"];
        self.userID = [coder decodeObjectForKey:@"userID"];
        self.email = [coder decodeObjectForKey:@"email"];
        self.nickname = [coder decodeObjectForKey:@"nickname"];
        self.userDescription = [coder decodeObjectForKey:@"userDescription"];;
        self.gender = [coder decodeObjectForKey:@"gender"];
        self.smallAvatarURL = [coder decodeObjectForKey:@"smallAvatarURL"];
        self.bigAvatarURL = [coder decodeObjectForKey:@"bigAvatarURL"];
        self.bgImgURL = [coder decodeObjectForKey:@"bgImgURL"];
        self.birthday = [coder decodeObjectForKey:@"birthday"];
        self.createTime = [coder decodeObjectForKey:@"createTime"];
        self.emailVerified = [[coder decodeObjectForKey:@"emailVerified"] boolValue];
        self.access_token = [coder decodeObjectForKey:@"access_token"];
        self.expires_in = [coder decodeObjectForKey:@"expires_in"];
        self.refresh_token = [coder decodeObjectForKey:@"refresh_token"];
        self.bindStatus = [[coder decodeObjectForKey:@"bindStatus"] integerValue];
        
        self.lastSignDate = [coder decodeObjectForKey:@"lastSignDate"];
        self.continueDays = [coder decodeObjectForKey:@"continueDays"];
        self.allDays = [coder decodeObjectForKey:@"allDays"];
        
        self.renownCount = [coder decodeObjectForKey:@"renownCount"];
        self.brief = [coder decodeObjectForKey:@"brief"];
        self.type = (XTAccountCategory)[[coder decodeObjectForKey:@"type"] intValue];
        self.friendsCount = [coder decodeObjectForKey:@"friendsCount"];
        self.fansCount = [coder decodeObjectForKey:@"fansCount"];
        self.albumCount = [coder decodeObjectForKey:@"albumCount"];
        self.picCount = [coder decodeObjectForKey:@"picCount"];
        self.subArtistCount = [coder decodeObjectForKey:@"subArtistCount"];
        self.hideArtistCount = [coder decodeObjectForKey:@"hideArtistCount"];
        self.commendCount = [coder decodeObjectForKey:@"commendCount"];
        self.favoriteCount = [coder decodeObjectForKey:@"favoriteCount"];
        self.percentage = [coder decodeObjectForKey:@"percentage"];
        self.level = [coder decodeObjectForKey:@"level"];
        self.levelName = [coder decodeObjectForKey:@"levelName"];

        self.honours = [coder decodeObjectForKey:@"honours"];
        self.province = [coder decodeObjectForKey:@"province"];
        self.city = [coder decodeObjectForKey:@"city"];
        self.hasFollowed = [[coder decodeObjectForKey:@"hasFollowed"] boolValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.userID forKey:@"userID"];
    [coder encodeObject:self.email forKey:@"email"];
    [coder encodeObject:self.nickname forKey:@"nickname"];
    [coder encodeObject:self.userDescription forKey:@"userDescription"];
    [coder encodeObject:self.gender forKey:@"gender"];
    [coder encodeObject:self.smallAvatarURL forKey:@"smallAvatarURL"];
    [coder encodeObject:self.bigAvatarURL forKey:@"bigAvatarURL"];
    [coder encodeObject:self.bgImgURL forKey:@"bgImgURL"];
    [coder encodeObject:self.birthday forKey:@"birthday"];
    [coder encodeObject:self.createTime forKey:@"createTime"];
    [coder encodeObject:[NSNumber numberWithBool:self.emailVerified]  forKey:@"emailVerified"];
    [coder encodeObject:self.access_token forKey:@"access_token"];
    [coder encodeObject:self.expires_in forKey:@"expires_in"];
    [coder encodeObject:self.refresh_token forKey:@"refresh_token"];
    [coder encodeObject:[NSNumber numberWithInteger:self.bindStatus] forKey:@"bindStatus"];
    
    [coder encodeObject:self.lastSignDate forKey:@"lastSignDate"];
    [coder encodeObject:self.continueDays forKey:@"continueDays"];
    [coder encodeObject:self.allDays forKey:@"allDays"];
    
    [coder encodeObject:self.renownCount forKey:@"renownCount"];
    [coder encodeObject:self.brief forKey:@"brief"];
    [coder encodeObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    [coder encodeObject:self.friendsCount forKey:@"friendsCount"];
    [coder encodeObject:self.fansCount forKey:@"fansCount"];
    [coder encodeObject:self.albumCount forKey:@"albumCount"];
    [coder encodeObject:self.picCount forKey:@"picCount"];
    [coder encodeObject:self.subArtistCount forKey:@"subArtistCount"];
    [coder encodeObject:self.hideArtistCount forKey:@"hideArtistCount"];
    [coder encodeObject:self.commendCount forKey:@"commendCount"];
    [coder encodeObject:self.favoriteCount forKey:@"favoriteCount"];
    [coder encodeObject:self.percentage forKey:@"percentage"];
    [coder encodeObject:self.level forKey:@"level"];
    [coder encodeObject:self.levelName forKey:@"levelName"];
    
    [coder encodeObject:self.honours forKey:@"honours"];
    [coder encodeObject:self.province forKey:@"province"];
    [coder encodeObject:self.city forKey:@"city"];
    [coder encodeObject:[NSNumber numberWithBool:self.hasFollowed] forKey:@"hasFollowed"];
}
@end
