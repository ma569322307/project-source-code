//
//  XTEditUserInfoViewController.h
//  tian
//
//  Created by 曹亚云 on 15-7-1.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"
#import "XTTextNumberControlView.h"
#import "XTUserFilesInfo.h"
#define EditUserInfoNotification @"EditUserInfoNotification"
typedef enum {
    XTEditUserInfoTypeNickname = 0,      //编辑呢称
    XTEditUserInfoTypeBrief,             //编辑签名
    XTEditUserInfoTypeBeiZhu,            //编辑相册描述
    XTEditAlbumTypeDes,
    XTEditAlbumTypeName
} XTEditUserInfoType;

@interface XTEditUserInfoViewController : XTRootViewController
@property (nonatomic, strong) XTUserFilesInfo *userFilesInfo;
@property (nonatomic, strong) NSMutableArray *beiZhuArray;
@property (nonatomic, strong) XTTextNumberControlView *textView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) NSString *placeHolderText;
@property (nonatomic, assign) XTEditUserInfoType type;
@property (nonatomic, assign) NSInteger index;
@end
