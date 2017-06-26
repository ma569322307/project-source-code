//
//  XTpublishViewController.m
//  tian
//
//  Created by yyt on 15-6-11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTmoreViewController.h"
#import "XTTopicTableViewCell.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTCreateTopic.h"
#import "XTTopicIndexViewController.h"
@interface XTmoreViewController ()
@property (nonatomic, assign) NSInteger loadMorePage;
#define K_MORETOPICLIST @"operate/topic/list.json"
//#define K_HEIGHT 78
@end

@implementation XTmoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"更多";
    self.tableView.frame = CGRectMake(0, 0., SCREEN_SIZE.width, SCREEN_SIZE.height-64);
    [self requestWothMoreTopicList:NO];
    @weakify(self);
    XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self requestWothMoreTopicList:YES];
    }];
    self.tableView.footer = footer;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark--------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.array count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *publish = @"publish";
    XTTopicTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:publish];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XTTopicTableViewCell" owner:self options:0]lastObject];
    }
    [cell configureTopicCell:[self.array objectAtIndex:indexPath.row]];
    [YYTHUD hideLoadingFrom:self.view];
    
    return cell;
}
-(void)requestWothMoreTopicList:(BOOL)isLoadMore{
    NSUInteger offset = isLoadMore?self.loadMorePage *24:0;
    [YYTHUD showLoadingAddedTo:self.view];
    NSDictionary *dic = @{@"offset":[NSNumber numberWithInteger:offset],@"size":@"24"};
    __weak XTmoreViewController *weakSelf= self;
    XTHTTPRequestOperationManager *manager = [[XTHTTPRequestOperationManager alloc]init];
    [manager GET:K_MORETOPICLIST parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:responseObject];
        
        [dataArray addObjectsFromArray:dataArray withCheckKey:@"id" completionBlock:^{
            self.loadMorePage++;
            [weakSelf.tableView reloadData];
        }];
        if (dataArray.count<5) {
            [self.tableView.footer setHidden:YES];
        }
        [self.tableView.footer endRefreshing];
        for (NSDictionary *TopicDic in dataArray) {
            
            XTCreateTopic *topicModel = [[XTCreateTopic alloc]init];
            [topicModel setValuesForKeysWithDictionary:TopicDic];
            
            topicModel.descrip = [TopicDic objectForKey:@"description"];
            topicModel.id = [[TopicDic objectForKey:@"id"] integerValue];
            topicModel.nickName = [[TopicDic objectForKey:@"user"]objectForKey:@"nickName"];
            topicModel.smallAvatar = [[TopicDic objectForKey:@"user"] objectForKey:@"smallAvatar"];
            [self.array addObject:topicModel];
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XTCreateTopic *topicModel = [self.array objectAtIndex:indexPath.row];
    XTTopicIndexViewController *topicIndexVC = [[XTTopicIndexViewController alloc]init];
    topicIndexVC.topicId = topicModel.id;
    topicIndexVC.topicTitle = topicModel.title;
    CLog(@"%zd %@",topicIndexVC.topicId,topicIndexVC.topicTitle);
    [self.navigationController pushViewController:topicIndexVC animated:YES];
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
