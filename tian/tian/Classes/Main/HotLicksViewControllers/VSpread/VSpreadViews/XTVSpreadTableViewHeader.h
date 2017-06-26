//
//  XTVSpreadTableHeaderView.h
//  tian
//
//  Created by huhuan on 15/7/7.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTUserInfo;
@class XTHotLicksRecsInfo;


@interface XTVSpreadTableViewHeader : UIView

+ (XTVSpreadTableViewHeader *)spreadTableViewHeader;

- (void)configureHeaderWithUserInfo:(XTUserInfo *)userInfo andRecsInfo:(XTHotLicksRecsInfo *)recsInfo;

@end
