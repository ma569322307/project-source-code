//
//  XTSearchTagCollectionView.m
//  tian
//
//  Created by huhuan on 15/6/11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchTopicCollectionView.h"
#import "XTSearchTopicCollectionViewCell.h"
#import "XTSearchTopicModel.h"
#import "UIViewController+Extend.h"
#import "XTTopicIndexViewController.h"

@interface XTSearchTopicCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation XTSearchTopicCollectionView

static NSString *cellIdentifier = @"SearchTopicCell";

+ (XTSearchTopicCollectionView *)searchTopicCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 10.0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    XTSearchTopicCollectionView *searchTagCV = [[XTSearchTopicCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    searchTagCV.backgroundColor = [UIColor clearColor];
    searchTagCV.dataSource = searchTagCV;
    searchTagCV.delegate = searchTagCV;
    searchTagCV.scrollEnabled = NO;
    [searchTagCV registerNib:[UINib nibWithNibName:@"XTSearchTopicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    return searchTagCV;

}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.topicArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XTSearchTopicCollectionViewCell *cell = (XTSearchTopicCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    NSString *topicStr = nil;
    if([self.topicArray[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        topicStr = self.topicArray[indexPath.row][@"title"];
    }else {
        XTSearchTopicModel *topicModel = self.topicArray[indexPath.row];
        topicStr = topicModel.title;
    }
    if(![topicStr hasPrefix:@"#"]) {
        topicStr = [NSString stringWithFormat:@"#%@#", topicStr];
    }
    cell.topicLabel.text = topicStr;
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_SIZE.width/2-20, 50);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XTTopicIndexViewController *topicIndexVC = [[XTTopicIndexViewController alloc] init];
    if([self.topicArray[indexPath.row] isKindOfClass:[XTSearchTopicModel class]]) {
        XTSearchTopicModel *topicModel = (XTSearchTopicModel *)self.topicArray[indexPath.row];
        topicIndexVC.topicId = topicModel.topicId;
        topicIndexVC.topicTitle = topicModel.title;
    }else if([self.topicArray[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        topicIndexVC.topicId = [self.topicArray[indexPath.row][@"id"] integerValue];
        topicIndexVC.topicTitle = self.topicArray[indexPath.row][@"title"];
    }
    
    [[UIViewController topViewController] pushViewController:topicIndexVC animated:YES];
}

@end
