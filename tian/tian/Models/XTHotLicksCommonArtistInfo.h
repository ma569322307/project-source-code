//
//  XTSpecificArtistInfo.h
//  tian
//
//  Created by huhuan on 15/7/1.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"
#import "XTHotLicksRecsInfo.h"
#import "XTUserInfo.h"

@interface XTHotLicksCommonArtistInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) XTHotLicksRecsInfo *basic;
@property (nonatomic, copy) NSArray *artists;
@property (nonatomic, copy) NSArray *albums;
@property (nonatomic, copy) NSArray *pictures;
@property (nonatomic, strong) XTUserInfo *user;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
