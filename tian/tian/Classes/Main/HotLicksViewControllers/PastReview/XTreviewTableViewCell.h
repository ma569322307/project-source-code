//
//  XTreviewTableViewCell.h
//  tian
//
//  Created by yyt on 15-6-8.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTNewsInfo;
@interface XTreviewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *TitleLable;

@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLable;
-(void)configCellWithIndexpath:(NSIndexPath *)indexpath andModel:(XTNewsInfo *)model;
@end
