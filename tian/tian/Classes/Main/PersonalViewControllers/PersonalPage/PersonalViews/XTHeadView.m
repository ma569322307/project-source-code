//
//  XTHeadView.m
//  tian
//
//  Created by 曹亚云 on 15-5-14.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHeadView.h"
#import "XTHeadPortraitView.h"
#import "XTRenownValueView.h"
#import "XTSignInView.h"
#import "XTActionBar.h"
#import "XTUserAccountInfo.h"
#import "UIView+JKPicker.h"
#import "XTNoHighLightedButton.h"
static UIEdgeInsets const kPadding = {10, 10, 10, 10};

@interface XTHeadView ()<XTActionBarDelegate>
@property (nonatomic, strong) UILabel *levelNameLabel;
@property (nonatomic, strong) XTRenownValueView *renownValueView;
@property (nonatomic, strong) XTSignInView *signInView;
@property (nonatomic, strong) UILabel *signatureLabel;
@property (nonatomic, strong) XTActionBar *titleActionBar;
@end

@implementation XTHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithType:(XTUserHeadViewType)type
{
    self = [super init];
    if (self) {
        switch (type) {
            case XTUserHeadViewTypeHis:{
                [self createHisSubviews];
            }
                break;
            default:{
                [self createMineSubviews];
            }
                break;
        }
    }
    return self;
}

- (void)createMineSubviews
{
    self.headPortraitView = [XTHeadPortraitView new];
    [self addSubview:_headPortraitView];
    
    self.levelNameLabel = [UILabel new];
    //_levelNameLabel.backgroundColor = [UIColor blackColor];
    _levelNameLabel.text = @"小透明";
    _levelNameLabel.font = [UIFont systemFontOfSize:10];
    _levelNameLabel.textColor = [UIColor whiteColor];
    _levelNameLabel.numberOfLines = 1;
    _levelNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_levelNameLabel];
    
    self.renownValueView = [[XTRenownValueView alloc] initWithType:XTUserRenownValueTypeMine];
    //_renownValueView.backgroundColor = [UIColor redColor];
    [self addSubview:_renownValueView];
    
    self.signInView = [XTSignInView new];
    //_signInView.backgroundColor = [UIColor redColor];
    [_signInView.signInButton addTarget:self action:@selector(clickSignIn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_signInView];
    
    self.signatureLabel = [UILabel new];
    //_signatureLabel.backgroundColor = [UIColor blackColor];
    _signatureLabel.text = @"5月14日至19日，印度总理莫迪将对中国、蒙古和韩国进行访问。不过此次莫迪出访还有一个小插曲。按照原计划他是先访问韩国，之后再访问中国和蒙古。但后来，莫迪决定把中国作为出访的第一站，而且在中国停留时间最长，为期三天。";
    _signatureLabel.font = [UIFont systemFontOfSize:12];
    _signatureLabel.textColor = [UIColor whiteColor];
    _signatureLabel.numberOfLines = 2;
    _signatureLabel.textAlignment = NSTextAlignmentCenter;
    _signatureLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_signatureLabel];

    self.titleActionBar = [XTActionBar new];
    _titleActionBar.backgroundColor = [UIColor clearColor];
    _titleActionBar.delegate = self;
    _titleActionBar.type = XTActionBarTitleType;
    _titleActionBar.titleColor = ABACTIONBAR_DEFAULT_TITLECOLOR;
    _titleActionBar.titleFont = ABACTIONBAR_DEFAULT_TITLEFONT;
    _titleActionBar.titleSpecialFont = ABACTIONBAR_DEFAULT_S_TITLEFONT;
    _titleActionBar.titleSpecialColor = ABACTIONBAR_DEFAULT_S_TITLECOLOR;
    _titleActionBar.topBorderColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    _titleActionBar.titleItems = @[@"`1240/1220`\n粉丝/关注", @"`3220/1240`\n喜欢/嫌弃", @"`1210/7890`\n点赞/收藏"];
    [self addSubview:_titleActionBar];
    
    [self.headPortraitView makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.top.equalTo(@64);
        make.height.equalTo(@125);
    }];
    
    [self.levelNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headPortraitView.bottom).offset(@5);
        make.height.equalTo(@15);
        make.centerX.equalTo(self.centerX);
    }];

    [self.renownValueView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.levelNameLabel.bottom).offset(@5);
        make.right.equalTo(_headPortraitView.centerX);
        make.width.equalTo(@80);
        make.height.equalTo(@35);
    }];
    
    [self.signInView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_renownValueView.centerY);
        make.left.equalTo(_renownValueView.right);
        make.width.equalTo(@70);
        make.height.equalTo(_renownValueView.height);
    }];
    
    [self.signatureLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_renownValueView.bottom).offset(@5);
        make.left.and.right.equalTo(self).insets(kPadding);
        make.height.equalTo(@35);
    }];

    [self.titleActionBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_signatureLabel.bottom).offset(@5);
        make.left.right.equalTo(self);
        make.height.equalTo(@60);
    }];
}

