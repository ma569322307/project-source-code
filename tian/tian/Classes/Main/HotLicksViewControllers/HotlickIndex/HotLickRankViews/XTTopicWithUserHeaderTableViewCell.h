//
//  XTTopicWithUserHeaderTableViewCell.h
//  tian
//
//  Created by yyt on 15-5-29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTLModel.h"
@interface XTTopicWithUserHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *descriptionlable;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLable;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
-(void)configWithCell:(MTLModel *)topicModel;

@end
