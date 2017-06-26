//
//  XTRenownValueView.h
//  tian
//
//  Created by 曹亚云 on 15-5-13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTUserAccountInfo.h"
typedef enum {
    XTUserRenownValueTypeMine= 0,  //我的声望
    XTUserRenownValueTypeHis       //他人的声望
} XTUserRenownValueType;

@interface XTRenownValueView : UIView
- (id)initWithType:(XTUserRenownValueType)type;
- (void)fillUesrInformation:(XTUserAccountInfo *)user;

@end
