 //
//  JKPhotoBrowser.m
//  JKPhotoBrowser
//
//  Created by Jecky on 14/12/29.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

#import "JKPhotoBrowser.h"
#import "JKPhotoBrowserCell.h"
#import "UIView+JKPicker.h"
#import "JKUtil.h"
#import "JKPromptView.h"

@interface JKPhotoBrowser() <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView   *topView;

@property (nonatomic, strong) UILabel  *numberLabel;
@property (nonatomic, strong) UIButton    *checkButton;
/// 完成按钮
@property (nonatomic, strong) UIButton *doneButton;
/// 当前页面选择索引
@property (nonatomic, strong) NSMutableArray *indexArray;

@end

static NSString *kJKPhotoBrowserCellIdentifier = @"kJKPhotoBrowserCellIdentifier";

@implementation JKPhotoBrowser

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [JKUtil getColor:@"282828"];
        self.autoresizesSubviews = YES;
        [self collectionView];
        [self topView];
        [self addConstrains];
    }
    return self;
}
- (void)addConstrains{
    @weakify(self);
    [self.doneButton makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.bottom.equalTo(self).with.offset(@-5);
    }];
}
- (void)doneClick{
    [self hide:YES];
    // 索引排序
    [self.indexArray sortUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        return obj1.integerValue < obj2.integerValue;
    }];
    if ([self.delegate respondsToSelector:@selector(photoBrowserDidClickDoneButton:withDeleteIndexArray:)]) {
        [self.delegate photoBrowserDidClickDoneButton:self withDeleteIndexArray:self.indexArray];
    }
}
- (void)closePhotoBrower
{
    [self hide:YES];
}
- (void)photoDidChecked{
    [self savingIndex:self.currentPage];
}
-(void)savingIndex:(NSInteger)index{
    //判断当前索引是否存在
    for (NSNumber *i in self.indexArray) {
        if (i.integerValue == index) {
            [self.indexArray removeObject:i];
            self.checkButton.selected = YES;
            return;
        }
    }
    [self.indexArray addObject:@(index)];
    self.checkButton.selected = NO;
}

- (void)updateStatus
{
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/%lu",(long)(_currentPage+1),(unsigned long)[self.assetsArray count]];
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/%lu",(long)(_currentPage+1),(unsigned long)[self.assetsArray count]];
    [self checkSelectedWithIndex:self.currentPage];
}

- (void)checkSelectedWithIndex:(NSInteger)index{
    //判断当前索引是否存在
    for (NSNumber *i in self.indexArray) {
        if (i.integerValue == index) {
            self.checkButton.selected = NO;
            return;
        }
    }
    self.checkButton.selected = YES;
}

//- (void)photoDidChecked
//{
//    if ((!self.checkButton.selected) && (self.pickerController.selectedAssetArray.count>(self.pickerController.maximumNumberOfSelection - self.pickerController.alreadySelectedNumber - 1))) {
//        NSString  *str = [NSString stringWithFormat:@"最多选择%zd张照片",self.pickerController.maximumNumberOfSelection];
//        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:str withCompletionBlock:nil];
//        return;
//    }
//    
//    if (self.checkButton.selected) {
//        if ([_delegate respondsToSelector:@selector(photoBrowser:didDeselectAtIndex:)]) {
//            switch (self.type) {
//                case JKPhotoBrowserTypeSelected:{
//                    [_delegate photoBrowser:self didDeselectAtIndex:[[self.assetsIndexArray objectAtIndex:self.currentPage] integerValue]];
//                }
//                    break;
//                default:{
//                    [_delegate photoBrowser:self didDeselectAtIndex:self.currentPage];
//                }
//                    break;
//            }
//        }
//    }else{
//        if ([_delegate respondsToSelector:@selector(photoBrowser:didSelectAtIndex:)]) {
//            switch (self.type) {
//                case JKPhotoBrowserTypeSelected:{
//                    [_delegate photoBrowser:self didSelectAtIndex:[[self.assetsIndexArray objectAtIndex:self.currentPage] integerValue]];
//                }
//                    break;
//                default:{
//                    [_delegate photoBrowser:self didSelectAtIndex:self.currentPage];
//                }
//                    break;
//            }
//        }
//    }
//    
//    self.checkButton.selected = !self.checkButton.selected;
////    // 判断是否可以点击
////    if ([self.delegate respondsToSelector:@selector(photoBrowserCheckDoneEnable:)]) {
////        self.doneButton.enabled = [self.delegate photoBrowserCheckDoneEnable:self];
////    }
//}

