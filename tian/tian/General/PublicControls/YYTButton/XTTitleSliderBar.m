//
//  XTTitleSliderBar.m
//  tian
//
//  Created by sz42c on 15/6/4.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTitleSliderBar.h"

#define XTTitleSliderFontSize	12

#define XTTitleButtonMargin		2.0f

#define XTTitleButtonWidth		38.0f
#define XTTitleButtonHeight		(XTTitleSliderFontSize + 4.0f)
#define XTTitleButtonSpacing	30.0f

#define XTTitleSliderWidth		26.0f
#define XTTitleSliderHeight		2.0f

@interface XTTitleSliderBar()

@property(nonatomic, strong) NSMutableArray*	titleArray;

@property(nonatomic, assign) NSInteger			index;

@property(nonatomic, strong) UIView*			sliderView;

@property(nonatomic, strong) NSLayoutConstraint* sliderViewCenterX;

@property(nonatomic, assign) BOOL				isAnimation;



@end

@implementation XTTitleSliderBar

- (id)initWIthTitleArray:(NSArray*)titleArray
{
	self = [super init];
	
	if (self) {
		
		self.index = 0;
		
		self.titleArray = [NSMutableArray arrayWithArray:titleArray];
		
		self.isAnimation = NO;
		
		UIButton* superButton = nil;
		UIButton* ruler = nil;
		
		__block XTTitleSliderBar* _self = self;
		
		//button位置
		for (NSInteger i = 0; i < self.titleArray.count; ++i) {
			
			NSString* title = (NSString*)[self.titleArray objectAtIndex:i];
			
			UIButton* button = [self createCustomButtonWithTitle:title];
			[button setTag:i];
			[self addSubview:button];
            //添加未读数
            
            if([self.titleArray[0] isEqualToString:@"消息"])
            {
            [_self addUnreadCountLabelWith:i withBtn:button];
            }
            
			[button makeConstraints:^(MASConstraintMaker *make) {
				
				make.width.equalTo(XTTitleButtonWidth);
				make.height.equalTo(XTTitleButtonHeight);
				make.centerY.equalTo(_self.centerY).with.offset(@(0));
				
				if (superButton == nil) {
					make.leading.equalTo(_self.leading).with.offset(@(XTTitleButtonMargin));
				} else {
					make.left.equalTo(superButton.right).with.offset(@(XTTitleButtonSpacing));
				}
			}];
			if (i == 0)
				ruler = button;
	
			superButton = button;
		}
		
		//横线位置
		self.sliderView = [[UIView alloc] init];
		[self.sliderView setTag:1000];
		[self.sliderView setBackgroundColor:UIColorFromRGB(0x4f242b)];
		[self addSubview:self.sliderView];
		
		[self.sliderView makeConstraints:^(MASConstraintMaker *make) {
			
			make.width.equalTo(XTTitleSliderWidth);
			make.height.equalTo(XTTitleSliderHeight);
			make.bottom.equalTo(_self.bottom).with.offset(@(-(XTTitleSliderBarHeight + XTTitleButtonHeight) / 2 + XTTitleButtonHeight + 2));
			make.leading.equalTo(_self.leading).with.offset(@([self getSliderLeadingWithTag:0]));
		}];
	}
	
	return self;
}
- (void)addUnreadCountLabelWith:(NSInteger)index withBtn:(UIButton *)btn
{
    switch (index) {
        case 2:
        {
            self.privateUnreadView = [[XTUnreadCountView alloc]init];
            [btn addSubview:self.privateUnreadView];
            [self.privateUnreadView makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@20);
                make.top.equalTo(btn.top).offset(-10);
                make.right.equalTo(btn.right).offset(8);
            }];
            [self.privateUnreadView setUnreadCountLabelText:0];
            
            break;
        }
        case 0:
        {
            self.messageUnreadView = [[XTUnreadCountView alloc]init];
            [btn addSubview:self.messageUnreadView];
            [self.messageUnreadView makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@20);
                make.top.equalTo(btn.top).offset(-10);
                make.right.equalTo(btn.right).offset(8);
            }];
            [self.messageUnreadView setUnreadCountLabelText:0];
            break;
        }
        case 1:
        {
            self.notificationUnreadView = [[XTUnreadCountView alloc]init];
            [btn addSubview:self.notificationUnreadView];
            [self.notificationUnreadView makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@20);
                make.top.equalTo(btn.top).offset(-10);
                make.right.equalTo(btn.right).offset(8);
            }];
            [self.notificationUnreadView setUnreadCountLabelText:0];
            break;
        }
        default:
            break;
    }
}
- (UIButton*)createCustomButtonWithTitle:(NSString*)title
{
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateHighlighted];
	[button setTitle:title forState:UIControlStateSelected];
	
	[button setTitleColor:UIColorFromRGB(0x4f242b) forState:UIControlStateNormal];
	[button setTitleColor:UIColorFromRGB(0x4f242b) forState:UIControlStateHighlighted];
	[button setTitleColor:UIColorFromRGB(0x4f242b) forState:UIControlStateSelected];
	
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:XTTitleSliderFontSize]];
	
	[button addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
	
	return button;
}

