//
//  XTLickManitoCollectViewCell.h
//  tian
//
//  Created by 曹亚云 on 15-7-8.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTCollectViewCell.h"
#import "SlideCollectionView.h"
@interface XTLickManitoCollectViewCell : XTCollectViewCell
@property (nonatomic, strong) SlideCollectionView *slideView;
@property (nonatomic, strong) NSMutableArray *imageInfoItem;
@property (nonatomic, strong) NSString *userID;

- (void)loadLickManitoNewData;
- (void)setSlideViewState:(State)state;
- (State)slideViewState;
@end
