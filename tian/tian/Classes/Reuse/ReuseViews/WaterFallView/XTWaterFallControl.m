//
//  XTWaterFallControl.m
//  tian
//
//  Created by cc on 15/6/8.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTWaterFallControl.h"
#import <MJRefresh.h>
#import "RAMCollectionViewCell.h"
#import "RAMCollectionAuxView.h"

#import "XTImageAndTopicCollectionViewCell.h"
#import "XTImageAndDescriptionCollectionViewCell.h"
#import "XTImageAnderUserAvatarCollectionViewCell.h"
#import "XTImageAnderLikeCollectionViewCell.h"

static NSString * const CellIdentifier = @"MyCell";
static NSString * const HeaderIdentifier = @"HeaderIdentifier";

@interface XTWaterFallControl ()<XTImageAnderUserAvatarCollectionViewCellDelegate,XTImageAndTopicCollectionViewCellDelegate,
    XTImageAndDescriptionCollectionViewCellDelegate>



@property (nonatomic, assign) XTWaterFallViewCellType theCellType;

@end
@implementation XTWaterFallControl
- (id)initWithCollectionView:(UICollectionView *)collectionV headerView:(UIView *)headerView refreshType:(XTWaterFallViewRefreshType)refreshType cellType:(XTWaterFallViewCellType)cellType
{
    self = [super init];
    if (self) {
        
        self.headerView = headerView;
        self.theCellType = cellType;
        
        self.collectionViewLayout = [[RAMCollectionViewFlemishBondLayout alloc]init];
        self.collectionViewLayout.delegate = self;
        self.collectionViewLayout.cellType = cellType;
        
        self.collectionView = collectionV;
        self.collectionView.collectionViewLayout = self.collectionViewLayout;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.delaysContentTouches = NO;
        
        switch (cellType) {
            case XTWaterFallViewCellType_imageAndDescription:
            {
                [self.collectionView registerNib:[UINib nibWithNibName:@"XTImageAndDescriptionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
                break;
            }
            case XTWaterFallViewCellType_imageAndUserAvatar:
            {
                
                [self.collectionView registerNib:[UINib nibWithNibName:@"XTImageAnderUserAvatarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
                
                break;
            }
            case XTWaterFallViewCellType_imageAndTopic:
            {
                [self.collectionView registerNib:[UINib nibWithNibName:@"XTImageAndTopicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
                
                break;
            }
            case XTWaterFallViewCellType_imageAndLike:
            {
                [self.collectionView registerNib:[UINib nibWithNibName:@"XTImageAnderLikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
                
                break;
            }
            case XTWaterFallViewCellType_imageAndCollection:
            {
                [self.collectionView registerNib:[UINib nibWithNibName:@"XTImageAnderLikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
                
                break;
            }
            case XTWaterFallViewCellType_other:
            {
                [self.collectionView registerClass:[RAMCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
                break;
            }
            default:
                break;
        }
        
        XTGifHeader *header;
        XTGifFooter *footer;
        if (refreshType & XTWaterFallRefreshType_header) {
            header = [XTGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
        }
        if (refreshType & XTWaterFallRefreshType_footer) {
            footer = [XTGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
        }
        header.lastUpdatedTimeLabel.hidden = YES;//隐藏刷新时间
//        footer.automaticallyRefresh = NO;//手指离开后刷新
        self.collectionView.header = header;
        self.collectionView.footer = footer;
        
    //    if (headerView) {
            [self.collectionView registerClass:[RAMCollectionAuxView class] forSupplementaryViewOfKind:RAMCollectionViewFlemishBondHeaderKind withReuseIdentifier:HeaderIdentifier];
    //    }
        
    }
    return self;
}
/**
 *   刷新view隐藏、显示
 */
- (void)hidenTheHeaderView:(BOOL)hiden
{
    self.collectionView.header.hidden = hiden;
}

- (void)hidenTheFooterView:(BOOL)hiden
{
   self.collectionView.footer.hidden = hiden;
}
#pragma mark - reloadData
- (void)reloadCollectionViewData
{
    RAMCollectionViewFlemishBondLayout *layout = (RAMCollectionViewFlemishBondLayout*)self.collectionView.collectionViewLayout;
    layout.array = self.dataArray;
    [self.collectionView reloadData];
}

- (void)stopWaterViewAnimating
{
    [self.collectionView.footer endRefreshing];
    [self.collectionView.header endRefreshing];
    
}

- (void)waterViewTriggerRefresh
{
    [self.collectionView.header beginRefreshing];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.theCellType) {
        case XTWaterFallViewCellType_imageAndDescription:
        {
            XTImageAndDescriptionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell configureCellWithIndexPath:indexPath andWithModel:self.dataArray[indexPath.item]];
            cell.delegate = self;
            return cell;
            break;
        }
        case XTWaterFallViewCellType_imageAndUserAvatar:
        {
            XTImageAnderUserAvatarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell configureCellWithIndexPath:indexPath andWithModel:self.dataArray[indexPath.item]];
            cell.delegate = self;
            return cell;
            break;
        }
        case XTWaterFallViewCellType_imageAndTopic:
        {
            XTImageAndTopicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell configureCellWithIndexPath:indexPath andWithModel:self.dataArray[indexPath.item]];
            cell.delegate = self;
            return cell;
            break;
        }
        case XTWaterFallViewCellType_imageAndLike:
        {
            XTImageAnderLikeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell configureCellWithIndexPath:indexPath andWithModel:self.dataArray[indexPath.item] withCellType:ImageAnderLikeCollectionView_LikeCellType];
            return cell;
            break;
        }
        case XTWaterFallViewCellType_imageAndCollection:
        {
            XTImageAnderLikeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell configureCellWithIndexPath:indexPath andWithModel:self.dataArray[indexPath.item] withCellType:ImageAnderLikeCollectionView_CollectionCellType];
            return cell;
            break;
        }
        case XTWaterFallViewCellType_other:
        {
            RAMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell configureCellWithIndexPath:indexPath andWithModel:self.dataArray[indexPath.item]];
            return cell;
            break;
        }
        default:
            break;
    }
    return nil;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerV;
    if (kind == RAMCollectionViewFlemishBondHeaderKind) {
        headerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        //赋值
        if (headerV.subviews) {
            for (UIView *v  in headerV.subviews) {
                [v removeFromSuperview];
            }
        }
        [headerV addSubview:self.headerView];
        [self.headerView makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.offset(0);
        }];
    }
    return headerV;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickCellIndexRow:)]) {
        [self.delegate clickCellIndexRow:indexPath.row];
    }
}
#pragma mark - RAMCollectionViewVunityLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(RAMCollectionViewFlemishBondLayout *)collectionViewLayout estimatedSizeForHeaderInSection:(NSInteger)section
{
    //headerView的  宽、高
    if (!self.headerView) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.headerView.bounds));
}



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(collectionViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.delegate collectionViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(collectionViewDidEndDragging:willDecelerate:)]) {
        [self.delegate collectionViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(collectionViewDidEndDecelerating:)]) {
        [self.delegate collectionViewDidEndDecelerating:scrollView];
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(collectionViewDidEndScrollingAnimation:)]) {
        [self.delegate collectionViewDidEndScrollingAnimation:scrollView];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(collectionViewWillBeginDragging:)]) {
        [self.delegate collectionViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewDidScroll:)]) {
        [self.delegate collectionViewDidScroll:scrollView];
    }
}

#pragma mark - 刷新方法
- (void)headerRefreshAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pullToRefresh)]) {
        [self.delegate pullToRefresh];
    }
}
- (void)footerRefreshAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(infiniteScrolling)]) {
        [self.delegate infiniteScrolling];
    }
}
#pragma mark - 点击用户头像
- (void)clickImgAndUserCellUserAvatarBtn:(NSInteger)clickUserId
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickUserAvatarBtn:)]) {
        [self.delegate clickUserAvatarBtn:clickUserId];
    }
}
- (void)clickCellOfTopicBtn:(NSInteger)clickTopicId
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickImgAndTopicCellTopicBtn:)]) {
        [self.delegate clickImgAndTopicCellTopicBtn:clickTopicId];
    }
}

- (void)clickCellTopImage:(NSInteger)clickRow;
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickCellIndexRow:)]) {
        [self.delegate clickCellIndexRow:clickRow];
    }
}
@end
