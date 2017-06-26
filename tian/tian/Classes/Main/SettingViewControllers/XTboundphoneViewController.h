//
//  XTboundiphoneTwoViewController.h
//  tian
//
//  Created by yyt on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"
typedef enum {
    XTboundiphoneregister = 0,
    XTboundiphoneresetPassword = 1,
    XTboundiphonebind = 2,
}XTboundiphonetype;
@interface XTboundphoneViewController : XTRootViewController
@property (assign, nonatomic) XTboundiphonetype type;
@property (nonatomic, copy) void(^completionBlock)();


@end
