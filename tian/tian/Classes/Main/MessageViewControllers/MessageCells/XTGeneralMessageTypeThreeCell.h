//
//  XTGeneralMessageTypeThreeCell.h
//  tian
//
//  Created by cc on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTMessageInfo;
@protocol XTGeneralMessageTypeThreeCellDelegate <NSObject>

@optional
- (void)clickXTGeneralMessageTypeThreeCellUserAvatarBtnWithIndexpathRow:(NSInteger)indexpathRow;
- (void)clickXTGeneralMessageTypeThreeCellRightImageViewBtnWithIndexpathRow:(NSInteger)indexpathRow;

@end

@interface XTGeneralMessageTypeThreeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *userAvatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *topContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) id<XTGeneralMessageTypeThreeCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *VuserImageView;
- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath andWithModel:(XTMessageInfo *)model;
- (IBAction)clickUserAvatarBtn:(id)sender;
- (IBAction)clickRightImageViewBtn:(id)sender;

@end
