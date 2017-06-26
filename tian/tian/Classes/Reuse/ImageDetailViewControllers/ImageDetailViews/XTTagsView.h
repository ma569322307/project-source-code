//
//  XTTagsView.h
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTTagInfo;
@protocol XTTagsViewDelegate <NSObject>

-(void)tagViewTapActionWith:(XTTagInfo *)tagInfo;

@end

@interface XTTagsView : UIView

@property(nonatomic,strong)NSArray *tags;

@property(nonatomic,weak)id <XTTagsViewDelegate> delegate;

@end
