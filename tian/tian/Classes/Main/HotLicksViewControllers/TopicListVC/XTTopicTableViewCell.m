//
//  XTPublishTableViewCell.m
//  tian
//
//  Created by yyt on 15-6-11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTopicTableViewCell.h"
#import "XTHotLicksTopicsInfo.h"
#import "XTCreateTopic.h"
@interface XTTopicTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userheadImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardLable;

@end

@implementation XTTopicTableViewCell
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xd2d2d2).CGColor);
    CGContextSetLineWidth(context, 0.5f);
    
    CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(context);
}

- (void)awakeFromNib {
    // Initialization code
    self.userheadImageView.layer.masksToBounds = YES;
    self.userheadImageView.layer.cornerRadius = 11.0f;
}

- (void)configureTopicCell:(MTLModel *)topicModel {
    if([topicModel isKindOfClass:[XTHotLicksTopicsInfo class]]) {
        XTHotLicksTopicsInfo *hotlicksTopicInfo = (XTHotLicksTopicsInfo *)topicModel;
        [self.headImageView an_setImageWithURL:[NSURL URLWithString:hotlicksTopicInfo.headImg]];
        self.titleLabel.text = [NSString stringWithFormat:@"%@",hotlicksTopicInfo.title];
        self.contentLabel.text = hotlicksTopicInfo.topicDescription;
        self.nicknameLabel.text = hotlicksTopicInfo.userName;
        self.cardLable.text = [NSString stringWithFormat:@"%ld",hotlicksTopicInfo.viewCount];
        
    }else if([topicModel isKindOfClass:[XTCreateTopic class]]) {
        XTCreateTopic *createTopic = (XTCreateTopic *)topicModel;
        [self.headImageView an_setImageWithURL:[NSURL URLWithString:createTopic.image]];
        self.titleLabel.text = createTopic.title;
        self.contentLabel.text = createTopic.descrip;
        self.nicknameLabel.text = createTopic.nickName;
        self.cardLable.text = [NSString stringWithFormat:@"%ld",createTopic.viewCount];
        
        [self.userheadImageView an_setImageWithURL:[NSURL URLWithString:createTopic.smallAvatar]];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
