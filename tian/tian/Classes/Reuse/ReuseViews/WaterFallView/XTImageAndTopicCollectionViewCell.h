//
//  XTImageAndTopicCollectionViewCell.h
//  tian
//
//  Created by cc on 15/6/9.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTWaterFallPicInfo.h"
@protocol XTImageAndTopicCollectionViewCellDelegate<NSObject>

@optional
- (void)clickCellOfTopicBtn:(NSInteger)clickTopicId;
- (void)clickCellTopImage:(NSInteger)clickRow;


@end

@interface XTImageAndTopicCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *topImageView;
@property (strong, nonatomic) IBOutlet UIButton *topicBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_imageHeight;
@property (weak, nonatomic) id<XTImageAndTopicCollectionViewCellDelegate> delegate;
- (IBAction)clickTopicBtn:(id)sender;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath andWithModel:(XTWaterFallPicInfo *)model;
@end
