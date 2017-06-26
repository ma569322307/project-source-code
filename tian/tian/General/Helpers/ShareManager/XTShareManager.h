//
//  XTShareManager.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/10.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"//新浪微博
#import "XTShareSheet.h"

#define APPID_WeiXin    @"wxc8b1a54d24eb3e93"
#define APPSecret_WeiXin @"19cd4c7ef82a06a06f158ff5145a167f"
#define APPID_Qzone     @"tencent1104332950"
#define APPID_SinaWeiBo @"wb3583787489"
typedef NS_ENUM (NSInteger, XTShareType) {
    XTShareTypeQzone,                  //QQ空间
    XTShareTypeSina,                   //新浪微博
    XTShareTypeWeiXinfriendCircle,     //微信朋友圈
    XTShareTypeQQ,                     //QQ
    XTShareTypeWeiXinFriend            //微信好友
};

typedef NS_ENUM (NSInteger, XTShareModeType) {
    XTShareModeTypeAtlas,                   //设置分享
    XTShareModeTypePicture,                 //图片详情分享
    XTShareModeTypeTopicDetails,            //话题详情
    XTShareModeTypeSeries,                  //系列内容分享页面
    XTShareModeTypePicShare,                //独家原创分享页面
    XTShareModeTypeStar,                    //专属艺人分享页面
    XTShareModeTypeHotEvent,                //热点事件分享页面
    XTShareModeTypeTopic,                   //热门话题分享页面
    XTShareModeTypeBigV,                    //大V宣传分享页面
};

@interface XTShareManager : NSObject<UIActionSheetDelegate,TencentSessionDelegate,WeiboSDKDelegate>
{
    TencentOAuth *_tencentOAuth;
}

@property (nonatomic, assign) XTShareType shareType;  //分享的第三方类型
@property (nonatomic, assign) XTShareModeType modeType; //分享的内容类型
@property (nonatomic, strong) NSString *desc;  // 图片描述
@property (nonatomic, strong) UIImage *image;  //分享图片
@property (nonatomic, strong) NSString *urlString;  //分享网页链接
@property (nonatomic, assign) long pid;
@property (nonatomic, strong) NSString *title; //分享标题
+ (instancetype)sharedManager;
/**
 *   微信登录
 */
- (void)WXLogin:(void (^)(void))block;
- (void)getWXAccessTokenWithCode:(NSString *)wxCode;

/*! @brief WXApi的成员函数，向微信终端程序注册第三方应用。
 *
 * 需要在每次启动第三方应用程序时调用。第一次调用后，会在微信的可用应用列表中出现。
 * @see registerApp
 * @param appid 微信开发者ID
 * @param appdesc 应用附加信息，长度不超过1024字节
 * @return 成功返回YES，失败返回NO。
 */
- (void)shareWithMvDesc:(NSString *)desc withImage:(UIImage *)image withShareModeType:(XTShareModeType)modeType withPid:(long)pid withShareSheetType:(XTShareSheetItemType)type withCompletionBlock:(AlertViewBlock)completion;

-(void)shareWithTitle:(NSString *)title withMvDesc:(NSString *)desc withImage:(UIImage *)image withShareModeType:(XTShareModeType)modeType withPid:(long)pid withShareSheetType:(XTShareSheetItemType)type withCompletionBlock:(AlertViewBlock)completion;
/**
 *
 *   新浪sso登录
 */
- (void)ssoSinaLogin:(void (^)(void))block;
/**
 *
 *   QQsso登录
 */
- (void)ssoQQLogin:(void (^)(void))block;
@end
