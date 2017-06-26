//
//  XTDaysHotCollectViewCell.h
//  tian
//
//  Created by 曹亚云 on 15-7-8.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTCollectViewCell.h"
#import "SlideCollectionView.h"
#import "XTRootViewController.h"
@interface XTDaysHotCollectViewCell : XTCollectViewCell
@property (nonatomic, strong) SlideCollectionView *slideView;
@property (nonatomic, strong) NSMutableArray *imageInfoItem;
@property (nonatomic, strong) NSString *userID;

- (void)loadDaysHotNewData;
- (void)setSlideViewState:(State)state;
- (State)slideViewState;
@end
