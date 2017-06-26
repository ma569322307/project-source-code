//
//  XTWaterFallPicInfo.h
//  tian
//
//  Created by cc on 15/6/4.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//


#import "MTLModel.h"
#import "XTHotLicksTopicsInfo.h"
#import "XTImageInfo.h"
#import <Mantle.h>
@interface XTWaterFallPicInfo : MTLModel<MTLJSONSerializing>
//舔神瀑布流数据
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *headImg;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSURL *imgUrl;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) NSInteger albumId;
@property (nonatomic, assign) NSInteger picId;//count==1的时候用此id

//热舔 瀑布流数据
@property (nonatomic, assign) long created;
@property (nonatomic, strong) NSString *descriptionStr;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) XTHotLicksTopicsInfo *topic;
@end
