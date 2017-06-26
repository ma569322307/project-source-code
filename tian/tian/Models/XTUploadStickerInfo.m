//
//  XTUploadStickerInfo.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUploadStickerInfo.h"

@implementation XTUploadStickerInfo
-(instancetype)initWithStickerName:(NSString *)stickerName stickerCenter:(CGPoint)center stickerBounds:(CGRect)bounds stickerTransform:(CGAffineTransform)transform andType:(NSNumber *)type{
    if (self = [super init]) {
        self.stickerName = stickerName;
        self.stickerCenter = center;
        self.stickerBounds = bounds;
        self.stickerTransform = transform;
        self.type = type;
    }
    return self;
}

+(instancetype)uploadStickerInfoWithType:(NSNumber *)type withCenter:(CGPoint)center{
    CGRect bounds;
    if (type.integerValue == 1) {
        bounds = CGRectMake(0, 0, 200, 50);
    }else{
        bounds = CGRectMake(0, 0, 100, 100);
    }
    NSString *stickerName = @"upload_stickerSample1";
    return [[self alloc] initWithStickerName:stickerName stickerCenter:center stickerBounds:bounds stickerTransform:CGAffineTransformIdentity andType:type];
}
@end
