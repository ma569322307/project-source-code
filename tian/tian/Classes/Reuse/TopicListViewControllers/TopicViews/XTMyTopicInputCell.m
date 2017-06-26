//
//  XTMyTopicInputCell.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTMyTopicInputCell.h"
#import "XTTextNumberControlView.h"

@interface XTMyTopicInputCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation XTMyTopicInputCell

// 设置控制的字数
-(void)setBig:(BOOL)big{
    _big = big;
    // 根据类型判断大小文本
    if (big) {
        self.textView.count = 140;
        // 大文本需要做的事情
        self.textView.placeHolder = @"在饭圈儿，简介和话题更配哦 (200字以内)";
    }else{
        self.textView.count = 10;
        // 小文本需要做的事情
        self.textView.scrollEnabled = NO;
        self.textView.placeHolder = @"从脑洞里贡献点什么吧 (10字以内)";
    }
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textColor = UIColorFromRGB(0x595959);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
