//
//  XTAlbumModel.h
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"

@interface XTAlbumModel : MTLModel<MTLJSONSerializing>


@property(nonatomic,strong)NSNumber *itemID;

@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSString *cover;

@property(nonatomic,strong)NSNumber *picCount;

@property(nonatomic,strong)NSNumber *personal;

@property(nonatomic,strong)NSNumber *createdAt;

@property(nonatomic,strong)NSString *des;

@end
