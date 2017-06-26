//
//  XTSelectPhotoViewController.m
//  tian
//
//  Created by 曹亚云 on 15-6-27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSelectPhotoViewController.h"
#import "JKAssetsViewCell.h"
@interface XTSelectPhotoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, JKAssetsViewCellDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (nonatomic, strong) NSMutableArray     *selectedAssetArray;
@end

@implementation XTSelectPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JKAssetsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJKPhotoPickerCellIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    ALAsset *asset = self.assetsArray[indexPath.row-1];
    cell.asset = asset;
    cell.assetIndex = [NSNumber numberWithInteger:indexPath.row-1];
    NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    cell.isSelected = [self assetIsSelected:assetURL];
    
    return cell;
}

#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-20)/3

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4, 6, 4, 6);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


static NSString *kJKPhotoPickerCellIdentifier = @"PhotoPickerCellIdentifier";
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 4.0;
        layout.minimumInteritemSpacing = 4.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height-64) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[JKAssetsViewCell class] forCellWithReuseIdentifier:kJKPhotoPickerCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_collectionView];
        
    }
    return _collectionView;
}

#pragma mark - JKAssetsViewCellDelegate
- (void)startPhotoAssetsViewCell:(JKAssetsViewCell *)assetsCell
{
    
}

- (void)didSelectItemAssetsViewCell:(JKAssetsViewCell *)assetsCell
{
    // Add asset URL
    NSURL *assetURL = [assetsCell.asset valueForProperty:ALAssetPropertyAssetURL];
    [self addAssetsObject:assetURL];
    [self resetFinishFrame];
    assetsCell.isSelected = YES;
}

- (void)didDeselectItemAssetsViewCell:(JKAssetsViewCell *)assetsCell
{
    NSURL *assetURL = [assetsCell.asset valueForProperty:ALAssetPropertyAssetURL];
    [self removeAssetsObject:assetURL];
    [self resetFinishFrame];
    assetsCell.isSelected = NO;
}

- (void)removeAssetsObject:(NSURL *)assetURL
{
    
}

- (void)addAssetsObject:(NSURL *)assetURL
{
    
}

- (BOOL)assetIsSelected:(NSURL *)assetURL
{
    return YES;
}

- (void)resetFinishFrame
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
