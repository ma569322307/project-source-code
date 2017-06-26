//
//  XTLickgodGroupViewController.m
//  tian
//
//  Created by cc on 15/7/16.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTLickgodGroupViewController.h"
#import "XTWaterFallControl.h"
#import "XTWaterFallPicInfo.h"
#import "XTLickGodStore.h"
#import "XTUserStore.h"
#import "XTUserHomePageViewController.h"
#import "XTTopicDetailViewController.h"
#import "XTPhotosListViewController.h"
#import "XTImgDetailViewController.h"
@interface XTLickgodGroupViewController ()<XTWaterFallViewControlDelegate>
@property (nonatomic, strong) XTWaterFallControl *waterFallControl;
@end

@implementation XTLickgodGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = self.title;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    RAMCollectionViewFlemishBondLayout *collectionViewLayout = [[RAMCollectionViewFlemishBondLayout alloc]init];
    UICollectionView *collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 49) collectionViewLayout:collectionViewLayout];
    collectionV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionV];
    
    self.waterFallControl = [[XTWaterFallControl alloc]initWithCollectionView:collectionV headerView:nil refreshType:XTWaterFallRefreshType_footer | XTWaterFallRefreshType_header cellType:XTWaterFallViewCellType_imageAndUserAvatar];
    self.waterFallControl.delegate = self;
    self.waterFallControl.dataArray = nil;
    [self.waterFallControl reloadCollectionViewData];
    
    [self.waterFallControl waterViewTriggerRefresh];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadDataWithIsLoadMore:(BOOL)isLoadMore
{
    
    NSInteger offset = 0;
    NSInteger albumId = 0;
    if (isLoadMore) {
        offset =  self.waterFallControl.dataArray.count;
        XTImageInfo *lastModel = [self.waterFallControl.dataArray lastObject];
        albumId = lastModel.albumId;
    }
    [[[XTLickGodStore alloc] init] fetchGodPictureListWithPropId:self.propId offset:offset size:20 fromId:albumId CompletionBlock:^(id hotLickInfo, NSError *error) {
        if (!error) {
            [self.waterFallControl stopWaterViewAnimating];
            CLog(@"舔神分类列表成功");
            NSMutableArray *arr = hotLickInfo;
            if (arr.count>0) {
                if (isLoadMore) {
                    [self.waterFallControl.dataArray addObjectsFromArray:arr];
                }else
                {
                    self.waterFallControl.dataArray = [NSMutableArray arrayWithArray:arr];
                }
                [self.waterFallControl reloadCollectionViewData];
            }
            
        }else
        {
            [YYTAlertView showHalfTypeAlertViewWithTitle:@"提示" message:[error xtErrorMessage] completaionBlock:nil];
        }
    }];
}
#pragma mark - waterView Delegate
- (void)infiniteScrolling
{
    [self loadDataWithIsLoadMore:YES];
    
}
- (void)pullToRefresh
{
    [self loadDataWithIsLoadMore:NO];
}
- (void)clickCellIndexRow:(NSInteger)clickRow
{
    CLog(@"点击的row %ld",clickRow);
    
    XTWaterFallPicInfo *waterFallInfo = [self.waterFallControl.dataArray objectAtIndex:clickRow];
    if (waterFallInfo.count>1) {
        
        XTPhotosListViewController *atlasVC = [[XTPhotosListViewController alloc]init];
        atlasVC.pictureId = waterFallInfo.albumId;
        atlasVC.type = XTPhotosListOtherType;
        atlasVC.pictureCount = waterFallInfo.count;
        [self.navigationController pushViewController:atlasVC animated:YES];
        
    }else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
        
        XTImgDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
        controller.pidArr = [NSArray arrayWithObject:[NSNumber numberWithInteger:waterFallInfo.picId]];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
- (void)clickUserAvatarBtn:(NSInteger)clickUserid
{
    if ([[XTUserStore sharedManager].user.userID integerValue]==clickUserid) {
        return;
    }
    
    XTUserHomePageViewController *userHomePageVC = [[XTUserHomePageViewController alloc]init];
    userHomePageVC.type = XTUserHomePageTypeHis;
    userHomePageVC.userType = XTAccountCommon;
    userHomePageVC.userID = [NSString stringWithFormat:@"%ld",clickUserid];
    [self.navigationController pushViewController:userHomePageVC animated:YES];
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
