//
//  XTPlazaWaterFallInfo.h
//  StarPicture
//
//  Created by cc on 15-3-4.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@interface XTPlazaWaterFallInfo : MTLModel<MTLJSONSerializing>
@property(nonatomic, assign) NSInteger id;
@property(nonatomic, strong) NSString * text;
@property(nonatomic, strong) NSURL *picUrl;
@property(nonatomic, assign) float height;
@property(nonatomic, assign) float width;
@property(nonatomic, strong) NSArray *artists;
@end
