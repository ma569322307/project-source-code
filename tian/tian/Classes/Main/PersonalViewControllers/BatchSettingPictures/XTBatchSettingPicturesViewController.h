//
//  XTBatchSettingPicturesViewController.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/13.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTRootViewController.h"
typedef enum{
    XTBatchSettingHeadChoosing = 0, //头像选取
    XTBatchSettingPictures          //相册操作
}XTBatchSettingType;
@interface XTBatchSettingPicturesViewController : XTRootViewController
///操作类型
@property (nonatomic, assign) XTBatchSettingType settingType;
///设置回调
@property (nonatomic, copy) void(^completionBlock)(NSString *imageURL);
///相册id
@property (nonatomic, assign) NSInteger albumId;
@end
