//
//  XTTopicCell.h
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTHotTopicSetModel;
@interface XTTopicCell : UITableViewCell


-(void)configerDataWithModel:(XTHotTopicSetModel *)model andIndex:(NSInteger)index;


@end
