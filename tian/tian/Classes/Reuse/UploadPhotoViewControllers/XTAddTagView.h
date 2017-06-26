//
//  XTAddTagView.h
//  tian
//
//  Created by 曹亚云 on 15-6-16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTAddTagView;
@protocol XTAddTagDelegate <NSObject>
@optional
- (void)onClickAddTag:(UIButton *)addTagBtn;
- (void)giveSearchKey:(NSString *)KeyStr;
- (void)giveDefaultTag;
@end

@interface XTAddTagView : UIView
@property (nonatomic, assign) id<XTAddTagDelegate> delegate;
@property (nonatomic, strong) UITextField *tagTextField;
@end
