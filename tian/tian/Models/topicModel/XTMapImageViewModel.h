//
//  XTMapImageViewModel.h
//  tian
//
//  Created by loong on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"


/**
 cover = "http://img2.yytcdn.com/uploads/default/Albums.png";
 createdAt = 1426242818000;
 id = 16;
 personal = 0;
 picCount = 0;
 title = "\U554a\U8def\U54c8\U53ef\U6015\U4e86";
 **/


@interface XTMapImageViewModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,strong)NSString *cover;

@property(nonatomic,strong)NSNumber *createdAt;

@property(nonatomic,strong)NSNumber *personal;

@property(nonatomic,strong)NSNumber *picCount;

@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSNumber *itemID;

@property(nonatomic,strong)NSDictionary *user;

@property(nonatomic,strong)NSArray *pics;

//@"user":NSNull.null,
//@"pics":NSNull.null,


@end
