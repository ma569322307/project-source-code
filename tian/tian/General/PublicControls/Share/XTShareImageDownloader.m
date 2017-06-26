//
//  XTShareImageDownloader.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/11.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTShareImageDownloader.h"
#import <SDWebImagePrefetcher.h>
#define kShareImageURL @"http://img2.yytcdn.com/img/artistApp/150710/0/-M-bc51c4c4bd39ecc70f2098cb3981a445_0x0.jpg"
@implementation XTShareImageDownloader
/// 单例创建
+(instancetype)XTShareImageDownloaderManage{
    static XTShareImageDownloader *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[self alloc] init];
    });
    return _shareManager;
}
+(void)downloadShareImage{
    NSURL *url = [NSURL URLWithString:kShareImageURL];
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:@[url] progress:nil completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
        NSLog(@"预先获取图片完成");
    }];
}
+(UIImage *)shareImage{
    return [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:kShareImageURL];
}
@end
