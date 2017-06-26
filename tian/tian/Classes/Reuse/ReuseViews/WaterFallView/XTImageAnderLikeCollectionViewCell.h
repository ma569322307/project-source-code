//
//  XTImageAnderLikeCollectionViewCell.h
//  tian
//
//  Created by cc on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ImageAnderLikeCollectionViewCellType) {
    ImageAnderLikeCollectionView_LikeCellType,
    ImageAnderLikeCollectionView_CollectionCellType,
};
@class XTImageInfo;
@interface XTImageAnderLikeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftIconImageV;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_imageHeight;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath andWithModel:(XTImageInfo *)model withCellType:(ImageAnderLikeCollectionViewCellType)type;
@end
