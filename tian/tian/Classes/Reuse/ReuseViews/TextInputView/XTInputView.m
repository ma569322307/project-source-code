//
//  XTInputView.m
//  tian
//
//  Created by loong on 15/6/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTInputView.h"
#import "XTTextView.h"
@interface XTInputView ()<UITextViewDelegate>

@property(nonatomic,weak)IBOutlet XTTextView *textView;


@property (weak, nonatomic) IBOutlet UIButton *postBtn;

@end


@implementation XTInputView

@synthesize text = textStr;

-(void)awakeFromNib{
    //textView.inputAccessoryView
    //[textView resignFirstResponder];
    self.textView.layer.cornerRadius = 10.0f;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderColor = RGBA(207, 177, 16, 1).CGColor;
    self.textView.layer.borderWidth = 1.0f;
    self.textView.contentInset = UIEdgeInsetsMake(3., 0., 0., 0.);
    //self.textView.placeholder = @"说点什么吧";
}

-(NSMutableDictionary *)postCommentsInfo{
    if (!_postCommentsInfo) {
        _postCommentsInfo = [NSMutableDictionary dictionary];
    }
    return _postCommentsInfo;
}


-(BOOL)xt_resignFirstResponder{
    
    return [self.textView resignFirstResponder];

}

-(BOOL)xt_isFirstResponder{
    
    self.postCommentsInfo = nil;
    return [self.textView isFirstResponder];
}

-(BOOL)xt_becomeFirstResponder{

    return [self.textView becomeFirstResponder];
}

-(NSString *)text{
    return self.textView.text;
}

-(void)setText:(NSString *)aText{
    textStr = aText;
    self.textView.text = textStr;
    if ([textStr isEqualToString:@""]) {
        self.heightConstraint.constant = 53;
    }
}



-(void)setPlaceholderText:(NSString *)aPlaceholderText{
    _placeholderText = aPlaceholderText;
    self.textView.placeholder = _placeholderText;

}

- (IBAction)postBtnClick:(UIButton *)sender {
    if (!self.textView.text || self.textView.text.length <=0) {
        [self.textView resignFirstResponder];
        return;
    }
    [self.postCommentsInfo setObject:self.textView.text forKeyedSubscript:@"text"];
    if ([self.delegate respondsToSelector:@selector(postBtnActionWith:)]){
        [self.delegate postBtnActionWith:self.postCommentsInfo];
    }
}


-(void)setHeightConstraint:(NSLayoutConstraint *)aHeightConstraint{
    _heightConstraint = aHeightConstraint;
    
    [self addConstraint:_heightConstraint];
}

- (void)textViewDidChange:(UITextView *)textView{
    //NSLog(@"textView.text === %f",textView.contentSize.height);
//    if (textView.text.length == 0 || textView.text.length > 140) {
//        self.postBtn.enabled = NO;
//    }else{
//        self.postBtn.enabled = YES;
//    }
    
    //NSLog(@"textView.length ===== %zd andtext ===== %@",textView.text.length,textView.text);
    

    CGFloat height = textView.contentSize.height;
    NSLog(@"height ===== %@",@(height));
    
    if (height < 31 || height > 80) {
        return;
    }
    
    if (self.heightConstraint) {
        
        self.heightConstraint.constant = textView.contentSize.height + 22;
        
        return;
        
    }else if ([self.delegate respondsToSelector:@selector(textDidChange:)]){
        
        [self.delegate textDidChange:textView.contentSize.height + 22];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
