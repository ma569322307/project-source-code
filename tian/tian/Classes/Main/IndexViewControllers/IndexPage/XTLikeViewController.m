//
//  XTLikeViewController.m
//  tian
//
//  Created by cc on 15/6/15.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTLikeViewController.h"
#import "XTHomePageStore.h"
#import "XTImgDetailViewController.h"
#import "XTImageInfo.h"
#import "XTPhotosListViewController.h"
#import "XTHomePageLikeAndHateViewController.h"
#import "XTUserStore.h"

@interface XTLikeViewController ()<XTWaterFallViewControlDelegate>
@property (nonatomic, assign) NSInteger loadDataPage;
@end

@implementation XTLikeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.waterFallControl.collectionView.header isRefreshing
        ]&&self.waterFallControl.dataArray.count == 0) {
        [self loadWaterFallDataWithLoadMore:NO];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadDataPage = 0;
    
    RAMCollectionViewFlemishBondLayout *collectionViewLayout = [[RAMCollectionViewFlemishBondLayout alloc]init];
    UICollectionView *collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 49 - 64) collectionViewLayout:collectionViewLayout];
    collectionV.backgroundColor = [UIColor clearColor];
    collectionV.showsHorizontalScrollIndicator = NO;
    collectionV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:collectionV];
    
    self.waterFallControl = [[XTWaterFallControl alloc]initWithCollectionView:collectionV headerView:nil refreshType:XTWaterFallRefreshType_footer | XTWaterFallRefreshType_header cellType:XTWaterFallViewCellType_imageAndDescription];
    self.waterFallControl.delegate = self;
    self.waterFallControl.dataArray = nil;
   // [self.waterFallControl reloadCollectionViewData];
    
    [self.waterFallControl waterViewTriggerRefresh];
  //  [self loadWaterFallDataWithLoadMore:NO];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)loadWaterFallDataWithLoadMore:(BOOL)isLoadMore
{
    NSInteger offset = isLoadMore?self.loadDataPage*24:0;
    __weak XTLikeViewController *weakSelf = self;
    [[[XTHomePageStore alloc]init]fetchHomePageLikeListWithoffset:offset size:24 CompletionBlock:^(id picList, BOOL subArtist, NSError *error) {
        [self.waterFallControl stopWaterViewAnimating];
        [YYTBlankView hideFromView:self.waterFallControl.collectionView];
        [YYTHUD hideLoadingFrom:self.view];
        if (!error) {
            [self.waterFallControl hidenTheHeaderView:NO];
            [self.waterFallControl hidenTheFooterView:NO];
            if (isLoadMore) {
                NSArray *tempArr = [NSArray arrayWithArray:picList];
                if (tempArr.count==0) {
                    [self.waterFallControl hidenTheFooterView:YES];
                }
                self.loadDataPage+=1;
                [self.waterFallControl.dataArray addObjectsFromArray:picList withCheckKey:@"id" completionBlock:^{
                    [weakSelf.waterFallControl reloadCollectionViewData];
                }];
            }else
            {
                self.loadDataPage = 1;
                self.waterFallControl.dataArray = [NSMutableArray arrayWithArray:picList];
                if (self.waterFallControl.dataArray.count==0) {
                    [self.waterFallControl hidenTheHeaderView:YES];
                    [self.waterFallControl hidenTheFooterView:YES];
                    YYTBlankView *blankView = [YYTBlankView showBlankInView:self.waterFallControl.collectionView style:YYTBlankViewStyleBlank eventClick:^{
                            [weakSelf pushToLikeVC];
                    }];
                    if (subArtist) {
                        blankView.tipString = @"你的爱空荡荡，还没有图片";
                        blankView.buttonTitle = @"+尝尝窝边草";
                        blankView.headerStyle =YYTBlankHeaderStyleUnhappy;
                    }else
                    {
                        [self setLikeUserDefaultsWith:NO];
                        blankView.tipString = @"你怎么谁都不喜欢~起来选";
                        blankView.buttonTitle = @"+添加艺人";
                        blankView.headerStyle =YYTBlankHeaderStyleLike;
                    }
                }else
                {
                    [self setLikeUserDefaultsWith:YES];
                }
                
                [self.waterFallControl reloadCollectionViewData];
            }
            
        }else
        {
            
            if (self.waterFallControl.dataArray.count == 0) {
                [self.waterFallControl hidenTheHeaderView:YES];
                [self.waterFallControl hidenTheFooterView:YES];
                YYTBlankView *blankView = [YYTBlankView showBlankInView:self.waterFallControl.collectionView style:YYTBlankViewStyleNetworkError eventClick:^{
                    [YYTHUD showLoadingAddedTo:self.view];
                    [self loadWaterFallDataWithLoadMore:NO];
                }];
                blankView.error = error;
            }
        }
    }];
}

- (void)pushToLikeVC
{
    XTHomePageLikeAndHateViewController *likeAndHateVC = [[XTHomePageLikeAndHateViewController alloc] init];
    [self.navigationController pushViewController:likeAndHateVC animated:YES];
}
#pragma mark - 是否有喜欢的艺人
- (void)setLikeUserDefaultsWith:(BOOL)haveArtist
{
    NSString *userId = [XTUserStore sharedManager].user.userID;
    NSString *likeKey = [NSString stringWithFormat:@"%@like",userId];
    [[NSUserDefaults standardUserDefaults] setBool:haveArtist forKey:likeKey];
}

#pragma mark - waterFallDelegate
//下拉
- (void)pullToRefresh
{
    [self loadWaterFallDataWithLoadMore:NO];
}
//上提
- (void)infiniteScrolling;

{
    [self loadWaterFallDataWithLoadMore:YES];
}
- (void)clickCellIndexRow:(NSInteger)clickRow
{
    CLog(@"click喜欢Pic =  %zd",clickRow);
    
  XTImageInfo *clickedImgInfo = [self.waterFallControl.dataArray objectAtIndex:clickRow];
    
    if (clickedImgInfo.imgCount>1) {
        
        XTPhotosListViewController *atlasVC = [[XTPhotosListViewController alloc]init];
        atlasVC.pictureId = clickedImgInfo.id;
        atlasVC.type = XTPhotosListOtherType;
        if (clickedImgInfo.type == 1) {
            atlasVC.type = XTphotosListspecialType;
        }
        atlasVC.pictureCount = clickedImgInfo.imgCount;
        [self.navigationController pushViewController:atlasVC animated:YES];
        
    }else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
        
        XTImgDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
        controller.pidArr = [NSArray arrayWithObject:[NSNumber numberWithInteger:clickedImgInfo.picId]];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSMutableArray *)getAllIdArray
//{
//    NSMutableArray *mArray = [NSMutableArray array];
//    for (XTImageInfo *imgInfo in self.waterFallControl.dataArray) {
//        [mArray addObject:[NSString stringWithFormat:@"%ld",imgInfo.id]];
//    }
//    return mArray;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
