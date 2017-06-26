//
//  XTUploadStickerInfo.h
//  tian
//
//  Created by Jiajun Zheng on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTUploadStickerInfo : NSObject
// 贴图名称
@property (nonatomic, copy) NSString *stickerName;
// 贴图center
@property (nonatomic, assign) CGPoint stickerCenter;
// 贴图bounds
@property (nonatomic, assign) CGRect stickerBounds;
// 贴图transform
@property (nonatomic, assign) CGAffineTransform stickerTransform;
// 判断是否是快贴
@property (nonatomic, strong) NSNumber *type;

// 快贴属性
// 快贴文字
@property (nonatomic, copy) NSString *stickerLabelText;
// 快贴文字颜色
@property (nonatomic, copy) NSString *textColor;
// 快贴字体

-(instancetype)initWithStickerName:(NSString *)stickerName stickerCenter:(CGPoint)center stickerBounds:(CGRect)bounds stickerTransform:(CGAffineTransform)transform andType:(NSNumber *)type;
+(instancetype)uploadStickerInfoWithType:(NSNumber *)type withCenter:(CGPoint)center;

@end
