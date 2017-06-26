//
//  XTSearchTagCollectionView.m
//  tian
//
//  Created by huhuan on 15/6/11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchTagCollectionView.h"
#import "XTSearchTagCollectionViewCell.h"
#import "XTSearchTagCollectionLayout.h"
#import "XTPhotosListViewController.h"
#import "UIViewController+Extend.h"

@interface XTSearchTagCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation XTSearchTagCollectionView

static NSString *cellIdentifier = @"SearchTopicCell";

+ (XTSearchTagCollectionView *)searchTagCollectionView {
    XTSearchTagCollectionLayout *layout = [[XTSearchTagCollectionLayout alloc] init];
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 10.0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    XTSearchTagCollectionView *searchTagCV = [[XTSearchTagCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    searchTagCV.backgroundColor = [UIColor clearColor];
    searchTagCV.dataSource = searchTagCV;
    searchTagCV.delegate = searchTagCV;
    searchTagCV.scrollEnabled = NO;
    [searchTagCV registerNib:[UINib nibWithNibName:@"XTSearchTagCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    return searchTagCV;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tagArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XTSearchTagCollectionViewCell *cell = (XTSearchTagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.tagLabel.text = self.tagArray[indexPath.row][@"title"];
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tagString = [self.tagArray objectAtIndex:indexPath.row][@"title"];
    return CGSizeMake(([tagString length]-1) * 10 + 50, 40);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XTPhotosListViewController *listVC = [[XTPhotosListViewController alloc] init];
    if([self.tagArray[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        listVC.titleString = self.tagArray[indexPath.row][@"title"];
    }else {
        listVC.titleString = self.tagArray[indexPath.row];
    }
    
    listVC.type = XTphotosListLabelType;
    [[UIViewController topViewController] pushViewController:listVC animated:YES];
}

@end
