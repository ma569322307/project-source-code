//
//  YYTAlertView.h
//  Promp
//
//  Created by Jiajun Zheng on 15/7/2.
//  Copyright (c) 2015年 zjProject. All rights reserved.
//

//#import "YYTHUD.h"

@class YYTAlertView;
@protocol YYTAlertViewDelegate <NSObject>
// 点击取消
- (void)alertViewClickedCancelButton:(YYTAlertView *)alertView;
// 点击确定
- (void)alertViewClickedVerifyButton:(YYTAlertView *)alertView;
@end

@interface YYTAlertView : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, weak) id<YYTAlertViewDelegate> delegate;
///快速显示有确定和取消样式的提示框用block回调
+(void)showFullTypeAlertViewWithTitle:(NSString *)title message:(NSString *)message completaionBlock:(void(^)(NSInteger))completaion;
///快速展示只有确定样式提示框用block回调
+(void)showHalfTypeAlertViewWithTitle:(NSString *)title message:(NSString *)message completaionBlock:(void(^)(NSInteger))completaion;

///打赏页
+(void)showTipsAlertViewWithCompletaionBlock:(void(^)(NSInteger index, NSInteger number))textBlock;

///快速展示确定取消样式提示框
+(void)showFullTypeAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;
///快速展示只有确定样式提示框
+(void)showHalfTypeAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;

///创建自定义取消确定文字的提示框
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle verifyButtonTitle:(NSString *)verifyButtonTitle;
///创建自定义确定文字的提示框
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate verifyButtonTitle:(NSString *)verifyButtonTitle;
///创建确定取消样式提示框
-(instancetype)initFullTypeAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;
///创建只有确定样式提示框
-(instancetype)initHalfTypeAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;

///展示
-(void)show;
///展示有回调
-(void)showWithBlock:(AlertViewBlock)completionBlock;
@end
