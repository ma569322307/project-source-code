//
//  XTTabBarSelectedView.h
//  tian
//
//  Created by 尚毅 杨 on 15/4/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^onTabBarCustomButtonSelectedBlock)(NSInteger);				//TabBar切换视图
typedef void (^onTabBarPalyButtonSelectedBlock)();							//拍照按钮

@interface XTTabBarSelectedView : UIView


@property(nonatomic, copy) onTabBarCustomButtonSelectedBlock	customButtonDelegate;

@property(nonatomic, copy) onTabBarPalyButtonSelectedBlock		playButtonDelegate;

@property(nonatomic, readwrite) NSInteger						customPos;	//当前焦点focus

@end
