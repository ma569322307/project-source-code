//
//  XTPhotosListViewController.h
//  tian
//
//  Created by yyt on 15/7/9.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//图集列表

#import "XTRootViewController.h"
typedef enum {
    XTphotosListLabelType,
    XTPhotosListOtherType,
    XTphotosListspecialType
}XTphotosListType;
@interface XTPhotosListViewController : XTRootViewController
//图集
@property (nonatomic, assign)NSInteger pictureCount;
@property (nonatomic, assign)XTphotosListType type;
@property (nonatomic, assign) NSInteger pictureId;
//标签
@property (nonatomic,copy) NSString *titleString;

@end
