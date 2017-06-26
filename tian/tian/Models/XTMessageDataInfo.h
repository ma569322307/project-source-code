//
//  XTMessageDataInfo.h
//  StarPicture
//
//  Created by cc on 15-4-8.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@interface XTMessageDataInfo : MTLModel<MTLJSONSerializing>
@property(nonatomic, assign) NSInteger id;
@property(nonatomic, strong) NSString * text;
@property(nonatomic, strong) NSURL *picUrl;
@property(nonatomic, assign) float height;
@property(nonatomic, assign) float width;
@property(nonatomic, strong) NSArray *artists;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, assign) long cid;
@property(nonatomic, assign) long uid;
@end
