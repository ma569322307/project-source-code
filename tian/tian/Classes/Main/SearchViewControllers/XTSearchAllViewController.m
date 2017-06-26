//
//  XTSearchAllViewController.m
//  tian
//
//  Created by huhuan on 15/6/13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchAllViewController.h"
#import "XTSearchAllCollectionView.h"
#import "XTConfig.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTSearchAllModel.h"
#import <Mantle/EXTScope.h>

@interface XTSearchAllViewController ()

@property (nonatomic, strong) XTSearchAllCollectionView *searchAllCollectionView;
@property (nonatomic, assign) NSInteger offset;

@end

@implementation XTSearchAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchAllCollectionView = [XTSearchAllCollectionView searchAllCollectionView];
    @weakify(self);
    self.searchAllCollectionView.loadMore = ^() {
        @strongify(self);
        [self requestAllInfo];
    };
    self.offset = 0;
}

- (void)refreshViewController {
    self.offset = 0;
    self.searchAllCollectionView.searchAllModel = nil;
    [self requestAllInfo];
}

- (void)requestAllInfo {
  
    NSString *searchText = [self.keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    NSDictionary *requestDic = @{
                                 @"keyword"    : searchText ? searchText : @"",
                                 @"soType"     : @"all",
                                 @"order"      : @"",
                                 @"offset"     : @(self.offset),
                                 @"size"       : @"24"
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:searchAllUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *err = nil;
        XTSearchAllModel *searchAllInfo = [MTLJSONAdapter modelOfClass:[XTSearchAllModel class] fromJSONDictionary:responseObject error:&err];

        if([searchAllInfo.users count] > 9) {
            NSMutableArray *tempUserArray = [NSMutableArray arrayWithArray:searchAllInfo.users];
            [tempUserArray removeObjectsInRange:NSMakeRange(9, [searchAllInfo.users count] - 9)];
            searchAllInfo.users = tempUserArray;
        }
        
        if([searchAllInfo.albums count] > 10) {
            NSMutableArray *tempAlbumArray = [NSMutableArray arrayWithArray:searchAllInfo.albums];
            [tempAlbumArray removeObjectsInRange:NSMakeRange(10, [searchAllInfo.albums count] - 10)];
            searchAllInfo.albums = tempAlbumArray;
        }
        
        [self.view addSubview:self.searchAllCollectionView];
        if(!self.searchAllCollectionView.searchAllModel) {
            self.searchAllCollectionView.searchAllModel = searchAllInfo;
            [self.searchAllCollectionView configureSearchAllCollectionView];
            [self.searchAllCollectionView reloadData];
        }else {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.searchAllCollectionView.searchAllModel.pics];
            
            [tempArray addObjectsFromArray:searchAllInfo.pics withCheckKey:@"id" completionBlockWithReturnValue:^(NSMutableArray *array) {
                
               self.searchAllCollectionView.searchAllModel.pics = array;
                [self.searchAllCollectionView configureSearchAllCollectionView];
                [self.searchAllCollectionView reloadData];
                
            }];

        }

        if([searchAllInfo.pics count] == 0) {
            [self.searchAllCollectionView.waterFallControl hidenTheFooterView:YES];
        }else {
            [self.searchAllCollectionView.waterFallControl hidenTheFooterView:NO];
            self.offset += 24;
        }
        [self.searchAllCollectionView.waterFallControl stopWaterViewAnimating];
        
        [self.searchAllCollectionView remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
        }];
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        
        if(!searchAllInfo.artist &&
           [searchAllInfo.users count] == 0 &&
           [searchAllInfo.topics count] == 0 &&
           [searchAllInfo.albums count] == 0 &&
           [searchAllInfo.pics count] == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleBlank eventClick:^{
                
            }];
            [self.view bringSubviewToFront:blankView];
            blankView.headerStyle = YYTBlankHeaderStyleBowl;
            blankView.tipString = @"没有找到你搜索的东西，图库君(●—●)等你反馈";
        }else {
            [YYTBlankView hideFromView:self.view];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTBlankView hideFromView:self.view];
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        
        [self.searchAllCollectionView configureSearchAllCollectionView];
        [self.searchAllCollectionView reloadData];
        
        if(!self.searchAllCollectionView.searchAllModel.artist &&
           [self.searchAllCollectionView.searchAllModel.users count] == 0 &&
           [self.searchAllCollectionView.searchAllModel.topics count] == 0 &&
           [self.searchAllCollectionView.searchAllModel.albums count] == 0 &&
           [self.searchAllCollectionView.searchAllModel.pics count] == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
                [self requestAllInfo];
            }];
            [self.view bringSubviewToFront:blankView];
        }

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
