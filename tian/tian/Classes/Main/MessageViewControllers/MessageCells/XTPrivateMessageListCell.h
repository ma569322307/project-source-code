//
//  XTPrivateMessageListCell.h
//  tian
//
//  Created by cc on 15/7/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface XTPrivateMessageListCell : RCConversationBaseCell

@property (nonatomic, strong) UIView *whiteBgView;
@property (nonatomic, strong) UIButton *userAvatarBtn;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *messagelabel;
@property (nonatomic, strong) UILabel *unReadCountLabel;
- (void)configureCellWithIndexPath:(NSInteger)indexPathRow;
@end
