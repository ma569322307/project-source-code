//
//  XTBatchSettingPhotoListView.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/13.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTBatchSettingPhotoListView.h"
#import "XTBatchSettingImageCell.h"
#import "XTSubStore.h"
#import "XTPictureInfoModel.h"
#import "XTGifHeader.h"
#import "YYTHUD.h"
#define kBatchItemInteritemSpacing 3.0
#define kBatchItemLineSpacing 3.0
#define kBatchViewInsetLeftAndRight 5.0
#define kBatchColumnNumber 3.0
#define kMaxLoadNumber 40
@interface XTBatchSettingPhotoListView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation XTBatchSettingPhotoListView
static NSString * const reuseIdentifier = @"XTBatchSettingPhotoListViewCell";
+(instancetype)batchSettingPhotoListCreateView{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - (kBatchViewInsetLeftAndRight * 2) - kBatchItemInteritemSpacing * (kBatchColumnNumber - 1)) / kBatchColumnNumber;
    CGFloat itemHeight = itemWidth;
    flow.itemSize = CGSizeMake(itemWidth, itemHeight);
    flow.minimumInteritemSpacing = kBatchItemInteritemSpacing;
    flow.minimumLineSpacing = kBatchItemLineSpacing;
    XTBatchSettingPhotoListView *view = [[self alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    view.dataSource = view;
    view.delegate = view;
    [view registerClass:[XTBatchSettingImageCell class] forCellWithReuseIdentifier:reuseIdentifier];
    view.backgroundColor = [UIColor clearColor];
    view.contentInset = UIEdgeInsetsMake(kBatchItemLineSpacing, kBatchViewInsetLeftAndRight,0, kBatchViewInsetLeftAndRight);
    return view;
}

-(void)setAlbumId:(NSInteger)albumId{
    _albumId = albumId;
    XTGifHeader *header = [XTGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.header = header;
    [self.header beginRefreshing];
}

-(void)loadData{
    //加载数据
    [YYTHUD showLoadingAddedTo:self];
    @weakify(self);
    [[[XTSubStore alloc] init] fetchAlbumPictureListWithAlbumID:self.albumId maxID:0 sinceID:0 completionBlock:^(NSArray *albumDetail, NSError *error) {
        // 清空选择数组
        if (self.selectionBlock) {
            // 传入-1 表示清空数组
            self.selectionBlock(-1);
        }
        [YYTHUD hideLoadingFrom:self];
        //完成回调
        @strongify(self);
        if (error != nil) {
            NSLog(@"%@",error);
            [self.header endRefreshing];
            [YYTHUD showPromptAddedTo:self withText:@"网络出错" withCompletionBlock:^{
                
            }];
            return;
        }
        [self.header endRefreshing];
        //处理返回数据
        NSLog(@"图片列表信息==%zd",[albumDetail count]);
        self.pictureList = [XTPictureInfoModel pictureURLListWithList:albumDetail];
        [self reloadData];
        //需要上拉刷新
        @weakify(self);
        XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
            @strongify(self);
            //开始上拉刷新
            XTPictureInfoModel *model = self.pictureList.lastObject;
            //开始网络请求
            [[[XTSubStore alloc] init] fetchAlbumPictureListWithAlbumID:self.albumId maxID:model.id sinceID:0 completionBlock:^(NSArray *albumDetail, NSError *error) {
                //处理错误
                if (error != nil) {
                    NSLog(@"%@",error);
                    return;
                }
                //如果没有新数据表示不需要上拉刷新
                if (albumDetail.count == 0) {
                    self.footer.hidden = YES;
                    [self.footer noticeNoMoreData];
                    return;
                }
                //添加数据
                [self.pictureList addObjectsFromArray:[XTPictureInfoModel pictureURLListWithList:albumDetail]];
                ///查看当前数目
                NSLog(@"目前数组数目%zd",self.pictureList.count);
                [self reloadData];
                [self.footer endRefreshing];
            }];
        }];
        self.footer = footer;
    }];

}

-(void)setBottomInset:(CGFloat)bottomInset{
    _bottomInset = bottomInset;
    self.contentInset = UIEdgeInsetsMake(kBatchItemLineSpacing, kBatchViewInsetLeftAndRight,bottomInset, kBatchViewInsetLeftAndRight);
}
#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pictureList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XTBatchSettingImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.needButton = self.bottomInset;
    cell.model = self.pictureList[indexPath.item];
    return cell;
}
#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XTPictureInfoModel *model = self.pictureList[indexPath.item];
    model.selected = !model.selected;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    if (self.selectionBlock) {
        self.selectionBlock(indexPath.item);
    }
}
@end
