//
//  XTOriginImgModel.h
//  tian
//
//  Created by loong on 15/7/2.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"

@interface XTOriginImgModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,strong)NSNumber *pid;

@property(nonatomic,strong)NSURL *thumbnailPic;

@property(nonatomic,strong)NSURL *middlePic;

@property(nonatomic,strong)NSURL *originalPic;


@end
