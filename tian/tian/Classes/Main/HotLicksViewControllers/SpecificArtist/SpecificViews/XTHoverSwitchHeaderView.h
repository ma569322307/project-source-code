//
//  XTSpecificArtistHeaderView.h
//  tian
//
//  Created by huhuan on 15/7/1.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTHotLicksRecsInfo;

/**
 *  header类型：0:专属艺人 1:热点事件
 */
typedef NS_ENUM (NSUInteger, XTHoverSwitchHeaderViewStyle) {
    XTHoverSwitchHeaderViewStyleSpecific = 0,
    XTHoverSwitchHeaderViewStyleHotEvent
};

@interface XTHoverSwitchHeaderView : UIView

@property (nonatomic, weak  ) IBOutlet UIImageView *headerImageView;
@property (nonatomic, assign) BOOL isIntroStatus;
@property (nonatomic, copy  ) void (^pageChangeBlock)(NSInteger index);
@property (nonatomic, assign) float headerHeight;

+ (XTHoverSwitchHeaderView *)hoverHeaderViewWithRecInfo:(XTHotLicksRecsInfo *)recsInfo andHeaderStyle:(XTHoverSwitchHeaderViewStyle)style;

- (void)switchHeaderViewStatus;

@end