- (void)buttonClickEvent:(UIButton*)sender
{
	if (self.isAnimation)
		return;

	NSInteger tag = sender.tag;
	
	if (tag == self.index)
		return;
	
	[self animationToButtonCenter:sender];
	
	if (self.tilteSliderBarSelectedBlock) {
		self.tilteSliderBarSelectedBlock(tag);
	}
	
	self.index = tag;
}

- (CGFloat)getTitleSliderBarWidth
{
	return XTTitleButtonMargin * 2 + self.titleArray.count * XTTitleButtonWidth + (self.titleArray.count - 1) * XTTitleButtonSpacing;
}

- (void)animationToButtonCenter:(UIButton*)button
{
	self.isAnimation = YES;
	
	__block XTTitleSliderBar* _self = self;
	
	[UIView animateWithDuration:XTTitleSliderAnimationTime animations:^{
		
		[_self.sliderView remakeConstraints:^(MASConstraintMaker *make) {
			
			make.width.equalTo(XTTitleSliderWidth);
			make.height.equalTo(XTTitleSliderHeight);
			make.bottom.equalTo(_self.bottom).with.offset(@(-(XTTitleSliderBarHeight + XTTitleButtonHeight) / 2 + XTTitleButtonHeight + 2));
			make.leading.equalTo(_self.leading).with.offset(@([_self getSliderLeadingWithTag:button.tag]));
		}];
		
		[_self layoutIfNeeded];
		
	} completion:^(BOOL finished) {
		
		self.isAnimation = NO;
		
	}];
}

- (void)bottomLineScrollToButtonCenterWith:(float)x
{
    CGFloat leadMax = [self getSliderLeadingWithTag:self.titleArray.count - 1];
    CGFloat leadMin = [self getSliderLeadingWithTag:0];
    CGFloat c = leadMax - leadMin;
    int b = x/(self.titleArray.count*SCREEN_SIZE.width);
    CGFloat d = b*c;
    
    CLog(@"x==%f\n c = %f \n b = %zd \n d = %f \n   width = %f",x,c,b,d,self.titleArray.count*SCREEN_SIZE.width);
    
        [self.sliderView updateConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.leading).with.offset(@(d));
        }];
        
        [self layoutIfNeeded];
}


- (void)animationToNext:(NSInteger)index
{
	UIButton* button = (UIButton*)[self viewWithTag:index];
	if (button == nil)
		return;
	
	[self animationToButtonCenter:button];
	
	self.index = index;
}

- (CGFloat)getSliderLeadingWithTag:(NSInteger)tag
{
	CGFloat margin = (XTTitleButtonWidth - XTTitleSliderWidth) / 2;
	CGFloat leading = XTTitleButtonMargin + tag * XTTitleButtonSpacing + tag * XTTitleButtonWidth + margin;
	
	return leading;
}

- (BOOL)titleSliderBarIsAnimation
{
	return self.isAnimation;
}

@end
