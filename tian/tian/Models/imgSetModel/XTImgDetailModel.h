//
//  XTImgDetailModel.h
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
@class XTImgShowModel;
@interface XTImgDetailModel : MTLModel

@property(nonatomic,strong)XTImgShowModel *model;

@property(nonatomic,strong)NSArray *arr;


@end
