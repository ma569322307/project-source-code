//
//  XTSearchAssociateTableView.h
//  tian
//
//  Created by huhuan on 15/6/17.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTSearchAssociateTableView : UITableView

@property (nonatomic, copy) NSArray *associateArray;
@property (nonatomic, copy) void (^cellClick)(NSString *keyword);

+ (XTSearchAssociateTableView *)associateTableView;

@end
