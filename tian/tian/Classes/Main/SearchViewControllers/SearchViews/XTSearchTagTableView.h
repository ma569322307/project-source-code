//
//  XTSearchTagTableView.h
//  tian
//
//  Created by huhuan on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTTapTableView.h"

@interface XTSearchTagTableView : XTTapTableView

@property (nonatomic, strong) NSArray *tagArray;

+ (XTSearchTagTableView *)tagTableView;

@end