- (void)show:(BOOL)animated
{
    if (animated){
        self.xttop = [UIScreen mainScreen].bounds.size.height;
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.xttop = 0;
                         }
                         completion:^(BOOL finished) {
                             [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                         }];
        
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}

- (void)hide:(BOOL)animated
{
    if (animated){
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.xttop = [UIScreen mainScreen].bounds.size.height;
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }
    else{
        [self removeFromSuperview];
    }
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JKPhotoBrowserCell *cell = (JKPhotoBrowserCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kJKPhotoBrowserCellIdentifier forIndexPath:indexPath];
    cell.asset = [self.assetsArray objectAtIndex:indexPath.row];
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.bounds.size.width+20, self.bounds.size.height);
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    float itemWidth = CGRectGetWidth(self.collectionView.frame);
    if (offsetX >= 0){
        int page = offsetX / itemWidth;
        [self didScrollToPage:page];
    }
}

- (void)didScrollToPage:(int)page
{
    _currentPage = page;
    [self updateStatus];
}

- (BOOL)assetIsSelected:(NSURL *)assetURL
{
    for (JKAssets *asset in self.pickerController.selectedAssetArray) {
        if ([assetURL isEqual:asset.assetPropertyURL]) {
            return YES;
        }
    }
    return NO;
}


- (void)reloadPhotoeData
{
    [self.collectionView setContentOffset:CGPointMake(_currentPage*CGRectGetWidth(self.collectionView.frame), 0) animated:NO];
    [self updateStatus];
    [self.collectionView reloadData];
}


//- (void)updateStatus
//{
//    self.numberLabel.text = [NSString stringWithFormat:@"%lu/%lu",(long)(_currentPage+1),(unsigned long)[self.assetsArray count]];
//    self.numberLabel.text = [NSString stringWithFormat:@"%lu/%lu",(long)(_currentPage+1),(unsigned long)[self.assetsArray count]];
//    
//    ALAsset  *asset = [self.assetsArray objectAtIndex:_currentPage];
//    NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
//    self.checkButton.selected = [self assetIsSelected:assetURL];
//}

#pragma mark - setter
- (void)setAssetsArray:(NSMutableArray *)assetsArray{
    if (_assetsArray != assetsArray) {
        _assetsArray = assetsArray;
        
        [self reloadPhotoeData];
    }
}

#pragma mark - getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, self.bounds.size.width+20, self.bounds.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[JKPhotoBrowserCell class] forCellWithReuseIdentifier:kJKPhotoBrowserCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:_collectionView];
        
    }
    return _collectionView;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(floor((CGRectGetWidth(self.frame)-100)/2), 32, 100, 20)];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont systemFontOfSize:17.0f];
        _numberLabel.text = @"0/0";
    }
    return _numberLabel;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 64)];
        _topView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        [_topView addSubview:self.numberLabel];
        
        UIImage  *img = [UIImage imageNamed:@"na_back"];
        UIImage  *imgHigh = [UIImage imageNamed:@"na_back_sel"];
        UIButton  *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 20+floor((44-img.size.height)/2), img.size.width, img.size.height);
        [button setBackgroundImage:img forState:UIControlStateNormal];
        [button setBackgroundImage:imgHigh forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(closePhotoBrower) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:button];
        
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage  *img1 = [UIImage imageNamed:@"upload_check_default"];
        UIImage  *imgH = [UIImage imageNamed:@"upload_check_selected"];
        _checkButton.frame = CGRectMake(0, 0, img1.size.width + 20, img1.size.height + 20);
        [_checkButton setImage:img1 forState:UIControlStateNormal];
        [_checkButton setImage:imgH forState:UIControlStateSelected];
        [_checkButton addTarget:self action:@selector(photoDidChecked) forControlEvents:UIControlEventTouchUpInside];
        _checkButton.exclusiveTouch = YES;
        _checkButton.xtright = self.xtwidth-10;
        _checkButton.xtcenterY = button.xtcenterY;
        [_topView addSubview:_checkButton];
        
        [self addSubview:_topView];
    }
    return _topView;
}
-(UIButton *)doneButton
{
    if (_doneButton == nil) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setImage:[UIImage imageNamed:@"upload_done"] forState:UIControlStateNormal];
        [_doneButton setImage:[UIImage imageNamed:@"upload_done_sel"] forState:UIControlStateHighlighted];
        [_doneButton addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_doneButton];
    }
    return _doneButton;
}
-(NSMutableArray *)indexArray
{
    if (_indexArray == nil) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}
@end
