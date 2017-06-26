//
//  XTBatchSettingPhotoListView.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/13.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface XTBatchSettingPhotoListView : UICollectionView
+(instancetype)batchSettingPhotoListCreateView;
@property (nonatomic, assign) CGFloat bottomInset;
@property (nonatomic, copy) void(^selectionBlock)(NSInteger index);
@property (nonatomic, strong) NSMutableArray *pictureList;
///相册id
@property (nonatomic, assign) NSInteger albumId;
@end
