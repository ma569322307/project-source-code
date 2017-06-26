//
//  XTHotCreateViewController.m
//  tian
//
//  Created by yyt on 15-5-29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHotCreateViewController.h"
#import "XTHotMyCreateTopicCell.h"
#import "XTTopicIndexViewController.h"
#import "XTCreateTopic.h"
#define K_Count 10
#define K_CREATETOPICLISTURL @"topic/my.json"  //我创建的话题列表
@interface XTHotCreateViewController ()
@property (nonatomic , assign)NSInteger loadMorePage;
@property (nonatomic, assign) NSInteger maxId;
@property (nonatomic ,strong) NSMutableDictionary *postCountDic;//用于存放每个话题的帖子数
@end

@implementation XTHotCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.frame = CGRectMake(0., 0., SCREEN_SIZE.width, SCREEN_SIZE.height-64);
    self.title = @"我创建的话题";
    [self requestMyCreateTopic:NO];
    @weakify(self);
    [XTGifFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self requestMyCreateTopic:YES];
    }];
}
-(void)requestMyCreateTopic:(BOOL)loadMore{
    NSInteger maxId = loadMore?self.maxId:0;
    NSDictionary *paramDic = @{@"maxId":[NSNumber numberWithInteger:maxId],@"size":@"20"};
    XTHTTPRequestOperationManager  *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:K_CREATETOPICLISTURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, NSMutableArray * responseObject) {
        
        NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
        for (NSDictionary *dic in responseObject) {
            XTCreateTopic *TopicModel = [[XTCreateTopic alloc]init];
            [TopicModel setValuesForKeysWithDictionary:dic];
            TopicModel.replaceid = (long)[dic objectForKey:@"id"];
            TopicModel.descrip = [dic objectForKey:@"description"];
            

            //计算未读帖子数
            self.postCountDic = [NSMutableDictionary dictionaryWithDictionary:[Defaults objectForKey:@"postCount"]];
//            NSString *readCount = [self.postCountDic[@(TopicModel.id)] stringValue];
//            NSInteger postCount = TopicModel.PostCount;
//            TopicModel.viewCount = [readCount integerValue];
            TopicModel.viewCount = [self.postCountDic[[@(TopicModel.id) stringValue]] integerValue];
            self.postCountDic[[@(TopicModel.id) stringValue]] = @(TopicModel.viewCount);
            [self.array addObject:TopicModel];
            [self.tableView reloadData];
        }
        [Defaults setObject:self.postCountDic forKey:@"postCount"];
        [Defaults synchronize];
        XTCreateTopic *lastModel = [self.array lastObject];
        self.maxId = lastModel.id;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identi = @"ID";
    XTHotMyCreateTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:Identi];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XTHotMyCreateTopicCell" owner:self options:0]lastObject];
    }
    [cell configWithCell:[self.array objectAtIndex:indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XTTopicIndexViewController *topicVC = [[XTTopicIndexViewController alloc]init];
    XTCreateTopic *model = [self.array objectAtIndex:indexPath.row];
    topicVC.topicTitle = model.title;
    topicVC.topicId = model.id;
    
    model.viewCount = model.PostCount;
    self.postCountDic[[@(model.id) stringValue]] = @(model.viewCount);
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    [Defaults setObject:self.postCountDic forKey:@"postCount"];
    [Defaults synchronize];
    [self.tableView reloadData];
    
    [self.navigationController pushViewController:topicVC animated:YES];

}
@end
