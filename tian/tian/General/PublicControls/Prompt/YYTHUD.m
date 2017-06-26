//
//  YYTHUD.m
//  Promp
//
//  Created by Jiajun Zheng on 15/7/2.
//  Copyright (c) 2015年 zjProject. All rights reserved.
//

#import "YYTHUD.h"
@implementation YYTHUD
/// 显示加载动画
+ (void)showLoadingAddedTo:(UIView *)view{
    [self showLoadingAddedTo:view hasMask:NO lock:YES freeCenter:NO];
}
/// 显示有蒙版的加载动画
+ (void)showLoadingWithMaskAddedTo:(UIView *)view{
    [self showLoadingAddedTo:view hasMask:YES lock:YES freeCenter:NO];
}
/// 显示加载动画无限制
+ (void)showLoadingNoLockAddedTo:(UIView *)view{
    [self showLoadingAddedTo:view hasMask:NO lock:NO freeCenter:NO];
}
/// 显示加载有蒙版动画无限制
+ (void)showLoadingHasMaskNoLockAddedTo:(UIView *)view{
    [self showLoadingAddedTo:view hasMask:YES lock:NO freeCenter:NO];
}
/// 显示加载动画无限制
+ (void)showLoadingNoLockFreeCenterAddedTo:(UIView *)view{
    [self showLoadingAddedTo:view hasMask:NO lock:NO freeCenter:YES];
}
/// 显示有蒙版加载动画无限制
+ (void)showLoadingHasMaskNoLockFreeCenterAddedTo:(UIView *)view{
    [self showLoadingAddedTo:view hasMask:YES lock:NO freeCenter:YES];
}
// 保存当前界面正在loading的视图
__weak static YYTHUD *loadingView = nil;
// 保存当前界面正在prompt的视图
__weak static YYTHUD *promptView = nil;






/// 显示加载动画
+ (void)showLoadingAddedTo:(UIView *)view hasMask:(BOOL)hasMask lock:(BOOL)lock freeCenter:(BOOL)freeCenter{
    // 去掉先前的loading
    if (loadingView != nil) {
        [loadingView removeFromSuperview];
    }
    [self checkExit];
    view.userInteractionEnabled = !lock;
    // 创建遮罩视图
    YYTHUD *mask = [[YYTHUD alloc] initWithFrame:view.bounds];
    if (!freeCenter) {
        loadingView = mask;
    }
    // 根据是否有遮罩改变背景图片颜色
    mask.backgroundColor = [UIColor colorWithWhite:0.000 alpha:hasMask?kMaskAlph:0];
    // 添加遮罩
    [view addSubview:mask];
    // 创建动画视图
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%zd",kAnimationImageName,1]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGSize imageSize = CGSizeMake(image.size.width, image.size.height);
    imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    [mask addSubview:imageView];
    // 放在中间
    if (freeCenter) {
        mask.center = CGPointMake(view.frame.size.width * 0.5, view.frame.size.height * 0.5);
    }else{
        mask.center = [view convertPoint:[UIApplication sharedApplication].keyWindow.center toView:view];
    }
    mask.bounds = imageView.bounds;
    // 获取动画图片数组
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:kAnimationImageNumber];
    for (int i = 1; i<=kAnimationImageNumber; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@%zd",kAnimationImageName,i];
        UIImage *image = [UIImage imageNamed:imageName];
        [arrayM addObject:image];
    }
    // 添加动画图片
    imageView.animationImages = arrayM;
    imageView.animationDuration = 0.7;
    // 开始动画
    [imageView startAnimating];
}





/// 隐藏加载动画
+(void)hideLoadingFrom:(UIView *)view{
    view.userInteractionEnabled = YES;
    YYTHUD *hub = [self HUDForView:view];
    // 移除自身
    [hub removeFromSuperview];
    loadingView = nil;
}
+ (void)checkExit{
    // 存在loading视图先隐藏
    if (loadingView != nil) {
        loadingView.hidden = YES;
    }
}
+ (BOOL)checkPromptExit{
    if (promptView) {
        return YES;
    }
    return NO;
}
/// 寻找动画视图动画
+ (instancetype)HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (YYTHUD *)subview;
        }
    }
    return nil;
}
/// 显示成功
+ (void)showSucessedAddedTo:(UIView *)view{
    [self showImageAddedToView:view hasMask:NO withImageName:kPromptSuccessedName withText:kPromptSuccessedWord withCompletionBlock:nil];
}
/// 显示失败
+ (void)showErrorAddedTo:(UIView *)view{
    [self showImageAddedToView:view hasMask:NO withImageName:kPromptErrorName withText:kPromptErrorWord withCompletionBlock:nil];
}
/// 显示举报
+ (void)showWarningAddedTo:(UIView *)view{
    [self showImageAddedToView:view hasMask:NO withImageName:kPromptWarningName withText:kPromptWarningWord withCompletionBlock:nil];
}
/// 显示成功
+ (void)showSucessedAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion{
    [self showImageAddedToView:view hasMask:NO withImageName:kPromptSuccessedName withText:kPromptSuccessedWord withCompletionBlock:completion];
}
/// 显示失败
+ (void)showErrorAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion{
    [self showImageAddedToView:view hasMask:NO withImageName:kPromptErrorName withText:kPromptErrorWord withCompletionBlock:completion];
}
/// 显示举报
+ (void)showWarningAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion{
    [self showImageAddedToView:view hasMask:NO withImageName:kPromptWarningName withText:kPromptWarningWord withCompletionBlock:completion];
}

