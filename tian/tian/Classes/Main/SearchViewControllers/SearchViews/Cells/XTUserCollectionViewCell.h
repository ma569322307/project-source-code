//
//  XTUserFavorateCollectionViewCell.h
//  tian
//
//  Created by huhuan on 15/6/11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTUserCollectionView;
/**
 *  用户Cell类型：0、默认，只有姓名 1、标签加性别 2、粉丝数
 */
typedef NS_ENUM (NSUInteger, XTUserCollectionViewCellStyle) {
    XTUserCollectionViewCellStyleDefault = 0,
    XTUserCollectionViewCellStyleTagAndSex,
    XTUserCollectionViewCellStyleFans
};

/**
 *  cellButton类型：0:喜欢 1:嫌弃 2:关注
 */
typedef NS_ENUM (NSUInteger, XTUserCollectionViewCellButtonStyle) {
    XTUserCollectionViewCellButtonStyleLike = 0,
    XTUserCollectionViewCellButtonStyleHate,
    XTUserCollectionViewCellButtonStyleFollow,
    XTUserCollectionViewCellButtonStyleRemove
};

@protocol XTUserCollectionViewCellDelegate <NSObject>
-(BOOL)sholdChangeInfo;
@end
@interface XTUserCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) XTUserCollectionViewCellStyle       cellStyle;
@property (nonatomic, assign) XTUserCollectionViewCellButtonStyle buttonStyle;
@property (nonatomic, strong) XTUserCollectionView                *userCollectionView;
@property (nonatomic, assign) BOOL        isArtist;
@property (nonatomic, strong) NSIndexPath *cellIndexPath;
@property (nonatomic, copy  ) NSString    *buttonNormalTitle;
@property (nonatomic, copy  ) NSString    *buttonSelectedTitle;
@property (nonatomic, copy)   void (^buttonClick)(MTLModel *userModel, BOOL isSelected, NSIndexPath *indexPath);
@property (nonatomic, copy)   void (^transferModelSave)(MTLModel *userModel, NSIndexPath *indexPath);
@property (nonatomic, weak) id<XTUserCollectionViewCellDelegate> infoDelegate;

- (void)configureUserCell:(MTLModel *)userModel;
- (void)changeButtonStatus;

@end
