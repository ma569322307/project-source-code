//
//  XTActionBar.m
//  StarPicture
//
//  Created by 曹亚云 on 15-2-11.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTActionBar.h"
@interface XTActionBar ()
@property (nonatomic, retain) UIImageView *leftGapImage;
@property (nonatomic, retain) UIImageView *rightGapImage;
@property (nonatomic, retain) NSMutableArray *titleViews;
@property (nonatomic, retain) NSMutableArray *leftBtnViews;
@property (nonatomic, retain) NSMutableArray *buttonViews;
@end

@implementation XTActionBar
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleViews = [[NSMutableArray alloc] initWithCapacity:4];
        _leftBtnViews = [[NSMutableArray alloc] initWithCapacity:4];
        _rightBtnViews = [[NSMutableArray alloc] initWithCapacity:4];
        _buttonViews = [[NSMutableArray alloc] initWithCapacity:4];
        
        self.titleFont = ABACTIONBAR_DEFAULT_TITLEFONT;
        self.titleSpecialFont = ABACTIONBAR_DEFAULT_S_TITLEFONT;
        
        self.titleColor = ABACTIONBAR_DEFAULT_TITLECOLOR;
        self.titleSpecialColor = ABACTIONBAR_DEFAULT_S_TITLECOLOR;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_bottomBorderColor) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextBeginPath(context);
        CGContextSetStrokeColorWithColor(context, _bottomBorderColor.CGColor);
        CGContextSetLineWidth(context, 1.0f);
        
        CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
        CGContextStrokePath(context);
    }
    if (_topBorderColor) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextBeginPath(context);
        CGContextSetStrokeColorWithColor(context, _topBorderColor.CGColor);
        CGContextSetLineWidth(context, 1.0f);
        
        CGContextMoveToPoint(context, 0.0f, 0.0f);
        CGContextAddLineToPoint(context, self.bounds.size.width, 0.0f);
        CGContextStrokePath(context);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame        = CGRectZero;
    CGFloat x_offset    = 0;
    CGFloat y_offset    = 0;
    CGFloat width       = 0;
    
    if (_leftButton) {
        frame = _leftButton.frame;
        x_offset = ABACTIONBAR_BUTTON_MARGIN;
        y_offset = (self.frame.size.height - frame.size.height) / 2;
        frame.origin = CGPointMake(x_offset, y_offset);
        _leftButton.frame = frame;
        
        x_offset += frame.size.width;
        x_offset += ABACTIONBAR_BUTTON_MARGIN;
        y_offset = (self.frame.size.height - ABACTIONBAR_GAP_HEIGHT) / 2;
        frame = _leftGapImage.frame;
        frame.origin = CGPointMake(x_offset, y_offset);
        _leftGapImage.frame = frame;
    }
    
    if (_rightButton) {
        frame = _rightButton.frame;
        x_offset = self.frame.size.width - ABACTIONBAR_BUTTON_MARGIN - frame.size.width;
        y_offset = (self.frame.size.height - frame.size.height) / 2;
        frame.origin = CGPointMake(x_offset, y_offset);
        _rightButton.frame = frame;
        
        x_offset -= (ABACTIONBAR_GAP_WIDTH + ABACTIONBAR_BUTTON_MARGIN);
        y_offset = (self.frame.size.height - ABACTIONBAR_GAP_HEIGHT) / 2;
        frame = _rightGapImage.frame;
        frame.origin = CGPointMake(x_offset, y_offset);
        _rightGapImage.frame = frame;
    }
    
    x_offset = _leftButton.frame.size.width + ABACTIONBAR_BUTTON_MARGIN * 2;
    width = self.frame.size.width - 4 * ABACTIONBAR_BUTTON_MARGIN - _leftButton.frame.size.width - _rightButton.frame.size.width;
    width -= 2 * ABACTIONBAR_GAP_WIDTH;
    
    [self layoutTitleViews:width offset:x_offset];
    [self layoutLeftViews:width offset:x_offset];
    [self layoutRightViews:width offset:x_offset];
    [self layoutButtonViews:width offset:x_offset];
}

