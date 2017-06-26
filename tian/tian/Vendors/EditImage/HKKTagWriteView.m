//
//  HKKTagWriteView.m
//  TagWriteViewTest
//
//  Created by kyokook on 2014. 1. 11..
//  Copyright (c) 2014 rhlab. All rights reserved.
//

#import "HKKTagWriteView.h"
#import "YYTUICommon.h"
#import <UIButton+WebCache.h>
#import "UIView+JKPicker.h"
@import QuartzCore;

@interface HKKTagWriteView()<UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *tagViews;
@property (nonatomic, strong) UITextView *inputView;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) NSMutableArray *tagsMade;

@property (nonatomic, assign) BOOL readyToDelete;

@end

@implementation HKKTagWriteView

#pragma mark - Life Cycle
- (id)initWithFrame:(CGRect)frame withTagType:(XTTagType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setType:type];
        [self initProperties];
        [self initControls];
        
        [self reArrangeSubViews];
    }
    return self;
}

#pragma mark - Property Get / Set
- (void)setFont:(UIFont *)font
{
    _font = font;
    for (UIButton *btn in _tagViews)
    {
        [btn.titleLabel setFont:_font];
    }
}

- (void)setTagBackgroundColor:(UIColor *)tagBackgroundColor
{
    _tagBackgroundColor = tagBackgroundColor;
    for (UIButton *btn in _tagViews)
    {
        [btn setBackgroundColor:_tagBackgroundColor];
    }
    
    _inputView.layer.borderColor = _tagBackgroundColor.CGColor;
    _inputView.textColor = _tagBackgroundColor;
}

- (void)setTagForegroundColor:(UIColor *)tagForegroundColor
{
    _tagForegroundColor = tagForegroundColor;
    for (UIButton *btn in _tagViews)
    {
        [btn setTitleColor:_tagForegroundColor forState:UIControlStateNormal];
    }
}

- (void)setMaxTagLength:(int)maxTagLength
{
    _maxTagLength = maxTagLength;
}

- (NSArray *)tags
{
    return _tagsMade;
}

- (void)setFocusOnAddTag:(BOOL)focusOnAddTag
{
    _focusOnAddTag = focusOnAddTag;
    if (_focusOnAddTag)
    {
        [_inputView becomeFirstResponder];
    }
    else
    {
        [_inputView resignFirstResponder];
    }
}

#pragma mark - Interfaces
- (void)clear
{
    _inputView.text = @"";
    [_tagsMade removeAllObjects];
    [self reArrangeSubViews];
}

- (void)setTextToInputSlot:(NSString *)text
{
    _inputView.text = text;
}

- (void)addTags:(NSArray *)tags
{
    for (NSString *tag in tags)
    {
        NSArray *result = [_tagsMade filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tag]];
        if (result.count == 0)
        {
            [_tagsMade addObject:tag];
        }
    }
    
    [self reArrangeSubViews];
}

- (void)removeTags:(NSArray *)tags
{
    for (NSString *tag in tags)
    {
        NSArray *result = [_tagsMade filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tag]];
        if (result)
        {
            [_tagsMade removeObjectsInArray:result];
        }
    }
    [self reArrangeSubViews];
}

- (void)removeAllTags
{
    [_tagsMade removeAllObjects];
    [self reArrangeSubViews];
}

- (void)addTagToLast:(NSString *)tag animated:(BOOL)animated
{
    for (NSString *t in _tagsMade)
    {
        if ([tag isEqualToString:t])
        {
            [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"标签已存在" withCompletionBlock:nil];
            NSLog(@"DUPLICATED!");
            return;
        }
    }
    
    [_tagsMade addObject:tag];
    
    _inputView.text = @"";
    
    [self addTagViewToLast:tag animated:animated];
    //[self layoutInputAndScroll];
    [self reArrangeSubViews];
    
    if ([_delegate respondsToSelector:@selector(tagWriteView:didMakeTag:)])
    {
        [_delegate tagWriteView:self didMakeTag:tag];
    }
}

- (void)removeTag:(NSString *)tag animated:(BOOL)animated
{
    NSInteger foundedIndex = -1;
    for (NSString *t in _tagsMade)
    {
        if ([tag isEqualToString:t])
        {
            NSLog(@"FOUND!");
            foundedIndex = (NSInteger)[_tagsMade indexOfObject:t];
            break;
        }
    }
    
    if (foundedIndex == -1)
    {
        return;
    }

    [_tagsMade removeObjectAtIndex:foundedIndex];

    [self removeTagViewWithIndex:foundedIndex animated:animated completion:^(BOOL finished){
        //[self layoutInputAndScroll];
        [self reArrangeSubViews];
    }];
    
    if ([_delegate respondsToSelector:@selector(tagWriteView:didRemoveTag:)])
    {
        [_delegate tagWriteView:self didRemoveTag:tag];
    }
}

