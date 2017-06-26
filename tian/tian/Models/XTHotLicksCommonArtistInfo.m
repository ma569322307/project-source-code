//
//  XTSpecificArtistInfo.m
//  tian
//
//  Created by huhuan on 15/7/1.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHotLicksCommonArtistInfo.h"
#import "XTOrderArtist.h"
#import "XTAlbumInfo.h"
#import "XTImageInfo.h"
#import "XTUserInfo.h"

@implementation XTHotLicksCommonArtistInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}

+ (NSValueTransformer *)basicJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *recsInfo) {
        NSError *error = nil;
        XTUserInfo *basicInfo = [MTLJSONAdapter modelOfClass:[XTHotLicksRecsInfo class] fromJSONDictionary:recsInfo error:&error];
        return basicInfo;
    }];
}

+ (NSValueTransformer *)artistsJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *artistArray) {
        NSError *error = nil;
        return [MTLJSONAdapter modelsOfClass:[XTOrderArtist class] fromJSONArray:artistArray error:&error];
    }];
}

+ (NSValueTransformer *)albumsJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *artistArray) {
        NSError *error = nil;
        return [MTLJSONAdapter modelsOfClass:[XTAlbumInfo class] fromJSONArray:artistArray error:&error];
    }];
}

+ (NSValueTransformer *)picturesJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *pictureArray) {
        NSError *error = nil;
        return [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:pictureArray error:&error];
    }];
}

+ (NSValueTransformer *)userJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *userInfo) {
        NSError *error = nil;
        return [MTLJSONAdapter modelOfClass:[XTUserInfo class] fromJSONDictionary:userInfo error:&error];
    }];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

@end
