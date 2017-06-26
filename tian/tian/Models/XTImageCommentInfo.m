//
//  XTImageCommentInfo.m
//  StarPicture
//
//  Created by cc on 15-3-7.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTImageCommentInfo.h"
#import "XTUserInfo.h"
@implementation XTImageCommentInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}
//userinfo
+ (NSValueTransformer *)userJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *userdic) {
        NSError *error = nil;
        XTUserInfo *userinfo = [MTLJSONAdapter modelOfClass:[XTUserInfo class] fromJSONDictionary:userdic error:&error];
        return userinfo;
    }];
}

@end
