//
//  XTAlbumListCollectionViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-6-5.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTAlbumListCollectionViewCell.h"
#import "XTAlbumCollectionViewCell.h"
#import "XTUserStore.h"
#import "XTSubStore.h"
#import "XTAlbumInfo.h"
#import "YYTHUD.h"
#import "XTOriginalViewController.h"
#define kSizeCollectionView  ([UIScreen mainScreen].bounds.size.width-48)/2

@interface XTAlbumListCollectionViewCell()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) NSInteger pageCount;
@end

static NSString *kCellIdentifier = @"kCellIdentifier";

@implementation XTAlbumListCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        self.backgroundColor = [UIColor whiteColor];
        self.albumInfoItem = [NSMutableArray arrayWithCapacity:0];
        self.pageCount = 0;
        [self slideView];
    }
    
    return self;
}

- (SlideCollectionView *)slideView{
    if (!_slideView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 4.0;
        layout.minimumInteritemSpacing = 16.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _slideView = [[SlideCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _slideView.backgroundView = [[UIView alloc] init];
        _slideView.backgroundView.backgroundColor = [UIColor whiteColor];
        _slideView.backgroundColor = [UIColor whiteColor];        
        _slideView.delegate = self;
        _slideView.dataSource = self;
        _slideView.showsHorizontalScrollIndicator = YES;
        _slideView.showsVerticalScrollIndicator = YES;
        _slideView.pagingEnabled = NO;
        [_slideView registerClass:[XTAlbumCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
        [self addSubview:_slideView];
        
        [_slideView makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(@0);
            make.left.offset(@0);
            make.right.offset(@0);
            make.height.equalTo(self);
        }];
    }
    return _slideView;
}

- (void)loadUserAlbumListNewDataWithCompletionBlock:(void(^)(NSError *error))completionBlock
{
    // 没有回调表示是普通刷新，有回调表示是下拉刷新不需要提示框
    if (!completionBlock) {
        [YYTHUD showLoadingNoLockFreeCenterAddedTo:self];
    }
    XTSubStore *subStore = [[XTSubStore alloc] init];
    NSString *userId = self.userID;
    
    @weakify(self);
    [subStore fetchUserAlbumFromUserId:[userId integerValue]
                              Location:0
                                length:DefaultLoadCount
                       completionBlock:^(NSArray *albumItems, NSError *error) {
                           @strongify(self);
                           if (!error) {
                               [UIViewController UserHomePageController].isRefreshAlbumList = NO;
                               [YYTBlankView hideFromView:self];
                               [self.albumInfoItem removeAllObjects];
                               [self.albumInfoItem addObjectsFromArray:albumItems];
                               [self.slideView reloadData];
                               if ([albumItems count] == 0) {
                                   self.slideView.footer.hidden = YES;
                                   YYTBlankView *blankView = [YYTBlankView showBlankInView:self style:YYTBlankViewStyleBlank eventClick:nil];
                                   if ([self.userID isEqualToString:[XTUserStore sharedManager].user.userID]) {
                                       blankView.tipString = @"饭盆空空，求喂（chuan）食（tu）";
                                   }else{
                                       blankView.tipString = @"这只汪可能是懒吧";
                                   }
                               }else{
                                   self.pageCount = 1;
                                   if (!self.slideView.footer) {
                                       @weakify(self);
                                       self.slideView.footer = [XTGifFooter footerWithRefreshingBlock:^{
                                           @strongify(self);
                                           [self loadUserAlbumListMoreData];
                                       }];
                                   }
                                   self.slideView.footer.hidden = NO;
                               }
                               if (completionBlock) {
                                   completionBlock(nil);
                               }
                           }else if (completionBlock) {
                               // 完成的回调失败不作处理
                               completionBlock(error);
                           }else{
                               YYTBlankView *blankView = [YYTBlankView showBlankInView:self style:YYTBlankViewStyleNetworkError eventClick:^{
                                   [self loadUserAlbumListNewDataWithCompletionBlock:nil];
                               }];
                               blankView.error = error;
                           }
                           [self.slideView.footer endRefreshing];
                           [YYTHUD hideLoadingFrom:self];
                       }];
}

- (void)loadUserAlbumListMoreData
{
    XTSubStore *subStore = [[XTSubStore alloc] init];
    NSString *userId = self.userID;
    
    @weakify(self);
    [subStore fetchUserAlbumFromUserId:[userId integerValue]
                              Location:self.pageCount*DefaultLoadCount
                                length:DefaultLoadCount
                       completionBlock:^(NSArray *albumItems, NSError *error) {
                           @strongify(self);
                           if (!error && [albumItems count] > 0) {
                               self.slideView.footer.hidden = NO;
                               self.pageCount += 1;
                               @weakify(self);
                               //数据去重
                               [self.albumInfoItem addObjectsFromArray:albumItems withCheckKey:@"id" completionBlock:^{
                                   @strongify(self);
                                   [self.slideView reloadData];
                               }];
//                               [self.albumInfoItem addObjectsFromArray:albumItems];
//                               [self.slideView reloadData];
                           }else if (!error && [albumItems count] == 0){
                               self.slideView.footer.hidden = YES;
                           }
                           [self.slideView.footer endRefreshing];
                       }];
}

- (void)updateAlbumList{
    [self loadUserAlbumListNewDataWithCompletionBlock:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.albumInfoItem count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XTAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.secondCoverImageView.image = [UIImage imageNamed:@"placeholderImage1"];
    cell.thirdCoverImageView.image = [UIImage imageNamed:@"placeholderImage2"];
    cell.fourthCoverImageView.image = [UIImage imageNamed:@"placeholderImage3"];
    cell.fifthCoverImageView.image = [UIImage imageNamed:@"placeholderImage4"];
    
    XTAlbumInfo *item = [self.albumInfoItem objectAtIndex:indexPath.row];
    [self setImageView:cell.firstCoverImageView withImageUrl:item.cover];
    
    NSArray *imageViewArray = [NSArray arrayWithObjects:cell.secondCoverImageView, cell.thirdCoverImageView, cell.fourthCoverImageView, cell.fifthCoverImageView, nil];
    for (int index = 0; index < [item.pics count]; index++) {
        NSString *imageUrlStr = [item.pics objectAtIndex:index];
        NSURL *imageUrl = [NSURL URLWithString:imageUrlStr];
        UIImageView *imageView = (UIImageView *)[imageViewArray objectAtIndex:index];
        [self setImageView:imageView withImageUrl:imageUrl];
    }
    cell.secretIconImageView.hidden = !item.type;
    cell.albumNameLabel.text = item.title;
    cell.imageCountLabel.text = [NSString stringWithFormat:@"(%zd)",item.picCount];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd"; //设置日期格式
    cell.albumCreateDateLabel.text = [formatter stringFromDate:item.createTime];
    
    return cell;
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


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeCollectionView, kSizeCollectionView*1.5);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 16, 10, 16);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)[indexPath row]);
    XTAlbumInfo *item = [self.albumInfoItem objectAtIndex:indexPath.row];
    XTOriginalViewController *originalCtr = [[XTOriginalViewController alloc] init];
    originalCtr.type = XTPageTypeOther;
    originalCtr.pictureId = item.id;
    [[UIViewController topViewController] pushViewController:originalCtr animated:YES];
}

- (void)setContentOffset:(CGPoint)point{
    [self.slideView setContentOffset:point animated:YES];
}

- (void)setSlideViewState:(State)state{
    self.slideView.tState = state;
}

- (State)slideViewState{
    return self.slideView.tState;
}

@end
