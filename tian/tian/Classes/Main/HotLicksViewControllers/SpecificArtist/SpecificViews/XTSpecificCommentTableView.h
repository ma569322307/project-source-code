//
//  XTSpecificCommentTableView.h
//  tian
//
//  Created by huhuan on 15/7/2.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTTapTableView.h"
@class XTCommentsModel;

/**
 *  tableView类型：0:默认无header 1:带header
 */
typedef NS_ENUM (NSUInteger, XTSpecificCommentTableViewStyle) {
    XTSpecificCommentTableViewStyleDefault = 0,
    XTSpecificCommentTableViewStyleHeader
};

@interface XTSpecificCommentTableView : XTTapTableView

@property (nonatomic, assign) XTSpecificCommentTableViewStyle tableViewStyle;
@property (nonatomic, copy) NSString *belongId;
@property (nonatomic, strong) XTCommentsModel *commentModel;

+ (XTSpecificCommentTableView *)specificCommentTableView;

- (void)configureCommentTableView;

@end
