//
//  XTTopicIndexViewController.m
//  tian
//
//  Created by huhuan on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTopicIndexViewController.h"
#import "XTTabBarController.h"
#import "XTConfig.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTHotLicksTopicsInfo.h"
#import "XTPostInfo.h"
#import "XTTopicIndexHeaderView.h"
#import "XTTopicTableView.h"
#import "XTPostTopicViewController.h"
#import "XTSingleTopicDisplayController.h"
#import <Mantle/EXTScope.h>
#import "YYTActionSheet.h"
#import "XTUserStore.h"
#import "XTTopicDetailViewController.h"
#import "JKImagePickerController.h"
#import "XTUploadImageManage.h"

@interface XTTopicIndexViewController () <JKImagePickerControllerDelegate>

@property (nonatomic, strong) XTTopicIndexHeaderView *headerView;
@property (nonatomic, strong) XTTopicTableView       *topicTableView;
@property (nonatomic, strong) UIButton               *settingButton;
@property (nonatomic, strong) XTHotLicksTopicsInfo   *topicInfo;

@property (nonatomic, assign) BOOL                   postListNeedRefresh;
@property (nonatomic, assign) long                   lastId;

@end

@implementation XTTopicIndexViewController

static NSString* const topicDetailUrl    = @"topic/show.json";
static NSString* const topicSubPostsUrl  = @"topic/posts/list.json";
static NSString* const topicComplaintUrl = @"topic/complaint.json";
static NSString* const topicDeleteUrl    = @"topic/delete.json";
static NSString* const topicBgSetUrl     = @"topic/bg/set.json";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.topicTitle;
    
    self.settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingButton.frame = CGRectMake(0, 0, 40, 40);
    [self.settingButton setImage:[UIImage imageNamed:@"set_brown"] forState:UIControlStateNormal];
    [self.settingButton setImage:[UIImage imageNamed:@"set_brown_sel"] forState:UIControlStateHighlighted];
    [self.settingButton addTarget:self action:@selector(settingClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.settingButton];
    
    [self.view addSubview:self.topicTableView];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"na_add"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"na_add_sel"] forState:UIControlStateHighlighted];
    [addButton setTitle:@"参与话题" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [addButton setTitleColor:UIColorFromRGB(0x4f242b) forState:UIControlStateNormal];
    addButton.imageEdgeInsets = UIEdgeInsetsMake(0., -3., 0., 0.);
    addButton.titleEdgeInsets = UIEdgeInsetsMake(0., -3., 0., 0.);
    [addButton setBackgroundImage:[UIImage imageNamed:@"Tabbar_nav_title"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"Tabbar_nav_title"] forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(addTopicClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    [self.topicTableView updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.bottom.equalTo(addButton.mas_top);
    }];
    
//    MJRefreshHeader *header = [MJRefreshHeader headerWithRefreshingBlock:^{
//        [self refreshTopic];
//    }];
//    self.topicTableView.header = header;
    
    @weakify(self);
    XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self requestTopicSubPostsInfo];
    }];
//    footer.automaticallyRefresh = NO;
    self.topicTableView.footer = footer;
    
    [addButton updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.height.equalTo(@50);
    }];
    
    self.lastId = 0;
    
    [self requestTopicDetailInfo];
    [self requestTopicSubPostsInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRefreshStatus) name:@"PostListRefreshNotification" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    if(self.postListNeedRefresh) {
        [self refreshPost];
        self.postListNeedRefresh = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadResult:) name:UploadImageSucceedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UploadImageSucceedNotification object:nil];
}

- (void)clickNaBackBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeRefreshStatus {
    self.postListNeedRefresh = YES;
}

- (XTTopicIndexHeaderView *)headerView {
    if(!_headerView) {
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"XTTopicIndexHeaderView" owner:self options:0]lastObject];
        @weakify(self);
        _headerView.collectClickBlock = ^(BOOL needCollect) {
            @strongify(self);
            [self requestCollect:needCollect];
        };
    }
    return _headerView;
}

