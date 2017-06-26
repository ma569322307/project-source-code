//
//  XTGeneralMessageTypeOneCell.h
//  tian
//
//  Created by cc on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTMessageInfo;
@protocol XTGeneralMessageTypeOneCellDelegate <NSObject>

@optional
- (void)clickGeneralMessageCellUserAvatarBtnWithIndexRow:(NSInteger)indexpathRow;
- (void)clickGeneralMessageCellImageViewWithindex:(NSInteger)index;
- (void)clickCellTopicBtnWithIndexRow:(NSInteger)indexpathRow;

@end
@interface XTGeneralMessageTypeOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *userAvatarBgView;
@property (weak, nonatomic) IBOutlet UILabel *userCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtnImage;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) id<XTGeneralMessageTypeOneCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *topicBtn;
- (IBAction)clickRightImageBtn:(id)sender;
- (IBAction)clickTopicBtn:(id)sender;
- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath andWithModel:(XTMessageInfo *)model;
@end
