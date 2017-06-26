//
//  XTPushToOtherVCManager.h
//  tian
//
//  Created by cc on 15/7/14.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XTMessageInfo;
@interface XTPushToOtherVCManager : NSObject
+ (void)pushMessagePushToOtherViewControllerWithType:(NSString *)type withViewController:(UINavigationController *)viewController withModel:(XTMessageInfo *)messageInfo;
@end
