//
//  XTUnreadCountView.h
//  tian
//
//  Created by cc on 15/7/16.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTUnreadCountView : UIView
@property (nonatomic, strong)UILabel *countLabel;
- (void)setUnreadCountLabelText:(NSInteger)unreadCount;
- (NSInteger)getTheUnreadCount;
@end
