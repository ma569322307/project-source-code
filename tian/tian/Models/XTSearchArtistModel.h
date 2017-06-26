//
//  XTSearchArtistModel.h
//  tian
//
//  Created by huhuan on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"

@interface XTSearchArtistModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSArray *artists;
@property (nonatomic, copy) NSArray *topics;
@property (nonatomic, copy) NSArray *pics;

@end
