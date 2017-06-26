//
//  XTNotificationMessageCell.h
//  tian
//
//  Created by cc on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//


#import <UIKit/UIKit.h>
@class XTMessageInfo;
@protocol XTNotificationMessageCellDelegate <NSObject>

@optional
- (void)clickNotificationMessageCellUserAvatarBtnWithIndexpathRow:(NSInteger)indexpathRow;
- (void)clickNotificationMessageCellBgViewWithIndexpathRow:(NSInteger)indexpathRow;

@end
@interface XTNotificationMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *userAvatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) id<XTNotificationMessageCellDelegate>delegate;
- (IBAction)clickUserAvatarBtn:(id)sender;
/**
 *   cell数据填充
 */
- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath andWithModel:(XTMessageInfo *)model;
@end
