//
//  XTUserStore.m
//  StarPicture
//
//  Created by 尚毅 杨 on 15/2/12.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTUserStore.h"
#import "XTHTTPRequestOperationManager.h"
#import "NSError+XTError.h"
#import "NSString+NSString_DES.h"
#import "XTUserAccountInfo.h"
#import "XTImageInfo.h"
//#import "XTBlockAlertView.h"
#import "XTBindApnsStore.h"
@interface XTUserSignInInfo : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSDate *lastSignDate;     //最后签到日期
@property (nonatomic, strong) NSString *continueDays;   //签到连续天数
@property (nonatomic, strong) NSString *allDays;        //总签到次数
@end

@implementation XTUserSignInInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}

+ (NSValueTransformer *)lastSignDateJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *timeInMillisecond) {
        return [NSDate dateWithTimeIntervalSince1970:[timeInMillisecond doubleValue] / 1000];
    }];
}

+ (NSValueTransformer *)continueDaysJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *continueDays) {
        return [continueDays stringValue];
    }];
}

+ (NSValueTransformer *)allDaysJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *allDays) {
        return [allDays stringValue];
    }];
}

@end

@interface XTUserDetailInfo : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSURL *smallAvatarURL;    //小头像URL
@property (nonatomic, strong) NSURL *bgImgURL;          //头像背景URL
@property (nonatomic, strong) NSString *nickname;       //用户呢称
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
@property (nonatomic, strong) NSString *gender;         //性别
@property (nonatomic, strong) NSString *province;       //所在省
@property (nonatomic, strong) NSString *city;           //所在市
@property (nonatomic, assign) BOOL hasFollowed;         //是否关注
@property (nonatomic, strong) NSDate *birthday;         //用户生日
@property (nonatomic, strong) NSMutableArray *picList;  //用户图片数组


@end

@implementation XTUserDetailInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"userID":         @"uid",
             @"nickname":       @"nickName",
             @"smallAvatarURL": @"smallAvatar",
             @"bgImgURL":       @"bgImgUrl",
             @"levelName":      @"title"
             };
}

//int类型转换成NSString
+ (NSValueTransformer *)userIDJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *objID) {
        return [objID stringValue];
    }];
}

//long类型转换成NSDate
+ (NSValueTransformer *)birthdayJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *timeInMillisecond) {
        return [NSDate dateWithTimeIntervalSince1970:[timeInMillisecond doubleValue] / 1000];
    }];
}

//string类型转换成NSURL
+ (NSValueTransformer *)smallAvatarURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

//string类型转换成NSURL
+ (NSValueTransformer *)bgImgURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)renownCountJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *renownCount) {
        return [renownCount stringValue];
    }];
}

+ (NSValueTransformer *)typeJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           [NSNumber numberWithInteger:1]: @(XTAccountCommon),
                                                                           [NSNumber numberWithInteger:2]: @(XTAccountFans),
                                                                           [NSNumber numberWithInteger:3]: @(XTAccountManito)
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

+ (NSValueTransformer *)albumCountJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *albumCount) {
        return [albumCount stringValue];
    }];
}

+ (NSValueTransformer *)picCountJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *picCount) {
        return [picCount stringValue];
    }];
}

+ (NSValueTransformer *)subArtistCountJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *subArtistCount) {
        return [subArtistCount stringValue];
    }];
}

+ (NSValueTransformer *)hideArtistCountJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *hideArtistCount) {
        return [hideArtistCount stringValue];
    }];
}

+ (NSValueTransformer *)commendCountJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *commendCount) {
        return [commendCount stringValue];
    }];
}

+ (NSValueTransformer *)favoriteCountJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *favoriteCount) {
        return [favoriteCount stringValue];
    }];
}

+ (NSValueTransformer *)percentageJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *percentage) {
        return [percentage stringValue];
    }];
}

+ (NSValueTransformer *)levelJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *level) {
        return [level stringValue];
    }];
}
@end

@interface XTUserStore ()
{
    XTUserAccountInfo *(^initArchiveUser)(NSDictionary *, NSString *);
}
@end

typedef void (^RequestOperationSuccessBlock)(AFHTTPRequestOperation *, id);
typedef void (^RequestOperationFailureBlock)(AFHTTPRequestOperation *, NSError *);

@implementation XTUserStore
+ (instancetype)sharedManager
{
    static XTUserStore *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[self alloc] init];
    });
    return _shareManager;
}

