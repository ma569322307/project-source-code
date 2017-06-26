//
//  XTAttentionImageInfo.h
//  tian
//
//  Created by cc on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@interface XTAttentionImageInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) long sid;
@property (nonatomic, strong) NSURL *thumbnailPic;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@end
