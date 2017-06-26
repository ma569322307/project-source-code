//
//  XTUserAccountInfo.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/2/13.
//  Copyright (c) 2015年 cc. All rights reserved.
//

//#import "MTLModel.h"
#import <Mantle.h>

typedef NS_ENUM(NSInteger, XTPeopleGender) {
    XTPeopleMale = 0,
    XTPeopleFemale
};

typedef NS_ENUM(NSInteger, XTAccountCategory) {
    XTAccountCommon = 1,
    XTAccountFans,
    XTAccountManito
};

/**
 *  用户详情模型类
 *
 */
@interface XTUserAccountInfo : MTLModel<MTLJSONSerializing, NSCoding>
//uid	int	该用户编号
//email	string	账号
//nickName	string	昵称
//description	string	描述
//gender	string	性别
//smallAvatar	string	小头像
//largeAvatar	string	大头像
//birthday	string	生日
//location	string	用户所在位置
//createdAt	long	用户注册时间
//emailVerified	bool	邮箱是否验证
//access_token	string	访问令牌
//token_type	string	令牌类型
//expires_in	string	令牌过期时间
//refresh_token	string	刷新令牌

@property (nonatomic, strong) NSString *userID;         //用户编号
@property (nonatomic, strong) NSString *email;          //邮箱账号
@property (nonatomic, strong) NSString *nickname;       //用户呢称
@property (nonatomic, strong) NSString *userDescription;//描述
@property (nonatomic, strong) NSString *gender;         //性别
@property (nonatomic, strong) NSURL *smallAvatarURL;    //小头像URL
@property (nonatomic, strong) NSURL *bigAvatarURL;      //大头像URL
@property (nonatomic, strong) NSURL *bgImgURL;          //头像背景URL
@property (nonatomic, strong) NSDate *birthday;         //生日
@property (nonatomic, strong) NSDate *createTime;       //用户注册时间
@property (nonatomic, assign) BOOL emailVerified;       //邮箱是否验证
@property (nonatomic, strong) NSString *access_token;   //访问令牌
@property (nonatomic, strong) NSString *expires_in;     //令牌过期时间
@property (nonatomic, strong) NSString *refresh_token;  //刷新令牌
@property (nonatomic, assign) NSInteger bindStatus;     //绑定手机邮箱状态  1未绑定， 2绑定邮箱， 4绑定手机， 3绑定邮箱且绑定手机

@property (nonatomic, strong) NSDate *lastSignDate;     //最后签到日期
@property (nonatomic, strong) NSString *continueDays;   //签到连续天数
@property (nonatomic, strong) NSString *allDays;        //总签到次数

@property (nonatomic, strong) NSString *renownCount;    //用户积分
@property (nonatomic, strong) NSString *brief;          //用户签名
@property (nonatomic, assign) XTAccountCategory type;   //用户类型
@property (nonatomic, strong) NSString *friendsCount;   //关注数
@property (nonatomic, strong) NSString *fansCount;      //粉丝数
@property (nonatomic, strong) NSString *albumCount;     //相册数
@property (nonatomic, strong) NSString *picCount;       //图片数
@property (nonatomic, strong) NSString *subArtistCount; //订阅艺人数
@property (nonatomic, strong) NSString *hideArtistCount;//屏蔽艺人数
@property (nonatomic, strong) NSString *commendCount;   //点赞数
@property (nonatomic, strong) NSString *favoriteCount;  //收藏数
@property (nonatomic, strong) NSString *percentage;     //距离下一个等级的百分比值
@property (nonatomic, strong) NSString *level;          //用户等级
@property (nonatomic, strong) NSString *levelName;      //用户等级名

@property (nonatomic, strong) NSArray *honours;         //获得勋章数组
@property (nonatomic, strong) NSString *province;       //所在省
@property (nonatomic, strong) NSString *city;           //所在市
@property (nonatomic, assign) BOOL hasFollowed;         //是否关注
@property (nonatomic, strong) NSString *phone;         //手机号码
@end


