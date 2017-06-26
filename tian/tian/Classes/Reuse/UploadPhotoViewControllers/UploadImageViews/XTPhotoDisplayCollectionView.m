//
//  XTPhotoDisplayCollectionView.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/22.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTPhotoDisplayCollectionView.h"
#import "JKPhotoBrowserCell.h"
#import "XTLocalPhotoModel.h"
@interface XTPhotoDisplayCollectionView ()<UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@end

@implementation XTPhotoDisplayCollectionView
static NSString * const reuseIdentifier = @"XTPhotoDisplayCollectionViewCell";
+(instancetype)photoDisplayCollectionViewCreateView{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.itemSize = CGSizeMake(55, 55);
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
    XTPhotoDisplayCollectionView *view = [[self alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    view.flowLayout = flow;
    view.dataSource = view;
    [view registerClass:[JKPhotoBrowserCell class] forCellWithReuseIdentifier:reuseIdentifier];
    view.pagingEnabled = YES;
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(void)setPhotos:(NSArray *)photos{
    _photos = photos;
    self.flowLayout.itemSize = self.frame.size;
    [self reloadData];
}

#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JKPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    XTLocalPhotoModel *model = self.photos[indexPath.item];
    cell.photoModel = model;
    return cell;
}
@end

