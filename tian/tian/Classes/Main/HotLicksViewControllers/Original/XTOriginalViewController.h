//
//  XTOriginalViewController.h
//  tian
//
//  Created by yyt on 15/6/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"
#import "XTWaterFallControl.h"
#import "XTUserHomePageViewController.h"
#import "XTAlbumInfo.h"
typedef enum {
    XTPageTypeOriginal = 0,  //从独家原创
    XTPageTypeOther = 1,//其他页面跳转
}XTOriginalPageType;
@class XTUserAccountInfo;

@interface XTOriginalViewController : XTRootViewController

@property (nonatomic, assign) NSInteger originalId;

@property (nonatomic, assign) NSInteger pictureId;//跳转要传的参数

@property (nonatomic, strong) XTAlbumInfo *albumInfo;

@property (nonatomic, assign)XTOriginalPageType type;//跳转要传的参数


@end