- (XTTopicTableView *)topicTableView {
    if(!_topicTableView) {
        _topicTableView = [XTTopicTableView topicTableViewWithCellStyle:XTTopicTableViewCellStyleHotlick];
        _topicTableView.topicTitle = self.topicTitle;
        @weakify(self);
        _topicTableView.refreshTopicInfo = ^() {
            @strongify(self);
            [self refreshTopic];
        };
        _topicTableView.topicCellClick = ^(MTLModel *modelInfo) {
            @strongify(self);
            if([modelInfo isKindOfClass:[XTPostInfo class]]) {
                XTPostInfo *postInfo = (XTPostInfo *)modelInfo;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
                
                XTTopicDetailViewController *topicDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"XTTopicDetailViewController"];
                topicDetailVC.topicID = @(postInfo.postId);
                [self.navigationController pushViewController:topicDetailVC animated:YES];
                
            }
        };
    }
    return _topicTableView;
}

- (void)addTopicClick:(UIButton *)topicButton {
    XTPostTopicViewController *postTopicVC = [[XTPostTopicViewController alloc] init];
    postTopicVC.topicId = self.topicId;
    postTopicVC.topicTitle = self.topicTitle;
    postTopicVC.completionBlock = ^(){
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"发布成功" withCompletionBlock:^{
            [self refreshTopic];
        }];
        
    };
    [self.navigationController pushViewController:postTopicVC animated:YES];
}

- (void)settingClick:(id)sender {
    
    NSArray *titleArray = nil;
    if(self.topicInfo.user.uid == [[XTUserStore sharedManager].user.userID longLongValue]) {
        titleArray = @[@"设置背景图片", @"设置", @"删除"];
    }else {
        titleArray = @[@"查看资料", @"举报"];
    }
    [YYTActionSheet showWithTitleArray:titleArray withCompletionBlock:^(NSInteger index) {
        if(self.topicInfo.user.uid == [[XTUserStore sharedManager].user.userID longLongValue]) {
            if(index == 1) {
                [self chooseImage];
            }else if(index == 2) {
                XTSingleTopicDisplayController *topicDisplayVC = [[XTSingleTopicDisplayController alloc] init];
                @weakify(self);
                topicDisplayVC.completionBlock = ^() {
                    @strongify(self);
                    [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"修改成功" withCompletionBlock:^{
                        [self requestTopicDetailInfo];
                    }];
                };
                topicDisplayVC.topicInfo = self.topicInfo;
                [self.navigationController pushViewController:topicDisplayVC animated:YES];
            }else if(index == 3) {
                [self deleteTopic];
            }
        }else {
            if(index == 1) {
                XTSingleTopicDisplayController *topicDisplayVC = [[XTSingleTopicDisplayController alloc] init];
                topicDisplayVC.topicInfo = self.topicInfo;
                [self.navigationController pushViewController:topicDisplayVC animated:YES];
            }else if(index == 2) {
                [self requestComplaint];
            }
        }
        
    }];
    
}


-(void)chooseImage {
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = NO;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 1;
    imagePickerController.needSquareCrop = YES;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)refreshTopic {
    [self requestTopicDetailInfo];
    [self refreshPost];
}

- (void)refreshPost {
    self.lastId = 0;
    self.topicTableView.topicArray = nil;
    [self requestTopicSubPostsInfo];
}

/**
 *  删除话题
 */
- (void)deleteTopic {
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    NSDictionary *requestDic = @{@"id" : @(self.topicId)};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager POST:topicDeleteUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"删除成功" withCompletionBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicDeleteSuccessNotification" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:^{
            
        }];
    }];
}

/**
 *  举报话题
 */
- (void)requestComplaint {
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    NSDictionary *requestDic = @{@"topicId" : @(self.topicId)};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager POST:topicComplaintUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"举报成功" withCompletionBlock:^{
            
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:^{
            
        }];
    }];
}

