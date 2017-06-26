//
//  XTNewAlbumViewController.h
//  tian
//
//  Created by 曹亚云 on 15-6-25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"
#import "XTAlbumInfo.h"
typedef enum {
    XTAlbumChangeTypeNew = 0,   //新建相册
    XTAlbumChangeTypeEdit       //编辑相册
} XTAlbumChangeType;

@interface XTNewAlbumViewController : XTRootViewController
@property (nonatomic, strong) NSDictionary *parameterDic;
@property (nonatomic, strong) XTAlbumInfo *albumInfo;
@property (nonatomic, assign) long albumID;
@property (nonatomic, assign) XTAlbumChangeType type;
@end
