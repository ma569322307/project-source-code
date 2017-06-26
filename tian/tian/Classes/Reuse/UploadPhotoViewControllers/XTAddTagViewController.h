//
//  XTAddTagViewController.h
//  tian
//
//  Created by 曹亚云 on 15-6-16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"
#import "XTTagDisplayView.h"
#import "XTAddTagView.h"
#define AddTagNotification @"AddTagNotification"
typedef enum {
    XTAddTagTypeDefault = 0,    //默认的添加标签页面（带热门标签和常用标签）
    XTAddTagTypeNoData,         //不带热门标签和常用标签
} XTAddTagType;

@interface XTAddTagViewController : XTRootViewController<XTAddTagDelegate, HKKTagWriteViewDelegate>
@property (nonatomic, assign) XTAddTagType type;
@property (nonatomic, strong) HKKTagWriteView *tagWriteView;
@property (nonatomic, strong) UILabel *tagCountLabel;
@property (nonatomic, strong) UIView *tagDisplayView;
@property (nonatomic, strong) XTAddTagView *addTagView;
@property (nonatomic, strong) UIScrollView *tagScrollView;
@property (nonatomic, strong) HKKTagWriteView *tagResultView;
//原先的数组
@property (nonatomic, strong) NSArray *oldTags;
@end
