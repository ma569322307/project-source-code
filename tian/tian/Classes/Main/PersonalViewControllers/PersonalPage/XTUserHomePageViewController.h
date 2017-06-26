//
//  XTUserHomePageViewController.h
//  tian
//
//  Created by 尚毅 杨 on 15/4/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"

typedef enum {
    XTUserHomePageTypeMine= 0,  //我的个人主页
    XTUserHomePageTypeHis,      //他的个人主页
    XTUserHomePageTypeArtist,   //艺人主页
} XTUserHomePageType;
@class XTUserAccountInfo;
/*
    默认显示普通用户的我的个人页
 */
@interface XTUserHomePageViewController : XTRootViewController
@property (nonatomic, assign) XTUserHomePageType type;    //页面类型（我的个人页、他的个人页）
@property (nonatomic, strong) NSString *userID;           //用户ID
@property (nonatomic, assign) XTAccountCategory userType; //用户类型（分为普通用户、大V用户）

@property (nonatomic, assign) BOOL imagePickerWillDisplay;
@property (nonatomic, assign) BOOL willPushToUserPage;

@property (nonatomic, assign) BOOL isRefreshAlbumDetail;
@property (nonatomic, assign) BOOL isRefreshAlbumList;
@property (nonatomic, assign) BOOL isRefreshUserTopic;
@property (nonatomic, assign) BOOL isRefreshUserFiles;
@end
