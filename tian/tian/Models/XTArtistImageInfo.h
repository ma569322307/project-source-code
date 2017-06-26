//
//  XTArtistImageInfo.h
//  tian
//
//  Created by 曹亚云 on 15-7-9.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "MTLModel.h"
#import "XTImageInfo.h"
@interface XTArtistImageInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) XTImageInfo *imageInfo;
@property (nonatomic, assign) NSInteger artistImageInfoID;
@property (nonatomic, strong) NSString *type;
@end
