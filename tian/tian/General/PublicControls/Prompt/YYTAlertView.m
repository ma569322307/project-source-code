//
//  YYTAlertView.m
//  Promp
//
//  Created by Jiajun Zheng on 15/7/2.
//  Copyright (c) 2015年 zjProject. All rights reserved.
//

#import "YYTAlertView.h"
#import "UIViewController+Extend.h"
#import <IQKeyboardManager.h>
#define kTipsBackgroundImage @"TipsBackground"
#define kTipsFontSize 8
#define kTipsLabelFont [UIFont boldSystemFontOfSize:kTipsFontSize]
#define kTipsCancelButtonImage @"TipsCancel"
#define kTipsVerifyButtonImage @"TipsVerify"
#define kTipsCloseButtonImage @"TipsCancelButton"
#define kTipsButtonWidth 86.0
#define kTipsButtonHeight 30.0
#define kTipsLeftMerage 10.0
@interface YYTAlertView ()
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSString *verifyButtonTitle;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *messageLabel;
@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) UIButton *verifyButton;
@property (nonatomic, weak) UIImageView *backgroundView;
@property (nonatomic, assign) CGSize backgroundSize;
@property (nonatomic, assign) CGSize cancelButtonSize;
@property (nonatomic, assign) CGSize verifyButtonSize;
@property (nonatomic, copy) AlertViewBlock block;
@property (nonatomic, copy) void(^textBlock)(NSInteger index, NSInteger number);
@property (nonatomic, assign) BOOL isNav;
//打赏关闭按钮
@property (nonatomic, weak) UIButton *closeButton;
//打赏上小标题
@property (nonatomic, weak) UILabel *tipsSmallUpTitle;
//打赏数值文本
@property (nonatomic, weak) UITextField *tipsTextField;
//打赏下小标题
@property (nonatomic, weak) UILabel *tipsSmallDownTitle;
//背景图片宽高约束(动画用)
@property (nonatomic, strong) NSLayoutConstraint *backWidth;
@property (nonatomic, strong) NSLayoutConstraint *backHeight;
@end

@implementation YYTAlertView
///创建自定义取消确定文字的提示框
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle verifyButtonTitle:(NSString *)verifyButtonTitle{
    if (self = [super init]) {
        self.title = title;
        self.message = message;
        self.delegate = delegate;
        self.cancelButtonTitle = cancelButtonTitle;
        self.verifyButtonTitle = verifyButtonTitle;
    }
    return self;
}
///创建自定义确定文字的提示框
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate verifyButtonTitle:(NSString *)verifyButtonTitle{
    return [self initWithTitle:title message:message delegate:delegate cancelButtonTitle:nil verifyButtonTitle:verifyButtonTitle];
}
///创建确定取消样式提示框
-(instancetype)initFullTypeAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate{
    return [self initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"取消" verifyButtonTitle:@"确定"];
}
///创建只有确定样式提示框
-(instancetype)initHalfTypeAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate{
    return [self initWithTitle:title message:message delegate:delegate cancelButtonTitle:nil verifyButtonTitle:@"确定"];
}

///创建确定取消样式提示框
-(instancetype)initFullTypeAlertViewWithTitle:(NSString *)title message:(NSString *)message completaionBlock:(void(^)(NSInteger))completaion{
    return [self initWithTitle:title message:message delegate:nil cancelButtonTitle:@"取消" verifyButtonTitle:@"确定"];
}
///创建只有确定样式提示框
-(instancetype)initHalfTypeAlertViewWithTitle:(NSString *)title message:(NSString *)message completaionBlock:(void(^)(NSInteger))completaion{
    return [self initWithTitle:title message:message delegate:nil cancelButtonTitle:nil verifyButtonTitle:@"确定"];
}

