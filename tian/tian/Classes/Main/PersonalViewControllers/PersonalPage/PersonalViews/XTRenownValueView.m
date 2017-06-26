//
//  XTRenownValueView.m
//  tian
//
//  Created by 曹亚云 on 15-5-13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRenownValueView.h"
#import "XTUserAccountInfo.h"
static UIEdgeInsets const kPadding = {0, 0, 10, 10};

@interface XTRenownValueView ()
@property (nonatomic, assign) XTUserRenownValueType type;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIProgressView *levelProgressView;
@property (nonatomic, strong) UILabel *levelLabel;
@end

@implementation XTRenownValueView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithType:(XTUserRenownValueType)type
{
    self = [super init];
    if (self) {
        switch (type) {
            case XTUserRenownValueTypeHis:{
                self.type = XTUserRenownValueTypeHis;
                [self createHisSubviews];
            }
                break;
            default:{
                self.type = XTUserRenownValueTypeMine;
                [self createMineSubviews];
            }
                break;
        }
    }
    return self;
}

- (void)createMineSubviews
{
    self.nameLabel = [UILabel new];
    //_nameLabel.backgroundColor = [UIColor blackColor];
    _nameLabel.text = @"声望值:";
    _nameLabel.font = [UIFont systemFontOfSize:10];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.numberOfLines = 1;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_nameLabel];
    
    self.valueLabel = [UILabel new];
    //_valueLabel.backgroundColor = [UIColor blackColor];
    _valueLabel.text = @"121121";
    _valueLabel.font = [UIFont boldSystemFontOfSize:12];
    _valueLabel.textColor = [UIColor whiteColor];
    _valueLabel.numberOfLines = 1;
    _valueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_valueLabel];
    
    self.levelProgressView = [UIProgressView new];
    _levelProgressView.progressTintColor = [UIColor colorWithRed:255/255.0 green:222/255.0 blue:20/255.0 alpha:1.0];
    _levelProgressView.trackTintColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    _levelProgressView.layer.cornerRadius = 3;
    _levelProgressView.layer.masksToBounds = YES;
    [_levelProgressView setProgress:0.5f];
    [self addSubview:_levelProgressView];
    
    self.levelLabel = [UILabel new];
    //_levelLabel.backgroundColor = [UIColor blackColor];
    _levelLabel.text = @"lv7/lv8";
    _levelLabel.font = [UIFont boldSystemFontOfSize:9];
    _levelLabel.textColor = [UIColor whiteColor];
    _levelLabel.numberOfLines = 1;
    _levelLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_levelLabel];
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).insets(kPadding);
        make.top.equalTo(self.top).offset(@5);
    }];
    
    [_valueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.centerY);
        make.left.equalTo(self.nameLabel.right);
    }];
    
    [_levelProgressView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).insets(kPadding);
        make.top.equalTo(self.nameLabel.bottom).offset(@6);
        make.size.equalTo(CGSizeMake(40, 5));
    }];
    
    [_levelLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.levelProgressView.centerY);
        make.left.equalTo(self.levelProgressView.right).offset(@5);
    }];
}

- (void)createHisSubviews
{
    self.nameLabel = [UILabel new];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.text = @"声望值:";
    _nameLabel.font = [UIFont systemFontOfSize:10];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.numberOfLines = 1;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_nameLabel];
    
    self.valueLabel = [UILabel new];
    //_valueLabel.backgroundColor = [UIColor blackColor];
    _valueLabel.text = @"121121";
    _valueLabel.font = [UIFont boldSystemFontOfSize:12];
    _valueLabel.textColor = [UIColor whiteColor];
    _valueLabel.numberOfLines = 1;
    _valueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_valueLabel];
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).insets(kPadding);
        make.centerY.equalTo(self);
    }];
    
    [_valueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.centerY);
        make.left.equalTo(self.nameLabel.right);
    }];
}

- (void)fillUesrInformation:(XTUserAccountInfo *)user{
    switch (self.type) {
        case XTUserRenownValueTypeHis:{
            self.valueLabel.text = user.renownCount;
        }
            break;
        default:{
            self.valueLabel.text = user.renownCount;
            [self.levelProgressView setProgress:[user.percentage floatValue]/100];
            self.levelLabel.text = [NSString stringWithFormat:@"lv%@/lv%d",user.level,[user.level intValue]+1,nil];
        }
            break;
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // for multiline UILabel's you need set the preferredMaxLayoutWidth
    // you need to do this after [super layoutSubviews] as the frames will have a value from Auto Layout at this point
    
    // stay tuned for new easier way todo this coming soon to Masonry
    
    CGFloat width = CGRectGetMinX(self.valueLabel.frame) - kPadding.left;
    width -= CGRectGetMinX(self.nameLabel.frame);
    self.nameLabel.preferredMaxLayoutWidth = width;
    
    // need to layoutSubviews again as frames need to recalculated with preferredLayoutWidth
    [super layoutSubviews];
}

@end
