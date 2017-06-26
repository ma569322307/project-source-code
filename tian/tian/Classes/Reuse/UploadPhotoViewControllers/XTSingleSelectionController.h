//
//  XTSingleSelectionController.h
//  collectionViewPlay
//
//  Created by Jiajun Zheng on 15/6/23.
//  Copyright (c) 2015年 zjProject. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTGroupSelectionCollectionViewController;
@interface XTSingleSelectionController : UIViewController
// 接收选择具体组的通知
#define kSelectionGroupNotification @"SelectionGroupNotification"
#define kSelectSingleStickerNotification @"SelectSingleStickerNotification"
#define kReloadLogoGroupNotification @"ReloadLogoGroupNotification"
#define kHideNotification @"HideNotification"
#define kHeight kDistance + kBigSize + kItemMerage * 2
#define kUploadScreenHight ([UIScreen mainScreen].scale > 2 ? 667.0 : [UIScreen mainScreen].bounds.size.height)
#define kRation (kUploadScreenHight / 667.0)
#define kDistance (64.0 * kRation)
#define kBigSize (100.0 * kRation)
#define kSingleLeftEdge kBigSize / 2.0
#define kSmallSize (80.0 * kRation)
#define kItemMerage (8.0 * kRation)
#define kBackColor UIColorFromRGB(0xeaeaea)
#define kStickerLabelWidth (113.0 * kRation)
#define kStickerLabelHeight (33.0 * kRation)

//#define kSelectLogoNotification @"SelectLogoNotification"
// 提供分组展示的控制器
@property (nonatomic, strong) XTGroupSelectionCollectionViewController *groupsController;
// 自身高度约束
@property (nonatomic, strong) NSLayoutConstraint *height;
// 具体一组数据
@property (nonatomic, strong) NSArray *singleStickers;
// 快贴按钮
@property (nonatomic, weak) UIButton *stickerButton;
// logo按钮
@property (nonatomic, weak) UIButton *logoButton;
// 贴图按钮点击事件
-(void)stickerClick;
//logo按钮点击事件
-(void)logoClick;
@end
