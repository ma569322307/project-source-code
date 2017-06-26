//
//  XTAlbumsOfPicView.h
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTAlbumModel;

@protocol XTAlbumsOfPicViewDelegate <NSObject>

@optional
-(void)tapAction:(XTAlbumModel *)model;

@end

@interface XTAlbumsOfPicView : UIView


@property(nonatomic,strong)XTAlbumModel *model;

@property(nonatomic,weak)id <XTAlbumsOfPicViewDelegate> delegate;

@property(weak,nonatomic) IBOutlet NSLayoutConstraint *heightConstraints;

@end
