//
//  XTTopicWithUserHeaderTableViewCell.m
//  tian
//
//  Created by yyt on 15-5-29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTopicWithUserHeaderTableViewCell.h"
#import "XTCreateTopic.h"
#import "XTHotLicksTopicsInfo.h"

@implementation XTTopicWithUserHeaderTableViewCell
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
    [self layoutIfNeeded];
    [self.headImage layoutIfNeeded];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = self.headImage.frame.size.width/2.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configWithCell:(MTLModel *)topicModel{
    
    int i = arc4random() % 6+1 ;
    NSString *placeholderImageName = [NSString stringWithFormat:@"placeholderImage%@",@(i)];
    if([topicModel isKindOfClass:[XTCreateTopic class]]) {
        
        XTCreateTopic *creatTopicModel = (XTCreateTopic *)topicModel;
        
        [self.image an_setImageWithURL:[NSURL URLWithString:creatTopicModel.image] placeholderImage:[UIImage imageNamed:placeholderImageName]];
        
        self.titleLable.text           =  [NSString stringWithFormat:@"%@(%@)",creatTopicModel.title,@(creatTopicModel.PostCount - creatTopicModel.viewCount)];
        
        self.descriptionlable.text     = creatTopicModel.descrip;
        self.nickNameLable.text = [creatTopicModel.user objectForKey:@"nickName"];
        [self.headImage an_setImageWithURL:[NSURL URLWithString:[creatTopicModel.user objectForKey:@"smallAvatar"]] placeholderImage:nil];
        
    }else if ([topicModel isKindOfClass:[XTHotLicksTopicsInfo class]]) {
        XTHotLicksTopicsInfo *hotTopicModel = (XTHotLicksTopicsInfo *)topicModel;
        [self.image an_setImageWithURL:[NSURL URLWithString:hotTopicModel.headImg] placeholderImage:[UIImage imageNamed:placeholderImageName]];
        self.titleLable.text           = hotTopicModel.title;
        self.descriptionlable.text     = hotTopicModel.topicDescription;
        self.nickNameLable.text        = hotTopicModel.userName;
        [self.headImage an_setImageWithURL:[NSURL URLWithString:hotTopicModel.userHeadImg] placeholderImage:nil];
    }
}

@end
