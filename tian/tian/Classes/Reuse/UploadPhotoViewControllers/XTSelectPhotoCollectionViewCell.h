//
//  XTSelectPhotoCollectionViewCell.h
//  tian
//
//  Created by 曹亚云 on 15-6-27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTSelectPhotoCollectionViewCell;
@protocol XTSelectPhotoCellDelegate <NSObject>
@optional
//- (void)startPhotoAssetsViewCell:(XTSelectPhotoCollectionViewCell *)assetsCell;
- (void)didSelectItemAssetsViewCell:(XTSelectPhotoCollectionViewCell *)assetsCell;
- (void)didDeselectItemAssetsViewCell:(XTSelectPhotoCollectionViewCell *)assetsCell;

@end
@interface XTSelectPhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSURL *asset;
@property (nonatomic, assign) id<XTSelectPhotoCellDelegate> delegate;
@property (nonatomic, assign) BOOL isSelected;
@end
