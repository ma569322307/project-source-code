//
//  YYTBarButtonItem.m
//  StarPicture
//
//  Created by 曹亚云 on 15-2-13.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "YYTBarButtonItem.h"
#import "YYTButton.h"
@interface YYTBarButtonItem() {
    id customTarget;
}
@property (nonatomic, strong) YYTButton *customButton;

@end

@implementation YYTBarButtonItem
- (id)initWithImage:(UIImage *)image
      selectedImage:(UIImage *)selectedImage
             target:(id)target action:(SEL)action
{
    YYTButton *btn = [YYTButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, image.size.width, image.size.height)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:image forState:UIControlStateNormal];
    if (selectedImage != nil) {
        [btn setImage:selectedImage forState:UIControlStateHighlighted];
    } else {
//        btn.showsTouchWhenHighlighted = YES;
    }
    
    self = [self initWithCustomView:btn];
    
    if (self) {
        self.customButton = btn;
    }
    
    return self;
}
+ (YYTBarButtonItem *)barItemWithImageName:(NSString *)baseName
                                   target:(id)target
                                   action:(SEL)action
{
    UIImage *img = [UIImage imageNamed:baseName];
    UIImage *select_img = [UIImage imageNamed:[NSString stringWithFormat:@"%@_focus", baseName]];
    return [YYTBarButtonItem barItemWithImage:img selectedImage:select_img target:target action:action];
}

+ (YYTBarButtonItem *)barItemWithImage:(UIImage *)image
                        selectedImage:(UIImage *)selectedImage
                               target:(id)target
                               action:(SEL)action
{
    return [[YYTBarButtonItem alloc] initWithImage:image
                                    selectedImage:selectedImage
                                           target:target
                                           action:action];
}

- (void)setCustomImage:(UIImage *)image
{
    [_customButton setImage:image forState:UIControlStateNormal];
}

- (void)setCustomSelectedImage:(UIImage *)image
{
    [_customButton setImage:image forState:UIControlStateHighlighted];
//    _customButton.showsTouchWhenHighlighted = NO;
}

- (UIImage*)customImage
{
    if (_customButton) {
        return [_customButton imageForState:UIControlStateNormal];
    }
    
    return nil;
}

- (UIImage*)customSelectedImage
{
    if (_customButton) {
        return [_customButton imageForState:UIControlStateHighlighted];
    }
    
    return nil;
}

#pragma mark - Text

- (id)initWithTitle:(NSString *)title
               font:(UIFont*)font
         themeColor:(UIColor *)themeColor
             target:(id)target
             action:(SEL)action
{
    CGSize maxButtonSize = CGSizeMake(MAXFLOAT, 44);
    CGFloat width = [title sizeWithFont:font
                      constrainedToSize:maxButtonSize
                          lineBreakMode:NSLineBreakByCharWrapping].width;

    YYTButton *btn = [YYTButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, width + 20, 44.0f)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:themeColor forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:font];
    [btn setImage:nil forState:UIControlStateNormal];
    [btn setImage:nil forState:UIControlStateHighlighted];
    
    self = [self initWithCustomView:btn];
    
    if (self) {
        self.customButton = btn;
    }
    
    return self;
}

+ (YYTBarButtonItem *)barItemWithTitle:(NSString *)title
                                 font:(UIFont*)font
                           themeColor:(UIColor *)themeColor
                               target:(id)target
                               action:(SEL)action
{
    return [[YYTBarButtonItem alloc] initWithTitle:title
                                             font:font
                                       themeColor:themeColor
                                           target:target
                                           action:action];
}

#pragma mark - Actions

- (void)setCustomAction:(SEL)action {
    //    customAction = action;
    
    [_customButton removeTarget:nil
                         action:NULL
               forControlEvents:UIControlEventAllEvents];
    
    [_customButton addTarget:customTarget
                      action:action
            forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - api
- (void)setContentEdgeInsets:(UIEdgeInsets)insets
{
    _customButton.contentEdgeInsets = insets;
}

#pragma mark - Animation
- (void)startAnimating
{
    [_customButton startAnimating];
}

- (void)stopAnimating
{
    [_customButton stopAnimating];
}

- (void)spin
{
    [_customButton spin];
}

- (BOOL)isAnimating
{
    return [_customButton isAnimating];
}

@end