#pragma mark - Internals
- (void)initControls
{
    _scrollView = [UIScrollView new];
    _scrollView.showsHorizontalScrollIndicator = NO;
    //_scrollView.backgroundColor = [UIColor blueColor];
    _scrollView.scrollsToTop = NO;
    if (self.type == XTTagTypeVerticalText) {
        _scrollView.showsHorizontalScrollIndicator = NO;
    }else if (self.type == XTTagTypeHorizontalText || self.type == XTTagTypeReadOnlyHorizontalText) {
        _scrollView.showsVerticalScrollIndicator = NO;
    }else if (self.type == XTTagTypeClick) {
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
    }
    [self addSubview:_scrollView];
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 20, 20)];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"del_tag"] forState:UIControlStateNormal];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"del_tag_sel"] forState:UIControlStateHighlighted];
    [_deleteButton addTarget:self action:@selector(deleteTagDidPush:) forControlEvents:UIControlEventTouchUpInside];
    _deleteButton.hidden = YES;
    [_scrollView addSubview:_deleteButton];
}

- (void)initProperties
{
    _font = [UIFont systemFontOfSize:12.0f];
    _tagBackgroundColor = COLOR_RGB_HEX(0xf8f8f8);
    _tagForegroundColor = COLOR_RGB_HEX(0x818181);
    _maxTagLength = 20;
    _tagGap = 4.0f;
    
    _tagsMade = [NSMutableArray array];
    _tagViews = [NSMutableArray array];
    
    _readyToDelete = NO;
}

- (void)addTagViewToLast:(NSString *)newTag animated:(BOOL)animated
{
    CGFloat posX = [self posXForObjectNextToLastTagView];
    CGFloat posY = _tagGap + 6.0f;
    
    UIButton *tagBtn = [self tagButtonWithTag:newTag posX:posX posY:posY];
    [_tagViews addObject:tagBtn];
    tagBtn.tag = [_tagViews indexOfObject:tagBtn];
    [_scrollView addSubview:tagBtn];
    
    if (animated)
    {
        tagBtn.alpha = 0.0f;
        [UIView animateWithDuration:0.25 animations:^{
            tagBtn.alpha = 1.0f;
        }];
    }
}

- (void)removeTagViewWithIndex:(NSUInteger)index animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    NSAssert(index < _tagViews.count, @"incorrected index");
    if (index >= _tagViews.count)
    {
        return;
    }
    
    UIView *deletedView = [_tagViews objectAtIndex:index];
    [deletedView removeFromSuperview];
    [_tagViews removeObject:deletedView];
    
    void (^layoutBlock)(void) = ^{
//        CGFloat posX = _tagGap;
//        for (int idx = 0; idx < _tagViews.count; ++idx)
//        {
//            UIView *view = [_tagViews objectAtIndex:idx];
//            CGRect viewFrame = view.frame;
//            viewFrame.origin.x = posX;
//            view.frame = viewFrame;
//            
//            posX += viewFrame.size.width + _tagGap;
//            
//            view.tag = idx;
//        }
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.25 animations:layoutBlock completion:completion];
    }
    else
    {
        layoutBlock();
    }

}

- (void)reArrangeSubViews
{
    CGFloat accumX = _tagGap;
    CGFloat accumY = _tagGap;
    NSInteger row = 0;
    NSMutableArray *newTags = [[NSMutableArray alloc] initWithCapacity:_tagsMade.count];
    for (NSString *tag in _tagsMade)
    {
        if (self.type == XTTagTypeVerticalText || self.type == XTTagTypeClick) {
            CGFloat tagWidth = [tag sizeWithAttributes:@{NSFontAttributeName:_font}].width+40.0;
            if (accumX+tagWidth > self.frame.size.width) {
                row++;
                accumY = _tagGap*(row+1) + 31*row;
                accumX = _tagGap;
            }
        }
        UIButton *tagBtn = [self tagButtonWithTag:tag posX:accumX posY:accumY];
        [newTags addObject:tagBtn];
        tagBtn.tag = [newTags indexOfObject:tagBtn];
        accumX += tagBtn.frame.size.width + _tagGap;
        NSLog(@"%@:%@",tag,NSStringFromCGRect(tagBtn.frame));
        [_scrollView addSubview:tagBtn];
    }
    
    for (UIView *oldTagView in _tagViews)
    {
        [oldTagView removeFromSuperview];
    }
    _tagViews = newTags;
    
    [self layoutInputAndScroll];
}

