//
//  XTHotLicksOneViewController.m
//  tian
//
//  Created by cc on 15/5/25.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTHotLicksOneViewController.h"
#import "XTHotLicksStore.h"
#import <UIImageView+WebCache.h>
#import "XTHotLicksHeaerView.h"
#import <UIImageView+WebCache.h>
#import "XTLickRankingViewController.h"
#import "XTpastReviewViewController.h"
#import "XTOriginalViewController.h"
#import "XTTopicListViewController.h"
#define ViewSpace 14
#import "XTVSpreadViewController.h"
#import "XTTopicDetailViewController.h"
#import "XTWaterFallControl.h"
#import "XTHotMyTopivViewController.h"
#import "XTSeriesContentController.h"
#import "XTHotTopicViewController.h"
#import "XTTopicIndexViewController.h"
#import "XTSpecificArtistViewController.h"
#import "XTHotEventsViewController.h"
#import "XTVSpreadViewController.h"
#import "XTImgDetailViewController.h"
#import "XTWebVIewViewController.h"

#import "XTmoreViewController.h"
#import "XTVSpreadViewController.h"
#define K_TIANLIBANG @"rank/power/list.json"
#define K_TIANSHENBANG @"rank/god/list.json"
#define K_MINGXINGBANG @"rank/star/list.json"
@interface XTHotLicksOneViewController ()<XTWaterFallViewControlDelegate,XTHotLicksHeaderViewDelegate>
@property (nonatomic, strong) XTHotLicksInfo *hotLicksinfo;

@property (nonatomic, strong) XTHotLicksHeaerView *hotHeaderView;

@property (nonatomic, assign) NSInteger loadDataPage;//加载页数
@end

@implementation XTHotLicksOneViewController

- (void)viewDidLoad {
    self.loadDataPage = 0;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (VERSION > 7.9) {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, SCREEN_SIZE.width, self.view.frame.size.height);
    }
}
- (void)loadTheData
{
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    __weak XTHotLicksOneViewController *weakSelf = self;
    [[[XTHotLicksStore alloc]init] fetchHotLicksInfoCompletionBlock:^(id hotLickInfo, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        [YYTBlankView hideFromView:self.view];
        if (!error) {
            self.hotLicksinfo = hotLickInfo;
            self.loadDataPage +=1;
            [weakSelf addHeaderViewAndCollectionView];
        }else
        {
            __weak XTHotLicksOneViewController *weakSelf = self;
            if (!self.hotLicksinfo) {
                YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
                    [weakSelf loadTheData];
                }];
                blankView.error = error;
            }
        }
    }];

}
- (void)addHeaderViewAndCollectionView
{
    RAMCollectionViewFlemishBondLayout *collectionViewLayout = [[RAMCollectionViewFlemishBondLayout alloc]init];
    UICollectionView *collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 49 - 64) collectionViewLayout:collectionViewLayout];
    collectionV.backgroundColor = [UIColor clearColor];
    collectionV.showsHorizontalScrollIndicator = NO;
    collectionV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:collectionV];
    
    self.hotHeaderView = [[XTHotLicksHeaerView alloc]initWithHotLicksInfo:self.hotLicksinfo];
    self.hotHeaderView.delegate = self;
    self.waterFallControl = [[XTWaterFallControl alloc]initWithCollectionView:collectionV headerView:self.hotHeaderView refreshType:XTWaterFallRefreshType_footer|XTWaterFallRefreshType_header cellType:XTWaterFallViewCellType_imageAndTopic];
    self.waterFallControl.delegate = self;
    self.waterFallControl.dataArray = [NSMutableArray arrayWithArray:self.hotLicksinfo.hots];
    if (self.hotLicksinfo.hots.count==0) {
        [self.waterFallControl hidenTheFooterView:YES];
    }else
    {
        self.loadDataPage = 1;
    }
    [self.waterFallControl reloadCollectionViewData];
    [collectionV performSelector:@selector(setContentSize:) withObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_SIZE.width, 1000)] afterDelay:2.f];
}


