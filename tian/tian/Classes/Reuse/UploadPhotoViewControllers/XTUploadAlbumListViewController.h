//
//  XTUploadAlbumListViewController.h
//  tian
//
//  Created by 曹亚云 on 15-6-24.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"
typedef enum {
    XTAlbumListTypeUpload = 0,   //新建相册
    XTAlbumListTypeMove          //编辑相册
} XTAlbumListType;

@interface XTUploadAlbumListViewController : XTRootViewController
@property (nonatomic, assign) XTAlbumListType type;
@end
