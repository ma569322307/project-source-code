//
//  UploadPhotoViewController.h
//  tian
//
//  Created by 曹亚云 on 15-5-25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTRootViewController.h"
#import "XTAlbumInfo.h"
#define  UpdateSelectedNotification  @"updateSelectedAlbumNotification"
typedef enum {
    XTUploadPhotoTypeDefault = 0,   //普通上传照片
    XTUploadPhotoTypeSureAlbum      //上传照片到固定相册
} XTUploadPhotoType;

@interface UploadPhotoViewController : XTRootViewController
@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (nonatomic, strong) NSMutableDictionary *parameterDic;
@property (nonatomic, strong) NSArray *localPhotoArray;
@property (nonatomic, strong) XTAlbumInfo *albumInfo;
@property (nonatomic, assign) XTUploadPhotoType type;
@end
