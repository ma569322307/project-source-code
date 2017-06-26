//
//  XTMessageSetTableViewCell.h
//  StarPicture
//
//  Created by 曹亚云 on 15-3-13.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTMessageSetTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UISwitch *messageSwitch;
@property (nonatomic, strong) UIView *buttomLineView;
@end