///快速展示确定取消样式提示框
+(void)showFullTypeAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate{
    [[[self alloc] initFullTypeAlertViewWithTitle:title message:message delegate:delegate] show];
}
///快速展示只有确定样式提示框
+(void)showHalfTypeAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate{
    [[[self alloc] initHalfTypeAlertViewWithTitle:title message:message delegate:delegate] show];
}
+(void)showFullTypeAlertViewWithTitle:(NSString *)title message:(NSString *)message completaionBlock:(void(^)(NSInteger))completaion{
    [[[self alloc] initFullTypeAlertViewWithTitle:title message:message delegate:nil] showWithBlock:completaion];
}
///快速展示只有确定样式提示框
+(void)showHalfTypeAlertViewWithTitle:(NSString *)title message:(NSString *)message completaionBlock:(void(^)(NSInteger))completaion{
    [[[self alloc] initHalfTypeAlertViewWithTitle:title message:message delegate:nil] showWithBlock:completaion];
}
///打赏页
+(void)showTipsAlertViewWithCompletaionBlock:(void(^)(NSInteger index, NSInteger number))textBlock{
    YYTAlertView *view =[[self alloc] initFullTypeAlertViewWithTitle:@"打赏" message:@"打赏积分" delegate:nil];
    view.isNav = YES;
    [view tipsWithBlock:textBlock];
}

