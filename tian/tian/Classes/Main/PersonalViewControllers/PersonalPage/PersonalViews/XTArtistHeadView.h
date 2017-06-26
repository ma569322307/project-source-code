//
//  XTArtistHeadView.h
//  tian
//
//  Created by 曹亚云 on 15-6-13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTLabelAndBtnView.h"
#import "XTOrderArtist.h"
@protocol XTArtistHeadViewDelegate <NSObject>
- (void)onClickBtn:(UIButton *)btn;
@end

@interface XTArtistHeadView : UIView
@property (nonatomic, assign) id<XTArtistHeadViewDelegate>delegate;
@property (nonatomic, strong) XTLabelAndBtnView *manitoLabelAndBtnView;
@property (nonatomic, strong) XTLabelAndBtnView *fansLabelAndBtnView;
+ (CGFloat)calculateViewHeight;
- (void)fillUesrInformation:(XTOrderArtist *)artistInfo;
@end
