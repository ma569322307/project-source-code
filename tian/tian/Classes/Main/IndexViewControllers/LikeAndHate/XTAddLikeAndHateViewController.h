//
//  XTAddLikeAndHateViewController.h
//  tian
//
//  Created by huhuan on 15/6/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"
#import "XTUserCollectionView.h"
#define kCancelLikeNotification @"CancelLikeNotification"
//进入类型，默认是主页进入类型
typedef enum{
    XTAddLikeAndHateHomePage = 0, //主页进入
    XTAddLikeAndHateGuidePage     //引导页进入
}XTAddLikeAndHateDisplayType;

@interface XTAddLikeAndHateViewController : XTRootViewController

@property (nonatomic, copy) void (^shouldRefresh)();

@property (nonatomic, assign) XTUserCollectionViewCellButtonStyle buttonStyle;
@property (nonatomic, assign) XTAddLikeAndHateDisplayType displayType;
@end
