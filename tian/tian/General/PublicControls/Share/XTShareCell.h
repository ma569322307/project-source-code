//
//  XTShareCell.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/10.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTShareModel;
@interface XTShareCell : UICollectionViewCell
@property (nonatomic, strong) XTShareModel *model;
@property (nonatomic, copy) void(^btnBlock)(NSInteger index);
@end
