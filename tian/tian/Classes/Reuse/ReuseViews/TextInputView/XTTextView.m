//
//  XTTextView.m
//  tian
//
//  Created by loong on 15/7/9.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTTextView.h"

@interface XTTextView()

@property(nonatomic,strong)UILabel *placeholderLabel;

@end


@implementation XTTextView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}


-(void)textChanged:(NSNotification *)notif{
    if([[self placeholder] length] == 0){
        return;
    }
    
    if([[self text] length] == 0){
        self.placeholderLabel.hidden = NO;;
    }else{
        self.placeholderLabel.hidden = YES;
    }
}

-(BOOL)resignFirstResponder{
    self.placeholder = @"说点什么吧";
    if (self.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }else{
        self.placeholderLabel.hidden = YES;
    }
    
    return [super resignFirstResponder];
}



//-(void)setText:(NSString *)aText{
//    [super setText:aText];
//    if (!self.text || self.text.length <=0) {
//        self.placeholderLabel.hidden = NO;
//    }else{
//        self.placeholderLabel.hidden = YES;
//    }
//}

-(void)setPlaceholder:(NSString *)aPlaceholder{
    _placeholder = aPlaceholder;
    self.placeholderLabel.text = self.placeholder;
}


-(UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (CGRectGetHeight(self.frame) - 20) / 2 - 3, CGRectGetWidth(self.frame), 20)];
//        _placeholderLabel.backgroundColor = [UIColor magentaColor];
        _placeholderLabel.textAlignment = NSTextAlignmentLeft;
        
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        
        _placeholderLabel.font = [UIFont systemFontOfSize:10];
        
        //_placeholderLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

@end
