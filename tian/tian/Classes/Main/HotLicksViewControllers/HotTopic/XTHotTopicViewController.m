//
//  XTHotTopicViewController.m
//  tian
//
//  Created by loong on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHotTopicViewController.h"
#import "XTHotTopicView.h"
#import "XTSeriesContentStore.h"
#import "Define.h"
#import "XTTopicCell.h"
#import "XTTopicIndexViewController.h"
#import "XTHotTopicSetModel.h"
#import "XTHotTopicModel.h"
#import "XTParticipateView.h"
#import "XTUserHomePageViewController.h"
#import "XTUserInfo.h"
#import "XTShareManager.h"
@interface XTHotTopicViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,XTParticipateViewDelegate,XTHotTopicViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)XTHotTopicView *topicView;


@property(nonatomic,strong)NSArray *dataSource;

@end

@implementation XTHotTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *sharBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    sharBtn.frame = CGRectMake(0, 0, 40, 40);
    
    [sharBtn setBackgroundImage:[UIImage imageNamed:@"share_brown"] forState:UIControlStateNormal];
    //[sharBtn setBackgroundImage:[UIImage imageNamed:@"share_h.png"] forState:UIControlStateHighlighted];
    
    [sharBtn addTarget:self action:@selector(sharBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:sharBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XTTopicCell" bundle:nil] forCellReuseIdentifier:@"XTTopicCell"];
    
    
    [self hotTopicSetRequest];
    
}

-(XTHotTopicView *)topicView{
    if (!_topicView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XTHotTopicView" owner:self options:nil];
        
        _topicView = nib[0];
        _topicView.delegate = self;
    }
    return _topicView;
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"NO",@"isShowTabBar",nil];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"isShowTabBarNotification" object:dic];
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"YES",@"isShowTabBar",nil];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"isShowTabBarNotification" object:dic];
//}

-(IBAction)sharBtnClick:(UIButton *)sender{
    
    XTHotTopicSetModel *model = self.dataSource[0];
    [[XTShareManager sharedManager] shareWithTitle:model.title withMvDesc:model.des withImage:[self.topicView getShareImage] withShareModeType:XTShareModeTypeTopic withPid:[self.itemID integerValue] withShareSheetType:XTShareSheetItemNone withCompletionBlock:^(NSInteger index) {
        
    }];
}



-(void)hotTopicSetRequest{
    NSString *url = [XT_API stringByAppendingString:XT_HOTTOPICSET];
    NSLog(@"url === %@",url);
    
    NSDictionary *parameters = @{@"id":self.itemID};
    
    [XTSeriesContentStore fatchHotTopicSetWithUrl:url andParameters:parameters successBlock:^(id responseObject) {
        NSLog(@"responseObject ===== %@",responseObject);
        //self.dataSource = responseObject;
        
        XTHotTopicModel *model = responseObject;
        
        self.title = model.title;
        
        self.dataSource = model.topics;
        
        self.topicView.model = self.dataSource[0];
        
        CGSize size = [self.topicView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        self.topicView.frame = CGRectMake(0, 0, size.width, size.height);
        
        
        self.tableView.tableHeaderView = self.topicView;
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"error ==== %@",error);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"XTTopicCell";
    XTTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    [cell configerDataWithModel:self.dataSource[indexPath.row + 1] andIndex:(indexPath.row + 1) % 6];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 84;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XTTopicIndexViewController *controller = [[XTTopicIndexViewController alloc] init];
    
    XTHotTopicSetModel *model = self.dataSource[indexPath.row + 1];
    
    controller.topicId = [model.itemID integerValue];
    
    controller.topicTitle = model.title;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}


#pragma -mark XTParticipateViewDelegate

-(void)tapActionWith:(XTUserInfo *)userInfo{
    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%ld",userInfo.uid];
    controller.type = XTUserHomePageTypeHis;
    controller.userType = XTAccountCommon;
    [self.navigationController pushViewController:controller animated:YES];

    
}


#pragma -mark XTHotTopicViewDelegate

-(void)hotTopicViewTapAction{
    
    XTTopicIndexViewController *controller = [[XTTopicIndexViewController alloc] init];
    
    XTHotTopicSetModel *model = self.dataSource[0];
    
    controller.topicId = [model.itemID integerValue];
    
    controller.topicTitle = model.title;
    
    [self.navigationController pushViewController:controller animated:YES];

    
    
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
