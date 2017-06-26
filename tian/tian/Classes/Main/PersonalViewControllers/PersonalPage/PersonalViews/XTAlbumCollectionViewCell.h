//
//  XTAlbumCollectionViewCell.h
//  tian
//
//  Created by 曹亚云 on 15-6-5.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTAlbumCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *firstCoverImageView;
@property (nonatomic, strong) UIImageView *secondCoverImageView;
@property (nonatomic, strong) UIImageView *thirdCoverImageView;
@property (nonatomic, strong) UIImageView *fourthCoverImageView;
@property (nonatomic, strong) UIImageView *fifthCoverImageView;
@property (nonatomic, strong) UILabel *albumNameLabel;
@property (nonatomic, strong) UILabel *imageCountLabel;
@property (nonatomic, strong) UILabel *albumCreateDateLabel;
@property (nonatomic, strong) UIImageView *secretIconImageView;

@end
