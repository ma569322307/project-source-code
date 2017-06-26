//
//  XTTopicIndexHeaderView.h
//  tian
//
//  Created by huhuan on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTHotLicksTopicsInfo;

@interface XTTopicIndexHeaderView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *contentImageView;

@property (nonatomic, copy) void (^collectClickBlock)(BOOL needCollect);

- (void)configureViewWithTopicInfo:(XTHotLicksTopicsInfo *)topicInfo;

/**
 *  收藏或取消收藏成功时，将收藏Button置为可用
 *  收藏或取消收藏失败时，重置按钮状态
 */
- (void)resetCollectStatusWithResponse:(BOOL)isSuccess collectMode:(BOOL)needCollect;

@end
