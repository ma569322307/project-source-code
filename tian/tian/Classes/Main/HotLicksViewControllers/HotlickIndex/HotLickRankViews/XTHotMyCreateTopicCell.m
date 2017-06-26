//
//  XTHotSecondTableViewCell.m
//  tian
//
//  Created by yyt on 15-5-29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHotMyCreateTopicCell.h"

@implementation XTHotMyCreateTopicCell
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configWithCell:(XTCreateTopic *)model{
         [self.headImageView an_setImageWithURL:[NSURL URLWithString:model.image]];
        self.titleLable.text = [NSString stringWithFormat:@"%@(%@)",model.title,@(model.PostCount-model.viewCount)];
    
        self.contentLable.text = model.descrip;
        self.cardLable.text = [NSString stringWithFormat:@"帖子数:%@",@(model.PostCount)];
        self.collectionLable.text = [NSString stringWithFormat:@"收藏:%@",@(model.favoritesCount)];
}

@end
