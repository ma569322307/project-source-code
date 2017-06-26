//
//  XTSearchTagTableViewCell.m
//  tian
//
//  Created by huhuan on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchTagTableViewCell.h"
#import "XTTagInfo.h"

@interface XTSearchTagTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;

@end

@implementation XTSearchTagTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureTagCell:(XTTagInfo *)tagModel {
    self.nameLabel.text = tagModel.tag;
    self.countLabel.text = [NSString stringWithFormat:@"%@张",@(tagModel.picCount)];
}

@end
