//
//  XTAlbumDetailCollectionViewCell.h
//  tian
//
//  Created by 曹亚云 on 15-6-11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTCollectViewCell.h"
#import "SlideCollectionView.h"
#import "XTRootViewController.h"
@interface XTAlbumDetailCollectionViewCell : XTCollectViewCell
@property (nonatomic, strong) SlideCollectionView *slideView;
@property (nonatomic, strong) NSMutableArray *imageInfoItem;
@property (nonatomic, strong) NSString *userID;

- (void)setSlideViewState:(State)state;
- (State)slideViewState;
- (void)reloadCollectView;
- (void)loadDefaultDataWithCompletionBlock:(void(^)(NSError *error))completionBlock;
@end
