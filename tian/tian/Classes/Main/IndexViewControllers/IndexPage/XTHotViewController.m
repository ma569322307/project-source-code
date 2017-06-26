//
//  XTHotViewController.m
//  tian
//
//  Created by cc on 15/6/15.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHotViewController.h"
#import "XTHomePageStore.h"
#import "XTAttentionInfo.h"
#import <MJRefresh.h>


#import "XTTopicIndexViewController.h"
#import "XTImgDetailViewController.h"
#import "XTPhotosListViewController.h"
#import "XTTopicDetailViewController.h"

#import "XTPostInfo.h"
#import "XTTopicInfo.h"
#import "XTImageInfo.h"

@interface XTHotViewController ()
@property (nonatomic, assign) NSInteger loadDataPage;
@end

static NSString *const identifier  = @"cellIdentifier";
@implementation XTHotViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.topicTableView.header isRefreshing
          ]&&self.topicTableView.topicArray.count == 0) {
        [self loadWaterFallDataWithLoadMore:NO];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /**
    _
     */
    [self.view addSubview:self.topicTableView];
    [self.topicTableView updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
    
    __weak XTHotViewController *weakSelf = self;
    XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadWaterFallDataWithLoadMore:YES];
    }];
//    footer.automaticallyRefresh = NO;
    self.topicTableView.footer = footer;
    
    self.topicTableView.header = [XTGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadWaterFallDataWithLoadMore:NO];
    }];
    [self.topicTableView.header beginRefreshing];
    
    
    self.topicTableView.topicCellClick = ^(MTLModel *model)
    {
        if ([model isKindOfClass:[XTTopicInfo class]]) {
            XTTopicInfo *info = (XTTopicInfo *)model;
            XTTopicIndexViewController *topicCtr = [[XTTopicIndexViewController alloc] init];
            topicCtr.topicId = info.topicId;
            topicCtr.topicTitle = info.title;
            [weakSelf.navigationController pushViewController:topicCtr animated:YES];
        }else if ([model isKindOfClass:[XTPostInfo class]]){
            XTPostInfo *postInfo = (XTPostInfo *)model;
            if ([postInfo.type isEqualToString:@"pic"]) {
                
                XTImageInfo *imginfo = [postInfo.images firstObject];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
                
                XTImgDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
                controller.pidArr = [NSArray arrayWithObject:[NSNumber numberWithInteger:imginfo.id]];
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }else if ([postInfo.type isEqualToString:@"status"])
            {
                XTPhotosListViewController *atlasVC = [[XTPhotosListViewController alloc]init];
                atlasVC.type = XTPhotosListOtherType;
                atlasVC.pictureCount = [postInfo.images count];
                atlasVC.pictureId = postInfo.stateID;
                [weakSelf.navigationController pushViewController:atlasVC animated:YES];
            }else if ([postInfo.type isEqualToString:@"post"])
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
                
                XTTopicDetailViewController *topicDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"XTTopicDetailViewController"];
                topicDetailVC.topicID = [NSNumber numberWithDouble:postInfo.stateID];
                [weakSelf.navigationController pushViewController:topicDetailVC animated:YES];
            }
        }

    };
}
- (XTTopicTableView *)topicTableView {
    if(!_topicTableView) {
        _topicTableView = [XTTopicTableView topicTableViewWithCellStyle:XTTopicTableViewCellStyleIndexFollow];
        
    }
    return _topicTableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadWaterFallDataWithLoadMore:(BOOL)isLoadMore
{
    double maxid = 0;
    if (isLoadMore&&self.topicTableView.topicArray.count>0) {
        MTLModel *lastModel = [self.topicTableView.topicArray lastObject];
        if ([lastModel isKindOfClass:[XTPostInfo class]]) {
            XTPostInfo *postInfo = (XTPostInfo *)lastModel;
            maxid = postInfo.stateID;
        }else if ([lastModel isKindOfClass:[XTTopicInfo class]])
        {
            XTTopicInfo *topicInfo = (XTTopicInfo *)lastModel;
            maxid = topicInfo.stateID;
        }
    }
    
    [[[XTHomePageStore alloc]init] fetchHomePageAttentionListWithmaxId:maxid sinceId:0 size:24 CompletionBlock:^(id picList, NSError *error) {
        [self.topicTableView.footer endRefreshing];
        [self.topicTableView.header endRefreshing];
        [YYTBlankView hideFromView:self.topicTableView];
        [YYTHUD hideLoadingFrom:self.view];
        self.topicTableView.header.hidden = NO;
        self.topicTableView.footer.hidden = NO;
        if (!error) {
            
            NSArray *dataArr = [NSArray arrayWithArray:picList];
            if (dataArr.count<5) {
                [self.topicTableView.footer setHidden:YES];
            }
            if (isLoadMore) {
                NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.topicTableView.topicArray];
                [mutableArr addObjectsFromArray:picList];
                self.topicTableView.topicArray = [NSArray arrayWithArray:mutableArr];
                [self.topicTableView reloadData];
            }else
            {
                self.topicTableView.topicArray = [NSArray arrayWithArray:picList];
                if (self.topicTableView.topicArray.count==0) {
                    self.topicTableView.header.hidden = YES;
                    self.topicTableView.footer.hidden = YES;
                    YYTBlankView *blankView = [YYTBlankView showBlankInView:self.topicTableView style:YYTBlankViewStyleBlank eventClick:nil];
                        blankView.tipString = @"还木有发现美味儿的基友…";
                        blankView.headerStyle =YYTBlankHeaderStyleCry;
                }
                [self.topicTableView refreshTableView];
                
            }

        }else
        {
            if (self.topicTableView.topicArray.count == 0) {
                self.topicTableView.header.hidden = YES;
                self.topicTableView.footer.hidden = YES;
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.topicTableView style:YYTBlankViewStyleNetworkError eventClick:^{
                [YYTHUD showLoadingAddedTo:self.view];
                [self loadWaterFallDataWithLoadMore:NO];
            }];
            blankView.error = error;
            }
        }

    }];
    
}

//#pragma mark - tableViewDelegate dataSource
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    XTHomePageAttentionTableViewCell *cell = [self.theTableView dequeueReusableCellWithIdentifier:identifier];
//    cell.delegate = self;
//    [cell configureCellWithIndexPath:indexPath andWithModel:[self.dataArray objectAtIndex:indexPath.row]];
//    
//    return cell;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.dataArray.count;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CLog(@"clickTableView indexPathRow = %ld",indexPath.row);
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [XTHomePageAttentionTableViewCell cellHeightWithAttentionInfo:[self.dataArray objectAtIndex:indexPath.row]];
//}
//#pragma mark CellDlegate
//- (void)clickTopicBtnWithIndexPathRow:(NSInteger)indexpathRow
//{
//    CLog(@"点击了话题----%ld",indexpathRow);
//}
//- (void)clickImageViewWithIndexPathRow:(NSInteger)indexpathRow
//{
//    NSInteger row = 0;
//    NSInteger imagesIndex = 0;
//    if (indexpathRow>100) {
//        row = indexpathRow/100-1;
//        imagesIndex = indexpathRow%100;
//    }
//    
//    CLog(@"点击了图片---indexpathRow=%ld    imagesindex = %ld  row = %ld  ",indexpathRow,imagesIndex,row);
//    
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
