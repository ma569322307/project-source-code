//
//  XTImageInfo.m
//  tian
//
//  Created by cc on 15/6/9.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTImageInfo.h"

@interface XTImageInfo ()
//兼容字段
@property (nonatomic, strong) NSURL *cover;
@property (nonatomic, strong) NSURL *image;
@property (nonatomic, assign) NSInteger picCount;
@property (nonatomic, strong) NSURL *thumbnailPic;

@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *comments;
@property (nonatomic, strong) NSString *likes;
@end

@implementation XTImageInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}


//- (void)setThumbnailPic:(NSURL *)thumbnailPic
//{
//    _url = thumbnailPic;
//}
//string类型转换成NSURL
+ (NSValueTransformer *)picUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)urlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)coverJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)imageJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)commendCountJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *commendCount) {
        return [commendCount stringValue];
    }];
}

+ (NSValueTransformer *)commentCountJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *commentCount) {
        return [commentCount stringValue];
    }];
}

+ (NSValueTransformer *)commentsJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *comments) {
        return [comments stringValue];
    }];
}

+ (NSValueTransformer *)likesJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber *likes) {
        return [likes stringValue];
    }];
}

+ (NSValueTransformer *)thumbnailPicJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)middlePicJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (void)setImage:(NSURL *)image {
    if (image) {
        _url = image;
    }
}

- (void)setCover:(NSURL *)cover {
    if ([[cover absoluteString] hasPrefix:@"http://"]) {
        _url = cover;
    }
}

- (void)setPicCount:(NSInteger)picCount {
    self.imgCount = picCount;
}

- (void)setThumbnailPic:(NSURL *)thumbnailPic {
    if (thumbnailPic) {
        _url = thumbnailPic;
    }
}

- (void)setPicUrl:(NSURL *)picUrl {
    if(picUrl) {
        _url = picUrl;
    }
}

- (void)setDesc:(NSString *)desc {
    self.text = desc;
}

- (void)setLikes:(NSString *)likes {
    self.commendCount = likes;
}

- (void)setComments:(NSString *)comments {
    self.commentCount = comments;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{


}
@end
