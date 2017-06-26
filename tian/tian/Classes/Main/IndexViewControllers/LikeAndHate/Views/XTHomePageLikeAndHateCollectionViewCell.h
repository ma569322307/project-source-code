//
//  XTHomePageLikeAndHateCollectionViewCell.h
//  tian
//
//  Created by huhuan on 15/6/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTOrderArtist;

typedef NS_ENUM(NSUInteger, XTHomePageLikeAndHateCollectionViewMode) {
    XTHomePageLikeAndHateCollectionViewModeNormal = 0,
    XTHomePageLikeAndHateCollectionViewModeEdit
};

@interface XTHomePageLikeAndHateCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void (^removeClickBlock)(XTOrderArtist *artist, NSIndexPath *indexPath);

- (void)configureUserCell:(XTOrderArtist *)artist andCellMode:(XTHomePageLikeAndHateCollectionViewMode)cellMode andIndexPath:(NSIndexPath *)indexPath;

@end
