//
//  XTImageAnderUserAvatarCollectionViewCell.h
//  tian
//
//  Created by cc on 15/6/10.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTWaterFallPicInfo;

@protocol XTImageAnderUserAvatarCollectionViewCellDelegate<NSObject>

@optional
- (void)clickImgAndUserCellUserAvatarBtn:(NSInteger)clickUserId;

@end

@interface XTImageAnderUserAvatarCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIButton *userAvatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_TopImageViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) id<XTImageAnderUserAvatarCollectionViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countLabel_layout;
- (IBAction)clickUserAvatarBtn:(id)sender;
- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath andWithModel:(XTWaterFallPicInfo *)model;
@end
