//
//  XTSpecificCommentTableViewCell.h
//  tian
//
//  Created by huhuan on 15/7/4.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTCommentItemModel;

/**
 *  tableView类型：0:默认无header 1:带header
 */
typedef NS_ENUM (NSUInteger, XTSpecificCommentTableViewCellStyle) {
    XTSpecificCommentTableViewCellStylePraise = 0,
    XTSpecificCommentTableViewCellStyleLick
};

@interface XTSpecificCommentTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^praiseClickBlock)(XTCommentItemModel *itemModel);

- (void)configureCell:(XTCommentItemModel *)itemModel;

@end
