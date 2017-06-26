//
//  XTHotSecondTableViewCell.h
//  tian
//
//  Created by yyt on 15-5-29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTCreateTopic.h"
@interface XTHotMyCreateTopicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *cardLable;
@property (weak, nonatomic) IBOutlet UILabel *collectionLable;
-(void)configWithCell:(XTCreateTopic *)model;

@end