-(void)show{
    [self showWithBlock:nil];
}
-(UIView *)chooseView{
    if (self.isNav) {
        return [UIViewController topViewController].view;
    }
    return [UIApplication sharedApplication].keyWindow;
}
///展示提示
-(void)tipsWithBlock:(void(^)(NSInteger index, NSInteger number))textBlock{
    self.textBlock = textBlock;
    //创建遮盖
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:kMaskAlph];
    [[self chooseView] addSubview:self];
    // 添加背景图片
    UIImage *backgroundImage = [UIImage imageNamed:kTipsBackgroundImage];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.backgroundSize = CGSizeMake(kAlertViewWidth, kAlertViewHeight);
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    self.backgroundView = imageView;
    
    //添加标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = kFont;
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = kTextBoldColor;
    [imageView addSubview:titleLabel];
    [titleLabel sizeToFit];
    self.titleLabel = titleLabel;
    
    //添加内容
    UILabel *tipsSmallUpTitle = [[UILabel alloc] init];
    tipsSmallUpTitle.font = kTipsLabelFont;
    tipsSmallUpTitle.text = self.message;
    tipsSmallUpTitle.textAlignment = NSTextAlignmentCenter;
    tipsSmallUpTitle.textColor = kTextBoldColor;
    [imageView addSubview:tipsSmallUpTitle];
    [tipsSmallUpTitle sizeToFit];
    self.tipsSmallUpTitle = tipsSmallUpTitle;

    //添加打赏文本
    UITextField *tipsTextField = [[UITextField alloc] init];
    [imageView addSubview:tipsTextField];
    tipsTextField.backgroundColor = [UIColor whiteColor];
    tipsTextField.textAlignment = NSTextAlignmentCenter;
    tipsTextField.layer.cornerRadius = 5;
    tipsTextField.layer.masksToBounds = YES;
    tipsTextField.keyboardType = UIKeyboardTypeNumberPad;
    tipsTextField.font = [UIFont boldSystemFontOfSize:16];
    tipsTextField.textColor = UIColorFromRGB(0x595959);
    self.tipsTextField = tipsTextField;
    
    //添加下标文字
    UILabel *tipsSmallDownTitle = [[UILabel alloc] init];
    tipsSmallDownTitle.font = kTipsLabelFont;
    tipsSmallDownTitle.text = @"打赏的积分越多对方获得声望值越多，等级提升越快";
    tipsSmallDownTitle.textAlignment = NSTextAlignmentCenter;
    tipsSmallDownTitle.textColor = kTextBoldColor;
    [imageView addSubview:tipsSmallDownTitle];
    [tipsSmallDownTitle sizeToFit];
    self.tipsSmallDownTitle = tipsSmallDownTitle;
    
    //添加关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // 获取背景图片与大小
    UIImage *closeButtonImage = [UIImage imageNamed:kTipsCloseButtonImage];
    // 设置属性
    [closeButton setBackgroundImage:closeButtonImage forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_sel",kTipsCloseButtonImage]] forState:UIControlStateHighlighted];
    // 监听点击
    [closeButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:closeButton];
    self.closeButton = closeButton;
    
    // 创建按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // 获取背景图片与大小
    UIImage *cancelImage = [UIImage imageNamed:kTipsCancelButtonImage];
    self.cancelButtonSize = CGSizeMake(kTipsButtonWidth, kTipsButtonHeight);
    // 设置属性
    [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_sel",kTipsCancelButtonImage]] forState:UIControlStateHighlighted];
    // 监听点击
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:cancelButton];
    self.cancelButton = cancelButton;
    
    //添加确定按钮
    // 创建按钮
    UIButton *verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // 获取背景图片与大小
    UIImage *verifyImage = [UIImage imageNamed:kTipsVerifyButtonImage];
    self.verifyButtonSize = CGSizeMake(kTipsButtonWidth, kTipsButtonHeight);
    // 设置属性
    [verifyButton setBackgroundImage:verifyImage forState:UIControlStateNormal];
    [verifyButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_sel",kTipsVerifyButtonImage]] forState:UIControlStateHighlighted];
    // 监听点击
    [verifyButton addTarget:self action:@selector(verifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:verifyButton];
    self.verifyButton = verifyButton;
    // 添加约束
    [self addConstraints];
    
    // 显示动画
    [self showAnimation];
}


///展示提示
-(void)showWithBlock:(AlertViewBlock)completionBlock{
    // 判断当前界面是否已经有提示框
    [self checkExit];
    self.block = completionBlock;
    //创建遮盖
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:kMaskAlph];
    [[self chooseView] addSubview:self];
    
    // 添加背景图片
    UIImage *backgroundImage = [UIImage imageNamed:kPromptAlertBackgroundName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.backgroundSize = CGSizeMake(kAlertViewWidth, kAlertViewHeight);
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    self.backgroundView = imageView;
    
    //添加标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = kFont;
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = kTextBoldColor;
    [imageView addSubview:titleLabel];
    [titleLabel sizeToFit];
    self.titleLabel = titleLabel;
    
    //添加内容
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.font = kMessageFont;
    messageLabel.text = self.message;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    messageLabel.preferredMaxLayoutWidth = kAlertViewWidth - kTipsLeftMerage * 2;
    messageLabel.textColor = kTextNormalColor;
    [imageView addSubview:messageLabel];
    [messageLabel sizeToFit];
    self.messageLabel = messageLabel;
    
    //添加取消按钮
    if (self.cancelButtonTitle != nil) {
        // 创建按钮
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // 获取背景图片与大小
        UIImage *cancelImage = [UIImage imageNamed:kCancelBackgroundImageName];
        self.cancelButtonSize = cancelImage.size;
        // 设置属性
        [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_sel",kCancelBackgroundImageName]] forState:UIControlStateHighlighted];
        cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
        [cancelButton setTitleColor:kTextNormalColor forState:UIControlStateNormal];
        [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        // 监听点击
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:cancelButton];
        self.cancelButton = cancelButton;
    }
    //添加确定按钮
    // 创建按钮
    UIButton *verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // 获取背景图片与大小
    UIImage *verifyImage = [UIImage imageNamed:kVerifyBackgroundImageName];
    self.verifyButtonSize = verifyImage.size;
    // 设置属性
    [verifyButton setBackgroundImage:[UIImage imageNamed:kVerifyBackgroundImageName] forState:UIControlStateNormal];
    [verifyButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_sel",kVerifyBackgroundImageName]] forState:UIControlStateHighlighted];
    verifyButton.titleLabel.font = kFont;
    [verifyButton setTitleColor:kTextBoldColor forState:UIControlStateNormal];
    [verifyButton setTitle:self.verifyButtonTitle forState:UIControlStateNormal];
    // 监听点击
    [verifyButton addTarget:self action:@selector(verifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:verifyButton];
    self.verifyButton = verifyButton;
    // 添加约束
    [self addConstraints];
    
    // 显示动画
    [self showAnimation];
}
- (void)checkExit{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[YYTAlertView class]]) {
            [view removeFromSuperview];
            return;
        }
    }
}
//显示动画
-(void)showAnimation{
    //将键盘弹回
//    [[UIApplication sharedApplication].keyWindow endEditing:YES];
//    [UIViewController currentViewController].view.userInteractionEnabled = NO;
    //动画前准备
//    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
//    if (self.isNav) {
//        [IQKeyboardManager sharedManager].enable = YES;
//        [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 100;
//    }
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.backgroundView.alpha = 0;
    ///开始动画
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:kMaskAlph];
    } completion:^(BOOL finished) {
        self.backgroundView.alpha = 1;
        CGRect frame = self.backgroundView.frame;
        self.backgroundView.frame = CGRectOffset(frame, 0, -self.backgroundView.center.y);
        
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:0 animations:^{
            self.backgroundView.frame = frame;
        } completion:^(BOOL finished) {
//            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
        }];
    }];
}

