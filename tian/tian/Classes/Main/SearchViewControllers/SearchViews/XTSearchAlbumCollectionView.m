//
//  XTSearchAlbumCollectionView.m
//  tian
//
//  Created by huhuan on 15/6/15.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchAlbumCollectionView.h"
#import "XTAlbumCollectionViewCell.h"
#import "XTUserCollectionViewLayout.h"
#import "XTAlbumInfo.h"
#import "XTOriginalViewController.h"
#import "UIViewController+Extend.h"

#define kSizeCollectionView  ([UIScreen mainScreen].bounds.size.width-48)/2

@interface XTSearchAlbumCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation XTSearchAlbumCollectionView

static NSString *albumCellIdentifier = @"albumCell";

+ (XTSearchAlbumCollectionView *)albumCollectionViewWithCollectionViewStyle:(XTSearchAlbumCollectionViewStyle)style {

    UICollectionViewFlowLayout *layout = nil;
    if(style == XTSearchAlbumCollectionViewStyleHorizontal) {
        XTUserCollectionViewLayout *horizontalLayout = [[XTUserCollectionViewLayout alloc] initWithContentSize:CGSizeMake(kSizeCollectionView, kSizeCollectionView*1.5)];
        horizontalLayout.minimumLineSpacing = 12.f/320.f*SCREEN_SIZE.width;
        horizontalLayout.minimumInteritemSpacing = 0.0;
        horizontalLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout = horizontalLayout;
    }else if(style == XTSearchAlbumCollectionViewStyleVertical) {
        UICollectionViewFlowLayout *verticalLayout = [[UICollectionViewFlowLayout alloc] init];
        verticalLayout.minimumLineSpacing = 12.f/320.f*SCREEN_SIZE.width;
        verticalLayout.minimumInteritemSpacing = 12.f/320.f*SCREEN_SIZE.width;
        verticalLayout.itemSize = CGSizeMake(kSizeCollectionView, kSizeCollectionView*1.5);
        verticalLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout = verticalLayout;
    }
    
    XTSearchAlbumCollectionView *albumCV = [[XTSearchAlbumCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    albumCV.backgroundColor = [UIColor clearColor];
    albumCV.dataSource = albumCV;
    albumCV.delegate = albumCV;
    albumCV.showsHorizontalScrollIndicator = NO;
    albumCV.showsVerticalScrollIndicator = NO;
    
    [albumCV registerClass:[XTAlbumCollectionViewCell class] forCellWithReuseIdentifier:albumCellIdentifier];
    if(style == XTSearchAlbumCollectionViewStyleHorizontal) {
        albumCV.pagingEnabled = YES;
    }
    return albumCV;
}

- (void)setImageView:(UIImageView *)imageView withImageUrl:(NSURL *)imageUrl{
//    [imageView sd_setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [imageView setImage:image];
//        [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//        [imageView setContentMode:UIViewContentModeScaleAspectFill];
//        [imageView setClipsToBounds:YES];
//        imageView.alpha = 0.0;
//        [UIView animateWithDuration:1.0f animations:^{
//            imageView.alpha = 1.0;
//        }];
//    }];
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [imageView an_setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.albumArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XTAlbumCollectionViewCell *cell = (XTAlbumCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:albumCellIdentifier forIndexPath:indexPath];
    
    cell.secondCoverImageView.image = [UIImage imageNamed:@""];
    cell.thirdCoverImageView.image = [UIImage imageNamed:@""];
    cell.fourthCoverImageView.image = [UIImage imageNamed:@""];
    cell.fifthCoverImageView.image = [UIImage imageNamed:@""];
    
    XTAlbumInfo *item = self.albumArray[indexPath.row];
    [self setImageView:cell.firstCoverImageView withImageUrl:item.cover];
    NSArray *imageViewArray = [NSArray arrayWithObjects:cell.secondCoverImageView, cell.thirdCoverImageView, cell.fourthCoverImageView, cell.fifthCoverImageView, nil];
    for (int index = 0; index < [item.pics count]; index++) {
        
        NSString *imageUrlStr = nil;
        if([[item.pics objectAtIndex:index] isKindOfClass:[NSDictionary class]]) {
            imageUrlStr = [item.pics objectAtIndex:index][@"image"];
        }else {
            imageUrlStr = item.pics[index];
        }
        NSURL *imageUrl = [NSURL URLWithString:imageUrlStr];
        UIImageView *imageView = (UIImageView *)[imageViewArray objectAtIndex:index];
        [self setImageView:imageView withImageUrl:imageUrl];
    }
    cell.secretIconImageView.hidden = !item.type;
    cell.albumNameLabel.text = item.title;
    cell.imageCountLabel.text = [NSString stringWithFormat:@"(%ld)",item.picCount];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd"; //设置日期格式
    cell.albumCreateDateLabel.text = [formatter stringFromDate:item.createTime];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XTAlbumInfo *item = [self.albumArray objectAtIndex:indexPath.row];
    XTOriginalViewController *originalCtr = [[XTOriginalViewController alloc] init];
    originalCtr.type = XTPageTypeOther;
    originalCtr.pictureId = item.id;
    originalCtr.albumInfo = item;
    [[UIViewController topViewController] pushViewController:originalCtr animated:YES];
}

#pragma mark - scrollview Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPage = scrollView.contentOffset.x/(SCREEN_SIZE.width-28);
    if(self.pageNum) {
        self.pageNum([NSString stringWithFormat:@"%d/%@",currentPage+1,@(([self.albumArray count]-1)/2+1)]);
    }
}

@end
