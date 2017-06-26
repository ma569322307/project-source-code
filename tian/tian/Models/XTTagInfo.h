//
//  XTTagInfo.h
//  tian
//
//  Created by huhuan on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"

typedef NS_ENUM(NSUInteger, XTTagType) {
    XTTagNormal,
    XTTagArtist,
};

@interface XTTagInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) long tagId;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, assign) long picCount;
@property (nonatomic)XTTagType tagType;
@end
