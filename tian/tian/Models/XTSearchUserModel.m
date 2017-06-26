//
//  XTSearchUserModel.m
//  tian
//
//  Created by huhuan on 15/6/12.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchUserModel.h"

@interface XTSearchUserModel ()

@property (nonatomic, copy) NSString *subStatus;
@property (nonatomic, assign) long subNum;

@end

@implementation XTSearchUserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"userId" : @"id"
             };
}

+ (NSValueTransformer *)followJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *follow) {
        NSString *followStr = [NSString stringWithFormat:@"%@",follow];
        return followStr;
    }];
}

+ (NSValueTransformer *)likeJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *like) {
        NSString *likeStr = [NSString stringWithFormat:@"%@",like];
        return likeStr;
    }];
}

+ (NSValueTransformer *)blackJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *black) {
        NSString *blackStr = [NSString stringWithFormat:@"%@",black];
        return blackStr;
    }];
}

+ (NSValueTransformer *)subStatusJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *subStatus) {
        NSString *subStatusStr = [NSString stringWithFormat:@"%@",subStatus];
        return subStatusStr;
    }];
}

+ (NSValueTransformer *)sexJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"Boy": @"男",
                                                                           @"Girl": @"女",
                                                                           @"Secret": @"保密"
                                                                           }];
}

- (void)setSubStatus:(NSString *)subStatus {
    self.like = subStatus;
}

- (void)setSubNum:(long)subNum {
    self.fans = subNum;
}

@end
