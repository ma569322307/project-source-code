//
//  RPViewController.h
//  RoundProgress
//
//  Created by Arun Kumar.P on 20/03/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTPostTableViewCell.h"
@class SlideTableView;
@protocol SlideTableViewDelegate <NSObject>

-(State)SlideTableViewCheckState:(SlideTableView *)SlideTableView;

@end

@interface SlideTableView: UITableView
@property (nonatomic, assign) State tState;
@property (nonatomic, weak) id<SlideTableViewDelegate> stateDelegate;
@property (nonatomic, assign) XTTopicTableViewCellStyle tableViewCellStyle;
@end
