//
//  XTShareSheet.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/9.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTShareSheet.h"
#import "XTShareCollectionView.h"
#import "UIImage+rn_Blur.h"
#import "XTShareModel.h"
#import "UIImage+Capture.h"
//#import <Mantle/EXTScope.h>
@interface XTShareSheet ()
@property (nonatomic, strong) XTShareCollectionView *shareCollectionView;
///回调
@property (nonatomic, copy) AlertViewBlock block;
///背景遮罩
@property (nonatomic, strong) UIImageView *maskImageView;
///背景视图
@property (nonatomic, strong) UIImageView *backImageView;
///文字
@property (nonatomic, strong) UILabel *titleLabel;
///取消按钮
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSArray *cell;
@property (nonatomic, strong) NSArray *modelArray;
///弹框高度
@property (nonatomic, assign) CGFloat sheetHeight;
///动画约束
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) UIView *maskView;
// 假背景
@property (nonatomic, strong) UIImageView *windowSnapView;
@end

@implementation XTShareSheet
/// 显示一系列标题
+(void)showWithType:(XTShareSheetItemType)type withCompletionBlock:(AlertViewBlock)completion{
    [[[self alloc] init] showWithType:type withBlock:completion hasMask:YES];
}

///展示
-(void)showWithType:(XTShareSheetItemType)type withBlock:(AlertViewBlock)completion hasMask:(BOOL)hasMask{
    //储存模型数组
    self.modelArray = [XTShareModel shareModelListWithShareType:type];
    //储存block
    self.block = completion;
    //自己作为遮盖
    UIImage *defaultImage = [self snapshot];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:defaultImage];
    self.maskImageView = imageView;
    [self addSubview:imageView];
    [self.maskImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:1];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //添加约束
    [self addConstraints];
    [self layoutIfNeeded];
    
    
    //自己作为遮盖
    UIImage *newImage = [[UIImage captureShotWithView:self] applyBlurWithRadius:3 tintColor:[UIColor colorWithWhite:0 alpha:0.10] saturationDeltaFactor:1.0 maskImage:nil];
    [self.maskImageView removeFromSuperview];
    //截图
    UIImageView *newImageView = [[UIImageView alloc] initWithImage:newImage];
    
    self.maskImageView = newImageView;
    [self insertSubview:newImageView atIndex:0];
    [self.maskImageView updateConstraints:^(MASConstraintMaker *make) {
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
    self.windowSnapView = [[UIImageView alloc] initWithImage:defaultImage];
    [self insertSubview:self.windowSnapView atIndex:0];
    self.maskImageView.alpha = 0;
    // 防动画穿帮view
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_SIZE.height - 50, SCREEN_SIZE.width, 200)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    [self bringSubviewToFront:self.backImageView];
    
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    //显示
    [UIView animateWithDuration:kActionSheetAnimationTime delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bottomConstraint.constant -= self.sheetHeight;
        self.maskView.alpha = 0.2;
        [self.maskImageView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self.windowSnapView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(20, 20, 20, 20));
        }];
        self.maskImageView.alpha = 1;
        self.userInteractionEnabled = NO;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        [whiteView removeFromSuperview];
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    }];
}
///添加约束
-(void)addConstraints{
    // 添加自身约束
    UIView *window = [UIApplication sharedApplication].keyWindow;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cancelButton sizeToFit];
    CGFloat rowNumber = self.modelArray.count > kShareCollectionViewColumnNumber? 2 : 1;
    CGFloat backImageViewHeight = kShareButtonMerage + self.cancelButton.frame.size.height + kShareCollectionViewHeightMerage * 2 + kShareCollectionViewLineSpacing * (rowNumber - 1)+ [self caculateItemSize].height * rowNumber + kShareCancelTitleSize + kShareTitleMerage;
    self.sheetHeight = backImageViewHeight;
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
    ///背景约束
    NSLayoutConstraint *backLeft = [NSLayoutConstraint
                                constraintWithItem:self.backImageView
                                attribute:NSLayoutAttributeLeft
                                relatedBy:NSLayoutRelationEqual
                                toItem:self
                                attribute:NSLayoutAttributeLeft
                                multiplier:1
                                constant:kActionSheetWindowMerge];
    NSLayoutConstraint *backRight = [NSLayoutConstraint
                                    constraintWithItem:self.backImageView
                                    attribute:NSLayoutAttributeRight
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                    attribute:NSLayoutAttributeRight
                                    multiplier:1
                                    constant:-kActionSheetWindowMerge];
    NSLayoutConstraint *backBottom = [NSLayoutConstraint
                                     constraintWithItem:self.backImageView
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                     constant:-kActionSheetWindowMerge+self.sheetHeight];
    NSLayoutConstraint *backHeight = [NSLayoutConstraint
                                     constraintWithItem:self.backImageView
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1
                                     constant:backImageViewHeight];
    self.bottomConstraint = backBottom;
    //标题文字约束
    NSLayoutConstraint *titleLeft = [NSLayoutConstraint
                                    constraintWithItem:self.titleLabel
                                    attribute:NSLayoutAttributeLeft
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.backImageView
                                    attribute:NSLayoutAttributeLeft
                                    multiplier:1
                                    constant:kShareTitleMerage];
    NSLayoutConstraint *titleTop = [NSLayoutConstraint
                                     constraintWithItem:self.titleLabel
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.backImageView
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1
                                     constant:kShareTitleMerage];
    //取消按钮约束
    NSLayoutConstraint *cancelLeft = [NSLayoutConstraint
                                     constraintWithItem:self.cancelButton
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.backImageView
                                     attribute:NSLayoutAttributeLeft
                                     multiplier:1
                                     constant:kShareButtonMerage];
    NSLayoutConstraint *cancelBottom = [NSLayoutConstraint
                                    constraintWithItem:self.cancelButton
                                    attribute:NSLayoutAttributeBottom
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.backImageView
                                    attribute:NSLayoutAttributeBottom
                                    multiplier:1
                                    constant:-kShareButtonMerage];
    NSLayoutConstraint *cancelRight = [NSLayoutConstraint
                                        constraintWithItem:self.cancelButton
                                        attribute:NSLayoutAttributeRight
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self.backImageView
                                        attribute:NSLayoutAttributeRight
                                        multiplier:1
                                        constant:-kShareButtonMerage];
    
    //按钮界面约束
    NSLayoutConstraint *collectionViewLeft = [NSLayoutConstraint
                                      constraintWithItem:self.shareCollectionView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.backImageView
                                      attribute:NSLayoutAttributeLeft
                                      multiplier:1
                                      constant:kShareCollectionViewWidthMerage];
    NSLayoutConstraint *collectionViewBottom = [NSLayoutConstraint
                                        constraintWithItem:self.shareCollectionView
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self.cancelButton
                                        attribute:NSLayoutAttributeTop
                                        multiplier:1
                                        constant:-kShareCollectionViewHeightMerage];
    NSLayoutConstraint *collectionViewRight = [NSLayoutConstraint
                                       constraintWithItem:self.shareCollectionView
                                       attribute:NSLayoutAttributeRight
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self.backImageView
                                       attribute:NSLayoutAttributeRight
                                       multiplier:1
                                       constant:-kShareCollectionViewWidthMerage];
    NSLayoutConstraint *collectionViewTop = [NSLayoutConstraint
                                               constraintWithItem:self.shareCollectionView
                                               attribute:NSLayoutAttributeTop
                                               relatedBy:NSLayoutRelationEqual
                                               toItem:self.titleLabel
                                               attribute:NSLayoutAttributeBottom
                                               multiplier:1
                                               constant:kShareCollectionViewHeightMerage];
    
    //添加约束
    [self addConstraints:@[backLeft,backBottom,backRight,backHeight]];
    [self.backImageView addConstraints:@[titleLeft,titleTop,cancelLeft,cancelBottom,cancelRight,collectionViewBottom,collectionViewLeft,collectionViewRight,collectionViewTop]];
    [self layoutIfNeeded];
    [self.shareCollectionView reloadData];
}
///计算大小
-(CGSize)caculateItemSize{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat itemWidth = (screenSize.width - kShareCollectionViewWidthMerage * 2 - kActionSheetWindowMerge * 2 - (kShareCollectionViewColumnNumber - 1) * kShareCollectionViewInteritemSpacing) / kShareCollectionViewColumnNumber;
    CGFloat itemHeigth = itemWidth + kShareCollectionViewInteritemSpacing + kShareCollectionViewButtonTextSize;
    return CGSizeMake(itemWidth, itemHeigth);
}
///点击了取消
-(void)cancelClick{
    [self dismissAnimation];
}
///消失动画
-(void)dismissAnimation{
    //消失
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    [UIView animateWithDuration:kActionSheetAnimationTime animations:^{
        self.maskView.alpha = 0;
        self.userInteractionEnabled = NO;
        self.bottomConstraint.constant += self.sheetHeight;
        [self.maskImageView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(-20, -20, -20, -20));
        }];
        [self.windowSnapView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        self.maskImageView.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        NSInteger index = self.clickIndex;
        if (self.block) {
            self.block(index);
        }
        [self removeFromSuperview];
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    }];

}
///
-(void)setClickIndex:(NSInteger)clickIndex{
    [super setClickIndex:clickIndex];
    ///进行消失回调
    [self dismissAnimation];
}
//截取屏幕
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
#pragma mark 懒加载
-(XTShareCollectionView *)shareCollectionView
{
    if (_shareCollectionView == nil) {
        _shareCollectionView = [XTShareCollectionView shareCollectionViewCreateView];
        _shareCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_shareCollectionView resizeFlow:[self caculateItemSize]];
        [self.backImageView addSubview:_shareCollectionView];
        _shareCollectionView.modelList = self.modelArray;
        __weak XTShareSheet *weakSelf = self;
        [_shareCollectionView setBtnBlock:^(NSInteger index) {
            XTShareSheet *self = weakSelf;
            self.clickIndex = index;
        }];
    }
    return _shareCollectionView;
}
-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.text = @"分享到:";
        _titleLabel.font = [UIFont boldSystemFontOfSize:kShareTitleSize];
        _titleLabel.textColor = UIColorFromRGB(0x6f6f6f);
        [self.backImageView addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(UIButton *)cancelButton
{
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"ShareCancelButtonImage"] forState:UIControlStateNormal];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:kShareCancelTitleSize];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backImageView addSubview:_cancelButton];
    }
    return _cancelButton;
}
-(UIImageView *)backImageView
{
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShareBackImage"]];
        _backImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _backImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noClick)];
        [_backImageView addGestureRecognizer:tap];
        [self addSubview:_backImageView];
    }
    return _backImageView;
}
@end
