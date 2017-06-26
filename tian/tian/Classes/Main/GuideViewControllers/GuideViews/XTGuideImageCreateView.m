//
//  XTGuideImageCreateView.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/8.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTGuideImageCreateView.h"
#import "XTGuideImageCreateCell.h"
#import <Mantle/EXTScope.h>

@interface XTGuideImageCreateView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, weak) UIButton *knownButton;
@end

@implementation XTGuideImageCreateView
static NSString * const reuseIdentifier = @"ImageCreateCell";
+(instancetype)guideImageCreateView{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.itemSize = kGuideImageCreateItemSize;
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
    XTGuideImageCreateView *view = [[self alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    view.dataSource = view;
    view.delegate = view;
    view.pagingEnabled = YES;
    view.bounces = NO;
    [view registerClass:[XTGuideImageCreateCell class] forCellWithReuseIdentifier:reuseIdentifier];
    view.backgroundColor = [UIColor clearColor];
    view.showsHorizontalScrollIndicator = NO;
    return view;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
-(void)closeClick{
    if ([self.indexDelegate respondsToSelector:@selector(guideImageCreateViewClickClose:)]) {
        [self.indexDelegate guideImageCreateViewClickClose:self];
    }
}
#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XTGuideImageCreateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageName = [NSString stringWithFormat:@"GuideCreateImage%zd",indexPath.item + 1];
    @weakify(self);
    [cell setCloseClickBlock:^{
        @strongify(self);
        if ([self.indexDelegate respondsToSelector:@selector(guideImageCreateViewClickClose:)]) {
            [self.indexDelegate guideImageCreateViewClickClose:self];
        }
    }];
    self.knownButton = cell.knownButton;
    if (indexPath.item == 0) {
        cell.knownButton.hidden = YES;
    }
    return cell;
}
#pragma mark UICollectionViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.x);
    NSInteger page = (NSInteger)scrollView.contentOffset.x / (NSInteger)kGuideImageCreateItemWidth;
    NSLog(@"%f,%f,%zd",scrollView.contentOffset.x,kGuideImageCreateItemWidth,page);
    if ([self.indexDelegate respondsToSelector:@selector(guideImageCreateView:showingCellIndex:)]) {
        [self.indexDelegate guideImageCreateView:self showingCellIndex:page];
    }
    self.knownButton.hidden = page != 2;
}

@end
