//
//  XTSearchTagViewController.m
//  tian
//
//  Created by huhuan on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchTagViewController.h"
#import "XTSearchTagTableView.h"
#import "XTConfig.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTTagInfo.h"

@interface XTSearchTagViewController ()

@property (nonatomic, strong) XTSearchTagTableView *tagTableView;
@property (nonatomic, assign) NSInteger tagOffset;

@end

@implementation XTSearchTagViewController

static NSString* const requestUrl = @"/search/so.json";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tagOffset = 0;
    self.tagTableView = [XTSearchTagTableView tagTableView];
    @weakify(self);
    XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self requestTagInfo];
    }];
//    footer.automaticallyRefresh = NO;
    self.tagTableView.footer = footer;
}

- (void)refreshViewController {
    self.tagTableView.tagArray = nil;
    [self.tagTableView reloadData];
    self.tagOffset = 0;
    [self requestTagInfo];
}

- (void)requestTagInfo {
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    NSString *searchText = [self.keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSDictionary *requestDic = @{
                                 @"deviceinfo" : [[XTConfig sharedManager] deviceInfo],
                                 @"keyword"    : searchText ? searchText : @"",
                                 @"soType"     : @"tag",
                                 @"order"      : @"",
                                 @"offset"     : @(self.tagOffset),
                                 @"size"       : @"24"
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:requestUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        NSArray *tagInfo = [MTLJSONAdapter modelsOfClass:[XTTagInfo class] fromJSONArray:responseObject error:&err];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.tagTableView.tagArray];
        [tempArray addObjectsFromArray:tagInfo withCheckKey:@"tagId" completionBlockWithReturnValue:^(NSMutableArray *array) {
            
            self.tagTableView.tagArray = array;
            [self.view addSubview:self.tagTableView];
            [self.tagTableView reloadData];
            
            [self.tagTableView.footer endRefreshing];
            if([tagInfo count] == 0) {
                self.tagTableView.footer.hidden = YES;
            }else {
                self.tagTableView.footer.hidden = NO;
                self.tagOffset += 24;
            }
            
            [self.tagTableView updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(UIEdgeInsetsMake(0., 7., 0., 7.));
            }];
            [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
            
            if([self.tagTableView.tagArray count] == 0) {
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
        
        if([self.tagTableView.tagArray count] == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
                [self requestTagInfo];
            }];
            [self.view bringSubviewToFront:blankView];
        }else {
            [YYTBlankView hideFromView:self.view];
        }
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

@end
