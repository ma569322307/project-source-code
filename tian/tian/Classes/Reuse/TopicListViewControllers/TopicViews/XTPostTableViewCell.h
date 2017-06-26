//
//  XTPostTableViewCell.h
//  tian
//
//  Created by huhuan on 15/7/2.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTPostInfo;

/**
 *  cell类型：0：首页关注话题 1：热舔话题 2：我的话题
 */
typedef NS_ENUM (NSUInteger, XTTopicTableViewCellStyle) {
    XTTopicTableViewCellStyleIndexFollow = 0,
    XTTopicTableViewCellStyleHotlick,
    XTTopicTableViewCellStyleOwn
};

@interface XTPostTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^moreClick)(XTPostInfo *postInfo, UIImage *shareImage);

- (void)configureCell:(XTPostInfo *)postModel andCellStyle:(XTTopicTableViewCellStyle)cellStyle;

- (CGFloat)heightForIndexPath:(XTPostInfo *)postModel andCellStyle:(XTTopicTableViewCellStyle)cellStyle;

@end
