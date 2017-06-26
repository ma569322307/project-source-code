//
//  XTHomePageLikeAndHateCollectionView.h
//  tian
//
//  Created by huhuan on 15/6/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTHomePageLikeAndHateCollectionViewCell.h"

typedef NS_ENUM(NSUInteger, XTHomePageLikeAndHateCollectionViewStyle) {
    XTHomePageLikeAndHateCollectionViewStyleLike = 0,
    XTHomePageLikeAndHateCollectionViewStyleHate
};

@interface XTHomePageLikeAndHateCollectionView : UICollectionView

@property (nonatomic, assign) XTHomePageLikeAndHateCollectionViewStyle pageStyle;
@property (nonatomic, assign) XTHomePageLikeAndHateCollectionViewMode pageMode;
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, copy  ) void (^removeAllDataBlock)();

+ (XTHomePageLikeAndHateCollectionView *)likeAndHateCollectionView;

@end
