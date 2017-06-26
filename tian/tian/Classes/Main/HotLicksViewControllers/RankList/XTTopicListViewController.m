//
//  XTTopicListViewController.m
//  tian
//
//  Created by yyt on 15/6/23.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTopicListViewController.h"
#import "XTTopicListCell.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTTopicListModel.h"
#import "XTUploadImageManage.h"
#import "XTTopicIndexViewController.h"
#import "XTTopicRuleViewController.h"
#define K_CELLWITHHEIGHT 77;
static NSString *string = @"rank/topic/list.json";//话题榜读取数据
@interface XTTopicListViewController ()
@property (nonatomic, assign) NSInteger loadMorePage;

@end

@implementation XTTopicListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestWithTipic:) name:@"NotificationCollectionTopic" object:nil];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0., 0., 40., 40.0);
    self.tableView.frame = CGRectMake(0, 0., SCREEN_SIZE.width, SCREEN_SIZE.height-64);
    [button setImage:[UIImage imageNamed:@"HotClicks"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    @weakify(self);
    XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self requestWithTipic:YES];
    }];
    self.tableView.footer = footer;
    [self requestWithTipic:NO];
}
//网络下载数据
-(void)requestWithTipic:(BOOL)loadMore{
    NSInteger offset = loadMore?self.loadMorePage*24:0;
    [YYTHUD showLoadingAddedTo:self.view];
    NSDictionary *TopicDic = @{@"offset":[NSNumber numberWithInteger:offset],@"size":@"24"};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:string parameters:TopicDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:responseObject];
        
        [dataArray addObjectsFromArray:dataArray withCheckKey:@"topicId" completionBlock:^{
            [self.tableView reloadData];
            self.loadMorePage++;
        }];
        [self.tableView.footer endRefreshing];
        if (dataArray.count<5) {
            [self.tableView.footer setHidden:YES];
        }
        for (NSDictionary *topicDic in dataArray) {
            XTTopicListModel *model = [[XTTopicListModel alloc]init];
            [model setValuesForKeysWithDictionary:topicDic];
            
            [self.array addObject:model];
            
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
#pragma mark--------UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return K_CELLWITHHEIGHT;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.array count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"Identifier";
    XTTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XTTopicListCell" owner:self options:0]lastObject];
    }
    
    XTTopicListModel *listModel = [self.array objectAtIndex:indexPath.section];
    
    [cell configWithTopicCell:listModel];
    cell.layer.borderColor =UIColorFromRGB(0xd2d2d2).CGColor;
    [YYTHUD hideLoadingFrom:self.view];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{//设置头标题的高度
    if (section <3) {
        return 22;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section <3) {
        NSArray *titleArray = @[@"   第1名",@"   第2名",@"   第3名"];
        UIView *headerView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 22)];
        UILabel *headerLable = [[UILabel alloc]initWithFrame:CGRectMake(0, -0.5, SCREEN_SIZE.width, 22)];
        headerLable.backgroundColor = [UIColor whiteColor];
        headerLable.text = [titleArray objectAtIndex:section];
        headerLable.font = [UIFont systemFontOfSize:11];
        [headerView addSubview:headerLable];
        return headerView;
    }else{
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XTTopicIndexViewController *TopicIndex = [[XTTopicIndexViewController alloc]init];
    @weakify(self);
    [TopicIndex setCompletion:^{
        @strongify(self);
        self.loadMorePage = 0;
        [self.array removeAllObjects];
        [self requestWithTipic:NO];
    }];
    XTTopicListModel *model = [self.array objectAtIndex:indexPath.section];
    TopicIndex.topicTitle = model.title;
    TopicIndex.topicId = model.topicId;
    [self.navigationController pushViewController:TopicIndex animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buttonClicked:(id)sender{
    XTTopicRuleViewController *topicRule = [[XTTopicRuleViewController alloc]init];
    [self.navigationController pushViewController:topicRule animated:YES];
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
