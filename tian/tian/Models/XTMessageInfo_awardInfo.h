//
//  XTMessageInfo_awardInfo.h
//  tian
//
//  Created by cc on 15/8/2.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "MTLModel.h"
#import "XTImageInfo.h"
/*gr = 6;
g = 120;
gc = 60;
pic = {
 */
@interface XTMessageInfo_awardInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) XTImageInfo *pic;
@property (nonatomic, assign) NSInteger gr;//获得的声望
@property (nonatomic, assign) NSInteger g;//打赏的积分
@property (nonatomic, assign) NSInteger gc;//获得的积分

@end
