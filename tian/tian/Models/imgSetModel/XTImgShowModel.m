//
//  XTImgShowModel.m
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTImgShowModel.h"
#import "XTUserInfo.h"
#import "XTAlbumModel.h"
#import "XTTagInfo.h"
@implementation XTImgShowModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"itemID":@"id"};
}



+ (NSValueTransformer *)userJSONTransformer{
    
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *dic) {
        NSError *error = nil;
        XTUserInfo *user = [MTLJSONAdapter modelOfClass:[XTUserInfo class] fromJSONDictionary:dic error:&error];
        return user;
    }];
}


+(NSValueTransformer *)commendUsersJSONTransformer{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *array) {
        NSError *error = nil;
        NSArray *arr = [MTLJSONAdapter modelsOfClass:[XTUserInfo class] fromJSONArray:array error:&error];
        
        return arr;
    }];
}


+(NSValueTransformer *)albumJSONTransformer{
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *dic) {
        NSError *error = nil;
        XTAlbumModel *model = [MTLJSONAdapter modelOfClass:[XTAlbumModel class] fromJSONDictionary:dic error:&error];
        return model;
    }];
}



+(NSValueTransformer *)tagsNewJSONTransformer{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *arr) {
        NSError *error = nil;
        
        NSArray *array = [MTLJSONAdapter modelsOfClass:[XTTagInfo class] fromJSONArray:arr error:&error];
        
        return array;
    }];
}

//+(NSValueTransformer *)artistsJSONTransformer{
//    return [MTLValueTransformer transformerWithBlock:^id(NSArray *array) {
//        NSError *error = nil;
//        NSArray *arr = [MTLJSONAdapter modelsOfClass:[XTOrderArtist class] fromJSONArray:array error:&error];
//        NSLog(@"***************artists***************%@",arr);
//        return arr;
//    }];
//}


-(NSArray *)collocateTags{
    
    NSMutableArray *arr_m = [NSMutableArray arrayWithCapacity:self.tags.count];
    
    NSArray *artists = self.artists;
    
    NSLog(@"self.artists === %@",self.artists);
    
    if (!artists) {
        for (NSString *tag in self.tags) {
            XTTagInfo *tagInfo = [[XTTagInfo alloc] init];
            tagInfo.tag = tag;
            tagInfo.tagType = XTTagNormal;
            [arr_m addObject:tagInfo];
        }
    }else{
        NSMutableArray *arr_m_t = [NSMutableArray arrayWithCapacity:artists.count];
        for (NSDictionary *dic in artists) {
            [arr_m_t addObject:dic[@"name"]];
        }
        
        for (NSString *tag in self.tags) {
            XTTagInfo *tagInfo = [[XTTagInfo alloc] init];
            tagInfo.tag = tag;
            if ([arr_m_t containsObject:tag]) {
                NSInteger index = [arr_m_t indexOfObject: tag];
                NSDictionary *artist_d = artists[index];
                tagInfo.tagId = [artist_d[@"id"] integerValue];
                tagInfo.tagType = XTTagArtist;
            }else{
                tagInfo.tagType = XTTagNormal;
            }
            
            [arr_m addObject:tagInfo];
        }
    }
    return [arr_m copy];
}




@end