- (void)loadWaterFallDataIsLoadMore:(BOOL)isloadMore
{
    NSInteger offset = 0;
    if (isloadMore) {
        offset = self.loadDataPage*24;
    }else
    {
        offset = 0;
    }
    __weak XTHotLicksOneViewController *weakSelf = self;
    [[[XTHotLicksStore alloc]init] fetchHotTopicListWithoffset:offset size:24 CompletionBlock:^(id hotLickInfo, NSError *error) {
         [self.waterFallControl stopWaterViewAnimating];
        
        if (!error) {
            NSArray *waterfallDataArray = hotLickInfo;
            if (waterfallDataArray.count==0) {
                [self.waterFallControl hidenTheFooterView:YES];
            }
            if (waterfallDataArray.count>0) {
                if (isloadMore) {
                    self.loadDataPage +=1;
                    [self.waterFallControl.dataArray addObjectsFromArray:waterfallDataArray withCheckKey:@"id" completionBlock:^{
                        [weakSelf.waterFallControl reloadCollectionViewData];
                    }];
                }else
                {
                    self.loadDataPage = 1;
                self.waterFallControl.dataArray = [NSMutableArray arrayWithArray:waterfallDataArray];
                    [self.waterFallControl reloadCollectionViewData];
                }
                
            }
        }else
        {
            [YYTAlertView showHalfTypeAlertViewWithTitle:@"提示" message:[error xtErrorMessage] completaionBlock:nil];
        }

        
    }];
}
#pragma mark - waterFallDelegate
- (void)pullToRefresh;//下拉
{
    [self loadWaterFallDataIsLoadMore:NO];
}
//上提
- (void)infiniteScrolling;

{
    [self loadWaterFallDataIsLoadMore:YES];
}
- (void)clickCellIndexRow:(NSInteger)clickRow
{
    
     XTWaterFallPicInfo *imginfo = [self.waterFallControl.dataArray objectAtIndex:clickRow];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
    
    XTTopicDetailViewController *topicDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"XTTopicDetailViewController"];
    topicDetailVC.topicID = @(imginfo.id);
    [self.navigationController pushViewController:topicDetailVC animated:YES];
    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
