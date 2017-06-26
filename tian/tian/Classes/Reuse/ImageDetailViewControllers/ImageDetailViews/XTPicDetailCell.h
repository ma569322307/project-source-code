//
//  XTPicDetailCell.h
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTImgShowModel;
@class XTImgDetailView;
@class XTCommentItemModel;
@protocol XTPicDetailCellDelegate <NSObject>

-(void)tableViewDidSelectedWithCommentsInfo:(XTCommentItemModel *)info;

-(void)imgLoadFinish:(UIImage *)image;

-(void)fatchNextPageFinsih:(NSArray *)arr;

-(void)imgDetailViewTapAction;

@end



@interface XTPicDetailCell : UICollectionViewCell

typedef void(^XTPullDownAction)(CGPoint offset);

@property (nonatomic, copy) XTPullDownAction pullDownAction;



@property(nonatomic,strong) NSArray *dataSource;

@property(nonatomic,weak) id  delegate;

@property(nonatomic)NSInteger index;

@property(nonatomic,strong)NSURL *placeholderImageURL;

-(void)configureDataWithModel:(XTImgShowModel *)model;

@end
