//
//  XTAddTagView.m
//  tian
//
//  Created by 曹亚云 on 15-6-16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTAddTagView.h"
#define MaxNumber 15
@interface XTAddTagView()<UITextFieldDelegate>
//@property (nonatomic, strong) UITextField *tagTextField;
@property (nonatomic, strong) UIButton *addTagBtn;
@end

@implementation XTAddTagView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self tagTextField];
        [self addTagBtn];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldEditChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:self.tagTextField];
    }
    return self;
}

- (UITextField *)tagTextField{
    if (!_tagTextField) {
        _tagTextField = [UITextField new];
        _tagTextField.backgroundColor = [UIColor clearColor];
        _tagTextField.returnKeyType = UIReturnKeyDone;
        _tagTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _tagTextField.clearsOnBeginEditing = YES;
        _tagTextField.placeholder = @"标签最多输入15个字.";
        _tagTextField.font = [UIFont systemFontOfSize:12];
        _tagTextField.delegate = self;
        [self addSubview:_tagTextField];
        
        [_tagTextField makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 55));
        }];
        
    }
    return _tagTextField;
}

- (UIButton *)addTagBtn{
    if (!_addTagBtn) {
        _addTagBtn = [[UIButton alloc] init];
        [_addTagBtn setImage:[UIImage imageNamed:@"upload_addTag"] forState:UIControlStateNormal];
        [_addTagBtn setImage:[UIImage imageNamed:@"upload_addTag_sel"] forState:UIControlStateHighlighted];
        [_addTagBtn addTarget:self action:@selector(clickAddTagBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addTagBtn];
        
        [_addTagBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tagTextField.right).offset(@10);
            make.size.equalTo(CGSizeMake(35, 35));
            make.centerY.equalTo(_tagTextField);
        }];
    }
    return _addTagBtn;
}

- (void)clickAddTagBtn:(UIButton *)btn{
    if (self.delegate) {
        [_delegate onClickAddTag:btn];
    }
}

#pragma UITextFieldDelegate
//返回一个BOOL值，YES代表允许编辑，NO不允许编辑.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

//开始编辑时触发，文本字段将成为first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing...");
}

/*
  返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
  要想在用户结束编辑时阻止文本字段消失，可以返回NO，返回NO，点击键盘的返回按钮会无效果。
  这对一些文本字段必须始终保持活跃状态的程序很有用，比如即时消息
 */
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

//上面的代理方法返回YES后执行
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing...");
}

/*
  当用户使用自动更正功能，把输入的文字修改为推荐的文字时，就会调用这个方法。
  这对于想要加入撤销选项的应用程序特别有用
  可以跟踪字段内所做的最后一次修改，也可以对所有编辑做日志记录，用作审计用途。
  要防止文字被改变可以返回NO
  这个方法的参数中有一个NSRange对象，指明了被改变文字的位置，建议修改的文本也在其中
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
                                                       replacementString:(NSString *)string
{
//    NSString *new = [textField.text stringByReplacingCharactersInRange:range
//                                                            withString:string];
    if ([string isEqualToString:@" "]&&[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
    {
        return NO;
    }
    
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return YES;
    }
    
//    if (new.length > MaxNumber)
//    {
//        return  NO;
//    }
    
    return YES;
}

/*
  返回一个BOOL值指明是否允许根据用户请求清除内容
  可以设置在特定条件下才允许清除内容
 */
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

//返回一个BOOL值，指明是否允许在按下回车键时结束编辑
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.delegate) {
        [_delegate giveDefaultTag];
    }
    return YES;
}

//监听文本改变
- (void)textFieldEditChanged:(NSNotification *)obj
{
    UITextField *textView = (UITextField *)obj.object;
    NSString *toBeString = textView.text;
    for (UITextInputMode *mode in [UITextInputMode activeInputModes]) {
        NSLog(@"[UITextInputMode activeInputModes]:%@",[UITextInputMode activeInputModes]);
        NSLog(@"UITextInputMode:%@",[mode primaryLanguage]);
//        NSString *lang = [mode primaryLanguage]; // 键盘输入模式
//        if ([lang isEqualToString:@"emoji"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textView markedTextRange];
            // 获取高亮部分
            UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
            
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > MaxNumber) {
                    textView.text = [toBeString substringToIndex:MaxNumber];
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                NSLog(@"输入的英文还没有转化为汉字的状态");
            }
        }
//        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//        else{
//            if (toBeString.length > MaxNumber) {
//                textView.text = [toBeString substringToIndex:MaxNumber];
//            }
//        }
//    }
    if ([toBeString isEqualToString:@""]) {
        [textView resignFirstResponder];
        if (self.delegate) {
            [_delegate giveDefaultTag];
        }
    }else{
        if (self.delegate) {
            [_delegate giveSearchKey:textView.text];
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
