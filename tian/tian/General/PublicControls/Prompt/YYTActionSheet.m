//
//  YYTActionSheet.m
//  Promp
//
//  Created by Jiajun Zheng on 15/7/3.
//  Copyright (c) 2015年 zjProject. All rights reserved.
//

#import "YYTActionSheet.h"
#import "UIImage+rn_Blur.h"
#import "UIImage+Capture.h"
@interface YYTActionSheet ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *titleViews;
@property (nonatomic, copy) AlertViewBlock block;
@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) UIView *buttonBackView;
@property (nonatomic, strong) NSLayoutConstraint *cancelBottom;
@property (nonatomic, assign) CGFloat bottomConstant;
@property (nonatomic, weak) UIImageView *backImageView;
// 蒙版
@property (nonatomic, strong) UIView *maskView;
// 假背景
@property (nonatomic, strong) UIImageView *windowSnapView;
@end

@implementation YYTActionSheet
///初始化
-(instancetype)initWithArray:(NSArray *)titles{
    if (self = [super init]) {
        self.titles = titles;
    }
    return self;
}
///展示
-(void)showWithBlock:(AlertViewBlock)completion hasMask:(BOOL)hasMask{
    //储存block
    self.block = completion;
    //自己作为遮盖
    UIImage *windowSnap = [self snapshot];
    UIImage *defaultImage = [windowSnap applyBlurWithRadius:2 tintColor:[UIColor colorWithWhite:0 alpha:0.10] saturationDeltaFactor:1.0 maskImage:nil];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:defaultImage];
    //背景视图
    self.backImageView = imageView;
    [self addSubview:imageView];
    [self.backImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
    [self layoutIfNeeded];
    
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:1];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //根据数组创建
    [self createTitles];
    //添加约束
    [self addConstraints];
    [self layoutIfNeeded];
    // 动画初始变化
    self.bottomConstant = ([UIScreen mainScreen].bounds.size.height - CGRectGetMinY(self.buttonBackView.frame));
    
    self.cancelBottom.constant = self.bottomConstant;
    [self layoutIfNeeded];
    
    UIImage *newImage = [[UIImage captureShotWithView:self] applyBlurWithRadius:3 tintColor:[UIColor colorWithWhite:0 alpha:0.10] saturationDeltaFactor:1.0 maskImage:nil];
    [self.backImageView removeFromSuperview];
    //截图
    UIImageView *newImageView = [[UIImageView alloc] initWithImage:newImage];

    self.backImageView = newImageView;
    [self insertSubview:newImageView atIndex:0];
    [self.backImageView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(-20, -20, -20, -20));
    }];
    self.maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self insertSubview:self.maskView atIndex:1];
    [self.maskView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self layoutIfNeeded];
    // 图片已经截图完毕，开始动画准备
    self.windowSnapView = [[UIImageView alloc] initWithImage:windowSnap];
    [self insertSubview:self.windowSnapView atIndex:0];
    self.backImageView.alpha = 0;
    // 防动画穿帮view
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_SIZE.height - 50, SCREEN_SIZE.width, 200)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    [self bringSubviewToFront:self.buttonBackView];
    [self bringSubviewToFront:self.cancelButton];
    //显示
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    [UIView animateWithDuration:kActionSheetAnimationTime delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.cancelBottom.constant = -(kMarge + kActionSheetWindowMerge);
        self.backImageView.alpha = 1;
        [self.backImageView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self.windowSnapView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(20, 20, 20, 20));
        }];
        self.maskView.alpha = 0.2;
        [self layoutIfNeeded];
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:1];
    } completion:^(BOOL finished) {
        [whiteView removeFromSuperview];
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    }];
}
///添加约束
-(void)addConstraints{
    // 添加自身约束
    UIView *window = [UIApplication sharedApplication].keyWindow;
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
    // 添加
    [window addConstraints:@[maskLeft,maskTop,maskRight,maskBottm]];
    
    //从取消开始添加外部约束
    [self addLeftAndRightConstraintsOnButton:self.cancelButton inView:self withMarge:kMarge + kActionSheetWindowMerge];
    //初始底部约束值
    
    //取消按钮添加底部约束
    NSLayoutConstraint *cancelBottom = [NSLayoutConstraint
                                  constraintWithItem:self.cancelButton
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self
                                  attribute:NSLayoutAttributeBottom
                                  multiplier:1
                                  constant:-kActionSheetWindowMerge - kMarge];
    self.cancelBottom = cancelBottom;
    [self addConstraint:cancelBottom];
    //选择按钮父视图约束
    [self addLeftAndRightConstraintsOnButton:self.buttonBackView inView:self withMarge:kActionSheetWindowMerge];
    //底部约束
    NSLayoutConstraint *backBottom = [NSLayoutConstraint
                                  constraintWithItem:self.buttonBackView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.cancelButton
                                  attribute:NSLayoutAttributeBottom
                                  multiplier:1
                                  constant:kMarge];
    [self addConstraint:backBottom];
    
    //上一个按钮
    UIView *lastBtn = nil;
    // 取消按钮
    for (UIButton *btn in self.titleViews) {
        [self addLeftAndRightConstraintsOnButton:btn inView:self.buttonBackView withMarge:kMarge];
        NSLayoutConstraint *btnTop;
        if (lastBtn) {
            btnTop = [NSLayoutConstraint
                                          constraintWithItem:btn
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:lastBtn
                                          attribute:NSLayoutAttributeBottom
                                          multiplier:1
                                          constant:kActionSheetButtonMarge];
        }else{
            btnTop = [NSLayoutConstraint
                                          constraintWithItem:btn
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.buttonBackView
                                          attribute:NSLayoutAttributeTop
                                          multiplier:1
                                          constant:kMarge];
        }
        [self.buttonBackView addConstraint:btnTop];
        lastBtn = btn;
    }
}
///添加左右约束
-(void)addLeftAndRightConstraintsOnButton:(UIView *)btn inView:(UIView *)view withMarge:(NSInteger)marge{
    NSLayoutConstraint *left = [NSLayoutConstraint
                                constraintWithItem:btn
                                attribute:NSLayoutAttributeLeft
                                relatedBy:NSLayoutRelationEqual
                                toItem:view
                                attribute:NSLayoutAttributeLeft
                                multiplier:1
                                constant:marge];
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:btn
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:view
                                 attribute:NSLayoutAttributeRight
                                 multiplier:1
                                 constant:-marge];
    [view addConstraints:@[left,right]];
}
///创建标题
-(void)createTitles{
    // 添加选择按钮父视图
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    self.buttonBackView = view;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noClick)];
    [view addGestureRecognizer:tap];
    [self addHeightConstraintOnButton:view];
    [self addCornerOnButton:view];
    
    // 添加取消按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setBackgroundImage:[UIImage imageNamed:kActionSheetNormalBackground] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    btn.titleLabel.font = kFont;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    // 监听点击
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    // 设置索引
    btn.tag = 0;
    // 添加高度约束
    [self addHeightConstraintOnButton:btn];
    [self addSubview:btn];
    self.cancelButton = btn;
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:self.titles.count];
    NSInteger index = 1;
    // 循环添加按钮
    for (NSString *title in self.titles) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:kActionSheetNormalBackground] forState:UIControlStateNormal];
        btn.titleLabel.font = kFont;
        [btn setTitleColor:kTextBoldColor forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        // 监听点击
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 设置索引
        btn.tag = index;
        [view addSubview:btn];
        [arrayM addObject:btn];
        // 添加高度约束
        [self addHeightConstraintOnButton:btn];
        index++;
    }
    self.titleViews = arrayM;

}

