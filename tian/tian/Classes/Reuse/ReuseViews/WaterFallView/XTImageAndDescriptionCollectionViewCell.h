//
//  XTImageAndDescriptionCollectionViewCell.h
//  tian
//
//  Created by cc on 15/6/10.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHTransitionProtocol.h"

@class XTImageInfo;

@protocol XTImageAndDescriptionCollectionViewCellDelegate<NSObject>

@optional
- (void)clickCellTopImage:(NSInteger)clickRow;


@end

@interface XTImageAndDescriptionCollectionViewCell : UICollectionViewCell<XHTansitionWaterfallGridViewProtocol>
@property (strong, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeHeight;
//描述视图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeight;
//描述
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
//评论
@property (strong, nonatomic) IBOutlet UILabel *commentCountLabel;
//喜欢
@property (strong, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_topImageHeight;
@property (weak, nonatomic) IBOutlet UIImageView *fancyIconImage;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *likeBgView;
@property (weak, nonatomic) IBOutlet UIImageView *commentImg;
@property (weak, nonatomic) IBOutlet UIImageView *likeImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countLabel_layout;

@property (weak, nonatomic) id<XTImageAndDescriptionCollectionViewCellDelegate> delegate;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath andWithModel:(XTImageInfo *)model;
@end
