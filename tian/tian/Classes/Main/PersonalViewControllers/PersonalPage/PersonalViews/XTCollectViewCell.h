//
//  XTCollectViewCell.h
//  tian
//
//  Created by 曹亚云 on 15-6-11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+JKPicker.h"
#import "XTGifFooter.h"
//#define DefaultLoadCount 24
@interface XTCollectViewCell : UICollectionViewCell

- (void)setContentOffset:(CGPoint)point;
- (void)setSlideViewState:(State)state;
- (State)slideViewState;
@end
