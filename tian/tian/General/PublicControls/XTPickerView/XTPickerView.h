//
//  XTPickerView.h
//  tian
//
//  Created by huhuan on 15/6/13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTPickerView : UIView

@property (nonatomic, copy) void (^pickerSelectedBlock)(NSDictionary *typeDic);
//判断行数
@property (nonatomic, assign) NSInteger componentNumber;
@property (nonatomic, assign) BOOL alwaysRefresh;
+ (XTPickerView *)pickerViewWithDataSource:(NSArray *)dataArray;

- (void)show;

- (void)hide;

@end
