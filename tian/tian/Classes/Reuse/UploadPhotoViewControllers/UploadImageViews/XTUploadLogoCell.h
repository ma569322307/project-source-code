//
//  XTUploadLogoCell.h
//  tian
//
//  Created by Jiajun Zheng on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTUploadSingleModel,XTUploadLogoCell;
@protocol XTUpLoadLogoCellDelegate <NSObject>
// 长按按钮被触发
-(void)uploadLogoCellDidLongPressed:(XTUploadLogoCell *)uploadLogoCell;
@end

@interface XTUploadLogoCell : UICollectionViewCell
@property (nonatomic, strong) XTUploadSingleModel *single;
@property (nonatomic, weak) id<XTUpLoadLogoCellDelegate> delegate;
@end
