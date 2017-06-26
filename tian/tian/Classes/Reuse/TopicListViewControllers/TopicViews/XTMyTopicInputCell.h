//
//  XTMyTopicInputCell.h
//  tian
//
//  Created by Jiajun Zheng on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTTextNumberControlView;
@interface XTMyTopicInputCell : UITableViewCell
@property (weak, nonatomic) IBOutlet XTTextNumberControlView *textView;
@property (nonatomic, copy) NSString *title;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, assign,getter=isBig) BOOL big;
@end
