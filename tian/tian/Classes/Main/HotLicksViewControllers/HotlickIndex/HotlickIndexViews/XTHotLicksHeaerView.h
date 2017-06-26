//
//  XTHotLicksHeaerView.h
//  tian
//
//  Created by 尚毅 杨 on 15/5/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTHotLicksInfo;

@protocol XTHotLicksHeaderViewDelegate <NSObject>

@optional
- (void)clickBannerBtn;
- (void)clickRecsWithIndex:(NSInteger)index;
- (void)clickMyTopicBtn;
/**
 *   排行榜  tag = 300+...
 */
- (void)clickRankBtn:(UIButton *)sender;
/**
 *   热门话题  tag = 200+...
 */
- (void)clickTopicBtn:(UIButton *)sender;
@end

@interface XTHotLicksHeaerView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) CGFloat thehieght;
@property (nonatomic, strong) XTHotLicksInfo *hotLicksinfo;
@property (nonatomic, assign) int recsCurrentPage;
@property (nonatomic, strong) UILabel * pageLabel;
@property (nonatomic, weak)id<XTHotLicksHeaderViewDelegate> delegate;

- (id)initWithHotLicksInfo:(XTHotLicksInfo *)HLinfo;
@end
