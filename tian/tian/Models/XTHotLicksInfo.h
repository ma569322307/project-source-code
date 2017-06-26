//
//  XTHotLicksInfo.h
//  tian
//
//  Created by 尚毅 杨 on 15/5/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
#import "XTHotLicksBannerInfo.h"
#import "XTHotLicksRankInfo.h"
#import "XTHotLicksRecsInfo.h"
#import "XTHotLicksTopicsInfo.h"
#import "XTWaterFallPicInfo.h"
#import <Mantle.h>
@interface XTHotLicksInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) XTHotLicksBannerInfo *banner;
@property (nonatomic, strong) NSArray *ranks;
@property (nonatomic, strong) NSArray *recs;
@property (nonatomic, strong) NSArray *topics;
@property (nonatomic, strong) NSArray *hots;

@end
