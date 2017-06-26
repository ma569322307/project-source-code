//
//  XTTextNumberControlView.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTextNumberControlView.h"
#import <Mantle/EXTScope.h>
#import "KeyboardManager.h"
#import "NSString+TextSize.h"
@interface XTTextNumberControlView ()<UITextViewDelegate>
@property (nonatomic, weak) UILabel *placeHolderView;
@end

@implementation XTTextNumberControlView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib{
    [self setup];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
//初始化
-(void)setup{
    self.delegate = self;
    [IQKeyboardManager sharedManager].enable = YES;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.placeHolderView sizeToFit];
    self.placeHolderView.frame = CGRectMake(5, 8, self.placeHolderView.frame.size.width, self.placeHolderView.frame.size.height);
}

-(void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    self.placeHolderView.text = placeHolder;
}
// 注册通知
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewEditChanged)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}
// 字数改变
-(void)textViewEditChanged{
    self.placeHolderView.hidden = !(self.text.length == 0);
    NSString *toBeString = self.text;
    for (UITextInputMode *mode in [UITextInputMode activeInputModes]) {
//        NSLog(@"[UITextInputMode activeInputModes]:%@",[UITextInputMode activeInputModes]);
//        NSLog(@"UITextInputMode:%@",[mode primaryLanguage]);
//        NSString *lang = [mode primaryLanguage]; // 键盘输入模式
//        if ([lang isEqualToString:@"emoji"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [self markedTextRange];
            // 获取高亮部分
            UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
            
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if ([toBeString lengthOfBytesUsingChineseCheck] > self.count) {
                    self.text = [toBeString subChineseStringToIndex:self.count];
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
//                NSLog(@"输入的英文还没有转化为汉字的状态");
            }
        }
//        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//        else{
//            if (toBeString.length > self.count) {
//                self.text = [toBeString substringToIndex:self.count];
//            }
//        }
//    }
    // 告知代理自身字数
    if ([self.countDelegate respondsToSelector:@selector(textNumberControlView:numberOfText:)]) {
        [self.countDelegate textNumberControlView:self numberOfText:[self.text lengthOfBytesUsingChineseCheck]];
    }
}

- (NSInteger)getStringLengthWithString:(NSString *)string
{
    __block NSInteger stringLength = 0;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
    {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff)
        {
            if (substring.length > 1)
            {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f)
                {
                    stringLength += 1;
                }
                else
                {
                    stringLength += 1;
                }
            }
            else
            {
                stringLength += 1;
            }
        } else if (substring.length > 1)
        {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3)
            {
                stringLength += 1;
            }
            else
            {
                stringLength += 1;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff)
            {
                stringLength += 1;
            }
            else if (0x2B05 <= hs && hs <= 0x2b07)
            {
                stringLength += 1;
            }
            else if (0x2934 <= hs && hs <= 0x2935)
            {
                stringLength += 1;
            }
            else if (0x3297 <= hs && hs <= 0x3299)
            {
                stringLength += 1;
            }
            else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
            {
                stringLength += 1;
            }
            else
            {
                stringLength += 1;
            }
        }
    }];
    return stringLength;
}


-(void)dealloc{
    [IQKeyboardManager sharedManager].enable = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark UITextView代理
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    // 开始监听通知
    [self addNotification];
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    NSString *new = [textView.text stringByReplacingCharactersInRange:range
//                                                           withString:text];
    if ([text isEqualToString:@" "]&&[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
    {
        return NO;
    }
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return YES;
    }
    
//    if (new.length > self.count)
//    {
//        return  NO;
//    }
    
    return YES;
}
#pragma mark 懒加载
-(UILabel *)placeHolderView{
    if (_placeHolderView == nil) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        label.font = self.font;
        label.textColor = [UIColor lightGrayColor];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        _placeHolderView = label;
    }
    return _placeHolderView;
}
@end
