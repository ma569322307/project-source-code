//
//  XTAlbumListCollectionViewCell.h
//  tian
//
//  Created by 曹亚云 on 15-6-5.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTCollectViewCell.h"
#import "SlideCollectionView.h"
#import "XTRootViewController.h"
@interface XTAlbumListCollectionViewCell : XTCollectViewCell
@property (nonatomic, strong) SlideCollectionView *slideView;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSMutableArray *albumInfoItem;

- (void)setSlideViewState:(State)state;
- (State)slideViewState;
- (void)loadUserAlbumListNewDataWithCompletionBlock:(void(^)(NSError *error))completionBlock;
@end
