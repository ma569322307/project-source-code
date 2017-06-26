//
//  XTSearchTopicViewController.m
//  tian
//
//  Created by huhuan on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchTopicViewController.h"
#import "XTConfig.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTHotLicksTopicsInfo.h"
#import "XTSearchTopicTableView.h"

@interface XTSearchTopicViewController ()

@property (nonatomic, strong) XTSearchTopicTableView *topicTableView;
@property (nonatomic, assign) NSInteger topicOffset;

@end

@implementation XTSearchTopicViewController

static NSString* const requestUrl = @"/search/so.json";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topicTableView = [XTSearchTopicTableView topicTableView];
    
    @weakify(self);
    XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self requestTopicInfo];
    }];
//    footer.automaticallyRefresh = NO;
    self.topicTableView.footer = footer;

}

- (void)requestTopicInfo {
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    NSString *searchText = [self.keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSDictionary *requestDic = @{
                                 @"deviceinfo" : [[XTConfig sharedManager] deviceInfo],
                                 @"keyword"    : searchText ? searchText : @"",
                                 @"soType"     : @"topic",
                                 @"order"      : @"",
                                 @"offset"     : @(self.topicOffset),
                                 @"size"       : @"24"
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:requestUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        NSArray *topicInfo = [MTLJSONAdapter modelsOfClass:[XTHotLicksTopicsInfo class] fromJSONArray:responseObject error:&err];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.topicTableView.topicArray];
        [tempArray addObjectsFromArray:topicInfo withCheckKey:@"id" completionBlockWithReturnValue:^(NSMutableArray *array) {
            
            self.topicTableView.topicArray = array;
            
            [self.topicTableView.footer endRefreshing];
            if([topicInfo count] == 0) {
                self.topicTableView.footer.hidden = YES;
            }else {
                self.topicTableView.footer.hidden = NO;
                self.topicOffset += 24;
                
                [self.view addSubview:self.topicTableView];
                
                [self.topicTableView updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(UIEdgeInsetsMake(0., 7., 0., 7.));
                }];
            }
            
            [self.topicTableView reloadData];
            
            [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
            
            if([self.topicTableView.topicArray count] == 0) {
                YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleBlank eventClick:nil];
                blankView.headerStyle = YYTBlankHeaderStyleCry;
                blankView.tipString = @"没有找到你搜索的东西，图库君(●—●)等你反馈";
                [self.view bringSubviewToFront:blankView];
            }else {
                [YYTBlankView hideFromView:self.view];
            }
            
        }];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        if([self.topicTableView.topicArray count] == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
                [self requestTopicInfo];
            }];
            [self.view bringSubviewToFront:blankView];
        }else {
            [YYTBlankView hideFromView:self.view];
        }
    }];
}

- (void)refreshViewController {
    self.topicTableView.topicArray = nil;
    [self.topicTableView reloadData];
    self.topicOffset = 0;
    [self requestTopicInfo];
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
