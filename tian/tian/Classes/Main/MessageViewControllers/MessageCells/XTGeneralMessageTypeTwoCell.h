//
//  XTGeneralMessageTypeTwoCell.h
//  tian
//
//  Created by cc on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTMessageInfo;
@protocol XTGeneralMessageTypeTwoCellDelegate <NSObject>

@optional
- (void)clickGeneralMessageTypeTwoCellUserAvatarBtnWithIndexpthRow:(NSInteger)indexpthRow;
- (void)clickGeneralMessageTypeTwoCellCommentBtnWithIndexpthRow:(NSInteger)indexpthRow;
- (void)clickGeneralMessageTypeTwoCellRightImageViewBtnWithIndexpthRow:(NSInteger)indexpthRow;
- (void)clickGeneralMessageTypeTwoCellTopicBtnWithIndexpthRow:(NSInteger)indexpthRow;

@end
@interface XTGeneralMessageTypeTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *userAvatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cteatTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *imgCountLabel;
@property (weak, nonatomic) id<XTGeneralMessageTypeTwoCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *topicBtn;
@property (weak, nonatomic) IBOutlet UIImageView *VuserImageView;
- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath andWithModel:(XTMessageInfo *)model;

- (IBAction)clickTopicBtn:(id)sender;

- (IBAction)clickUserAvatarBtn:(id)sender;
- (IBAction)clickCommentBtn:(id)sender;
- (IBAction)clickRightImageViewBtn:(id)sender;

@end
