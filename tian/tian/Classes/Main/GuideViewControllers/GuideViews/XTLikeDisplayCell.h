//
//  XTLikeDisplayCell.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/6.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kItemWidthHeight 45
@class MTLModel;
@interface XTLikeDisplayCell : UICollectionViewCell
@property (nonatomic, strong) MTLModel *model;
@property (nonatomic, copy) void(^cancelClick)(MTLModel *model);
@property (nonatomic, copy) NSString *addName;

@end
