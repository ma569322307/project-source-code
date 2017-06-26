//
//  YYTHUD.h
//  Promp
//
//  Created by Jiajun Zheng on 15/7/2.
//  Copyright (c) 2015年 zjProject. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UIColorFromRGB(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

#define kMaskAlph 0.35
#define kFontSize 15
#define kFont [UIFont boldSystemFontOfSize:kFontSize]
#define kMessageFont [UIFont systemFontOfSize:14]
#define kPromptAlertBackgroundName @"PromptAlertBackground"
#define kCancelBackgroundImageName @"PromoAlertCancel"
#define kVerifyBackgroundImageName @"PromoAlertVerify"
#define kTextNormalColor UIColorFromRGB(0x595959)
#define kTextBoldColor UIColorFromRGB(0x572d29)
#define kAnimationImageName @"Loading"
#define kAnimationImageNumber 12
#define kAnimationShowDuration 0.5
#define kAnimationStayDuration 1
#define kPromptSuccessedName @"PromptSuccessed"
#define kPromptErrorName @"PromptError"
#define kPromptWarningName @"PromptWarning"
#define kPromptLongSuccessedName @"PromptLongSuccessed"
#define kPromptLongErrorName @"PromptLongError"
#define kPromptLongWarningName @"PromptLongWarning"

#define kPromptScreenHeight ([UIScreen mainScreen].scale > 2 ? 667.0 : [UIScreen mainScreen].bounds.size.height)
#define kPromptScreenwidth ([UIScreen mainScreen].scale > 2 ? 375.0 : [UIScreen mainScreen].bounds.size.width)
#define kRationHeight (kPromptScreenHeight / 667.0)
#define kRationWidth (kPromptScreenHeight / 375.0)
#define kPromptShowMerge 35.0
#define kPromptSuccessedWord @"上传成功"
#define kPromptErrorWord @"下载失败"
#define kPromptWarningWord @"已举报"
#define kTextColor [UIColor whiteColor]
#define kLabelDistance 25
#define kTitleHeight 44
#define kMarge 8
#define kAlertViewWidth 270
#define kAlertViewHeight 140
#define kActionSheetNormalBackground @"Tabbar_nav_title"
#define kActionSheetCornerRadius 0
#define kActionSheetButtonMarge 8
#define kActionSheetAnimationTime 0.5
#define kActionSheetWindowMerge 0
#define kPromptShowName @"PromptShow"


#define XTKeyWindow [UIApplication sharedApplication].keyWindow
typedef void(^HubBlock)();
typedef void(^AlertViewBlock)(NSInteger index);
@interface YYTHUD : UIView
/// 显示加载动画
+ (void)showLoadingAddedTo:(UIView *)view;
/// 显示有蒙版的加载动画
+ (void)showLoadingWithMaskAddedTo:(UIView *)view;
/// 隐藏加载动画
+ (void)hideLoadingFrom:(UIView *)view;

///显示提示
+(void)showPromptAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion;
+(void)showPromptNoLockAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion;
///// 显示成功
//+ (void)showSucessedAddedTo:(UIView *)view;
///// 显示失败
//+ (void)showErrorAddedTo:(UIView *)view;
///// 显示举报
//+ (void)showWarningAddedTo:(UIView *)view;
//
///// 显示成功
//+ (void)showSucessedAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion;
///// 显示失败
//+ (void)showErrorAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion;
///// 显示举报
//+ (void)showWarningAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion;
//
///// 显示成功+文字
//+ (void)showSucessedAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion;
///// 显示失败+文字
//+ (void)showErrorAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion;
///// 显示举报+文字
//+ (void)showWarningAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion;
//
///// 显示成功有蒙版
//+ (void)showSucessedWithMaskAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion;
///// 显示失败有蒙版
//+ (void)showErrorWithMaskAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion;
///// 显示举报有蒙版
//+ (void)showWarningWithMaskAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion;
///// 显示成功+文字 有蒙版
//+ (void)showSucessedWithMaskAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion;
///// 显示失败+文字 有蒙版
//+ (void)showErrorWithMaskAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion;
///// 显示举报+文字 有蒙版
//+ (void)showWarningWithMaskAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion;
//
///// 显示长文字成功+文字
//+ (void)showLongSucessedAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion;
///// 显示长文字失败+文字
//+ (void)showLongErrorAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion;
///// 显示长文字举报+文字
//+ (void)showLongWarningAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion;
//
///// 显示长文字成功有蒙版
//+ (void)showLongSucessedWithMaskAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion;
///// 显示长文字失败有蒙版
//+ (void)showLongErrorWithMaskAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion;
///// 显示长文字举报有蒙版
//+ (void)showLongWarningWithMaskAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion;
///// 显示长文字成功+文字 有蒙版
//+ (void)showLongSucessedWithMaskAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion;
///// 显示长文字失败+文字 有蒙版
//+ (void)showLongErrorWithMaskAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion;
///// 显示长文字举报+文字 有蒙版
//+ (void)showLongWarningWithMaskAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion;

/// 显示加载动画无限制
+ (void)showLoadingNoLockAddedTo:(UIView *)view;
/// 显示加载有蒙版动画无限制
+ (void)showLoadingHasMaskNoLockAddedTo:(UIView *)view;

/// 显示加载动画无限制
+ (void)showLoadingNoLockFreeCenterAddedTo:(UIView *)view;
/// 显示有蒙版加载动画无限制
+ (void)showLoadingHasMaskNoLockFreeCenterAddedTo:(UIView *)view;
@end