- (id)init {
    self = [super init];
    if (self) {
        _user = [NSKeyedUnarchiver unarchiveObjectWithFile:[self userArchivePath]];
        if (_user) {
            [[XTHTTPRequestOperationManager sharedManager] setHTTPRequestHeaderField:@"Authorization" value:_user.access_token];
        }
        initArchiveUser = ^XTUserAccountInfo *(NSDictionary *dataDic,NSString *archivePath) {
            XTUserAccountInfo *user = nil;
            NSError *error = nil;
            user = [MTLJSONAdapter modelOfClass:[XTUserAccountInfo class] fromJSONDictionary:dataDic[@"user"] error:&error];
            if (error) {
                [NSException raise:@"XTUserAccountInfo Parse Error" format:@"can't parse: %@", dataDic[@"user"]];
            }
            user.access_token = dataDic[@"access_token"];
            user.expires_in = dataDic[@"expires_in"];
            user.refresh_token = dataDic[@"refresh_token"];
            [NSKeyedArchiver archiveRootObject:user toFile:archivePath];
            [[XTHTTPRequestOperationManager sharedManager] setHTTPRequestHeaderField:@"Authorization" value:dataDic[@"access_token"]];
            return user;
        };
    }
    return self;
}

- (BOOL)isLogin {
    return self.user.access_token != nil;
}

- (id)loginWithUserName:(NSString *)userName
               password:(NSString *)password
        completionBlock:(void (^)(id user, NSError *error))block
{
    NSString *passwordString = [NSString encryptDESPlaintext:[NSString stringWithFormat:@"%@",password]];
    NSLog(@"加密后的密码==%@",passwordString);
    NSDictionary *parameters = @{@"username": userName, @"password": passwordString,@"Auth":[NSNumber numberWithBool:YES]};
    
    RequestOperationSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (!responseObject[@"error"]) {
            _user = initArchiveUser(responseObject, [self userArchivePath]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshRecommend" object:nil];
            //绑定apns
            if ([XTBindApnsStore sharedManager].apnsToken) {
                [[XTBindApnsStore sharedManager] bindApns];
            }
        }
        NSLog(@"%@", responseObject);
        if (block) block(_user, nil);
    };
    RequestOperationFailureBlock failure = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error xtErrorMessage]);
        if (block) block (nil, error);
    };
    XTHTTPRequestOperationManager *reqOperManager =[XTHTTPRequestOperationManager sharedManager];
    return (id)[reqOperManager POST:@"http://capi.yinyuetai.com/common/account/login.json"
                        parameters:parameters
                           success:success
                           failure:failure];
}

- (id)showSignInInfoCompletionBlock:(void (^)(XTUserAccountInfo *user, NSError *error))block
{
    RequestOperationSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSError *error = nil;
        XTUserSignInInfo *result = [MTLJSONAdapter modelOfClass:[XTUserSignInInfo class]
                                             fromJSONDictionary:responseObject
                                                          error:&error];
        if (error) {
            [NSException raise:@"XTUserSignInInfo Parse Error" format:@"can't parse: %@", responseObject];
        }
        
        if (!responseObject[@"error"]) {
            _user.lastSignDate = result.lastSignDate;
            _user.continueDays = result.continueDays;
            _user.allDays = result.allDays;
            [NSKeyedArchiver archiveRootObject:_user toFile:[self userArchivePath]];
            if (block) block([_user copy], nil);
        }
    };
    RequestOperationFailureBlock failure = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error xtErrorMessage]);
        if (block) block (nil, error);
    };
    XTHTTPRequestOperationManager *reqOperManager =[XTHTTPRequestOperationManager sharedManager];
    return (id)[reqOperManager POST:@"http://capi.yinyuetai.com/common/account/sign_in_show.json"
                        parameters:nil
                           success:success
                           failure:failure];
}

