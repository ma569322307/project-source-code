//
//  XTSignInView.h
//  tian
//
//  Created by 曹亚云 on 15-5-14.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTUserAccountInfo.h"
@class XTNoHighLightedButton;
@interface XTSignInView : UIView
@property (nonatomic, strong) XTNoHighLightedButton *signInButton;
@property (nonatomic, assign) BOOL isSigned;
- (void)fillUesrInformation:(XTUserAccountInfo *)user;

@end