//消失动画
-(void)dismissAnimationWithCompletaionBlock:(void(^)())completaion{
//    //动画前准备
//    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
//    self.backgroundView.alpha = 0;
//    ///开始动画
//    [UIView animateWithDuration:0.3 animations:^{
//        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
//    } completion:^(BOOL finished) {
//        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
//        [IQKeyboardManager sharedManager].enable = NO;
//        [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 0;
//        if (completaion) {
//            completaion();
//        }
//    }];
    
    //动画2
    //动画前准备
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    ///开始动画
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.backgroundView.frame;
        self.backgroundView.frame = CGRectOffset(frame, 0, -self.backgroundView.center.y - self.backgroundView.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        } completion:^(BOOL finished) {
            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
            [UIViewController currentViewController].view.userInteractionEnabled = YES;
            [IQKeyboardManager sharedManager].enable = NO;
            [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 0;
            if (completaion) {
                completaion();
            }
        }];
    }];
}

/// 添加约束
-(void)addConstraints{
    UIView *window = [self chooseView];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    // 创建遮盖约束
    NSLayoutConstraint *maskLeft = [NSLayoutConstraint
                                    constraintWithItem:self
                                    attribute:NSLayoutAttributeLeft
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:window
                                    attribute:NSLayoutAttributeLeft
                                    multiplier:1
                                    constant:0];
    NSLayoutConstraint *maskRight = [NSLayoutConstraint
                                    constraintWithItem:self
                                    attribute:NSLayoutAttributeRight
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:window
                                    attribute:NSLayoutAttributeRight
                                    multiplier:1
                                    constant:0];
    NSLayoutConstraint *maskTop = [NSLayoutConstraint
                                     constraintWithItem:self
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:window
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1
                                     constant:0];
    NSLayoutConstraint *maskBottm = [NSLayoutConstraint
                                     constraintWithItem:self
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:window
                                     attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                     constant:0];
    // 背景图片约束
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *pomptCenterX = [NSLayoutConstraint
                                     constraintWithItem:self.backgroundView
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeCenterX
                                     multiplier:1
                                     constant:0];
    NSLayoutConstraint *pomptCenterY = [NSLayoutConstraint
                                        constraintWithItem:self.backgroundView
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                        attribute:NSLayoutAttributeCenterY
                                        multiplier:1
                                        constant:0];
    NSLayoutConstraint *pomptWidth = [NSLayoutConstraint
                                        constraintWithItem:self.backgroundView
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                        multiplier:1
                                        constant:self.backgroundSize.width];
    NSLayoutConstraint *pomptHeight = [NSLayoutConstraint
                                      constraintWithItem:self.backgroundView
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                      multiplier:1
                                      constant:self.backgroundSize.height];
    self.backHeight = pomptHeight;
    self.backWidth = pomptWidth;
    
    // 确定按钮
    self.verifyButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *veriftyCenterX = [NSLayoutConstraint
                                         constraintWithItem:self.verifyButton
                                         attribute:NSLayoutAttributeCenterX
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.backgroundView
                                         attribute:NSLayoutAttributeCenterX
                                          multiplier:self.cancelButton?1.5:1
                                         constant:0];
    NSLayoutConstraint *veriftyBottom = [NSLayoutConstraint
                                        constraintWithItem:self.verifyButton
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self.backgroundView
                                        attribute:NSLayoutAttributeBottom
                                        multiplier:1
                                        constant:-8];
    NSLayoutConstraint *veriftyHeight = [NSLayoutConstraint
                                        constraintWithItem:self.verifyButton
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                        multiplier:1
                                        constant:self.verifyButtonSize.height];
    NSLayoutConstraint *veriftyWidth = [NSLayoutConstraint
                                       constraintWithItem:self.verifyButton
                                       attribute:NSLayoutAttributeWidth
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:nil
                                       attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1
                                       constant:self.verifyButtonSize.width];
    
    // 添加
    [window addConstraints:@[maskLeft,maskTop,maskRight,maskBottm]];
    [self addConstraints:@[pomptCenterX,pomptCenterY]];
    [self.verifyButton addConstraints:@[veriftyWidth,veriftyHeight]];
    [self.backgroundView addConstraints:@[pomptWidth,pomptHeight,veriftyCenterX,veriftyBottom]];
    // 不一定有的控件约束
    // 取消按钮约束
    if (self.cancelButton != nil) {
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *cancelCenterX = [NSLayoutConstraint
                                             constraintWithItem:self.cancelButton
                                             attribute:NSLayoutAttributeCenterX
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self.backgroundView
                                             attribute:NSLayoutAttributeCenterX
                                             multiplier:0.5
                                             constant:0];
        NSLayoutConstraint *cancelBottom = [NSLayoutConstraint
                                             constraintWithItem:self.cancelButton
                                             attribute:NSLayoutAttributeBottom
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self.backgroundView
                                             attribute:NSLayoutAttributeBottom
                                             multiplier:1
                                             constant:-8];
        NSLayoutConstraint *canCelHeight = [NSLayoutConstraint
                                            constraintWithItem:self.cancelButton
                                            attribute:NSLayoutAttributeHeight
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:nil
                                            attribute:NSLayoutAttributeNotAnAttribute
                                            multiplier:1
                                            constant:self.cancelButtonSize.height];
        NSLayoutConstraint *canCelWidth = [NSLayoutConstraint
                                           constraintWithItem:self.cancelButton
                                           attribute:NSLayoutAttributeWidth
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                           attribute:NSLayoutAttributeNotAnAttribute
                                           multiplier:1
                                           constant:self.cancelButtonSize.width];
        [self.backgroundView addConstraints:@[cancelCenterX,cancelBottom,canCelWidth,canCelHeight]];
    }
    // 关闭按钮约束
    if (self.closeButton != nil) {
        self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *closeCenterX = [NSLayoutConstraint
                                             constraintWithItem:self.closeButton
                                             attribute:NSLayoutAttributeCenterX
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self.backgroundView
                                             attribute:NSLayoutAttributeRight
                                             multiplier:1
                                             constant:-3];
        NSLayoutConstraint *closeCenterY = [NSLayoutConstraint
                                            constraintWithItem:self.closeButton
                                            attribute:NSLayoutAttributeCenterY
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.backgroundView
                                            attribute:NSLayoutAttributeTop
                                            multiplier:1
                                            constant:3];
        [self.backgroundView addConstraints:@[closeCenterX,closeCenterY]];
    }
    
    // 打赏上文本约束
    if (self.tipsSmallUpTitle) {
        self.tipsSmallUpTitle.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *tipsSmallUpTitleLeft = [NSLayoutConstraint
                                              constraintWithItem:self.tipsSmallUpTitle
                                              attribute:NSLayoutAttributeLeft
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self.backgroundView
                                              attribute:NSLayoutAttributeLeft
                                              multiplier:1
                                              constant:kTipsLeftMerage];
        NSLayoutConstraint *tipsSmallUpTitleTop = [NSLayoutConstraint
                                          constraintWithItem:self.tipsSmallUpTitle
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.titleLabel
                                          attribute:NSLayoutAttributeTop
                                          multiplier:1
                                          constant:15];
        [self.backgroundView addConstraints:@[tipsSmallUpTitleLeft,tipsSmallUpTitleTop]];
    }
    if (self.titleLabel) {
        // 标题约束
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *titelTop = [NSLayoutConstraint
                                        constraintWithItem:self.titleLabel
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self.backgroundView
                                        attribute:NSLayoutAttributeCenterX
                                        multiplier:1
                                        constant:0];
        NSLayoutConstraint *titelCenterX = [NSLayoutConstraint
                                            constraintWithItem:self.titleLabel
                                            attribute:NSLayoutAttributeTop
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.backgroundView
                                            attribute:NSLayoutAttributeTop
                                            multiplier:1
                                            constant:8];
        [self.backgroundView addConstraints:@[titelCenterX,titelTop]];
    }
    
    // 消息约束
    if (self.messageLabel) {
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *messageCenterX = [NSLayoutConstraint
                                              constraintWithItem:self.messageLabel
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self.backgroundView
                                              attribute:NSLayoutAttributeCenterX
                                              multiplier:1
                                              constant:0];
        NSLayoutConstraint *messageCenterY = [NSLayoutConstraint
                                          constraintWithItem:self.messageLabel
                                          attribute:NSLayoutAttributeCenterY
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.backgroundView
                                          attribute:NSLayoutAttributeCenterY
                                          multiplier:1
                                          constant:0];
        [self.backgroundView addConstraints:@[messageCenterX,messageCenterY]];
    }
    // 打赏数值约束
    if (self.tipsTextField != nil) {
        self.tipsTextField.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *textCenterX = [NSLayoutConstraint
                                             constraintWithItem:self.tipsTextField
                                             attribute:NSLayoutAttributeCenterX
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self.backgroundView
                                             attribute:NSLayoutAttributeCenterX
                                             multiplier:1
                                             constant:0];
        NSLayoutConstraint *textCenterY = [NSLayoutConstraint
                                            constraintWithItem:self.tipsTextField
                                            attribute:NSLayoutAttributeCenterY
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.backgroundView
                                            attribute:NSLayoutAttributeCenterY
                                            multiplier:1
                                            constant:-10];
        NSLayoutConstraint *textHeight = [NSLayoutConstraint
                                            constraintWithItem:self.tipsTextField
                                            attribute:NSLayoutAttributeHeight
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:nil
                                            attribute:NSLayoutAttributeNotAnAttribute
                                            multiplier:1
                                            constant:40];
        NSLayoutConstraint *textWidth = [NSLayoutConstraint
                                           constraintWithItem:self.tipsTextField
                                           attribute:NSLayoutAttributeWidth
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                           attribute:NSLayoutAttributeNotAnAttribute
                                           multiplier:1
                                           constant:self.backgroundSize.width - kTipsLeftMerage * 2];
        [self.backgroundView addConstraints:@[textCenterX,textCenterY,textHeight,textWidth]];
    }
    // 消息约束
    if (self.tipsSmallDownTitle) {
        self.tipsSmallDownTitle.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *tipsSmallDownTitleLeft = [NSLayoutConstraint
                                              constraintWithItem:self.tipsSmallDownTitle
                                              attribute:NSLayoutAttributeLeft
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self.backgroundView
                                              attribute:NSLayoutAttributeLeft
                                              multiplier:1
                                              constant:kTipsLeftMerage];
        NSLayoutConstraint *tipsSmallDownTitleTop = [NSLayoutConstraint
                                          constraintWithItem:self.tipsSmallDownTitle
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.tipsTextField
                                          attribute:NSLayoutAttributeBottom
                                          multiplier:1
                                          constant:2];
        [self.backgroundView addConstraints:@[tipsSmallDownTitleLeft,tipsSmallDownTitleTop]];
    }
}
#pragma mark 监听事件
-(void)cancelButtonClick{
    [self dismissAnimationWithCompletaionBlock:^{
        if (self.block) {
            self.block(0);
        }
        if (self.textBlock) {
            self.textBlock(0,0);
        }
        if ([self.delegate respondsToSelector:@selector(alertViewClickedCancelButton:)]) {
            [self.delegate alertViewClickedCancelButton:self];
        }
        [self removeFromSuperview];
    }];
}
-(void)verifyButtonClick{
    [self dismissAnimationWithCompletaionBlock:^{
        if (self.block) {
            self.block(1);
        }
        if (self.textBlock) {
            self.textBlock(1,[self.tipsTextField.text integerValue]);
        }
        if ([self.delegate respondsToSelector:@selector(alertViewClickedVerifyButton:)]) {
            [self.delegate alertViewClickedVerifyButton:self];
        }
        [self removeFromSuperview];
    }];
}
@end
