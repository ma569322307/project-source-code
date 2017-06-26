//
//  XTAttentionInfo.m
//  tian
//
//  Created by cc on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTAttentionInfo.h"
/**
 *   {
 createdAt = 1429238466000;
 id = 116737797;
 images =             (
 {
 sid = 116737797;
 thumbnailPic = "http://img6.c.yinyuetai.com/starpicture/starpicture/150417/0/-M-df5620d7fdbcc4c380fbb2453205ab53_320x0.jpg";
 }
 );
 user =             {
 nickName = "\U4e71\U821e\U7cbe\U7075";
 smallAvatar = "http://img1.yytcdn.com/user/avatar/150610/37946767/-M-78a5e3088f65e18ebca6d0c83a8713ed_100x100.jpg";
 uid = 37946767;
 };
 }
 */
@implementation XTAttentionInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"userId":@"user.uid",
                @"userNickName":@"user.nickName",
                @"userSmallAvatar":@"user.smallAvatar",
                
             };
}
+ (NSValueTransformer *)imagesJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *imgArr) {
        NSError *error = nil;
        NSArray *imagesArr = [MTLJSONAdapter modelsOfClass:[XTAttentionImageInfo class] fromJSONArray:imgArr error:&error];
        return imagesArr;
    }];
}
+ (NSValueTransformer *)imageUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
+ (NSValueTransformer *)userSmallAvatarJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