- (void)layoutInputAndScroll
{
    CGFloat accumX = [self posXForObjectNextToLastTagView];
    CGFloat accumY = [self posYForObjectNextToLastTagView];
    
    if (self.type == XTTagTypeVerticalText) {
        CGSize contentSize = _scrollView.contentSize;
        contentSize.height = accumY;
        _scrollView.contentSize = contentSize;
    }else if (self.type == XTTagTypeHorizontalText) {
        CGSize contentSize = _scrollView.contentSize;
        contentSize.width = accumX;
        _scrollView.contentSize = contentSize;
        [self setScrollOffsetToShowEndTag];
    }else if (self.type == XTTagTypeReadOnlyHorizontalText) {
        CGSize contentSize = _scrollView.contentSize;
        contentSize.width = accumX;
        _scrollView.contentSize = contentSize;
    }else if (self.type == XTTagTypeClick) {
        CGSize size = _scrollView.contentSize;
        size.height = accumY;
        self.tagHeight = accumY;
        if ([_delegate respondsToSelector:@selector(tagWriteViewDidEndEditing:)])
        {
            [_delegate tagWriteViewDidEndEditing:self];
        }
    }
    [_scrollView layoutIfNeeded];
}

- (void)setScrollOffsetToShowEndTag
{
    CGFloat scrollingDelta = [self posXForObjectNextToLastTagView] - (_scrollView.contentOffset.x + _scrollView.frame.size.width);
    if (scrollingDelta > 0)
    {
        CGPoint scrollOffset = _scrollView.contentOffset;
        scrollOffset.x += scrollingDelta + 0.0f;
        _scrollView.contentOffset = scrollOffset;
    }
}

- (void)setScrollOffsetToShowInputView
{
    CGRect inputRect = _inputView.frame;
    CGFloat scrollingDelta = (inputRect.origin.x + inputRect.size.width) - (_scrollView.contentOffset.x + _scrollView.frame.size.width);
    if (scrollingDelta > 0)
    {
        CGPoint scrollOffset = _scrollView.contentOffset;
        scrollOffset.x += scrollingDelta + 40.0f;
        _scrollView.contentOffset = scrollOffset;
    }
}

- (CGFloat)widthForInputViewWithText:(NSString *)text
{
    return MAX(50.0, [text sizeWithAttributes:@{NSFontAttributeName:_font}].width + 25.0f);
}

- (CGFloat)posXForObjectNextToLastTagView
{
    CGFloat accumX = _tagGap;
    if (_tagViews.count)
    {
        UIView *last = _tagViews.lastObject;
        accumX = last.frame.origin.x + last.frame.size.width + _tagGap;
    }
    return accumX;
}

- (CGFloat)posYForObjectNextToLastTagView
{
    CGFloat accumY = _tagGap;
    if (_tagViews.count)
    {
        UIView *last = _tagViews.lastObject;
        accumY = last.frame.origin.y + last.frame.size.height + _tagGap;
    }
    return accumY;
}

- (UIButton *)tagButtonWithTag:(NSString *)tag posX:(CGFloat)posX posY:(CGFloat)posY
{
    UIButton *tagBtn = [[UIButton alloc] init];
    [tagBtn.titleLabel setFont:_font];
    [tagBtn setBackgroundColor:_tagBackgroundColor];
    [tagBtn setTitleColor:_tagForegroundColor forState:UIControlStateNormal];
    [tagBtn addTarget:self action:@selector(tagButtonDidPushed:) forControlEvents:UIControlEventTouchUpInside];
    [tagBtn setTitle:tag forState:UIControlStateNormal];
    
    CGRect btnFrame = tagBtn.frame;
    btnFrame.origin.x = posX;
    btnFrame.origin.y = posY;
    if (self.type == XTTagTypeHorizontalText||self.type == XTTagTypeReadOnlyHorizontalText) {
        btnFrame.size.width = [tagBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_font}].width + 40.0f;
        btnFrame.size.height = self.frame.size.height- 2*_tagGap;
        UIImageView *iconImageView = [UIImageView new];
        iconImageView.image = [UIImage imageNamed:@"key_tag_icon"];
        [tagBtn addSubview:iconImageView];
        [iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tagBtn);
            make.width.height.equalTo(@20);
            make.centerY.equalTo(tagBtn);
        }];
    }else if (self.type == XTTagTypeVerticalText) {
        btnFrame.size.width = [tagBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_font}].width + 40.0f;
        btnFrame.size.height = 31.0f;
        UIImageView *iconImageView = [UIImageView new];
        iconImageView.image = [UIImage imageNamed:@"key_tag_icon"];
        [tagBtn addSubview:iconImageView];
        [iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tagBtn);
            make.width.height.equalTo(@20);
            make.centerY.equalTo(tagBtn);
        }];
    }else if (self.type == XTTagTypeClick){
        //[tagBtn setBackgroundColor:COLOR_RGB_HEX(0x6bcbcf)];
        [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        btnFrame.size.width = [tagBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_font}].width + 20.0f;
        btnFrame.size.height = 31.0f;
    }
    tagBtn.frame = CGRectIntegral(btnFrame);
    NSLog(@"btn frame [%@] = %@", tag, NSStringFromCGRect(tagBtn.frame));
    return tagBtn;
}

