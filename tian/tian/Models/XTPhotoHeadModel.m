//
//  XTPhotoHeadModel.m
//  tian
//
//  Created by yyt on 15/7/16.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTPhotoHeadModel.h"

@implementation XTPhotoHeadModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"descrip" : @"description"
             };
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
@end
