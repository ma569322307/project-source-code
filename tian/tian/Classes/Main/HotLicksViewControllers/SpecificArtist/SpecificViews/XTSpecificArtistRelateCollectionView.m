//
//  XTSpecificArtistRelateCollectionView.m
//  tian
//
//  Created by huhuan on 15/7/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSpecificArtistRelateCollectionView.h"
#import "XTUserCollectionViewLayout.h"
#import "XTHomePageLikeAndHateCollectionViewCell.h"
#import "XTOrderArtist.h"

@interface XTSpecificArtistRelateCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>


@end

@implementation XTSpecificArtistRelateCollectionView

static NSString *artistCellIdentifier = @"artistCell";

+ (XTSpecificArtistRelateCollectionView *)specificArtistRelateCollectionView {
    
    XTUserCollectionViewLayout *horizontalLayout = [[XTUserCollectionViewLayout alloc] initWithContentSize:CGSizeMake(90.f/320.f*SCREEN_SIZE.width, 90)];
    horizontalLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    horizontalLayout.minimumLineSpacing = 12.f/320.f*SCREEN_SIZE.width;
    horizontalLayout.minimumInteritemSpacing = 0.0;
    
    XTSpecificArtistRelateCollectionView *artistCV = [[XTSpecificArtistRelateCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:horizontalLayout];
    artistCV.backgroundColor = [UIColor clearColor];
    artistCV.dataSource = artistCV;
    artistCV.delegate = artistCV;
    artistCV.showsHorizontalScrollIndicator = NO;
    artistCV.showsVerticalScrollIndicator = NO;
    artistCV.pagingEnabled = YES;
    
    [artistCV registerNib:[UINib nibWithNibName:@"XTHomePageLikeAndHateCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:artistCellIdentifier];
    
    return artistCV;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.artistArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XTHomePageLikeAndHateCollectionViewCell *cell = (XTHomePageLikeAndHateCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:artistCellIdentifier forIndexPath:indexPath];
    [cell configureUserCell:self.artistArray[indexPath.row] andCellMode:XTHomePageLikeAndHateCollectionViewModeNormal andIndexPath:indexPath];

    return cell;
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - scrollview Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPage = scrollView.contentOffset.x/(SCREEN_SIZE.width-28);
    if(self.pageNum) {
        self.pageNum([NSString stringWithFormat:@"%d/%@",currentPage+1,@((self.artistArray.count-1)/3+1)]);
    }
}

@end
