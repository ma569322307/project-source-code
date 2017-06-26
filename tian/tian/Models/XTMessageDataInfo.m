//
//  XTMessageDataInfo.m
//  StarPicture
//
//  Created by cc on 15-4-8.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTMessageDataInfo.h"

@implementation XTMessageDataInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return  @{
              @"userName":@"pic.user.nickName",
              @"uid":@"user.uid",
              @"id":@"pic.id",
              @"text":@"pic.text",
              @"picUrl":@"pic.picUrl",
              @"height":@"pic.height",
              @"width":@"pic.width",
              @"artists":@"pic.artists",
              @"width":@"pic.width",
              };
    
}
//string类型转换成NSURL
+ (NSValueTransformer *)picUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end
