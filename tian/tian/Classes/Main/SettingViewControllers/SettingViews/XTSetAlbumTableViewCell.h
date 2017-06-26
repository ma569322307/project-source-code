//
//  XTSetAlbumTableViewCell.h
//  tian
//
//  Created by 曹亚云 on 15-6-30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTSetAlbumTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *messageSwitch;
@property (nonatomic, strong) UIView *buttomLineView;
@property (nonatomic, copy) void(^switchBlock)();
@end
