//
//  XTDedicateListCollectViewCell.h
//  tian
//
//  Created by 曹亚云 on 15-6-15.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTCollectViewCell.h"
#import "SlideTableView.h"
@interface XTDedicateListCollectViewCell : XTCollectViewCell
@property (nonatomic, strong) SlideTableView *slideView;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSMutableArray *dedicateUserItem;
- (void)loadDedicateListData;
- (void)setSlideViewState:(State)state;
- (State)slideViewState;

@end
