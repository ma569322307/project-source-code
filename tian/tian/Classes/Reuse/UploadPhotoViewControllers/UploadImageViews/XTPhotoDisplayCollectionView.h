//
//  XTPhotoDisplayCollectionView.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/22.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTPhotoDisplayCollectionView : UICollectionView
+(instancetype)photoDisplayCollectionViewCreateView;
@property (nonatomic, strong) NSArray *photos;
@end
