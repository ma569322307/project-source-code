//
//  XTMapImageViewModel.m
//  tian
//
//  Created by loong on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTMapImageViewModel.h"

@implementation XTMapImageViewModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"itemID":@"id",
             @"user":NSNull.null,
             @"pics":NSNull.null,
             };
}



@end
