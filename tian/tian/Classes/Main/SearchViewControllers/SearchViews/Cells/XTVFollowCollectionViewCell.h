//
//  XTArtistFollowCollectionViewCell.h
//  tian
//
//  Created by huhuan on 15/6/15.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTOrderArtist;

@interface XTVFollowCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy)   void (^buttonClick)(XTOrderArtist *artistModel, BOOL isSelected);

- (void)configureArtistCell:(XTOrderArtist *)artistModel;

@end
