//
//  XTLickGodHeaderView.h
//  tian
//
//  Created by cc on 15/6/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTLickGodPropsInfo.h"

@protocol XTLickGodHeaderViewDelegate <NSObject>

@optional
- (void)clickGodBtn:(UIButton *)sender;

@end
@interface XTLickGodHeaderView : UIView
@property (nonatomic, assign) CGFloat theViewHeight;
@property (nonatomic,weak) id<XTLickGodHeaderViewDelegate> delegate;
@property (nonatomic, strong) NSArray *dataArray;
- (id)initLickGodViewWith:(NSArray *)objc;
@end
