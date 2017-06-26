//
//  XTImgSetViewController.h
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"
@class XTAlbumInfo;
typedef NS_ENUM(NSUInteger, XTImgDetailViewControllerType) {
    XTImgDetailViewControllerTypeDefault = 0,
    XTImgDetailViewControllerTypeMine,
    
};


@interface XTImgDetailViewController : XTRootViewController

@property(nonatomic,strong)NSArray *pidArr;

@property(nonatomic)NSInteger curIndex;

@property(nonatomic,strong)NSDictionary *commentInfo;

@property(nonatomic)XTImgDetailViewControllerType fromType;

@property(nonatomic,strong)XTAlbumInfo *albumInfo;

@property(nonatomic,strong)NSURL *placeholderImageURL;

@end
