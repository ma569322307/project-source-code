//
//  XTUploadImageStickerInfo.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/24.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUploadImageStickerInfo.h"
#import "JKAssets.h"
#import "XTUploadStickerInfo.h"

@implementation XTUploadImageStickerInfo
-(instancetype)initWithStickersInfo:(NSMutableArray *)stickersInfo andAsset:(JKAssets *)asset{
    if (self = [super init]) {
        self.stickersInfo = stickersInfo;
        self.asset = asset;
    }
    return self;
}
+(instancetype)UploadImageWithAsset:(JKAssets *)asset {
    return [[self alloc] initWithStickersInfo:nil andAsset:asset];
}
@end

