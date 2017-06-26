//
//  XTInputView.h
//  tian
//
//  Created by loong on 15/6/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XTInputViewDelegate <NSObject>

@optional
-(void)postBtnActionWith:(NSMutableDictionary *)info;

-(void)textDidChange:(CGFloat)height;

@end

@interface XTInputView : UIView

@property(nonatomic,strong)NSMutableDictionary *postCommentsInfo;

@property(nonatomic,weak) id <XTInputViewDelegate> delegate;

-(BOOL)xt_resignFirstResponder;

-(BOOL)xt_becomeFirstResponder;

-(BOOL)xt_isFirstResponder;

@property(nonatomic,strong)NSString *text;

@property(nonatomic,strong)NSString *placeholderText;

@property(nonatomic,strong)NSLayoutConstraint *heightConstraint;

//@property(nonatomic,strong) NSString *contentKey;

@end
