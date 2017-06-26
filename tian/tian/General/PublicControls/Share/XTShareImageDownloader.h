//
//  XTShareImageDownloader.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/11.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTShareImageDownloader : NSObject
/// 单例创建
+(instancetype)XTShareImageDownloaderManage;
+(void)downloadShareImage;
+(UIImage *)shareImage;
@end
