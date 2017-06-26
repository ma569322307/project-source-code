//
//  XTExampleViewController.m
//  tian
//
//  Created by yyt on 15-6-8.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTLickRankingViewController.h"
#import "XTHotRankListCell.h"
#import "XTHotLicksStore.h"
#import "XTConfig.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTLickRankingModel.h"
#import "XTUserHomePageViewController.h"
#import "XTUserStore.h"
#import "XTTopicRuleViewController.h"
#define K_TIANLIBANG @"rank/power/list.json"
#define K_TIANSHENBANG @"rank/god/list.json"
#define K_MINGXINGBANG @"rank/star/list.json"
@interface XTLickRankingViewController ()<UITableViewDataSource>
@property (nonatomic, assign) NSInteger isLoadMorepage;
@end

@implementation XTLickRankingViewController
-(void)buttonClicked:(id)sender{
    XTTopicRuleViewController *topicRule = [[XTTopicRuleViewController alloc]init];
    [self.navigationController pushViewController:topicRule animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0., 0., 40., 40.0);
    [button setImage:[UIImage imageNamed:@"HotClicks"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.tableView.frame = CGRectMake(8, 0, SCREEN_SIZE.width-16, SCREEN_SIZE.height-64);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self requestWithCell:NO];
    @weakify(self);
    XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self requestWithCell:YES];
    }];
    self.tableView.footer = footer;
}
#pragma mark-------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.array count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"Identifier";
    XTHotRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[XTHotRankListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
}
    XTLickRankingModel *model = [self.array objectAtIndex:indexPath.row];
    [cell configWithHotFourTbaleViewCell:indexPath andmodel:model];
    if (self.type == XTTIANLILIST) {
        cell.titleLabel.text = [NSString stringWithFormat:@"舔力值:%@",@(model.score)];
        cell.contentLabel.hidden = YES;
    }
    if (self.type == XTTIANSHENGLIST){
        cell.contentLabel.hidden = YES;
        cell.titleLabel.text = [NSString stringWithFormat:@"神力值:%@",@(model.score)];
    }if(self.type == XTMINGXING){
        cell.levelLabel.hidden = YES;
        cell.contentLabel.hidden = YES;
        cell.titleLabel.text = [NSString stringWithFormat:@"星能值:%@",@(model.score)];
    }
    [YYTHUD hideLoadingFrom:self.view];
    return cell;
}
-(void)requestWithCell:(BOOL)isLoadMore{
    NSInteger offset = isLoadMore?self.isLoadMorepage*24:0;
    [YYTHUD showLoadingAddedTo:self.view];
    NSDictionary *dic = @{@"offset":[NSNumber numberWithInteger:offset],@"size":@"24"};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager GET:self.string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:responseObject];
        if (self.type == XTMINGXING) {
            [dataArray addObjectsFromArray:dataArray withCheckKey:@"artistId" completionBlock:^{
                self.isLoadMorepage ++;
                
                [self.tableView reloadData];
            }];
        }else{
            [dataArray addObjectsFromArray:dataArray withCheckKey:@"userId" completionBlock:^{
                self.isLoadMorepage++;
                [self.tableView reloadData];
            }];
        }
        if (dataArray.count<5) {
            self.tableView.footer.hidden = YES;
        }
        [self.tableView.footer endRefreshing];
        for (NSDictionary *exampleDic in dataArray) {
            XTLickRankingModel *model = [[XTLickRankingModel alloc]init];
            [model setValuesForKeysWithDictionary:exampleDic];
            if (self.type ==XTMINGXING) {
                model.userName = [exampleDic objectForKey:@"artistName"];
                model.userId = [[exampleDic objectForKey:@"artistId"] integerValue];
            }
            [self.array addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XTUserHomePageViewController *homePageVC = [[XTUserHomePageViewController alloc]init];
    XTLickRankingModel *model = [self.array objectAtIndex:indexPath.row];
    XTUserStore *infoModel = [XTUserStore sharedManager];
    if ([self.string  isEqual: K_TIANLIBANG]  || [self.string isEqual:K_TIANSHENBANG] ) {
        if (model.userId != [infoModel.user.userID integerValue]){
            homePageVC.type = XTUserHomePageTypeHis;
            homePageVC.userID = [NSString stringWithFormat:@"%@",@(model.userId)];
            [self.navigationController pushViewController:homePageVC animated:YES];
        }
    }else{
        if (model.userId != [infoModel.user.userID integerValue]){
            homePageVC.type = XTUserHomePageTypeArtist;
            homePageVC.userID = [NSString stringWithFormat:@"%@",@(model.userId)];
            [self.navigationController pushViewController:homePageVC animated:YES];
    }
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
