//
//  XTSearchAlbumCollectionView.h
//  tian
//
//  Created by huhuan on 15/6/15.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  collection类型：0:横向滚动 1：纵向滚动
 */
typedef NS_ENUM (NSUInteger, XTSearchAlbumCollectionViewStyle) {
    XTSearchAlbumCollectionViewStyleHorizontal = 0,
    XTSearchAlbumCollectionViewStyleVertical
};

@interface XTSearchAlbumCollectionView : UICollectionView

@property (nonatomic, copy) NSArray *albumArray;
@property (nonatomic, copy) void (^pageNum)(NSString *pageNum);

+ (XTSearchAlbumCollectionView *)albumCollectionViewWithCollectionViewStyle:(XTSearchAlbumCollectionViewStyle)style;

@end
