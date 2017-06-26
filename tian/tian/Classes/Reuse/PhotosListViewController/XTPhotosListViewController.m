//
//  XTPhotosListViewController.m
//  tian
//
//  Created by yyt on 15/7/9.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTPhotosListViewController.h"
#import "RAMCollectionViewFlemishBondLayout.h"
#import "XTWaterFallControl.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTHomePageStore.h"
#import "YYTAlertView.h"
#import "XTImgDetailViewController.h"
#import "XTImageInfo.h"
#define XTPhotosListSpecialURL @"http://papi.yinyuetai.com/operate/album/detail.json"
@interface XTPhotosListViewController ()<XTWaterFallViewControlDelegate>
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) XTWaterFallControl *waterFallControl;
@property (nonatomic, assign) NSInteger tempCount;
@property (nonatomic, assign) NSInteger maxId;
@property (nonatomic, assign) NSUInteger loadDatapage;
@end

@implementation XTPhotosListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    RAMCollectionViewFlemishBondLayout *layout = [[RAMCollectionViewFlemishBondLayout alloc]init];
    self.collection  = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height-64) collectionViewLayout:layout];
    self.collection.backgroundColor = [UIColor whiteColor];
    self.collection.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collection];
    
    self.waterFallControl = [[XTWaterFallControl alloc]initWithCollectionView:self.collection headerView:nil refreshType:XTWaterFallRefreshType_footer | XTWaterFallRefreshType_header cellType:XTWaterFallViewCellType_imageAndDescription];
    self.waterFallControl.delegate = self;
    self.waterFallControl.dataArray = nil;
    [self.waterFallControl reloadCollectionViewData];
    [self.waterFallControl waterViewTriggerRefresh];

    if (self.type == XTphotosListLabelType) {
        self.title = [NSString stringWithFormat:@"%@",self.titleString];
    }else if (self.type == XTPhotosListOtherType){
        self.title = [NSString stringWithFormat:@"图集列表(%@)",@(self.pictureCount)];
    }else{
        self.title = [NSString stringWithFormat:@"精选图集(%@)",@(self.pictureCount)];
    }
}
- (void)loadWaterFallDataWithLoadMore:(BOOL)isLoadMore
{
    XTHomePageStore *homeStore = [[XTHomePageStore alloc]init];
    if (self.type == XTphotosListLabelType) {
        [homeStore fetchHomePagePicListWith:self.titleString andMaxId:self.maxId CompletionBlock:^(id picList, NSError *error) {
             [self.waterFallControl stopWaterViewAnimating];
            if (!error) {
                if([picList count] < 20) {
                    [self.waterFallControl hidenTheFooterView:YES];
                    [self.waterFallControl hidenTheHeaderView:YES];
                }
                if (isLoadMore) {
                    [self.waterFallControl.dataArray addObjectsFromArray:picList];
                    XTImageInfo *lastModel = [self.waterFallControl.dataArray lastObject];
                    self.maxId = lastModel.id;
                }else{
                    self.waterFallControl.dataArray = [NSMutableArray arrayWithArray:picList];
                }
                [self.waterFallControl reloadCollectionViewData];
            }else{
                [YYTAlertView showFullTypeAlertViewWithTitle:@"提示" message:[error xtErrorMessage] delegate:self];
            }
        }];
    }else if(self.type == XTPhotosListOtherType){
    [homeStore fetchHomePagePicListWith:self.pictureId CompletionBlock:^(id picList, NSError *error) {
        [self.waterFallControl stopWaterViewAnimating];
        [self.waterFallControl hidenTheFooterView:YES];
        [self.waterFallControl hidenTheHeaderView:YES];
        if (!error) {
            if (isLoadMore) {
                [self.waterFallControl.dataArray addObjectsFromArray:picList];
            }else{
                self.waterFallControl.dataArray = [NSMutableArray arrayWithArray:picList];
            }
            [self.waterFallControl reloadCollectionViewData];
        }else{
            [YYTAlertView showFullTypeAlertViewWithTitle:@"提示" message:[error xtErrorMessage] delegate:self];
        }
    }];
    }else{
        __weak XTPhotosListViewController *weakSelf = self;
     [homeStore fetchHomePagePhotoListSpecial:self.pictureId andOffset:weakSelf.loadDatapage*24 andSize:24 CompletionBlock:^(id piclist, NSError *error) {
         [weakSelf.waterFallControl hidenTheHeaderView:YES];
         [weakSelf.waterFallControl stopWaterViewAnimating];
         if (!error) {
             weakSelf.loadDatapage++;
             if ([piclist count]<5) {
                 [weakSelf.waterFallControl hidenTheFooterView:YES];
                 [weakSelf.waterFallControl hidenTheHeaderView:YES];
             }
             if (isLoadMore) {
                 [weakSelf.waterFallControl.dataArray addObjectsFromArray:piclist withCheckKey:@"id" completionBlock:^{
                     [weakSelf.waterFallControl reloadCollectionViewData];
                 }];
             }else{
                 weakSelf.waterFallControl.dataArray = [NSMutableArray arrayWithArray:piclist];
             }
             [weakSelf.waterFallControl reloadCollectionViewData];
         }else{
             [YYTAlertView showFullTypeAlertViewWithTitle:@"提示" message:[error xtErrorMessage] delegate:self];
         }
         
     }];
    }
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
    CLog(@"图册 =  %ld",clickRow);
    XTImageInfo *imageInfo = [self.waterFallControl.dataArray objectAtIndex:clickRow];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
    XTImgDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
    controller.pidArr = [self getAllIdArray];
    controller.curIndex = clickRow;
    controller.placeholderImageURL = imageInfo.url;
    self.needTranform = YES;
    [self tranformPushWithCollectionView:self.waterFallControl.collectionView imageSize:CGSizeMake(imageInfo.width, imageInfo.height) currentIndex:clickRow];
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