// 上传结果
-(void)uploadResult:(NSNotification *)note{
    [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
    NSString *result = [note.object objectForKey:@"message"];
    if ([result isEqualToString:@"照片上传成功"]) {
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"修改背景图片成功" withCompletionBlock:^{
            [self requestTopicDetailInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserTopicNotification" object:nil];
        }];
    }
}

- (void)requestTopicDetailInfo {
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    NSDictionary *requestDic = @{@"id" : @(self.topicId)};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:topicDetailUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self.topicTableView.header endRefreshing];
        [YYTBlankView hideFromView:self.view];
        self.topicTableView.hidden = NO;
        NSError *err = nil;
        self.topicInfo = [MTLJSONAdapter modelOfClass:[XTHotLicksTopicsInfo class] fromJSONDictionary:responseObject error:&err];
        
        self.topicTableView.topicId = self.topicId;
        if(self.topicInfo.user.uid == [[XTUserStore sharedManager].user.userID longLongValue]) {
            self.topicTableView.isMine = YES;
        }else {
            self.topicTableView.isMine = NO;
        }
        
        [self.headerView configureViewWithTopicInfo:self.topicInfo];
        self.topicTableView.tableHeaderView = self.headerView;
        
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        self.topicTableView.hidden = YES;
        YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
            [self refreshTopic];
        }];
        
        blankView.error = error;
    }];
}

- (void)requestTopicSubPostsInfo {
    NSDictionary *requestDic = @{
                                 @"size" : @"24",
                                 @"topicId" : @(self.topicId),
                                 @"maxId" : @(self.lastId),
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:topicSubPostsUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self.topicTableView.header endRefreshing];
        [self.topicTableView.footer endRefreshing];
        NSError *err = nil;
        NSArray *postArray = [MTLJSONAdapter modelsOfClass:[XTPostInfo class] fromJSONArray:responseObject error:&err];
        
        if([postArray count] == 0) {
            self.topicTableView.footer.hidden = YES;
        }
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.topicTableView.topicArray];
        [tempArray addObjectsFromArray:postArray];
        self.topicTableView.topicArray = tempArray;
        if(self.lastId == 0) {
            [self.topicTableView refreshTableView];
        }else {
            [self.topicTableView reloadData];
        }
        
        self.topicTableView.tableHeaderView = self.headerView;
        
        XTPostInfo *lastPost = [postArray lastObject];
        self.lastId = lastPost.postId;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.topicTableView.footer endRefreshing];
    }];
    
}

- (void)requestCollect:(BOOL)needCollect {
    NSString *collectApi = nil;
    if(needCollect) {
        collectApi = @"/topic/favorites/add.json";
    }else {
        collectApi = @"/topic/favorites/delete.json";
    }
    NSDictionary *requestDic = @{@"topicId" : @(self.topicId)};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager POST:collectApi parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject[@"rs"] integerValue] == 200) {
            [self.headerView resetCollectStatusWithResponse:YES collectMode:NO];
        }else{
            [YYTHUD showPromptAddedTo:self.view withText:needCollect ? @"收藏失败" : @"取消收藏失败" withCompletionBlock:^{
                [self.headerView resetCollectStatusWithResponse:NO collectMode:!needCollect];
            }];
        }
        if (self.completion) {
            self.completion();
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationCollectionTopic" object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD showPromptAddedTo:self.view withText:needCollect ? @"收藏失败" : @"取消收藏失败" withCompletionBlock:^{
            [self.headerView resetCollectStatusWithResponse:NO collectMode:!needCollect];
        }];
    }];
    
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{

    UIImage *tempImage = assets[0];
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    NSMutableDictionary *uploadParameter = [NSMutableDictionary dictionaryWithDictionary:@{@"id" : @(self.topicId)}];
    XTUploadImageManage *upLoadImageManage = [XTUploadImageManage shareUploadImageManage];
    upLoadImageManage.type = XTUploadImageTypeHeadTopicUpdate;
    upLoadImageManage.topicParameterDic = uploadParameter;
    [upLoadImageManage uploadImagePicker:tempImage];
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
    return;
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
