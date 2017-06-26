//
//  XTTagDisplayView.h
//  tian
//
//  Created by 曹亚云 on 15-6-16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKKTagWriteView.h"
@interface XTTagDisplayView : UIView
@property(nonatomic, strong) HKKTagWriteView *tagWriteView;
@property(nonatomic, strong) UILabel *tagCountLabel;
- (void)addTag:(NSString *)tag animated:(BOOL)animated;
- (void)addtags:(NSArray *)tagArray;
@end