/// 显示成功+文字
+ (void)showSucessedAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion{
    [self showImageAddedToView:view hasMask:NO withImageName:kPromptSuccessedName withText:text withCompletionBlock:completion];
}
/// 显示失败+文字
+ (void)showErrorAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion{
    [self showImageAddedToView:view hasMask:NO withImageName:kPromptErrorName withText:text withCompletionBlock:completion];
}
/// 显示举报+文字
+ (void)showWarningAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion{
    [self showImageAddedToView:view hasMask:NO withImageName:kPromptWarningName withText:text withCompletionBlock:completion];
}

/// 显示成功有蒙版
+ (void)showSucessedWithMaskAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion{
    [self showImageAddedToView:view hasMask:YES withImageName:kPromptSuccessedName withText:kPromptSuccessedWord withCompletionBlock:completion];
}
/// 显示失败有蒙版
+ (void)showErrorWithMaskAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion{
    [self showImageAddedToView:view hasMask:YES withImageName:kPromptErrorName withText:kPromptErrorWord withCompletionBlock:completion];
}
/// 显示举报有蒙版
+ (void)showWarningWithMaskAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion{
    [self showImageAddedToView:view hasMask:YES withImageName:kPromptWarningName withText:kPromptWarningWord withCompletionBlock:completion];
}
/// 显示成功+文字 有蒙版
+ (void)showSucessedWithMaskAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion{
    [self showImageAddedToView:view hasMask:YES withImageName:kPromptSuccessedName withText:text withCompletionBlock:completion];
}
/// 显示失败+文字 有蒙版
+ (void)showErrorWithMaskAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion{
    [self showImageAddedToView:view hasMask:NO withImageName:kPromptErrorName withText:text withCompletionBlock:completion];
}
/// 显示举报+文字 有蒙版
+ (void)showWarningWithMaskAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion{
    [self showImageAddedToView:view hasMask:YES withImageName:kPromptWarningName withText:text withCompletionBlock:completion];
}

/// 显示长文字成功+文字
+ (void)showLongSucessedAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion{
    [self showImageAddedToView:view hasMask:NO withImageName:kPromptLongSuccessedName withText:text withCompletionBlock:completion];
}
/// 显示长文字失败+文字
+ (void)showLongErrorAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion{

}
/// 显示长文字举报+文字
+ (void)showLongWarningAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion{

}

/// 显示长文字成功有蒙版
+ (void)showLongSucessedWithMaskAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion{

}
/// 显示长文字失败有蒙版
+ (void)showLongErrorWithMaskAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion{

}
/// 显示长文字举报有蒙版
+ (void)showLongWarningWithMaskAddedTo:(UIView *)view withCompletionBlock:(HubBlock)completion{

}
/// 显示长文字成功+文字 有蒙版
+ (void)showLongSucessedWithMaskAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion{

}
/// 显示长文字失败+文字 有蒙版
+ (void)showLongErrorWithMaskAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion{

}
/// 显示长文字举报+文字 有蒙版
+ (void)showLongWarningWithMaskAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion{

}
///显示提示
+(void)showPromptAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion{
    [self showPromptAddedTo:view withText:text lock:YES withCompletionBlock:completion];
}
+(void)showPromptNoLockAddedTo:(UIView *)view withText:(NSString *)text withCompletionBlock:(HubBlock)completion{
    [self showPromptAddedTo:view withText:text lock:NO withCompletionBlock:completion];
}



