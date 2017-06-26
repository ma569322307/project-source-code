//
//  XTHeadView.h
//  tian
//
//  Created by 曹亚云 on 15-5-14.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTUserAccountInfo.h"
#import "XTActionBar.h"
@class XTHeadPortraitView;
typedef enum {
    XTUserHeadViewTypeMine= 0,  //我的个人页
    XTUserHeadViewTypeHis       //他人的个人页
} XTUserHeadViewType;

@protocol XTHeadViewDelegate <NSObject>
- (void)onClickHeadBar:(XTActionBar *)headBar atTitle:(NSInteger)index;
- (void)onClickSignInBtn:(UIButton *)signInBtn;
@end

@interface XTHeadView : UIView
@property (nonatomic, assign) id<XTHeadViewDelegate> delegate;
@property (nonatomic, strong) XTHeadPortraitView *headPortraitView;
@property (nonatomic, assign) CGFloat height;
- (id)initWithType:(XTUserHeadViewType)type;
- (void)fillUesrInformation:(XTUserAccountInfo *)user;
- (void)fillLocalUserSignInInfo:(XTUserAccountInfo *)user;
+ (CGFloat)calculateViewHeight:(XTUserHeadViewType)type;
@end
