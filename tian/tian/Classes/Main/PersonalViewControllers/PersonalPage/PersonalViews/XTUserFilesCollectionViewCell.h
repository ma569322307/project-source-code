//
//  TestCollectionViewCell.h
//  tian
//
//  Created by 曹亚云 on 15-5-29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTCollectViewCell.h"
#import "SlideTableView.h"
@class XTUserFilesInfo;
@interface XTUserFilesCollectionViewCell : XTCollectViewCell
@property (nonatomic, strong) SlideTableView *slideView;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) XTUserFilesInfo *userFilesInfo;

- (void)setSlideViewState:(State)state;
- (State)slideViewState;
- (void)loadUserFilesDataWithCompletionBlock:(void(^)(NSError *error))completionBlock;
@end