//    XTImgDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
//    XTImageInfo *info = [imginfo.images objectAtIndex:0];
//    NSArray *arr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",info.id], nil];
//    controller.pidArr = arr;
//    [self.navigationController pushViewController:controller animated:YES];
}
- (void)clickImgAndTopicCellTopicBtn:(NSInteger)clickTopicId
{
    XTWaterFallPicInfo *imginfo = [self.waterFallControl.dataArray objectAtIndex:clickTopicId];
    
    XTTopicIndexViewController *topicCtr = [[XTTopicIndexViewController alloc] init];
    topicCtr.topicId = imginfo.topic.id;
    topicCtr.topicTitle = imginfo.topic.title;
    [self.navigationController pushViewController:topicCtr animated:YES];
    
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
//    
//    XTTopicDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTTopicDetailViewController"];
//    controller.topicID = [NSNumber numberWithInteger:clickTopicId];
//    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - headerViewDelegat
- (void)clickBannerBtn
{
    /**
     *   推荐类型，"series"为系列内容，"sole"为独家原创，"artist"为专属艺人内容，"hotevent"为热点事件，"hottopicset"为热点话题集合，"hottopic"为热点话题，"vuser"为大V宣传，"webview"为网页视图
     */
    XTHotLicksBannerInfo *bannerInfo = self.hotLicksinfo.banner;
    [self pushToViewControllerWithType:bannerInfo.type modelId:bannerInfo.link title:bannerInfo.title];
       CLog(@"点击了 banner  type = %@",bannerInfo.type);
}
- (void)clickMyTopicBtn
{
    XTHotMyTopivViewController *TopicVC = [[XTHotMyTopivViewController alloc]init];
    [self.navigationController pushViewController:TopicVC animated:YES];
}
- (void)clickRecsWithIndex:(NSInteger)index
{

    XTHotLicksRecsInfo *recInfo = self.hotLicksinfo.recs[index];
    
    [self pushToViewControllerWithType:recInfo.type modelId:[NSString stringWithFormat:@"%zd",recInfo.id] title:recInfo.title];
}
- (void)pushToViewControllerWithType:(NSString*)type modelId:(NSString *)modelid title:(NSString *)modelTitle
{
    if ([type isEqualToString:@"more"]) {
        XTpastReviewViewController *reviewVC = [[XTpastReviewViewController alloc]initWithNibName:@"XTReviewViewController" bundle:nil];
        [self.navigationController pushViewController:reviewVC animated:YES];
    }else if([type isEqualToString:@"sole"]) {
        XTOriginalViewController *OriginalVC = [[XTOriginalViewController alloc]init];
        OriginalVC.originalId = [modelid integerValue];
        OriginalVC.type = XTPageTypeOriginal;
        [self.navigationController pushViewController:OriginalVC animated:YES];
    }else if([type isEqualToString:@"artist"]) {
        XTSpecificArtistViewController *artistVC = [[XTSpecificArtistViewController alloc] init];
        artistVC.recommendId = [modelid integerValue];
        artistVC.recommendTitle = modelTitle;
        [self.navigationController pushViewController:artistVC animated:YES];
    }else if([type isEqualToString:@"hottopicset"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
        XTHotTopicViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTHotTopicViewController"];
        controller.itemID = [NSNumber numberWithInteger:[modelid integerValue]];
        controller.title = modelTitle;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([type isEqualToString:@"series"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
        XTSeriesContentController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTSeriesContentController"];
        controller.itemID = [NSNumber numberWithInteger:[modelid integerValue]];
        [self.navigationController pushViewController:controller animated:YES];
    }else if([type isEqualToString:@"hotevent"]) {
        XTHotEventsViewController *hotEventVC = [[XTHotEventsViewController alloc] init];
        hotEventVC.hotEventsId = [modelid integerValue];
        if (modelTitle) {
           hotEventVC.hotEventsTitle = modelTitle;
        }else
        {
            hotEventVC.hotEventsTitle = @"热点事件";
        }
        
        [self.navigationController pushViewController:hotEventVC animated:YES];
    }else if([type isEqualToString:@"vuser"]) {
        XTVSpreadViewController *spreadVC = [[XTVSpreadViewController alloc] init];
        spreadVC.recId = [modelid integerValue];
        spreadVC.recTitle = modelTitle;
        [self.navigationController pushViewController:spreadVC animated:YES];
    }else if ([type isEqualToString:@"webview"])
    {
        XTWebVIewViewController *webViewController = [[XTWebVIewViewController alloc]init];
        webViewController.theUrl = [NSURL URLWithString:modelid];
        [self.navigationController pushViewController:webViewController animated:YES];
    }

}

/**∫
 *   排行榜  tag = 300+...
 */
- (void)clickRankBtn:(UIButton *)sender
{
    NSInteger clickIndex = sender.tag - 300;
    
    XTHotLicksRankInfo *rankInfo = [self.hotLicksinfo.ranks objectAtIndex:clickIndex];
    
    if ([rankInfo.type isEqualToString:@"power"]) {
        XTLickRankingViewController *exampleVC = [[XTLickRankingViewController alloc]initWithNibName:@"XTLickRankingViewController" bundle:nil];
        exampleVC.title = @"舔力榜";
        exampleVC.type = XTTIANLILIST;
        exampleVC.string = K_TIANLIBANG;
        [self.navigationController pushViewController:exampleVC animated:YES];
    }else if ([rankInfo.type isEqualToString:@"god"]){
        XTLickRankingViewController *exampleVC = [[XTLickRankingViewController alloc]initWithNibName:@"XTLickRankingViewController" bundle:nil];
        exampleVC.title = @"舔神榜";
        exampleVC.type = XTTIANSHENGLIST;
        exampleVC.string = K_TIANSHENBANG;
        [self.navigationController pushViewController:exampleVC animated:YES];
    }else if ([rankInfo.type isEqualToString:@"star"]){
        XTLickRankingViewController *exampleVC = [[XTLickRankingViewController alloc]initWithNibName:@"XTLickRankingViewController" bundle:nil];
        exampleVC.title = @"明星榜";
        exampleVC.type = XTMINGXING;
        exampleVC.string = K_MINGXINGBANG;
        [self.navigationController pushViewController:exampleVC animated:YES];
    }else{
        XTTopicListViewController *topicVC = [[XTTopicListViewController alloc]initWithNibName:@"XTTopicListViewController" bundle:nil];
        topicVC.title = @"话题榜";
        [self.navigationController pushViewController:topicVC animated:YES];
    }
}
/**
 *   热门话题  tag = 200+...
 */
- (void)clickTopicBtn:(UIButton *)sender
{
    if (sender.tag - 200 == 5) {
        XTmoreViewController *pubLishVC = [[XTmoreViewController alloc]initWithNibName:@"XTmoreViewController" bundle:nil];
        [self.navigationController pushViewController:pubLishVC animated:YES];
        return;
  }else{
    XTHotLicksTopicsInfo *topicInfo = self.hotLicksinfo.topics[sender.tag - 200];
    XTTopicIndexViewController *topicIndexVC = [[XTTopicIndexViewController alloc] init];
    topicIndexVC.topicId = topicInfo.id;
    topicIndexVC.topicTitle = topicInfo.title;
    [self.navigationController pushViewController:topicIndexVC animated:YES];
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.hotLicksinfo) {
        [self loadTheData];
        CLog(@"热舔无数据，重新加载热舔数据");
    }
    CLog(@"hotlicks  viewwillappear-=-=-=-=-=");
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