- (void)layoutTitleViews:(CGFloat)width offset:(CGFloat)offset {
    if ([_titleViews count] <= 0) {
        return;
    }
    
    CGFloat x_offset = offset;
    CGSize btn_size = _btnBackground.size;
    NSInteger btn_count = [_titleViews count];
    
    if (btn_size.width == 0 || btn_size.height == 0) {
        btn_size.width = (width - ABACTIONBAR_TITLE_MARGIN * (btn_count + 1)) / btn_count;
        btn_size.height = self.frame.size.height;
    }
    
    
    x_offset += (width - btn_count * btn_size.width - ABACTIONBAR_TITLE_MARGIN * (btn_count - 1)) / 2;
    CGFloat y_offset = (self.frame.size.height - btn_size.height) / 2;
    
    for (UIButton *button in _titleViews) {
//        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
//        [self addSubview:imageView];
        
        button.frame = CGRectMake(x_offset, y_offset, btn_size.width, btn_size.height);
        x_offset += btn_size.width;
        //imageView.frame = CGRectMake(x_offset, 5, ABACTIONBAR_GAP_WIDTH, 41);
        x_offset += ABACTIONBAR_GAP_WIDTH;
    }
}

- (void)layoutLeftViews:(CGFloat)width offset:(CGFloat)offset {
    if ([_leftBtnViews count] <= 0) {
        return;
    }
    
    CGFloat x_offset = offset;
    x_offset += 0.0;
    
    for (UIButton *button in _leftBtnViews) {
        CGFloat y_offset = (self.frame.size.height - button.frame.size.height) / 2;
        button.frame = CGRectMake(x_offset, y_offset, button.frame.size.width, button.frame.size.height);
        x_offset += button.frame.size.width;
        x_offset += ABACTIONBAR_TITLE_MARGIN;
    }
}

- (void)layoutRightViews:(CGFloat)width offset:(CGFloat)offset {
    if ([_rightBtnViews count] <= 0) {
        return;
    }
    
    CGFloat x_offset = offset;
    NSInteger index = 0;
    UIButton *button = [_rightBtnViews objectAtIndex:index];
    x_offset = self.frame.size.width - 5.0 - button.frame.size.width;
    
    for (UIButton *button in _rightBtnViews) {
        CGFloat y_offset = (self.frame.size.height - button.frame.size.height) / 2;
        button.frame = CGRectMake(x_offset, y_offset, button.frame.size.width, button.frame.size.height);
        if (index+1 >= [_rightBtnViews count]) {
            return;
        }
        UIButton *button = [_rightBtnViews objectAtIndex:++index];
        x_offset -= button.frame.size.width;
        x_offset -= 5;
    }
}

- (void)layoutButtonViews:(CGFloat)width offset:(CGFloat)offset {
    if ([_buttonViews count] <= 0) {
        return;
    }
    
    NSInteger index = 0;
    UIButton *button = [_buttonViews objectAtIndex:index];
    NSInteger btnCount = [_buttonViews count];
    CGFloat x_offset = (self.frame.size.width - button.frame.size.width*btnCount)/(btnCount+1);
    CGFloat margin = x_offset;
    for (UIButton *button in _buttonViews) {
        CGFloat y_offset = (self.frame.size.height - button.frame.size.height) / 2;
        button.frame = CGRectMake(x_offset, y_offset, button.frame.size.width, button.frame.size.height);
        x_offset += button.frame.size.width + margin;
    }
}

