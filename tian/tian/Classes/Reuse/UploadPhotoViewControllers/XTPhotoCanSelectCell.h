//
//  XTPhotoCanSelectCell.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/21.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKAssets;
@interface XTPhotoCanSelectCell : UICollectionViewCell
@property (nonatomic, strong) JKAssets  *asset;
@property (nonatomic, assign) BOOL displaying;
@end
