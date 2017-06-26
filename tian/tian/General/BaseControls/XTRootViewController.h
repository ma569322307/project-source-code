//
//  XTRootViewController.h
//  tian
//
//  Created by 尚毅 杨 on 15/4/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTBarButtonItem.h"
#import "XTCommonMacro.h"
#import "UINavigationItem+CustomItem.h"
#import "NSError+XTError.h"
#import "UIView+JKPicker.h"
#import "YYTHUD.h"
#import "YYTAlertView.h"
#import "YYTActionSheet.h"
#import "XHNavigationControllerDelegate.h"

@interface XTRootViewController : UIViewController

@property (nonatomic, assign) BOOL needTranform;
@property (nonatomic, strong) XHNavigationControllerDelegate *navigationControllerDelegate;

//添加导航条返回按钮
- (void)addBackNavigationItem;

- (void)tranformPushWithCollectionView:(UICollectionView *)collectionView imageSize:(CGSize)imageSize currentIndex:(NSInteger)index;
/*
//HUD
-(void)showMBHUDWithText:(NSString *)text;
-(void)showMBHUD;
- (void)hideMBHUDAfter:(NSTimeInterval)afTime;
- (void)hideMBHUD;
//TIPView
- (void)showTipViewWithTitle:(NSString *)title Type:(TIPTYPE)type;
 */
@end
