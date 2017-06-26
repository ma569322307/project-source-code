//
//  AddPhotoViewController.h
//  tian
//
//  Created by 曹亚云 on 15-5-25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTRootViewController.h"
#import "UploadPhotoViewController.h"
#define kStickersInfoSaveNotifiacation @"StickersInfoSaveNotifiacation"
@interface AddPhotoViewController : XTRootViewController
@property (nonatomic, strong) NSMutableArray *assetsArray;
// 当前修改的图片索引
@property (nonatomic, assign) NSInteger imageIndexForNow;
// 判断从哪里过来
@property (nonatomic, assign,getter=isNeedPop) BOOL needPop;
// 数组模型
@property (nonatomic, strong) NSArray *oldInfo;
// 旧的图片数组
@property (nonatomic, strong) NSArray *oldAssertsArray;
//从图册跳转
@property (nonatomic, assign) XTUploadPhotoType type;
//相册信息
@property (nonatomic, strong) XTAlbumInfo *albumInfo;
//已选数目
@property (nonatomic, assign) NSUInteger alreadySelectedNumber;
//已选数组
@property (nonatomic, strong) NSMutableArray     *selectedAssetIndexArray;
// 最新数据
@property (nonatomic, copy) void(^backBlock)(NSMutableArray *selectedAssetArray, NSMutableArray *selectedAssetIndexArray);
@property (nonatomic, strong) NSArray *nameArray;
-(NSArray *)photoNameArray;
-(void)storePhotoImagesWithNameSet:(NSSet *)nameSet withCompeletionBlock:(void(^)())compeletionBlock;
@end