- (id)showUserWithUserID:(NSString *)userID
         completionBlock:(void (^)(XTUserAccountInfo *user, NSArray *picArray, NSError *error))block
{
    NSDictionary *parameters = @{@"uid": [NSNumber numberWithInt:[userID intValue]]};
    
    RequestOperationSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"后台接口返回的用户详情：%@", responseObject);
        NSError *error = nil;
        XTUserDetailInfo *result = [MTLJSONAdapter modelOfClass:[XTUserDetailInfo class]
                                             fromJSONDictionary:responseObject
                                                          error:&error];
        if (error) {
            [NSException raise:@"XTUserDetailInfo Parse Error" format:@"can't parse: %@", responseObject];
        }
        if ([_user.userID isEqualToString:userID]) {
            if (!responseObject[@"error"]) {
                _user.renownCount = result.renownCount;
                _user.brief = result.brief;
                _user.type = result.type;
                _user.friendsCount = result.friendsCount;
                _user.fansCount = result.fansCount;
                _user.albumCount = result.albumCount;
                _user.picCount = result.picCount;
                _user.subArtistCount = result.subArtistCount;
                _user.hideArtistCount = result.hideArtistCount;
                _user.commendCount = result.commendCount;
                _user.favoriteCount = result.favoriteCount;
                _user.percentage = result.percentage;
                _user.level = result.level;
                _user.levelName = result.levelName;
                
                _user.honours = result.honours;
                _user.nickname = result.nickname;
                _user.gender = result.gender;
                _user.province = result.province;
                _user.city = result.city;
                _user.birthday = result.birthday;
                _user.smallAvatarURL = result.smallAvatarURL;
                _user.bgImgURL = result.bgImgURL;
                NSArray *imageArray = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:result.picList error:&error];
                [NSKeyedArchiver archiveRootObject:_user toFile:[self userArchivePath]];
                
                if (block) block([_user copy], imageArray, nil);
            }
        }else{
            if (!responseObject[@"error"]) {
                XTUserAccountInfo *userInfo = [[XTUserAccountInfo alloc] init];
                userInfo.userID = result.userID;
                userInfo.renownCount = result.renownCount;
                userInfo.brief = result.brief;
                userInfo.type = result.type;
                userInfo.friendsCount = result.friendsCount;
                userInfo.fansCount = result.fansCount;
                userInfo.albumCount = result.albumCount;
                userInfo.picCount = result.picCount;
                userInfo.subArtistCount = result.subArtistCount;
                userInfo.hideArtistCount = result.hideArtistCount;
                userInfo.commendCount = result.commendCount;
                userInfo.favoriteCount = result.favoriteCount;
                userInfo.percentage = result.percentage;
                userInfo.level = result.level;
                userInfo.levelName = result.levelName;
                
                userInfo.honours = result.honours;
                userInfo.nickname = result.nickname;
                userInfo.gender = result.gender;
                userInfo.province = result.province;
                userInfo.city = result.city;
                userInfo.birthday = result.birthday;
                userInfo.smallAvatarURL = result.smallAvatarURL;
                userInfo.bgImgURL = result.bgImgURL;
                userInfo.hasFollowed = result.hasFollowed;
                NSArray *imageArray = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:result.picList error:&error];
                
                if (block) block(userInfo, imageArray, nil);
            }
        }
    };
    RequestOperationFailureBlock failure = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error xtErrorMessage]);
        if (block) block (nil, nil, error);
    };
    XTHTTPRequestOperationManager *reqOperManager =[XTHTTPRequestOperationManager sharedManager];
    return (id)[reqOperManager GET:@"account/user/show.json"
                        parameters:parameters
                           success:success
                           failure:failure];
}

- (id)signInWithCompletionBlock:(void (^)(id user, NSError *error))block{
    RequestOperationSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if (!responseObject[@"error"]) {
            if (block) block(responseObject, nil);
        }
    };
    RequestOperationFailureBlock failure = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error xtErrorMessage]);
        if (block) block (nil, error);
    };
    XTHTTPRequestOperationManager *reqOperManager =[XTHTTPRequestOperationManager sharedManager];
    return (id)[reqOperManager GET:@"http://capi.yinyuetai.com/common/account/sign_in.json"
                        parameters:nil
                           success:success
                           failure:failure];
}

