//
//  XTHotMyTopivViewController.m
//  tian
//
//  Created by yyt on 15-5-29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHotMyTopivViewController.h"
#import "XTMyTopicCell.h"
#import "XTTopicWithUserHeaderTableViewCell.h"
#import "XTHotCreateViewController.h"
#import "XTNavigationController.h"
#import "XTTabBarController.h"
#import "XTHotLicksStore.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTConfig.h"
#import "XTCreateTopicController.h"
#import "XTCreateTopic.h"
#import "XTTopicIndexViewController.h"
#import <Mantle/EXTScope.h>
#import "YYTHUD.h"
#define K_COLLECTIONTOPICLISTURL @"topic/favorites/list.json" //我收藏的话题列表
#define K_CREATETOPICLISTURL @"http://papi.yinyuetai.com/topic/my/count.json"  //我创建的话题数量
#import "XTHTTPRequestOperationManager.h"
static NSString *Identifier = @"IID";
static NSString *Ident = @"ID";
@interface XTHotMyTopivViewController ()
@property (nonatomic,strong) NSMutableArray *topicArray;//存放收藏的话题
@property (nonatomic,strong) NSMutableDictionary *postCountDictionary;//用来存放话题的未读帖子数
@property (nonatomic ,assign) NSInteger temp;
@property (nonatomic, assign) NSUInteger LoadMorePage;
@end

@implementation XTHotMyTopivViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestWithCollection:) name:@"deleteCollectionTopic" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.topicArray = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"我的话题";
    self.tableView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height-64-58);
    @weakify(self);
    XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self requestWithCollection:YES];
    }];
    self.tableView.footer = footer;
    [self requestMyCreateTopic];
    [self requestWithCollection:NO];
}
- (void)clickNaBackBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark------UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  [self.topicArray count]+1;
}              // Default is 1 if not implemented

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        XTMyTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:Ident];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"XTMyTopicCell" owner:self options:0]lastObject];
        }
        cell.lable.text = [NSString stringWithFormat:@"话题%@",@(self.temp)];
        return cell;
    }else{
        XTTopicWithUserHeaderTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"XTTopicWithUserHeaderTableViewCell" owner:self options:0]lastObject];
        }
        [cell configWithCell:[self.topicArray objectAtIndex:indexPath.section-1]];
        [YYTHUD hideLoadingFrom:self.view];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        XTHotCreateViewController *createTopicVC = [[XTHotCreateViewController alloc]init];
        [self.navigationController pushViewController:createTopicVC animated:YES];
    }else{
        XTTopicIndexViewController *topicindex = [[XTTopicIndexViewController alloc]init];
        XTCreateTopic *createModel = [self.topicArray objectAtIndex:indexPath.section-1];
        topicindex.topicId =createModel.id;
        topicindex.topicTitle = createModel.title;

        [self.navigationController pushViewController:topicindex animated:YES];
        createModel.viewCount = createModel.PostCount;
        self.postCountDictionary[[@(createModel.id) stringValue]] = @(createModel.viewCount);
        
        NSUserDefaults *userDefault= [NSUserDefaults standardUserDefaults];
        [userDefault setObject:self.postCountDictionary forKey:@"unread"];
        [userDefault synchronize];
        [self.tableView reloadData];
    }
}
-(void)requestMyCreateTopic{
    XTHTTPRequestOperationManager  *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:K_CREATETOPICLISTURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.temp = [[responseObject objectForKey:@"count"] integerValue];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)requestWithCollection:(BOOL)loadMore{
    NSUInteger offset = loadMore?self.LoadMorePage*24:0;
    self.array = [[NSMutableArray alloc]init];
    NSDictionary *paramDic = @{@"offset":[NSNumber numberWithInteger:offset],@"size":@"24"};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:K_COLLECTIONTOPICLISTURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [YYTHUD showLoadingAddedTo:self.view];
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:responseObject];
        if ([dataArray count]) {
            [dataArray addObjectsFromArray:dataArray withCheckKey:@"id" completionBlock:^{
                self.LoadMorePage++;
                [self.tableView reloadData];
            }];
        }else{
            [YYTHUD hideLoadingFrom:self.view];
        }
        if (dataArray.count<5) {
            self.tableView.footer.hidden = YES;
        }
        [self.tableView.footer endRefreshing];
        NSUserDefaults *userDefault= [NSUserDefaults standardUserDefaults];
        for (NSDictionary *dataDic in dataArray) {
            XTCreateTopic *topicModel = [[XTCreateTopic alloc]init];
            [topicModel setValuesForKeysWithDictionary:dataDic];
            
            topicModel.nickName = [[dataDic objectForKey:@"user"] objectForKey:@"nickName"];
            topicModel.smallAvatar = [[dataDic objectForKey:@"user"] objectForKey:@"smallAvatar"];
            topicModel.descrip = [dataDic objectForKey:@"description"];
            //计算未读帖子数
            
            self.postCountDictionary = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:@"unread"]];
            
            CLog(@"---%@",self.postCountDictionary[[@(topicModel.id) stringValue]]);
            
//            NSString *readCount = [self.postCountDictionary[@(topicModel.id)] stringValue];
            
            topicModel.viewCount = [self.postCountDictionary[[@(topicModel.id) stringValue]] integerValue];
            
            self.postCountDictionary[[@(topicModel.id) stringValue]] = @(topicModel.viewCount);
            
            [self.topicArray addObject:topicModel];
            
        }
        [userDefault setObject:self.postCountDictionary forKey:@"unread"];
        [userDefault synchronize];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
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

- (IBAction)buttonCreateTopic:(id)sender {
    XTCreateTopicController *createTopic =[[XTCreateTopicController alloc]init];
    @weakify(self);
    [createTopic setCompletionBlock:^{
        @strongify(self);
        self.temp++;
        [self requestMyCreateTopic];
    }];
   [self.navigationController pushViewController:createTopic animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
