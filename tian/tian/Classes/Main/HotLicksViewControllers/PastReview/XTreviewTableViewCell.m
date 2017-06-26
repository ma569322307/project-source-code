//
//  XTreviewTableViewCell.m
//  tian
//
//  Created by yyt on 15-6-8.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTreviewTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "XTNewsInfo.h"
#import "NSString+TimeReversal.h"
@implementation XTreviewTableViewCell
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
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)configCellWithIndexpath:(NSIndexPath *)indexpath andModel:(XTNewsInfo *)model{
     [self.headImageView an_setImageWithURL:model.cover placeholderImage:nil];
    self.TitleLable.text = [NSString stringWithFormat:@"%@",model.title];
    self.dateCreatedLable.text = [NSString diffTimestampOfPrivateMessageTime:model.dateCreated];
}
@end
