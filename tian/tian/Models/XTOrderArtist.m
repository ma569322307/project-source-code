//
//  XTOrderArtist.m
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/4.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTOrderArtist.h"
@interface XTOrderArtist ()

//兼容字段
@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString *name;

@end

@implementation XTOrderArtist

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}

- (void)setId:(int)aid {
    _artistId = aid;
}

- (void)setName:(NSString *)name {
    _artistName = name;
}



@end