- (void)detectBackspace
{
    if (_inputView.text.length == 0)
    {
        if (_readyToDelete)
        {
            // remove lastest tag
            if (_tagsMade.count > 0)
            {
                NSString *deletedTag = _tagsMade.lastObject;
                [self removeTag:deletedTag animated:YES];
                _readyToDelete = NO;
            }
        }
        else
        {
            _readyToDelete = YES;
        }
    }
}

#pragma mark - UI Actions
- (void)tagButtonDidPushed:(id)sender
{
    UIButton *btn = sender;
    NSLog(@"tagButton pushed: %@, idx = %ld", btn.titleLabel.text, (long)btn.tag);
    if (self.type == XTTagTypeHorizontalText || self.type == XTTagTypeVerticalText) {
        if (_deleteButton.hidden == NO && btn.tag == _deleteButton.tag)
        {
            // hide delete button
            _deleteButton.hidden = YES;
            [_deleteButton removeFromSuperview];
        }
        else
        {
            // show delete button
            _deleteButton.xtcenterY = btn.xtcenterY;
            _deleteButton.xtright = btn.xtright;
            _deleteButton.tag = btn.tag;
            
            if (_deleteButton.superview == nil)
            {
                [_scrollView addSubview:_deleteButton];
            }
            [_scrollView bringSubviewToFront:_deleteButton];
            _deleteButton.hidden = NO;
        }
    }else if(self.type == XTTagTypeClick){
        if ([_delegate respondsToSelector:@selector(tagWriteView:didSelectTag:)])
        {
            [_delegate tagWriteView:self didSelectTag:btn.titleLabel.text];
        }
    }
}

- (void)deleteTagDidPush:(id)sender
{
    NSLog(@"tag count = %ld,  button tag = %ld", _tagsMade.count, _deleteButton.tag);
    NSAssert(_tagsMade.count > _deleteButton.tag, @"out of range");
    if (_tagsMade.count <= _deleteButton.tag)
    {
        return;
    }
    
    _deleteButton.hidden = YES;
    [_deleteButton removeFromSuperview];
    
    NSString *tag = [_tagsMade objectAtIndex:_deleteButton.tag];
    [self removeTag:tag animated:YES];
}

- (void)updateBtnState:(NSString *)btnTitle{
    if (self.type == XTTagTypeClick) {
        for (id btn in _scrollView.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)btn;
                if ([button.titleLabel.text isEqualToString:btnTitle]) {
                    [button setBackgroundColor:_tagBackgroundColor];
                    [button setTitleColor:_tagForegroundColor forState:UIControlStateNormal];
                    break;
                }
            }
        }
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@" "] || [text isEqualToString:@"\n"])
    {
        if (textView.text.length > 0)
        {
            [self addTagToLast:textView.text animated:YES];
            textView.text = @"";
        }

        if ([text isEqualToString:@"\n"])
        {
            [textView resignFirstResponder];
        }

        return NO;
    }
    
    CGFloat currentWidth = [self widthForInputViewWithText:textView.text];
    CGFloat newWidth = 0;
    NSString *newText = nil;
    
    if (text.length == 0)
    {
        // delete
        if (textView.text.length)
        {
            newText = [textView.text substringWithRange:NSMakeRange(0, textView.text.length - range.length)];
        }
        else
        {
            [self detectBackspace];
            return NO;
        }
    }
    else
    {
        if (textView.text.length + text.length > _maxTagLength)
        {
            return NO;
        }
        newText = [NSString stringWithFormat:@"%@%@", textView.text, text];
    }
    newWidth = [self widthForInputViewWithText:newText];
    
    CGRect inputRect = _inputView.frame;
    inputRect.size.width = newWidth;
    _inputView.frame = inputRect;

    CGFloat widthDelta = newWidth - currentWidth;
    CGSize contentSize = _scrollView.contentSize;
    contentSize.width += widthDelta;
    _scrollView.contentSize = contentSize;
    
    [self setScrollOffsetToShowInputView];
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(tagWriteView:didChangeText:)])
    {
        [_delegate tagWriteView:self didChangeText:textView.text];
    }
    
    if (_deleteButton.hidden == NO)
    {
        _deleteButton.hidden = YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(tagWriteViewDidBeginEditing:)])
    {
        [_delegate tagWriteViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(tagWriteViewDidEndEditing:)])
    {
        [_delegate tagWriteViewDidEndEditing:self];
    }
}
@end