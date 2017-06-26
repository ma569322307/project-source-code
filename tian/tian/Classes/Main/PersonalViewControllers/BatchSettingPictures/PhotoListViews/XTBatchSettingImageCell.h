//
//  XTBatchSettingImageCell.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/14.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTPictureInfoModel;
@interface XTBatchSettingImageCell : UICollectionViewCell
@property (nonatomic, strong) NSString *image;
@property (nonatomic, assign,getter=isNeedButton) BOOL needButton;
///选择按钮
@property (nonatomic, strong) UIButton *selectButton;
///模型
@property (nonatomic, strong) XTPictureInfoModel *model;
@end
