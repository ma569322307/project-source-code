//
//  XTShareCollectionView.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/9.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTShareCollectionView.h"
#import "XTShareCell.h"
#import "XTShareSheet.h"
#import "XTShareModel.h"
@interface XTShareCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionViewFlowLayout *flow;
@end

@implementation XTShareCollectionView
static NSString * const reuseIdentifier = @"XTShareCollectionViewCell";
+(instancetype)shareCollectionViewCreateView{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.minimumInteritemSpacing = kShareCollectionViewInteritemSpacing;
    flow.minimumLineSpacing = kShareCollectionViewLineSpacing;
    XTShareCollectionView *view = [[self alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    view.flow = flow;
    view.dataSource = view;
    view.delegate = view;
    view.backgroundColor = [UIColor clearColor];
    view.scrollEnabled = NO;
    [view registerClass:[XTShareCell class] forCellWithReuseIdentifier:reuseIdentifier];
    return view;
}
-(void)resizeFlow:(CGSize)size{
    self.flow.itemSize = size;
}
-(void)setModelList:(NSArray *)modelList{
    _modelList = modelList;
    [self reloadData];
}
#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XTShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = self.modelList[indexPath.item];
    cell.model.index = indexPath.item;
    cell.btnBlock = self.btnBlock;
    return cell;
}
@end
