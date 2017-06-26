//
//  XTSearchIndexTableView.h
//  tian
//
//  Created by huhuan on 15/6/11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTSearchIndexModel.h"
#import "XTTapTableView.h"

@interface XTSearchIndexTableView : XTTapTableView

@property (nonatomic, strong) XTSearchIndexModel *indexModel;

+ (XTSearchIndexTableView *)searchIndexTableView;

- (void)configureSearchIndexTableView;

@end
