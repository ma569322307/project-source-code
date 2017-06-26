//
//  XTTextNumberControlView.h
//  tian
//
//  Created by Jiajun Zheng on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTTextNumberControlView;
@protocol XTTextNumberControlViewDelegate <NSObject>

-(void)textNumberControlView:(XTTextNumberControlView *)textView numberOfText:(NSInteger)numberOfText;

@end

@interface XTTextNumberControlView : UITextView
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, weak) id<XTTextNumberControlViewDelegate> countDelegate;
@end
