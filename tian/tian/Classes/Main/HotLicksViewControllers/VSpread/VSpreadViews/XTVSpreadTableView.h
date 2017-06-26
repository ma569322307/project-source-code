//
//  XTVSpreadHeaderTableView.h
//  tian
//
//  Created by huhuan on 15/7/7.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTHotLicksCommonArtistInfo;

@interface XTVSpreadTableView : UITableView

@property (nonatomic, strong) XTHotLicksCommonArtistInfo *artistInfo;

+ (XTVSpreadTableView *)spreadTableView;

- (void)configureSpreadTableView;

- (float)tableViewHeight;

@end
