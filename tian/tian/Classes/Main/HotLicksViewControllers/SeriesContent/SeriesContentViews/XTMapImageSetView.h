//
//  XTMapImage.h
//  tian
//
//  Created by loong on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTMapImageSetViewModel;


@interface XTMapImageSetView : UIView

@property(nonatomic,strong)XTMapImageSetViewModel *model;

@property(nonatomic,strong)NSNumber *commentNum;

@property(nonatomic,weak)id  delegate;

-(UIImage *)getImageForShare;

@end
