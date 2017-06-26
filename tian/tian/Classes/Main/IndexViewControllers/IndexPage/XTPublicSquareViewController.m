//
//  XTPublicSquareViewController.m
//  tian
//
//  Created by cc on 15/6/15.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTPublicSquareViewController.h"
#import "XTHomePageStore.h"
#import "XTImgDetailViewController.h"
#import "XTImageInfo.h"
#import "XTHomePageViewController.h"

@interface XTPublicSquareViewController ()<XTWaterFallViewControlDelegate>
@property (nonatomic,assign) NSInteger loadDataPage;
@end

@implementation XTPublicSquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadDataPage = 0;
    RAMCollectionViewFlemishBondLayout *collectionViewLayout = [[RAMCollectionViewFlemishBondLayout alloc]init];
    UICollectionView *collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 49-64) collectionViewLayout:collectionViewLayout];
    collectionV.backgroundColor = [UIColor clearColor];
    collectionV.showsHorizontalScrollIndicator = NO;
    collectionV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:collectionV];
    
    self.waterFallControl = [[XTWaterFallControl alloc]initWithCollectionView:collectionV headerView:nil refreshType:XTWaterFallRefreshType_footer | XTWaterFallRefreshType_header cellType:XTWaterFallViewCellType_imageAndDescription];
    self.waterFallControl.delegate = self;
    self.waterFallControl.dataArray = nil;
    [self.waterFallControl reloadCollectionViewData];
    
    [self.waterFallControl waterViewTriggerRefresh];
  //  [self loadWaterFallDataWithLoadMore:NO];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadWaterFallDataWithLoadMore:(BOOL)isLoadMore
{
    NSInteger offset = isLoadMore?self.loadDataPage*24:0;
    
    __weak XTPublicSquareViewController *weakSelf = self;
    [[[XTHomePageStore alloc]init]fetchHomePagePicListWithoffset:offset size:24 CompletionBlock:^(id picList, NSError *error) {
        [self.waterFallControl stopWaterViewAnimating];
        [YYTBlankView hideFromView:self.waterFallControl.collectionView];
        [YYTHUD hideLoadingFrom:self.view];
        if (!error) {
            [self.waterFallControl hidenTheFooterView:NO];
            [self.waterFallControl hidenTheHeaderView:NO];
            if (isLoadMore) {
                self.loadDataPage+=1;
                [self.waterFallControl.dataArray addObjectsFromArray:picList withCheckKey:@"id" completionBlock:^{
                    [weakSelf.waterFallControl reloadCollectionViewData];
                }];
            }else{
                self.loadDataPage = 1;
                self.waterFallControl.dataArray = [NSMutableArray arrayWithArray:picList];
                [weakSelf.waterFallControl reloadCollectionViewData];
            }
            
            
            if([self.waterFallControl.dataArray count] == 0) {
                [self.waterFallControl hidenTheFooterView:YES];
                [self.waterFallControl hidenTheHeaderView:YES];
                [YYTBlankView showBlankInView:self.waterFallControl.collectionView style:YYTBlankViewStyleBlank eventClick:^{
                    [self loadWaterFallDataWithLoadMore:NO];
                }];
            }
        }else
        {
//            [YYTAlertView showHalfTypeAlertViewWithTitle:@"提示" message:[error xtErrorMessage] completaionBlock:nil];
            if([self.waterFallControl.dataArray count] == 0) {
                [self.waterFallControl hidenTheFooterView:YES];
                [self.waterFallControl hidenTheHeaderView:YES];
                [YYTBlankView showBlankInView:self.waterFallControl.collectionView style:YYTBlankViewStyleNetworkError eventClick:^{
                    [YYTHUD showLoadingAddedTo:self.view];
                    [self loadWaterFallDataWithLoadMore:NO];
                }];
            }

        }
    }];
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
    CLog(@"click广场Pic =  %ld",clickRow);
    XTImageInfo *imginfo = [self.waterFallControl.dataArray objectAtIndex:clickRow];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
    XTImgDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
    controller.pidArr = [self getAllIdArray];
    controller.curIndex = clickRow;
    controller.placeholderImageURL = imginfo.url;
    XTHomePageViewController *homePageVC = (XTHomePageViewController *)self.parentViewController;
    homePageVC.needTranform = YES;
    XTImageInfo *imageInfo = self.waterFallControl.dataArray[clickRow];
    [homePageVC tranformPushWithCollectionView:self.waterFallControl.collectionView imageSize:CGSizeMake(imageInfo.width, imageInfo.height) currentIndex:clickRow];
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSMutableArray *)getAllIdArray
{
    NSMutableArray *mArray = [NSMutableArray array];
    for (XTImageInfo *imgInfo in self.waterFallControl.dataArray) {
        [mArray addObject:[NSString stringWithFormat:@"%ld",imgInfo.id]];
    }
    return mArray;
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
