//
//  XTLickingGodViewController.m
//  tian
//
//  Created by 尚毅 杨 on 15/5/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTLickingGodViewController.h"
#import "XTLickGodHeaderView.h"
#import "XTLickGodStore.h"
#import "XTUserStore.h"
#import "XTWaterFallControl.h"
#import "XTTopicDetailViewController.h"
#import "XTWaterFallPicInfo.h"
#import "XTUserHomePageViewController.h"
#import "XTLickgodGroupViewController.h"
#import "XTLickGodPropsInfo.h"
#import "XTPhotosListViewController.h"
#import "XTImgDetailViewController.h"

@interface XTLickingGodViewController ()<XTWaterFallViewControlDelegate,XTLickGodHeaderViewDelegate>

@property (nonatomic, strong) XTLickGodHeaderView *lickGodHeaderView;
@property (nonatomic, strong) NSArray *hotLickInfoArray;


@end

@implementation XTLickingGodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)loadHeaderViewData
{
    RAMCollectionViewFlemishBondLayout *collectionViewLayout = [[RAMCollectionViewFlemishBondLayout alloc]init];
    UICollectionView *collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 49 - 64) collectionViewLayout:collectionViewLayout];
    collectionV.backgroundColor = [UIColor clearColor];
    collectionV.showsHorizontalScrollIndicator = NO;
    collectionV.showsVerticalScrollIndicator = NO;
    [YYTHUD showLoadingAddedTo:self.view];
    
    XTLickGodStore *lickGodStore = [[XTLickGodStore alloc]init];
    
    [lickGodStore fetchGodPropsWithOffset:0 size:9 CompletionBlock:^(id hotLickInfo, NSError *error) {
        [YYTHUD hideLoadingFrom:self.view];
        [YYTBlankView hideFromView:self.view];
        if (!error) {
            self.hotLickInfoArray = [NSArray arrayWithArray:hotLickInfo];
            self.lickGodHeaderView = [[XTLickGodHeaderView alloc]initLickGodViewWith:hotLickInfo];
            self.lickGodHeaderView.delegate = self;
            
            self.waterFallControl = [[XTWaterFallControl alloc]initWithCollectionView:collectionV headerView:self.lickGodHeaderView refreshType:XTWaterFallRefreshType_footer|XTWaterFallRefreshType_header cellType:XTWaterFallViewCellType_imageAndUserAvatar];
            self.waterFallControl.delegate = self;
            [self.view addSubview:collectionV];
            [self loadImagesDataWithIsLoadMore:NO];
        }else
        {
         //   __weak XTLickingGodViewController *weakSelf = self;
            if (self.hotLickInfoArray.count == 0) {
                YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
                    
                    [self loadHeaderViewData];
                }];
                blankView.error = error;
                
            }
        }
    }];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.hotLickInfoArray.count==0) {
        [self loadHeaderViewData];
    }
}
- (void)loadImagesDataWithIsLoadMore:(BOOL)isLoadMore
{
    
    NSInteger uid = [[[[XTUserStore sharedManager] user] userID] integerValue];
    NSInteger offset = 0;
    NSInteger albumId = 0;
    if (isLoadMore) {
        offset =  self.waterFallControl.dataArray.count;
        XTWaterFallPicInfo *lastModel = [self.waterFallControl.dataArray lastObject];
        albumId = lastModel.albumId;
    }
    [[[XTLickGodStore alloc] init] fetchGodPicsWithUserId:uid offset:offset size:24 fromId:albumId CompletionBlock:^(id hotLickInfo, NSError *error) {
        if (!error) {
            [self.waterFallControl stopWaterViewAnimating];
            CLog(@"图片列表成功");
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
- (void)pullToRefresh;//下拉
{
    [self loadImagesDataWithIsLoadMore:NO];
}
- (void)infiniteScrolling
{
    [self loadImagesDataWithIsLoadMore:YES];
    
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

#pragma mark - headerViewDelegate
- (void)clickGodBtn:(UIButton *)sender
{
    CLog(@"click tag= %ld",sender.tag);
    NSInteger index = sender.tag- 500;
    XTLickGodPropsInfo *lickGodPropsinfo = [self.hotLickInfoArray objectAtIndex:index];
    XTLickgodGroupViewController *lickgodGroupVC = [[XTLickgodGroupViewController alloc]init];
    lickgodGroupVC.propId = lickGodPropsinfo.id;
    lickgodGroupVC.title = lickGodPropsinfo.title;
    [self.navigationController pushViewController:lickgodGroupVC animated:YES];
    
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
