//
//  XTBigImageViewCell.h
//  tian
//
//  Created by loong on 15/7/2.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTOriginImgModel;

@protocol XTBigImageViewCellDelegate <NSObject>

-(void)scrollActionWithOriginalImg:(BOOL)isExists andCurImg:(UIImage *)image;

@end



@interface XTBigImageViewCell : UICollectionViewCell

//@property(nonatomic,strong)XTOriginImgModel *model;

@property(nonatomic,weak)id <XTBigImageViewCellDelegate> delegate;


-(void)configureOriginalImg:(NSURL *)imgUrl existsBlock:(void(^)())exists;


-(void)configureModel:(XTOriginImgModel *)model andPlaceholderImage:(UIImage *)image;


@end
