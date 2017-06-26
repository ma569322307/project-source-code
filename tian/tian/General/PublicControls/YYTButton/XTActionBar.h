//
//  XTActionBar.h
//  StarPicture
//
//  Created by 曹亚云 on 15-2-11.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTUICommon.h"
#import "YYTButton.h"
typedef enum {
    XTActionBarNavigationType,
    XTActionBarTitleType,
    XTActionBarButtonType
} XTActionBarType;

#define ABACTIONBAR_HEIGHT              51
#define ABACTIONBAR_BUTTON_MARGIN       3
#define ABACTIONBAR_TITLE_MARGIN        0


#define ABACTIONBAR_GAP_RESOURCE        @"actionbar_gap"
#define ABACTIONBAR_GAP_WIDTH           0.5f
#define ABACTIONBAR_GAP_HEIGHT          51.0f

#define ABACTIONBAR_DEFAULT_TITLEFONT       [UIFont boldSystemFontOfSize:10]
#define ABACTIONBAR_DEFAULT_S_TITLEFONT     [UIFont boldSystemFontOfSize:14]

#define ABACTIONBAR_DEFAULT_TITLECOLOR      COLOR_RGB_HEX(0xffffff)
#define ABACTIONBAR_DEFAULT_S_TITLECOLOR    COLOR_RGB_HEX(0xfcea00)

#define ABACTIONBAR_DEFAULT_S_SPACE     6

@class XTActionBar;
@protocol XTActionBarDelegate <NSObject>
- (void)onClickActionBar:(XTActionBar *)actionBar atTitle:(NSInteger)index;
@end

@interface XTActionBar : UIView
/**
 * 设置左边操作按钮
 * @param itemImageName 按钮的背景图片名，itemImageName为normal itemImageName_focus为highlighted
 * @param target The target of the selector
 * @param action The selector to perform when the button is tapped
 *
 * @return
 */
- (void)setLeftActionItem:(NSString *)itemImageName target:(id)target action:(SEL)action;
/**
 * 设置右边操作按钮
 * @param itemImageName 按钮的背景图片名，itemImageName为normal itemImageName_focus为highlighted
 * @param target The target of the selector
 * @param action The selector to perform when the button is tapped
 *
 * @return
 */
- (void)setRightActionItem:(NSString *)itemImageName target:(id)target action:(SEL)action;

/**
 * 按钮的普通状态，按下状态
 */
@property (nonatomic, strong) UIImage *btnBackground;           //设置按钮正常态
@property (nonatomic, strong) UIImage *btnSelectedBackground;   //设置按钮按下态
@property (nonatomic, strong) UIFont *titleFont;                //设置title的基础字体
@property (nonatomic, strong) UIColor *titleColor;              //设置title的基础颜色
@property (nonatomic, strong) UIFont *titleSpecialFont;         //设置title的高亮字体
@property (nonatomic, strong) UIColor *titleSpecialColor;       //设置title的高亮颜色
@property (nonatomic, strong) UIColor *bottomBorderColor;
@property (nonatomic, strong) UIColor *topBorderColor;
@property (nonatomic, strong) NSArray *titleItems;
@property (nonatomic, strong) NSArray *leftBtnItems;
@property (nonatomic, strong) NSArray *rightBtnItems;
@property (nonatomic, strong) NSArray *buttonItems;
@property (nonatomic, assign) XTActionBarType type;

@property (nonatomic, strong) YYTButton *leftButton;             //左按钮
@property (nonatomic, strong) YYTButton *rightButton;            //右按钮

@property (nonatomic, strong) UIButton *signInBtn;
@property (nonatomic, strong) UILabel *signInNumberLabel;        //用户签到数
@property (nonatomic, weak) id <XTActionBarDelegate> delegate;  //Title按钮回调
@property (nonatomic, retain) NSMutableArray *rightBtnViews;

- (void)test;
- (void)setButtonStatus:(NSInteger)index;
- (void)setRightBtnsImage:(BOOL)isNormal;
- (void)setLeftBtnsImage:(BOOL)isNormal;
@end
