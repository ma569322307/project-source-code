//
//  PhotoListTableViewCell.h
//  tian
//
//  Created by 曹亚云 on 15-5-25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAssets.h"
#import "XTTextNumberControlView.h"
#import "XTLocalPhotoModel.h"
@class PhotoListTableViewCell;
@protocol PhotoListCellDelegate <NSObject>
@optional
- (void)clickPhotoAssetsViewCell:(PhotoListTableViewCell *)assetsCell;
@end

@interface PhotoListTableViewCell : UITableViewCell

@property (nonatomic, strong) JKAssets *asset;
@property (nonatomic, strong) XTLocalPhotoModel *model;
@property (nonatomic, strong) XTTextNumberControlView *photoDesTextView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) id<PhotoListCellDelegate> delegate;

- (void)setPhotoCount:(NSString *)photoCount;
@end
