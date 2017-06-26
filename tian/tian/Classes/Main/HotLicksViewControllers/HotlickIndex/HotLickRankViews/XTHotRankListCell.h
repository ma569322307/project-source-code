//
//  XTHotfourTableViewCell.h
//  tian
//
//  Created by yyt on 15-6-8.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTLickRankingModel;
@interface XTHotRankListCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headPortraitImageView;
@property (nonatomic, strong) UIImageView *VImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIView *separateLineView;
-(void)configWithHotFourTbaleViewCell:(NSIndexPath *)index andmodel:(XTLickRankingModel *)model;
@end