+ (CGFloat)calculateViewHeight:(XTUserHeadViewType)type{
    CGFloat height = 0;
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:10]};
//    CGSize size = [_signatureLabel.text boundingRectWithSize:CGSizeMake(355, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    if (type == XTUserHeadViewTypeMine) {
        height = 290.0 + 64.0;
    }else if (type == XTUserHeadViewTypeHis){
        height = 247.0 + 64.0;
    }
    
    return height;
}

- (void)createHisSubviews
{
    self.headPortraitView = [XTHeadPortraitView new];
    [self addSubview:_headPortraitView];
    
    self.levelNameLabel = [UILabel new];
    _levelNameLabel.backgroundColor = [UIColor clearColor];
    _levelNameLabel.text = @"小透明";
    _levelNameLabel.font = [UIFont systemFontOfSize:10];
    _levelNameLabel.textColor = [UIColor whiteColor];
    _levelNameLabel.numberOfLines = 1;
    _levelNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_levelNameLabel];
    
    self.renownValueView = [[XTRenownValueView alloc] initWithType:XTUserRenownValueTypeHis];
    _renownValueView.backgroundColor = [UIColor clearColor];
    [self addSubview:_renownValueView];
    
    self.signatureLabel = [UILabel new];
    _signatureLabel.backgroundColor = [UIColor clearColor];
    _signatureLabel.text = @"5月14日至19日，印度总理莫迪将对中国、蒙古和韩国进行访问。不过此次莫迪出访还有一个小插曲。按照原计划他是先访问韩国，之后再访问中国和蒙古。但后来，莫迪决定把中国作为出访的第一站，而且在中国停留时间最长，为期三天。";
    _signatureLabel.font = [UIFont systemFontOfSize:12];
    _signatureLabel.textColor = [UIColor whiteColor];
    _signatureLabel.numberOfLines = 0;
    _signatureLabel.textAlignment = NSTextAlignmentCenter;
    _signatureLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_signatureLabel];
    
    self.titleActionBar = [XTActionBar new];
    _titleActionBar.backgroundColor = [UIColor clearColor];
    _titleActionBar.delegate = self;
    _titleActionBar.type = XTActionBarTitleType;
    _titleActionBar.titleColor = ABACTIONBAR_DEFAULT_TITLECOLOR;
    _titleActionBar.titleFont = ABACTIONBAR_DEFAULT_TITLEFONT;
    _titleActionBar.titleSpecialFont = ABACTIONBAR_DEFAULT_S_TITLEFONT;
    _titleActionBar.titleSpecialColor = ABACTIONBAR_DEFAULT_S_TITLECOLOR;
    _titleActionBar.topBorderColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    _titleActionBar.titleItems = @[@"`0/0`\n粉丝/关注", @"`0/0`\n喜欢/嫌弃", @"`0/0`\n赞过/收藏"];
    [self addSubview:_titleActionBar];
    
    [self.headPortraitView makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.top.equalTo(@64);
        make.height.equalTo(@125);
    }];
    
    [self.levelNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headPortraitView.bottom).offset(@5);
        make.right.equalTo(self.centerX).offset(-5);
        make.height.equalTo(@12);
    }];
    
    [self.renownValueView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.levelNameLabel);
        make.left.equalTo(_levelNameLabel.right).offset(@10);
        make.width.equalTo(@80);
        make.height.equalTo(@12);
    }];
    
    [self.signatureLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_renownValueView.bottom).offset(@5);
        make.left.and.right.equalTo(self).insets(kPadding);
        make.height.equalTo(@35);
    }];
    
    [self.titleActionBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_signatureLabel.bottom).offset(@5);
        make.left.right.equalTo(self);
        make.height.equalTo(@60);
    }];
}

- (void)fillUesrInformation:(XTUserAccountInfo *)user
{
    [self.headPortraitView fillUesrInformation:user];
    self.levelNameLabel.text = user.levelName;
    [self.renownValueView fillUesrInformation:user];
    _signatureLabel.text = user.brief;
    NSString *oneStr = [NSString stringWithFormat:@"`%@/%@`\n粉丝/关注",user.fansCount,user.friendsCount];
    NSString *twoStr = [NSString stringWithFormat:@"`%@/%@`\n喜欢/嫌弃",user.subArtistCount,user.hideArtistCount];
    NSString *threeStr = [NSString stringWithFormat:@"`%@/%@`\n赞过/收藏",user.commendCount,user.favoriteCount];
    _titleActionBar.titleItems = @[oneStr,twoStr,threeStr];
}

- (void)fillLocalUserSignInInfo:(XTUserAccountInfo *)user{
    [self.signInView fillUesrInformation:user];
}

- (void)onClickActionBar:(XTActionBar *)actionBar atTitle:(NSInteger)index{
    if (self.delegate) {
        [_delegate onClickHeadBar:actionBar atTitle:index];
    }
}

- (void)clickSignIn:(UIButton *)sender{
    if (self.delegate) {
        if (!_signInView.isSigned) {
            [_delegate onClickSignInBtn:_signInView.signInButton];
        }
    }
}

@end
