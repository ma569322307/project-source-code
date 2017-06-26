//
//  XTSpecificArtistRelateCollectionView.h
//  tian
//
//  Created by huhuan on 15/7/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTSpecificArtistRelateCollectionView : UICollectionView

@property (nonatomic, copy) NSArray *artistArray;
@property (nonatomic, copy) void (^pageNum)(NSString *pageNum);

+ (XTSpecificArtistRelateCollectionView *)specificArtistRelateCollectionView;
@end
