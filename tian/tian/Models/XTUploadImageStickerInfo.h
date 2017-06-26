//
//  XTUploadImageStickerInfo.h
//  tian
//
//  Created by Jiajun Zheng on 15/6/24.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JKAssets;
@interface XTUploadImageStickerInfo : NSObject
// 哪个贴图属性（等增加了具体贴图增加）
@property (nonatomic, strong) JKAssets *asset;
@property (nonatomic, strong) NSMutableArray *stickersInfo;

-(instancetype)initWithStickersInfo:(NSMutableArray *)stickersInfo andAsset:(JKAssets *)asset;
+(instancetype)UploadImageWithAsset:(JKAssets *)asset;
@end