- (void)createTitleViews {
    if ([_titleItems count] <= 0) {
        return;
    }
    
    for (UIView *view in _titleViews) {
        [view removeFromSuperview];
    }
    
    [_titleViews removeAllObjects];
    
    for (int i = 0; i < [_titleItems count]; i++) {
        NSString *title = [_titleItems objectAtIndex:i];
        YYTButton *button = [YYTButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:_btnBackground forState:UIControlStateNormal];
        [button setBackgroundImage:_btnSelectedBackground forState:UIControlStateHighlighted];
        [button setBackgroundImage:_btnSelectedBackground forState:UIControlStateSelected];
        [button addTarget:self action:@selector(onTitleClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //非空字符串
        if ([[title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]) {
            [button setAttributeTitle:title attribute:@{ @"font":_titleFont,
                                                         @"color":_titleColor,
                                                         @"emphasize_font":_titleSpecialFont,
                                                         @"emphasize_color":_titleSpecialColor }];
        }
        
        [_titleViews addObject:button];
        [self addSubview:button];
    }
}

- (void)createButtonViews {
    if ([_buttonItems count] <= 0) {
        return;
    }
    
    for (UIView *view in _buttonViews) {
        [view removeFromSuperview];
    }
    
    [_buttonViews removeAllObjects];
    
    for (int i = 0; i < [_buttonItems count]; i++) {
        NSString *imageName = [_buttonItems objectAtIndex:i];
        NSString *selectImageName = [NSString stringWithFormat:@"%@_sel",imageName];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *selectImage = [UIImage imageNamed:selectImageName];
        YYTButton *button = [YYTButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:selectImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:selectImage forState:UIControlStateSelected];
        [button addTarget:self action:@selector(onTitleClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [_buttonViews addObject:button];
        [self addSubview:button];
    }
}

- (void)createLeftBtns {
    if ([_leftBtnItems count] <= 0) {
        return;
    }
    
    for (UIView *view in _leftBtnViews) {
        [view removeFromSuperview];
    }
    
    [_leftBtnViews removeAllObjects];
    
    for (int i = 0; i < [_leftBtnItems count]; i++) {
        NSString *imageName = [_leftBtnItems objectAtIndex:i];
        NSString *selectImageName = [NSString stringWithFormat:@"%@_focus",imageName];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *selectImage = [UIImage imageNamed:selectImageName];
        
        YYTButton *button = [YYTButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:selectImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:selectImage forState:UIControlStateSelected];
        [button addTarget:self action:@selector(onTitleClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        
        [_leftBtnViews addObject:button];
        [self addSubview:button];
    }
}

- (void)createRightBtns {
    if ([_rightBtnItems count] <= 0) {
        return;
    }
    
    for (UIView *view in _rightBtnViews) {
        [view removeFromSuperview];
    }
    
    [_rightBtnViews removeAllObjects];
    
    for (int i = 0; i < [_rightBtnItems count]; i++) {
        NSString *imageName = [_rightBtnItems objectAtIndex:i];
        NSString *selectImageName = [NSString stringWithFormat:@"%@_sel",imageName];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *selectImage = [UIImage imageNamed:selectImageName];
        
        YYTButton *button = [YYTButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:selectImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:selectImage forState:UIControlStateSelected];
        [button addTarget:self action:@selector(onTitleClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
        [_rightBtnViews addObject:button];
        [self addSubview:button];
        if ([imageName isEqualToString:@"homePage_signIn"]) {
            [button setBackgroundImage:[UIImage imageNamed:@"homePage_NoSignIn"] forState:UIControlStateDisabled];
            self.signInBtn = button;
            self.signInNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-40, 20, 16, 12)];
            _signInNumberLabel.backgroundColor = [UIColor clearColor];
            _signInNumberLabel.textAlignment = NSTextAlignmentCenter;
            _signInNumberLabel.font = [UIFont systemFontOfSize:12];
            _signInNumberLabel.textColor = [UIColor whiteColor];
            _signInNumberLabel.text = @"0";
            [self addSubview:_signInNumberLabel];
        }
    }
}

- (IBAction)onTitleClicked:(id)sender {
    NSInteger index = 0;
    switch (_type) {
        case XTActionBarNavigationType:{
            if ([_leftBtnViews containsObject:sender]) {
                index = [_leftBtnViews indexOfObject:sender];
            }else if ([_rightBtnViews containsObject:sender]){
                index = [_rightBtnViews indexOfObject:sender]+[_leftBtnViews count];
            }
        }
            break;
        case XTActionBarTitleType:{
            index = [_titleViews indexOfObject:sender];
            break;
        }
        case XTActionBarButtonType:{
            index = [_buttonViews indexOfObject:sender];
            [self setButtonStatus:index];
            break;
        }
        default:
            break;
    }
    if (self.delegate) {
        [_delegate onClickActionBar:self atTitle:index];
    }
}

#pragma mark - interface
- (void)setLeftActionItem:(NSString *)itemImageName target:(id)target action:(SEL)action {
    [_leftButton removeFromSuperview];
    self.leftButton = [YYTButton buttonWithImageName:itemImageName];
    [self.leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftButton];
    
    if (!_leftButton) {
        [_leftGapImage removeFromSuperview];
        _leftGapImage = nil;
    }
    else {
        if (!_leftGapImage) {
            _leftGapImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ABACTIONBAR_GAP_RESOURCE]];
        }
        [self addSubview:_leftGapImage];
    }
    
    [self setNeedsLayout];
}

- (void)setRightActionItem:(NSString *)itemImageName target:(id)target action:(SEL)action {
    [_rightButton removeFromSuperview];
    self.rightButton = [YYTButton buttonWithImageName:itemImageName];
    [self.rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightButton];
    
    if (!_rightButton) {
        [_rightGapImage removeFromSuperview];
        _rightGapImage = nil;
    }
    else {
        if (!_rightGapImage) {
            _rightGapImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ABACTIONBAR_GAP_RESOURCE]];
        }
        [self addSubview:_rightGapImage];
    }
    [self setNeedsLayout];
}

- (void)setTitleItems:(NSArray *)titleItems {
    _titleItems = titleItems;
    
    [self createTitleViews];
    [self setNeedsLayout];
}

- (void)setLeftBtnItems:(NSArray *)leftBtnItems {
    _leftBtnItems = leftBtnItems;
    
    [self createLeftBtns];
    [self setNeedsDisplay];
}

- (void)setRightBtnItems:(NSArray *)rightBtnItems {
    _rightBtnItems = rightBtnItems;
    
    [self createRightBtns];
    [self setNeedsDisplay];
}

- (void)setButtonItems:(NSArray *)buttonItems {
    _buttonItems = buttonItems;
    
    [self createButtonViews];
    [self setNeedsDisplay];
}

- (void)setButtonStatus:(NSInteger)index{
    if (!_buttonViews) {
        return;
    }
    
    for (UIButton *btn in _buttonViews) {
        btn.selected = NO;
    }
    //有些时候数组为空   cc
    if (_buttonViews.count<=index) {
        return;
    }
    UIButton *button = [_buttonViews objectAtIndex:index];
    button.selected = YES;
}

- (void)setRightBtnsImage:(BOOL)isNormal{
    for (int i = 0; i < [_rightBtnItems count]; i++) {
        NSString *imageName = nil;
        if (isNormal) {
            imageName = [NSString stringWithFormat:@"%@",[_rightBtnItems objectAtIndex:i]];
        }else{
            imageName = [NSString stringWithFormat:@"%@_brown",[_rightBtnItems objectAtIndex:i]];
        }
        NSString *selectImageName = [NSString stringWithFormat:@"%@_sel",imageName];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *selectImage = [UIImage imageNamed:selectImageName];
        
        UIButton *button = [_rightBtnViews objectAtIndex:i];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:selectImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:selectImage forState:UIControlStateSelected];
    }
}

- (void)setLeftBtnsImage:(BOOL)isNormal{
    for (int i = 0; i < [_leftBtnItems count]; i++) {
        NSString *imageName = nil;
        if (isNormal) {
            imageName = [NSString stringWithFormat:@"%@",[_leftBtnItems objectAtIndex:i]];
        }else{
            imageName = [NSString stringWithFormat:@"%@_brown",[_leftBtnItems objectAtIndex:i]];
        }
        NSString *selectImageName = [NSString stringWithFormat:@"%@_sel",imageName];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *selectImage = [UIImage imageNamed:selectImageName];
        
        UIButton *button = [_leftBtnViews objectAtIndex:i];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:selectImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:selectImage forState:UIControlStateSelected];
    }
}

#pragma mark - test
- (void)test {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"actionbar_bg"]];
    [self setLeftActionItem:@"btn_cancel" target:self action:@selector(onTest:)];
    [self setRightActionItem:@"btn_confirm" target:self action:@selector(onTest:)];
    //    self.btnBackground = [UIImage imageNamed:@"btn_camera"];
    self.titleColor = ABACTIONBAR_DEFAULT_TITLECOLOR;
    self.titleFont = ABACTIONBAR_DEFAULT_TITLEFONT;
    self.titleSpecialFont = ABACTIONBAR_DEFAULT_S_TITLEFONT;
    self.titleSpecialColor = ABACTIONBAR_DEFAULT_S_TITLECOLOR;
    self.titleItems = @[@"A\n `100` ", @"B\n `200`", @"C\n `1000`"];
    //    self.titleItems = @[@""];
    self.titleItems = @[@"已选择照片 `1000` 张"];
}

- (IBAction)onTest:(id)sender {
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
