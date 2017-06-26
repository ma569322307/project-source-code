//
//  XTTopicExampleCell.h
//  tian
//
//  Created by yyt on 15/6/23.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTTopicListModel.h"
#import "XTTopicListViewController.h"
@interface XTTopicListCell : UITableViewCell<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *HeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *hotValueLable;
@property (weak, nonatomic) IBOutlet UIButton *FavoritesButton;
@property (nonatomic, assign) NSInteger topicId;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) XTTopicListViewController *topicListViewVC;
- (IBAction)FavoritesButton:(UIButton *)sender and:(NSIndexPath*)index;
- (void)configWithTopicCell:(XTTopicListModel *)model;
@end
