//
//  XTUserStore.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/2/12.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * XTUserAccountInfo:
 * 1.提供用户相关的网络请求接口
 * 2.提供用户信息
 */
@class XTUserAccountInfo;
@interface XTUserStore : NSObject
@property (nonatomic, readonly) XTUserAccountInfo *user;

+ (instancetype)sharedManager;
/**
 * 判断是否登录
 */
- (BOOL)isLogin;

/**
 * 使用用户名、密码登录
 */
- (id)loginWithUserName:(NSString *)userName
               password:(NSString *)password
        completionBlock:(void (^)(id user, NSError *error))block;

/**
 * 获取用户签到信息
 */
- (id)showSignInInfoCompletionBlock:(void (^)(XTUserAccountInfo *user, NSError *error))block;

/**
 * 获取用户详细资料（包括图册图像数等...）
 */
- (id)showUserWithUserID:(NSString *)userID
         completionBlock:(void (^)(XTUserAccountInfo *user, NSArray *picArray, NSError *error))block;

/**
 * 用户签到
 */
- (id)signInWithCompletionBlock:(void (^)(id user, NSError *error))block;

/**
 * 修改用户呢称
 */
- (id)setNickname:(NSString *)nickname
  completionBlock:(void (^)(BOOL isSuccess, NSError *error))block;

/**
 * 修改用户签名
 */
- (id)setUserBrief:(NSString *)brief
   completionBlock:(void (^)(BOOL isSuccess, NSError *error))block;

/**
 * 修改用户所在地
 */
- (id)setUserProvince:(NSString *)Province
                 city:(NSString *)city
      completionBlock:(void (^)(BOOL isSuccess, NSError *error))block;

/**
 * 修改用户生日
 */
- (id)setBirthday:(long)birthday
  completionBlock:(void (^)(BOOL isSuccess, NSError *error))block;

/**
 * 修改用户性别
 */
- (id)setGender:(NSString *)gender
completionBlock:(void (^)(BOOL isSuccess, NSError *error))block;

/**
 * 修改用户头像
 */
- (id)setHeadImage:(NSString *)image
   completionBlock:(void (^)(BOOL isSuccess, NSError *error))block;

/**
 * 退出登录
 */
-(void)logoutWithBlock:(void (^)(BOOL , NSError *))block;

/**
 * 手机号注册
 */
- (id)registerWithPhoneNumber:(NSString *)phoneNumber
             verificationCode:(NSString *)verificationCode
                     password:(NSString *)password
                   repassword:(NSString *)repassword
              completionBlock:(void (^)(NSMutableDictionary *dic,XTUserAccountInfo *user, NSError *error))block;
/**
 *  为可用手机号下发验证码
 */
- (id)checkPhoneAuthCode:(NSDictionary *)param
         completionBlock:(void (^)(id dic, NSError *error))block;

/**
 *  根据手机找回密码
 */
- (id)resetPassword:(NSDictionary *)param
         completionBlock:(void (^)(id dic, NSError *error))block;

/**
 *
 *    删除用户信息
 */
- (void)removeUserInfo;

/**
 *
 *    第三方用户登录
 */
- (id)loginFromSocialPlatform:(NSDictionary *)params Withcompletion:(void(^)(id user, NSError *error))block;

/**
 *  登录界面图片推荐列表
 */
- (id)recommendPicWithcompletionBlock:(void (^)(id dic, NSError *error))block;

/*
 *绑定手机号码
 */
-(id)boundIphoneNumberWithComletionBlock: (NSDictionary *)parm and:(void(^)(id dic, NSError *error))block;
///*
// *修改密码
// */
//- (id)changePassWord:(NSDictionary *)param
//         completionBlock:(void (^)(id dic, NSError *error))block;

/**
 *  根据手机找回密码
 */
- (id)setNotifiesPush:(NSString *)deviceToken
                allow:(BOOL)isAllow
      completionBlock:(void (^)(BOOL success, NSError *error))block;


@end
