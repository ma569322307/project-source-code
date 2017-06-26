//
//  XTShareSheet.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/9.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "YYTHUD.h"
#import "XTActionBase.h"
#define kShareCollectionViewColumnNumber 5
#define kShareCollectionViewInteritemSpacing 15
#define kShareCollectionViewLineSpacing 5
#define kShareCollectionViewButtonTextSize 9
#define kShareCancelTitleSize 16
#define kShareTitleSize 12
#define kShareTitleMerage 15
#define kShareButtonMerage 8
#define kShareCollectionViewWidthMerage 15
#define kShareCollectionViewHeightMerage 8
typedef enum{
    XTShareSheetItemNone        = 0,        //什么都没
    XTShareSheetItemCancelTop   = 1,        //取消置顶按钮
    XTShareSheetItemTop         = 1 << 1,   //置顶按钮
    XTShareSheetItemTips        = 1 << 2,   //打赏按钮
    XTShareSheetItemWarning     = 1 << 3,   //举报按钮
    XTShareSheetItemMove        = 1 << 4,   //移动按钮
    XTShareSheetItemDelete      = 1 << 5    //删除按钮
}XTShareSheetItemType;
@interface XTShareSheet : XTActionBase
/*
    通过位移枚举提供需要的按钮
    XTShareSheetItemMove|XTShareSheetItemDelete|XTShareSheetItemTips|XTShareSheetItemWarning
 */
+(void)showWithType:(XTShareSheetItemType)type withCompletionBlock:(AlertViewBlock)completion;
@end
