//
//  XTPhotoDisplayViewController.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/22.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTRootViewController.h"

@interface XTPhotoDisplayViewController : XTRootViewController
/// 模型数组
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, copy) void(^completionBlock)(NSArray *indexArray);
@property (nonatomic, assign) NSInteger    currentPage;
@end
