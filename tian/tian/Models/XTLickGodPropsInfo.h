//
//  XTLickGodPropsInfo.h
//  tian
//
//  Created by cc on 15/6/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@interface XTLickGodPropsInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *imgUrl;
@end
