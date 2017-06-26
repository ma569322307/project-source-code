//
//  XTSearchTagCollectionView.h
//  tian
//
//  Created by huhuan on 15/6/11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTSearchTagCollectionView : UICollectionView

@property (nonatomic, copy) NSArray *tagArray;

+ (XTSearchTagCollectionView *)searchTagCollectionView;

@end
