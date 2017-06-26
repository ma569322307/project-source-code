//
//  XTSearchImageModel.h
//  tian
//
//  Created by huhuan on 15/6/13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"

@interface XTSearchImageModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) long imageId;
@property (nonatomic, copy) NSString *image;

@end
