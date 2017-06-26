//
//  XTPrivateMessageListCell.m
//  tian
//
//  Created by cc on 15/7/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTPrivateMessageListCell.h"
#import "NSString+TimeReversal.h"
@implementation XTPrivateMessageListCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.whiteBgView = [UIView new];
        self.whiteBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.whiteBgView];
        [self.whiteBgView makeConstraints:^(MASConstraintMaker *make) {
           
        }];
        
        self.userAvatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.userAvatarBtn.backgroundColor = [UIColor grayColor];
        [self.userAvatarBtn addTarget:self action:@selector(clickUserAvatar:) forControlEvents:UIControlEventTouchUpInside];
        self.userNameLabel.clipsToBounds = YES;
        self.userNameLabel.layer.cornerRadius = 22.5;
        [self.whiteBgView addSubview:self.userAvatarBtn];
        [self.userAvatarBtn makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        self.userNameLabel = [UILabel new];
        self.userNameLabel.backgroundColor = [UIColor clearColor];
        self.userNameLabel.font = [UIFont boldSystemFontOfSize:12];
        self.userNameLabel.textColor = UIColorFromRGB(0x595959);
        [self.whiteBgView addSubview:self.userNameLabel];
        [self.userNameLabel makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        self.timeLabel = [UILabel new];
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel.textColor = UIColorFromRGB(0x7b7b7b);
        self.timeLabel.backgroundColor = [UIColor clearColor];
        [self.whiteBgView addSubview:self.timeLabel];
        [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        self.messagelabel = [UILabel new];
        self.messagelabel.backgroundColor = [UIColor clearColor];
        self.messagelabel.font = [UIFont systemFontOfSize:12];
        self.messagelabel.textColor = UIColorFromRGB(0x7b7b7b);
        [self.whiteBgView addSubview:self.messagelabel];
        [self.messagelabel makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        self.unReadCountLabel = [UILabel new];
        self.unReadCountLabel.backgroundColor = [UIColor redColor];
        self.unReadCountLabel.font = [UIFont systemFontOfSize:9];
        self.unReadCountLabel.textColor = [UIColor whiteColor];
        self.unReadCountLabel.clipsToBounds = YES;
        self.unReadCountLabel.layer.cornerRadius = 2;
        [self.whiteBgView addSubview:self.unReadCountLabel];
        [self.unReadCountLabel makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        
        
    }
    return self;
}

- (void)clickUserAvatar:(UIButton *)sender
{
    CLog(@"click userAvatar tag = %zd",sender.tag);
}
- (void)configureCellWithIndexPath:(NSInteger)indexPathRow
{
    self.userAvatarBtn.tag = indexPathRow;
    [self.userAvatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.model.lastestMessage.senderUserInfo.portraitUri] forState:UIControlStateNormal];
    self.userNameLabel.text = self.model.lastestMessage.senderUserInfo.name;
    self.timeLabel.text = [NSString diffTimestampOfPrivateMessageTime:self.model.receivedTime];
    self.messagelabel.text = self.model.objectName;
    if (self.model.unreadMessageCount>0) {
        self.unReadCountLabel.hidden = NO;
        self.unReadCountLabel.text = [NSString stringWithFormat:@"%zd",self.model.unreadMessageCount];
    }else
    {
        self.unReadCountLabel.hidden = YES;
    }
}
@end
