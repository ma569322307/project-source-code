//
//  XTExampleViewController.h
//  tian
//
//  Created by yyt on 15-6-8.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTbaseTableViewController.h"
typedef enum {
    XTTIANLILIST,
    XTTIANSHENGLIST,
    XTMINGXING
}XTrankListType;
@interface XTLickRankingViewController : XTbaseTableViewController
@property (nonatomic, assign)XTrankListType type;
@property (nonatomic, copy) NSString *string;


@end
