//
//  XTSearchTagTableViewCell.h
//  tian
//
//  Created by huhuan on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTTagInfo;

@interface XTSearchTagTableViewCell : UITableViewCell

- (void)configureTagCell:(XTTagInfo *)tagModel;

@end