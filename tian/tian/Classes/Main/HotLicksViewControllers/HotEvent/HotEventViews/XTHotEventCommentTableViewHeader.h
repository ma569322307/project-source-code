//
//  XTHotEventCommentTableViewHeader.h
//  tian
//
//  Created by huhuan on 15/7/6.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTCommentsModel;

@interface XTHotEventCommentTableViewHeader : UIView

@property (nonatomic, strong) XTCommentsModel *commentModel;

@property (nonatomic, copy) void (^lickClickBlock)(BOOL isPoison);

+ (XTHotEventCommentTableViewHeader *)hotEventCommentTableViewHeaderWithCommentModel:(XTCommentsModel *)commentModel;

- (void)configureHeaderView;

@end
