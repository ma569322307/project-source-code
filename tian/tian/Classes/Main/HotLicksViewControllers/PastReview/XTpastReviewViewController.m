//
//  XTReviewViewController.m
//  tian
//
//  Created by yyt on 15-6-8.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTpastReviewViewController.h"
#import "XTreviewTableViewCell.h"
#import "XTHotLicksStore.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTConfig.h"
#import "XTNewsInfo.h"
#import "XTTabBarController.h"
#import "XTOriginalViewController.h"
#import "XTSeriesContentController.h"
#import "XTHotEventsViewController.h"
#import "XTSpecificArtistViewController.h"
#import "XTHotTopicViewController.h"
#import "XTVSpreadViewController.h"
static NSString *str = @"http://papi.yinyuetai.com/operate/rec/list.json";
@interface XTpastReviewViewController ()
@property (nonatomic, strong) XTreviewTableViewCell *tableViewCell;
@property (nonatomic,copy) NSString *str;
@property (nonatomic, assign) NSUInteger loadMore;


@end

@implementation XTpastReviewViewController
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:YES];
//    XTTabBarController *tabbar = [[XTTabBarController alloc]init];
//    [tabbar hideBottomViewWhenPushed];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"往期回顾";
    self.tableView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height-64);
    self.navigationController.navigationBar.translucent = NO;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
    }];
    @weakify(self);
    XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self requestWithReview:YES];
    }];
    self.tableView.footer = footer;
    [self requestWithReview:NO];
    /**
     *  cell的注册
     */
    [self.tableView registerNib:[UINib nibWithNibName:@"XTreviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"ID"];
}
-(void)requestWithReview:(BOOL)isLoadMore{
    NSUInteger offset = isLoadMore?self.loadMore *24:0;
    [YYTHUD showLoadingAddedTo:self.view];
    NSDictionary *requestDic = @{@"offset":[NSNumber numberWithInteger:offset],@"size":@"24"};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:str parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:responseObject];
        
        NSLog(@"%@",responseObject);
        
        [dataArray addObjectsFromArray:dataArray withCheckKey:@"id" completionBlock:^{
            [self.tableView reloadData];
            self.loadMore++;
        }];
        if (dataArray.count<5) {
            self.tableView.footer.hidden = YES;
            [self.tableView.footer noticeNoMoreData];
        }
        [self.tableView.footer endRefreshing];
        for (NSDictionary *dataDic in dataArray) {
            XTNewsInfo *Info = [[XTNewsInfo alloc]init];
            [Info setValuesForKeysWithDictionary:dataDic];
            [self.array addObject:Info];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
#pragma mark--------UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identifier = @"ID";
    
    XTreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XTreviewTableViewCell" owner:self options:0]lastObject];
    }
    [cell configCellWithIndexpath:indexPath andModel:[self.array objectAtIndex:indexPath.row]];
    [YYTHUD hideLoadingFrom:self.view];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XTNewsInfo *model = [self.array objectAtIndex:indexPath.row];
    if ([model.type isEqualToString:@"series"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
        XTSeriesContentController *seriseVC = [storyboard instantiateViewControllerWithIdentifier:@"XTSeriesContentController"];
        seriseVC.itemID = @(model.id);
        [self.navigationController pushViewController:seriseVC animated:YES];
    }
    
    
    else if ([model.type isEqualToString:@"sole"]){
        XTOriginalViewController *originalVC = [[XTOriginalViewController alloc]init];
        originalVC.type = 0;
        originalVC.originalId =model.id;
        [self.navigationController pushViewController:originalVC animated:YES];
    }
    
    
    else if ([model.type isEqualToString:@"artist"]){
        XTSpecificArtistViewController *specificArtistVC = [[XTSpecificArtistViewController alloc]init];
        specificArtistVC.recommendId = model.id;
        specificArtistVC.recommendTitle = model.title;
        [self.navigationController pushViewController:specificArtistVC animated:YES];
    }
    
    
    else if ([model.type isEqualToString:@"hotevent"]){
        XTHotEventsViewController *hotEventVC = [[XTHotEventsViewController alloc]init];
        hotEventVC.hotEventsId = model.id;
        hotEventVC.hotEventsTitle = model.title;
        [self.navigationController pushViewController:hotEventVC animated:YES];
    }
    
    
    else if ([model.type isEqualToString:@"hottopicset"]){
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
        XTHotTopicViewController *hotTopicVC = [storyBoard instantiateViewControllerWithIdentifier:@"XTHotTopicViewController"];
        
        hotTopicVC.itemID = [NSNumber numberWithInteger:model.id];
        
        [self.navigationController pushViewController:hotTopicVC animated:YES];
    }
    
    
    else if ([model.type isEqualToString:@"vuser"]){
        XTVSpreadViewController *spreadVC = [[XTVSpreadViewController alloc]init];
        spreadVC.recId = model.id;
        spreadVC.recTitle = model.title;
        [self.navigationController pushViewController:spreadVC animated:YES];
    }
    
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