- (id)setNickname:(NSString *)nickname
  completionBlock:(void (^)(BOOL isSuccess, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"nickName":    nickname,
                                 };
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"account/user/update.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"修改昵称后台数据：%@",responseObject);
        
        if (block) block(YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)setUserBrief:(NSString *)brief
   completionBlock:(void (^)(BOOL isSuccess, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"brief":    brief,
                                 };
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"account/user/update.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"修改签名后台数据：%@",responseObject);
        
        if (block) block(YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)setUserProvince:(NSString *)province
                 city:(NSString *)city
      completionBlock:(void (^)(BOOL isSuccess, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"province":    province,
                                 @"city":        city
                                 };
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"account/user/update.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"修改位置后台数据：%@",responseObject);
        
        if (block) block(YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)setBirthday:(long)birthday
  completionBlock:(void (^)(BOOL isSuccess, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"birthday":    [NSNumber numberWithLong:birthday],
                                 };
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"account/user/update.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"修改生日后台数据：%@",responseObject);
        
        if (block) block(YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)setGender:(NSString *)gender
completionBlock:(void (^)(BOOL isSuccess, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"gender":    gender,
                                 };
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"account/user/update.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"修改性别后台数据：%@",responseObject);
        
        if (block) block(YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (id)setHeadImage:(NSString *)image
   completionBlock:(void (^)(BOOL isSuccess, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"headImg":    image,
                                 };
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"account/user/update.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"修改头像后台数据：%@",responseObject);
        
        if (block) block(YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (void)logoutWithBlock:(void (^)(BOOL , NSError *))block
{
    [[XTHTTPRequestOperationManager sharedManager] POST:@"http://capi.yinyuetai.com/common/account/logout.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(YES,nil);
        //解除绑定apns
//        if ([XTBindApnsStore sharedManager].apnsToken) {
//            [[XTBindApnsStore sharedManager] bindApns];
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(NO,nil);
    }];
    [self removeUserInfo];
}

- (id)registerWithPhoneNumber:(NSString *)phoneNumber
             verificationCode:(NSString *)verificationCode
                     password:(NSString *)password
                   repassword:(NSString *)repassword
              completionBlock:(void (^)(NSMutableDictionary *dic,XTUserAccountInfo *user, NSError *error))block
{
    NSString *passwordString = [NSString encryptDESPlaintext:[NSString stringWithFormat:@"%@",password]];
    NSString *rePasswordString = [NSString encryptDESPlaintext:[NSString stringWithFormat:@"%@",repassword]];

    NSDictionary *parameters = @{
                                 @"phone": phoneNumber,
                                 @"code": verificationCode,
                                 @"pwd":passwordString,
                                 @"repwd":rePasswordString
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager POST:@"http://capi.yinyuetai.com/common/account/register_by_phone.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject[@"error"]) {
            _user = initArchiveUser(responseObject, [self userArchivePath]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshRecommend" object:nil];
        }
        block(responseObject, _user , nil);
//        XTBlockAlertView *alert = [[XTBlockAlertView alloc]initWithTitle:@"提示" message:@"注册成功" withCancelBlock:nil withOtherBlock:nil];
//        [alert show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,nil, error);
    }];
}
//为可用手机号下发验证码
- (id)checkPhoneAuthCode:(NSDictionary *)param
         completionBlock:(void (^)(id dic, NSError *error))block {
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"http://capi.yinyuetai.com/common/account/send_code.json" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (block) block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(operation.responseObject, error);
//        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[NSString stringWithFormat:@"%@",error] withCompletionBlock:^{
//        
//        }];
    }];
}

- (id)resetPassword:(NSDictionary *)param
    completionBlock:(void (^)(id dic, NSError *error))block
{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"http://capi.yinyuetai.com/common/account/reset_password.json" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(operation.responseObject, error);
    }];
}
-(id)boundIphoneNumberWithComletionBlock:(NSDictionary *)parm and:(void(^)(id dic, NSError *error))block{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager POST:@"http://capi.yinyuetai.com/common/account/bind_phone.json" parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) block (responseObject ,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block (operation.responseObject ,error);
            }];
}

- (NSString *)userArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"user.archive"];
}

- (void)removeUserInfo {
    
    [[XTHTTPRequestOperationManager sharedManager] setHTTPRequestHeaderField:@"Authorization" value:nil];
    
    NSString *archivePath = [self userArchivePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:archivePath]) {
        [fileManager removeItemAtPath:archivePath error:nil];
    }
    _user = nil;
}

/**
 *
 *    第三方用户登录
 */
- (id)loginFromSocialPlatform:(NSDictionary *)params Withcompletion:(void(^)(id user, NSError *error))block
{
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
//                          http://capi.yinyuetai.com/common/account/login_by_open.json
    return [manager POST:@"http://capi.yinyuetai.com/common/account/login_by_open.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject[@"error"]) {
            _user = initArchiveUser(responseObject, [self userArchivePath]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserHomePage" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshRecommend" object:nil];
        }
        if (block) block(_user, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(operation.responseObject, error);
    }];

}

/**
 *  登录界面图片推荐列表
 */
- (id)recommendPicWithcompletionBlock:(void (^)(id dic, NSError *error))block
{
    NSDictionary *parameters = @{
                                 @"size": [NSNumber numberWithInt:4],
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    return [manager GET:@"picture/list/recommend/login.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject , nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (id)setNotifiesPush:(NSString *)deviceToken
                allow:(BOOL)isAllow
      completionBlock:(void (^)(BOOL success, NSError *error))block{
    NSDictionary *parameters = @{
                                 @"device_token":    deviceToken,
                                 @"allow":        [NSNumber numberWithBool:isAllow]
                                 };
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    return [manager POST:@"notifies/push/set.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"推送消息设置后台返回数据：%@",responseObject);
        
        if (block) block(YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}


-(void)dealloc{

    NSLog(@"dsdsd");
}

@end
