//
//  XTSpecificArtistTableView.h
//  tian
//
//  Created by huhuan on 15/7/1.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTHotLicksCommonArtistInfo.h"
#import "XTTapTableView.h"

@interface XTHotLicksCommonArtistTableView : XTTapTableView

@property (nonatomic, strong) XTHotLicksCommonArtistInfo *commonArtistModel;

+ (XTHotLicksCommonArtistTableView *)commonArtistTableView;

- (void)configureArtistTableView;

@end
