//
//  XTGuideManage.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/4.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <Foundation/Foundation.h>
///引导页类型
typedef enum {
    //顺序
    XTGuideAnimation = 0, //开场动画
    XTGuideChooseLike,
    XTGuideHomePageGuide,
    XTGuidePhotoCreate,
    XTGuidePhotoUpload,
    XTGuideNormal
}XTGuideType;
@interface XTGuideManage : NSObject
///单例
+(instancetype)sharedGuideManage;
///判断启动的时候需要展示哪个界面类型
+(XTGuideType)chooseDisplayType;

///判断引导动画第一次
+(BOOL)checkGuideAnimationNeeded;
///设置引导动画
+(void)setGuideAnimationNeeded;

///判断添加喜欢艺人第一次
+(BOOL)checkChooseLikeNeeded;
///设置添加艺人
+(void)setChooseLikeNeeded;

///判断主页引导第一次
+(BOOL)checkHomePageGuideNeeded;
///设置主页引导
+(void)setHomePageGuideNeeded;

///判断贴图界面第一次
+(BOOL)checkPhotoCreateNeeded;
///设置贴图界面第一次
+(void)setPhotoCreateNeeded;

///判断贴图界面第一次
+(BOOL)checkPhotoUploadNeeded;
///设置贴图界面第一次
+(void)setPhotoUploadNeeded;
///根据情况选择显示的控制器
+(UIViewController *)createDispayViewController;
///重新产生引导 测试用
+(void)resetGuideSettings;
@end
