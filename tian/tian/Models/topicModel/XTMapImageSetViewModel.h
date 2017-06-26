//
//  XTMapImageModel.h
//  tian
//
//  Created by loong on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"

@interface XTMapImageSetViewModel : MTLModel <MTLJSONSerializing>


@property(nonatomic,strong)NSString *content;

@property(nonatomic,strong)NSArray *albums;

@property(nonatomic,strong)NSString *title;

@property(nonatomic)NSInteger albumCount;

//@property (nonatomic, copy) NSString *cover;

@end
