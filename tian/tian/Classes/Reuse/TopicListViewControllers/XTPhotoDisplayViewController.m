//
//  XTPhotoDisplayViewController.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/22.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTPhotoDisplayViewController.h"
#import "XTLocalPhotoModel.h"
#import "XTPhotoDisplayCollectionView.h"
@interface XTPhotoDisplayViewController ()<UICollectionViewDelegate>
/// 完成按钮
@property (nonatomic, strong) UIButton *doneButton;
/// 展示图片
@property (nonatomic, strong) XTPhotoDisplayCollectionView *collectionView;

@property (nonatomic, strong) UIView   *topView;

@property (nonatomic, strong) UILabel  *numberLabel;
@property (nonatomic, strong) UIButton    *checkButton;

@property (nonatomic, strong) NSMutableArray *indexArray;
@end

@implementation XTPhotoDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加约束
    [self addConstrains];
    self.view.backgroundColor = UIColorFromRGB(0x282828);
}
- (void)viewDidLayoutSubviews{
    self.collectionView.photos = self.photos;
    [self reloadPhotoeData];
}

- (void)addConstrains{
    @weakify(self);
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view.top).with.offset(@0);
        make.bottom.equalTo(self.view.bottom).with.offset(@-0);
        make.left.equalTo(self.view.left).with.offset(@-10);
        make.right.equalTo(self.view.right).with.offset(@10);
    }];
    
    [self.doneButton makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.bottom.equalTo(self.view).with.offset(@-5);
    }];
    [self topView];
}

- (void)doneClick{
    if (self.completionBlock) {
        self.completionBlock(self.indexArray);
    }
    [self closePhotoBrower];
}

- (void)closePhotoBrower{
    [self dismissViewControllerAnimated:YES completion:nil];
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
- (void)didScrollToPage:(int)page
{
    self.currentPage = page;
    [self updateStatus];
}

- (void)updateStatus
{
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/%lu",(long)(_currentPage+1),(unsigned long)[self.photos count]];
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/%lu",(long)(_currentPage+1),(unsigned long)[self.photos count]];
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

- (void)reloadPhotoeData
{
    [self.collectionView setContentOffset:CGPointMake(self.currentPage*CGRectGetWidth(self.collectionView.frame), 0) animated:NO];
    [self updateStatus];
    [self.collectionView reloadData];
}
#pragma mark UICollectionView代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    float itemWidth = CGRectGetWidth(self.collectionView.frame);
    if (offsetX >= 0){
        int page = offsetX / itemWidth;
        [self didScrollToPage:page];
    }
}

#pragma mark 懒加载
-(UIButton *)doneButton
{
    if (_doneButton == nil) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setImage:[UIImage imageNamed:@"upload_done"] forState:UIControlStateNormal];
        [_doneButton setImage:[UIImage imageNamed:@"upload_done_sel"] forState:UIControlStateHighlighted];
        [_doneButton addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_doneButton];
    }
    return _doneButton;
}
-(XTPhotoDisplayCollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [XTPhotoDisplayCollectionView photoDisplayCollectionViewCreateView];
        _collectionView.delegate = self;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(floor((CGRectGetWidth(self.view.frame)-100)/2), 32, 100, 20)];
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
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
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
        _checkButton.xtright = self.view.xtwidth-10;
        _checkButton.xtcenterY = button.xtcenterY;
        _checkButton.selected = YES;
        [_topView addSubview:_checkButton];
        
        [self.view addSubview:_topView];
    }
    return _topView;
}
- (NSMutableArray *)indexArray
{
    if (_indexArray == nil) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}
@end
