//
//  XTShareCollectionView.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/9.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XTShareCollectionViewDelegate <NSObject>

//-(void)XTShareCollectionView:(XTShareCollectionView *)shareCollectionView didClick

@end

@interface XTShareCollectionView : UICollectionView
@property (nonatomic, strong) NSArray *modelList;
@property (nonatomic, copy) void(^btnBlock)(NSInteger index);
+(instancetype)shareCollectionViewCreateView;
-(void)resizeFlow:(CGSize)size;
@end
