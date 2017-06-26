//
//  XTLikeDisplayCollectionView.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/6.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTSearchUserModel;
@interface XTLikeDisplayCollectionView : UICollectionView
//创建展示
+(instancetype)likeDisplay;
//添加展示
-(void)addDisplay:(MTLModel *)model;
//删除展示
-(void)deleteDisplay:(MTLModel *)model;
@end
