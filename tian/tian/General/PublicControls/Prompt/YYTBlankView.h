//
//  YYTBlankView.h
//  tian
//
//  Created by huhuan on 15/7/24.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, YYTBlankHeaderStyle) {
    YYTBlankHeaderStyleBowl = 0,     //食盆
    YYTBlankHeaderStyleCry,          //哭泣头像
    YYTBlankHeaderStyleLike,         //桃心头像
    YYTBlankHeaderStyleFear,         //害怕流汗头像
    YYTBlankHeaderStyleUnhappy,      //不高兴头像
    YYTBlankHeaderStyleForbid        //禁止标志头像
    
};

typedef NS_ENUM (NSUInteger, YYTBlankViewStyle) {
    YYTBlankViewStyleNetworkError = 0,      //网络或服务器异常
    YYTBlankViewStyleBlank                  //空数据
};

@interface YYTBlankView : UIView

/**
 *  标题：空数据时填写
 */
@property (nonatomic, copy) NSString *tipString;

/**
 *  图片类型：空数据时填写
 */
@property (nonatomic, assign) YYTBlankHeaderStyle headerStyle;

/**
 *  按钮标题：空数据时填写
 */
@property (nonatomic, copy) NSString *buttonTitle;

/**
 *  error：网络或服务器异常时填写
 */
@property (nonatomic, strong) NSError *error;

/**
 *  进行autoLayout布局。iOS7默认为NO
 */
@property (nonatomic, assign) BOOL needAutolayout;

/**
 *  初始化blankView
 *
 */
+ (YYTBlankView *)showBlankInView:(UIView *)view
                            style:(YYTBlankViewStyle)style
                       eventClick:(void(^)())eventBlock;

+ (void)hideFromView:(UIView *)view;

@end