//===========
+(void)showPromptAddedTo:(UIView *)view withText:(NSString *)text lock:(BOOL)lock withCompletionBlock:(HubBlock)completion{
    [self checkExit];
    if ([self checkPromptExit]) {
        return;
    }
    view.userInteractionEnabled = !lock;
    // 创建遮罩视图
    YYTHUD *mask = [[YYTHUD alloc] initWithFrame:view.bounds];
    promptView = mask;
    // 根据是否有遮罩改变背景图片颜色
    mask.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0];
    // 添加遮罩
    [view addSubview:mask];
    
    // 添加图片
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kPromptShowName]];
    
    //毛玻璃背景
    UIView *imageView;
    if ([UIDevice currentDevice].systemVersion.doubleValue > 8.0 ) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:effect];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        imageView = view;
    }else{
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        imageView = view;
    }
    imageView.bounds = CGRectMake(0, 0, 135, 61);
    imageView.layer.cornerRadius = 10.0;
    imageView.layer.masksToBounds = YES;
    
    //添加蒙版
    UIView *smallMaskView = [[UIView alloc] init];
    smallMaskView.backgroundColor = [UIColor blackColor];
    smallMaskView.alpha = 0.2;
    [imageView addSubview:smallMaskView];
    
    [mask addSubview:imageView];
    // 放在中间
    imageView.center = [[UIApplication sharedApplication].keyWindow convertPoint:[UIApplication sharedApplication].keyWindow.center toView:mask];
    // 添加文本
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    [label sizeToFit];
    //背景大小
    imageView.bounds = CGRectMake(0, 0, label.bounds.size.width + kPromptShowMerge * 2, imageView.bounds.size.height);
    smallMaskView.frame = imageView.bounds;
    // 文本中心
    label.center = imageView.center;
    label.textAlignment = NSTextAlignmentCenter;
    [mask addSubview:label];
    // 初始化
    imageView.transform = CGAffineTransformMakeScale(0, 0);
    label.transform = CGAffineTransformMakeScale(0, 0);
    
    // 弹出动画
    [UIView animateWithDuration:kAnimationShowDuration delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.8 options:0 animations:^{
        imageView.transform = CGAffineTransformIdentity;
        label.transform = CGAffineTransformIdentity;
        // 根据是否有遮罩改变背景图片颜色
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimationShowDuration delay:kAnimationStayDuration options:0 animations:^{
            imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            label.transform = CGAffineTransformMakeScale(0.01, 0.01);
            // 根据是否有遮罩改变背景图片颜色
            mask.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0];
        } completion:^(BOOL finished) {
            view.userInteractionEnabled = YES;
            [self hidePromptFrom:view];
            if (completion) {
                completion();
            }
        }];
    }];

}
//=============================
/// 隐藏加载动画
+(void)hidePromptFrom:(UIView *)view{
    view.userInteractionEnabled = YES;
    YYTHUD *hub = [self HUDForView:view];
    // 移除自身
    [hub removeFromSuperview];
    promptView = nil;
    // 如果loading还存在，显示
    if (loadingView != nil) {
        loadingView.hidden = NO;
    }
}
/// 展示提示
+(void)showImageAddedToView:(UIView *)view hasMask:(BOOL)hasMask withImageName:(NSString *)name withText:(NSString *)text withCompletionBlock:(HubBlock)completion{
    view.userInteractionEnabled = NO;
    // 创建遮罩视图
    YYTHUD *mask = [[YYTHUD alloc] initWithFrame:view.bounds];
    // 根据是否有遮罩改变背景图片颜色
    mask.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0];
    // 添加遮罩
    [view addSubview:mask];
    
    // 添加图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    [mask addSubview:imageView];
    // 放在中间
    imageView.center = [[UIApplication sharedApplication].keyWindow convertPoint:[UIApplication sharedApplication].keyWindow.center toView:mask];
    // 添加文本
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = kTextColor;
    label.font = kFont;
    [label sizeToFit];
    // 文本中心
    [mask checkLabelCenter:label imageView:imageView imageName:name];
    label.textAlignment = NSTextAlignmentCenter;
    [mask addSubview:label];
    // 初始化
    imageView.alpha = 0;
    label.alpha = 0;
    
    // 弹出动画
    [UIView animateWithDuration:kAnimationShowDuration animations:^{
        imageView.alpha = 1;
        label.alpha = 1;
        // 根据是否有遮罩改变背景图片颜色
        mask.backgroundColor = [UIColor colorWithWhite:0.000 alpha:hasMask?kMaskAlph:0];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimationShowDuration delay:kAnimationStayDuration options:0 animations:^{
            imageView.alpha = 0;
            label.alpha = 0;
            // 根据是否有遮罩改变背景图片颜色
            mask.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0];
        } completion:^(BOOL finished) {
            view.userInteractionEnabled = YES;
            [self hideLoadingFrom:view];
            if (completion) {
                completion();
            }
        }];
    }];
}
//计算文本中心
-(void)checkLabelCenter:(UILabel *)label imageView:(UIImageView *)imageView imageName:(NSString *)name{
    if ([name isEqualToString:kPromptLongErrorName] || [name isEqualToString:kPromptLongSuccessedName] || [name isEqualToString:kPromptLongWarningName]) {
        CGFloat x = imageView.center.x;
        CGFloat y = imageView.center.y;
        label.center = CGPointMake(x, y);
        return;
    }
    CGFloat x = imageView.center.x;
    CGFloat y = CGRectGetMaxY(imageView.frame) - kLabelDistance - (kFontSize) * 0.5;
    label.center = CGPointMake(x, y);
}
@end
