//
//  XTImgsModel.h
//  tian
//
//  Created by loong on 15/7/7.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"

@interface XTImgsModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,strong)NSURL *url;

@property(nonatomic,strong)NSNumber *width;

@property(nonatomic,strong)NSNumber *height;

@property(nonatomic,strong)NSNumber *itemID;

@end
