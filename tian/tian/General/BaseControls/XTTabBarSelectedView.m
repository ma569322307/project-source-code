//
//  XTTabBarSelectedView.m
//  tian
//
//  Created by 尚毅 杨 on 15/4/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTabBarSelectedView.h"
#define kTabBarFunsHeight	49.0+5.0											//Tabbar基本高度
#define kTranslationX	18.0
#define kTranslationXX	(kTranslationX + 10.0)

@interface XTTabBarSelectedView()

@property(nonatomic, strong) NSMutableArray*		buttonArray;

@property(nonatomic, strong) NSLayoutConstraint*	bgBottomTop;

@property(nonatomic, strong) NSLayoutConstraint*	bgTopHeight;

@property(nonatomic, strong) NSLayoutConstraint*	indexPageLeading;
@property(nonatomic, strong) NSLayoutConstraint*	plazzaLeading;
@property(nonatomic, strong) NSLayoutConstraint*	matchLeading;
@property(nonatomic, strong) NSLayoutConstraint*	rankingLeading;

@property(nonatomic, strong) NSLayoutConstraint*	playHeight;
@property(nonatomic, strong) NSLayoutConstraint*	playWidth;

@end


@implementation XTTabBarSelectedView

-(id)init
{
    self = [super init];
    
    if (self) {
        
        _customPos = -1;
        
        self.buttonArray = [[NSMutableArray alloc] initWithCapacity:5];
        [self setBackgroundColor:[UIColor clearColor]];
                
        [self createButtons];
    }
    
    return self;
}

- (void)createButtons
{
    UIImage *btnImg = [UIImage imageNamed:@"Tabbar_HomePage"];
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - (btnImg.size.width * 4+75)) / 6;
    CGFloat btnBottom = (kTabBarFunsHeight - btnImg.size.height) / 2;
    
    //首页
    UIButton* indexPageBtn = [self createCustomButton:@"Tabbar_HomePage"
                                           clickImage:@"Tabbar_HomePage_Sel"];
    //indexPageBtn.backgroundColor = [UIColor grayColor];
    [indexPageBtn setTag:100];
    [indexPageBtn addTarget:self
                     action:@selector(onCustomButtonEvent:)
           forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:indexPageBtn];
    [self.buttonArray addObject:indexPageBtn];
    
    [indexPageBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(margin);
        make.width.equalTo(btnImg.size.width);
        make.height.equalTo(btnImg.size.height);
        make.bottom.equalTo(self).offset(-btnBottom);
    }];
    
    //热舔
    UIButton* plazzaBtn = [self createCustomButton:@"Tabbar_HotLicks"
                                        clickImage:@"Tabbar_HotLicks_Sel"];
    //plazzaBtn.backgroundColor = [UIColor grayColor];
    [plazzaBtn setTag:101];
    [plazzaBtn addTarget:self
                  action:@selector(onCustomButtonEvent:)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:plazzaBtn];
    [self.buttonArray addObject:plazzaBtn];
    
    [plazzaBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(indexPageBtn.right).offset(margin);
        make.width.equalTo(btnImg.size.width);
        make.height.equalTo(btnImg.size.height);
        make.bottom.equalTo(self).offset(-btnBottom);
    }];
    
    UIButton* middleBtn = [self createCustomButton:@"Tabbar_upload"
                                        clickImage:@"Tabbar_upload"];
    
    //middleBtn.backgroundColor = [UIColor grayColor];
    [middleBtn addTarget:self
                 action:@selector(onPlayButtonEvnet:)
       forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:middleBtn];
    
    UIImageView* middleItemImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_middle_btn"]];
    [middleBtn addSubview:middleItemImageView];
    
    [middleItemImageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(middleBtn);
        make.width.height.equalTo(@40);
    }];
    
    [middleBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(plazzaBtn.right).offset(margin);
        make.width.equalTo(@75);
        make.height.equalTo(@75);
        make.bottom.equalTo(self).offset(-btnBottom + 5);
    }];
    
    
    //消息
    UIButton* matchBtn = [self createCustomButton:@"Tabbar_Message"
                                       clickImage:@"Tabbar_Message_Sel"];
    //matchBtn.backgroundColor = [UIColor grayColor];
    [matchBtn setTag:102];
    [matchBtn addTarget:self
                 action:@selector(onCustomButtonEvent:)
       forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:matchBtn];
    [self.buttonArray addObject:matchBtn];
    
    [matchBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(plazzaBtn.right).offset(2*margin+75);
        make.width.equalTo(btnImg.size.width);
        make.height.equalTo(btnImg.size.height);
        make.bottom.equalTo(self).offset(-btnBottom);
    }];
    
    //我
    UIButton* rankingBtn = [self createCustomButton:@"Tabbar_User"
                                         clickImage:@"Tabbar_User_Sel"];
    //rankingBtn.backgroundColor = [UIColor grayColor];
    [rankingBtn setTag:103];
    [rankingBtn addTarget:self
                   action:@selector(onCustomButtonEvent:)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rankingBtn];
    [self.buttonArray addObject:rankingBtn];
    
    [rankingBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(matchBtn.right).offset(margin);
        make.width.equalTo(btnImg.size.width);
        make.height.equalTo(btnImg.size.height);
        make.bottom.equalTo(self).offset(-btnBottom);
    }];
    
    //[self setTabType];
}

- (void)setTabType
{
    _indexPageLeading.constant -= kTranslationX;
    _plazzaLeading.constant -= kTranslationXX;
    _matchLeading.constant += kTranslationXX;
    _rankingLeading.constant += kTranslationX;
    
    UIImage* playImg = [UIImage imageNamed:@"main_button"];
    _playHeight.constant = playImg.size.height;
    _playWidth.constant = playImg.size.width;
}

- (UIButton*)createCustomButton:(NSString*)nomalName clickImage:(NSString*)clickName
{
    UIImage* nomalImg = [UIImage imageNamed:nomalName];
    UIImage* clickImg = [UIImage imageNamed:clickName];
    
    UIButton* button = [[UIButton alloc] init];
    [button setImage:nomalImg forState:UIControlStateNormal];
    [button setImage:clickImg forState:UIControlStateHighlighted];
    [button setImage:clickImg forState:UIControlStateSelected];
    
    return button;
}

#pragma mark button event
- (void)onCustomButtonEvent:(UIButton*)sender
{
    if (self.customButtonDelegate != nil) {
        self.customButtonDelegate(sender.tag);
    }

    if (_customPos == sender.tag - 100) {
        return;
    }
    
    [self setCustomPos:sender.tag - 100];
    
    
}

- (void)onPlayButtonEvnet:(UIButton*)sender
{
    if (self.playButtonDelegate != nil) {
        self.playButtonDelegate();
    }
}

/*
 *设置当前焦点高亮
 */
- (void)setCustomPos:(NSInteger)customPos
{
    UIButton* toBtn = (UIButton*)[self.buttonArray objectAtIndex:customPos];
    [toBtn setSelected:YES];
    
    if (_customPos == -1) {
        
        _customPos = customPos;
        
        return;
    }
    
    UIButton* fromBtn = (UIButton*)[self.buttonArray objectAtIndex:_customPos];
    [fromBtn setSelected:NO];
    
    _customPos = customPos;
}

@end
