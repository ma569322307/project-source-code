//
//  XTBigImageViewController.h
//  tian
//
//  Created by loong on 15/7/1.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"

@class XTBigImageViewController;

@protocol XTBigImageViewControllerDelegate <NSObject>

@optional
-(void)bigImageViewControllerDidClickedDismissButton:(XTBigImageViewController *)viewController;

-(void)scrollViewDidEndDeceleratingWith:(NSInteger)index;

@end


@interface XTBigImageViewController : XTRootViewController

@property(nonatomic,strong)UIImage *image;

@property(nonatomic,strong)NSArray *pidArr;

//@property(nonatomic,strong)NSDictionary *animationInfo;

@property(nonatomic,strong)NSNumber *topicID;

@property(nonatomic) NSInteger curIndex;

@property(nonatomic,strong) UIImage *placeholderImage;


@property(nonatomic,weak)id <XTBigImageViewControllerDelegate> delegate;


@end