/// 添加圆角
-(void)addCornerOnButton:(UIView *)btn{
    btn.layer.cornerRadius = kActionSheetCornerRadius;
    btn.layer.masksToBounds = YES;
}
/// 添加高度
-(void)addHeightConstraintOnButton:(UIView *)btn{
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    BOOL isView = ![btn isKindOfClass:[UIButton class]];
    NSLayoutConstraint *height = [NSLayoutConstraint
                                  constraintWithItem:btn
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1
                                  constant:isView?(kTitleHeight * (self.titles.count + 1) + kActionSheetButtonMarge * (self.titles.count) + kMarge * 2) : kTitleHeight];
    [btn addConstraint:height];
    
}
// 回调
-(void)buttonClick:(UIButton *)sender{
    self.clickIndex = sender.tag;
    [self dismissAnimation];
}
-(void)dismissAnimation{
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    [UIView animateWithDuration:kActionSheetAnimationTime animations:^{
        self.maskView.alpha = 0;
        self.userInteractionEnabled = NO;
        self.cancelBottom.constant = self.bottomConstant;
        self.backgroundColor = [UIColor clearColor];
        [self.backImageView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(-20, -20, -20, -20));
        }];
        [self.windowSnapView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        self.backImageView.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        ///动画完成进行回调
        if (self.block) {
            self.block(self.clickIndex);
        }
        [self removeFromSuperview];
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    }];
}
///快速展示
+(void)showWithTitleArray:(NSArray *)titles withCompletionBlock:(AlertViewBlock)completion{
    [[[self alloc] initWithArray:titles] showWithBlock:completion hasMask:YES];
}
///// 显示一系列标题有遮盖
//+(void)showHasMaskWithTitleArray:(NSArray *)titles withCompletionBlock:(AlertViewBlock)completion{
//    [[[self alloc] initWithArray:titles] showWithBlock:completion hasMask:YES];
//}
- (UIImage *)snapshot
{
    UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size, YES, 0);
    [[UIApplication sharedApplication].keyWindow drawViewHierarchyInRect:[[UIApplication sharedApplication].delegate window].bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(void)noClick{
    //不作为
}
@end
