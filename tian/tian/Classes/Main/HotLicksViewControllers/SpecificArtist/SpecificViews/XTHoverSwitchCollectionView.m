//
//  XTSpecificArtistSwitchCollectionView.m
//  tian
//
//  Created by huhuan on 15/7/2.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHoverSwitchCollectionView.h"
#import "XTHotLicksCommonArtistTableView.h"
#import "XTSpecificCommentTableView.h"
#import "XTHotLicksCommonArtistInfo.h"
#import "XTCommentsModel.h"

@interface XTHoverSwitchCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) XTHotLicksCommonArtistTableView *artistTableView;
@property (nonatomic, strong) XTSpecificCommentTableView *commentTableView;

@property (nonatomic, assign) float headerHeight;
@property (nonatomic, strong) UIView *controllerHeaderView;

@property (nonatomic, assign) BOOL isSwitching;

@end

@implementation XTHoverSwitchCollectionView

static NSString *cellObserverContext = @"cellObserverContext";
static NSString *cellIdentifier      = @"SpecificArtistSwitchCell";
static BOOL needHang = NO;

+ (XTHoverSwitchCollectionView *)hoverSwitchCollectionViewWithHeaderHeight:(float)height  andHeaderView:(UIView *)headerView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    XTHoverSwitchCollectionView *hoverCV = [[XTHoverSwitchCollectionView alloc] initWithFrame:CGRectMake(0., 0., SCREEN_SIZE.width, SCREEN_SIZE.height) collectionViewLayout:layout];
    [hoverCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    hoverCV.backgroundColor                = [UIColor clearColor];
    hoverCV.dataSource                     = hoverCV;
    hoverCV.delegate                       = hoverCV;
    hoverCV.pagingEnabled                  = YES;
    hoverCV.showsHorizontalScrollIndicator = NO;
    hoverCV.isSwitching                    = NO;
    hoverCV.headerHeight                   = height;
    hoverCV.controllerHeaderView           = headerView;
    
    UICollectionViewFlowLayout *tempLayout = (id)hoverCV.collectionViewLayout;
    tempLayout.itemSize = hoverCV.frame.size;
    return hoverCV;
}

- (XTHotLicksCommonArtistTableView *)artistTableView {
    if(!_artistTableView) {
        _artistTableView = [XTHotLicksCommonArtistTableView commonArtistTableView];
        _artistTableView.contentInset = UIEdgeInsetsMake(self.headerHeight+5, 0., 0., 0.);
        _artistTableView.alwaysBounceVertical = YES;
        [_artistTableView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&cellObserverContext];
        
        @weakify(self);
        _artistTableView.footer = [XTGifFooter footerWithRefreshingBlock:^{
            @strongify(self);
            if(self.basicTableViewLoadMore) {
                self.basicTableViewLoadMore();
            }
        }];

    }
    return _artistTableView;
}

- (XTSpecificCommentTableView *)commentTableView {
    if(!_commentTableView) {
        _commentTableView = [XTSpecificCommentTableView specificCommentTableView];
        _commentTableView.contentInset = UIEdgeInsetsMake(self.headerHeight, 0., 50., 0.);
        _commentTableView.alwaysBounceVertical = YES;
        [_commentTableView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&cellObserverContext];
        @weakify(self);
        
        _commentTableView.footer = [XTGifFooter footerWithRefreshingBlock:^{
            @strongify(self);
            if(self.commentTableViewLoadMore) {
                self.commentTableViewLoadMore();
            }
        }];
    }
    return _commentTableView;
}

- (void)configureSwitchCollectionView {
    self.artistTableView.commonArtistModel = self.artistInfo;
    [self.artistTableView configureArtistTableView];
    [self.artistTableView reloadData];
    if([self.commentInfo.pk count] > 0) {
        self.commentTableView.tableViewStyle = XTSpecificCommentTableViewStyleHeader;
    }else {
        self.commentTableView.tableViewStyle = XTSpecificCommentTableViewStyleDefault;
    }
    self.commentTableView.belongId = self.belongId;
    self.commentTableView.commentModel = self.commentInfo;
    [self.commentTableView configureCommentTableView];
}

- (void)switchCollectViewToIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self adjustCollectViewOffset];
    
}

- (void)adjustCollectViewOffset {
    self.isSwitching = YES;
    CGFloat headerViewDisplayHeight = self.controllerHeaderView.frame.size.height + self.controllerHeaderView.frame.origin.y;
    if(self.artistTableView.contentOffset.y < -60) {
        [self.artistTableView setContentOffset:CGPointMake(0, -headerViewDisplayHeight)];
    }
    if(self.commentTableView.contentOffset.y < -60) {
        [self.commentTableView setContentOffset:CGPointMake(0, -headerViewDisplayHeight)];
    }
    self.isSwitching = NO;
}

- (void)refreshBasicTableViewIsLastLoad:(BOOL)isLastLoad {
    [self.artistTableView.footer endRefreshing];
    [self.artistTableView reloadData];
    if(isLastLoad) {
        self.artistTableView.footer.hidden = YES;
    }
}
- (void)refreshCommentTableViewIsLastLoad:(BOOL)isLastLoad {
    [self.commentTableView.footer endRefreshing];
    [self.commentTableView reloadData];
    if(isLastLoad) {
        self.commentTableView.footer.hidden = YES;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];

    if(indexPath.row == 0) {
        [cell.contentView addSubview:self.artistTableView];
    }else if (indexPath.row == 1) {
        [cell.contentView addSubview:self.commentTableView];
    }
    return cell;
    
}

#pragma mark - obsever delegate methods

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &cellObserverContext) {
        if(self.isSwitching) {
            return;
        }
        CGPoint offset             = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGPoint oldOffset          = [change[NSKeyValueChangeOldKey] CGPointValue];
        CGFloat oldOffsetY         = oldOffset.y;
        CGFloat deltaY             = offset.y - oldOffsetY;
        CGFloat offsetYWithSegment = offset.y;

        CGRect headerViewFrame     = self.controllerHeaderView.frame;
        CGFloat headerViewHeight   = headerViewFrame.size.height;
        CGFloat temp               = headerViewHeight+headerViewFrame.origin.y;
        
        if(deltaY >= 0) {    //向上
            if(!needHang) {
                if(temp <= 60) {
                    
                    if(ABS(self.headerOriginYConstraint.constant) - ABS(-(self.headerHeight - 60.f)) > 1) {
                        self.headerOriginYConstraint.constant = -(self.headerHeight - 60.f);
                        needHang = YES;
                    }
                }else {
                    self.headerOriginYConstraint.constant -= deltaY;
                }
            }
            
        }else {            //向下
            if (temp < -offsetYWithSegment) {
                self.headerOriginYConstraint.constant -= deltaY;
                needHang = NO;
            }
        }
  
    }
}

#pragma mark - scrollview Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self adjustCollectViewOffset];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x/(SCREEN_SIZE.width);
    if(self.pageChangeBlock) {
        self.pageChangeBlock(currentPage);
    }
}

-(void)dealloc
{
    needHang = NO;
    [self.artistTableView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    [self.commentTableView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
}

@end
