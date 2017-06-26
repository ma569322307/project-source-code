//
//  XTGuideImageCreateCell.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/8.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTGuideImageCreateCell : UICollectionViewCell
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) void(^closeClickBlock)();
@property (nonatomic, weak) UIButton *knownButton;
@end
