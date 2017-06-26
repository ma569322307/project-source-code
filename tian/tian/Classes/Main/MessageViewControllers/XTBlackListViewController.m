//
//  XTBlackListViewController.m
//  tian
//
//  Created by cc on 15/7/7.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTBlackListViewController.h"
#import "XTUserCollectionView.h"
#import "XTMessageStore.h"
#import "XTUserStore.h"
@interface XTBlackListViewController ()
@property (nonatomic, strong)XTUserCollectionView *collectionView;
@end

@implementation XTBlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackNavigationItem];
    self.title = @"友尽列表";
    
    self.collectionView = [XTUserCollectionView userCollectionViewWithPageStyle:XTUserCollectionViewStyleVertical CellStyle:XTUserCollectionViewCellStyleDefault buttonStyle:XTUserCollectionViewCellButtonStyleRemove];
    [self.view addSubview:self.collectionView];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(14,14, 0, 14));
    }];
    __weak XTBlackListViewController *weakSelf = self;
    XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadBlackListDataIsLoadMore:YES];
    }];
//    footer.automaticallyRefresh = NO;
    self.collectionView.footer = footer;
    [self loadBlackListDataIsLoadMore:NO];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadBlackListDataIsLoadMore:(BOOL)isloadMore
{
    NSString * selfUserId = [XTUserStore sharedManager].user.userID;
    NSInteger offset = 1;
    if (isloadMore) {
        offset = self.collectionView.userArray.count;
    }
    [[[XTMessageStore alloc]init] fetchBlackListWithUserId:selfUserId offset:offset size:20 CompletionBlock:^(id userinfoArr, NSError *error) {
        [self.collectionView.footer endRefreshing];
        
        if (!error) {
            NSMutableArray *mutableArray = [NSMutableArray array];
            if (isloadMore) {
                NSArray *uInfoArr = [NSArray arrayWithArray:userinfoArr];
                
                if (uInfoArr.count<20) {
                    self.collectionView.footer.hidden = YES;
                }
                [mutableArray addObjectsFromArray:self.collectionView.userArray];
            }else
            {
                mutableArray = [NSMutableArray arrayWithArray:userinfoArr];
            }
            
            self.collectionView.userArray = [NSArray arrayWithArray:mutableArray];
            [self.collectionView reloadData];
        }else
        {
            CLog(@"请求失败了 = %@",error);
        }
    }];
}
- (void)removeFromShipendWithFriendId:(long)friendId
{
    [[[XTMessageStore alloc]init] removeShipendWithId:friendId CompletionBlock:^(BOOL removeSuccess, NSError *error) {
        if (removeSuccess) {
            CLog(@"删除成功");
        }else
        {
            CLog(@"删除失败 == =%@",error);
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
