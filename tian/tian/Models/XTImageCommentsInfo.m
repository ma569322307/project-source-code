//
//  XTImageCommentsInfo.m
//  StarPicture
//
//  Created by cc on 15-3-4.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTImageCommentsInfo.h"
#import "XTUserInfo.h"
@implementation XTImageCommentsInfo
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
+ (NSValueTransformer *)originalCommentJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *originalCommentdic) {
        NSError *error = nil;
        XTImageCommentsInfo *userinfo = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:originalCommentdic error:&error];
        return userinfo;
    }];
}
@end
