//
//  XTBindApnsStore.h
//  StarPicture
//
//  Created by cc on 15-3-16.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString +Expand.h"
#define BindApns_capiKey  @"http://capi.yinyuetai.com/common/apns/bind.json"
@interface XTBindApnsStore : NSObject
@property (nonatomic, copy) NSString *apnsToken;
+ (instancetype)sharedManager;
-(BOOL)isCanBind;
-(id)bindApns;
@end
