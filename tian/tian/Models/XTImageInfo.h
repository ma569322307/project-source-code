//
//  XTImageInfo.h
//  tian
//
//  Created by cc on 15/6/9.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@interface XTImageInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) NSString *commendCount;
@property (nonatomic, strong) NSString *commentCount;

@property (nonatomic, assign) NSInteger albumId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, assign) NSInteger imgCount;
@property (nonatomic, strong) NSURL *middlePic;
@property (nonatomic, strong) NSURL *picUrl;
@property (nonatomic, assign) NSInteger picId;//当imgcount == 1时用此id
@property (nonatomic, assign) NSInteger sid;//当imgcount > 1时用此id
@property (nonatomic, assign) NSInteger type;//0（默认）； type=1（精选）
@property (nonatomic, assign) NSInteger cid;//消息页面用
@property (nonatomic, assign) BOOL subArtist;//广场喜欢页面使用，判断是否有喜欢的艺人
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
