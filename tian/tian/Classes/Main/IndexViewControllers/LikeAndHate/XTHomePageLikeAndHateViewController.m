//
//  XTHomePageLikeAndHateViewController.m
//  tian
//
//  Created by huhuan on 15/6/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHomePageLikeAndHateViewController.h"
#import "XTTabBarController.h"
#import "XTTitleSliderBar.h"
#import "XTHomePageLikeAndHateCollectionView.h"
#import "XTAddLikeAndHateViewController.h"
#import "XTUserStore.h"
#import "XTOrderArtist.h"
#import "XTHTTPRequestOperationManager.h"
#import <Mantle/EXTScope.h>

typedef NS_ENUM(NSInteger, TagSelectItemType) {
    
    TagSelectItemTypeLike = 0,
    TagSelectItemTypeHate
    
};

@interface XTHomePageLikeAndHateViewController ()

@property (nonatomic, assign) TagSelectItemType currentSelectTag;
@property (nonatomic, assign) XTHomePageLikeAndHateCollectionViewMode pageMode;
@property (nonatomic, strong) XTHomePageLikeAndHateCollectionView *likeCollectionView;
@property (nonatomic, strong) XTHomePageLikeAndHateCollectionView *hateCollectionView;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, assign) BOOL needToRefreshLike;
@property (nonatomic, assign) BOOL needToRefreshHate;

@property (nonatomic, assign) NSInteger likeListOffset;
@property (nonatomic, assign) NSInteger hateListOffset;

@end

@implementation XTHomePageLikeAndHateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    [self addTitleBar];
    [self addItems];
    [self.view addSubview:self.likeCollectionView];
    
    self.pageMode = XTHomePageLikeAndHateCollectionViewModeNormal;
    CGFloat startY = 0.0f; //起始点
    CGFloat sortH = SCREEN_SIZE.height - 65.0f;
    CGFloat sortW = SCREEN_SIZE.width;
    
    self.likeCollectionView.frame = CGRectMake(0, startY, sortW, sortH);
    
    self.likeCollectionView.contentInset = UIEdgeInsetsMake(10., 0., 70., 0.);
    self.hateCollectionView.contentInset = UIEdgeInsetsMake(10., 0., 70., 0.);

    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setImage:[UIImage imageNamed:@"xt_like_hate_add"] forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
    
    [self.addButton updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.offset(-10);
        make.height.width.equalTo(65);
    }];
    
    self.likeListOffset = 0;
    self.hateListOffset = 0;
    
    [self requestLikeUsers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage:) name:@"XTUserCollectionViewCellAction" object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    XTTabBarController *tabBarCtr = (XTTabBarController *)self.parentViewController.parentViewController;
    [tabBarCtr hideBottomViewWhenPushed];
    
    if(self.needToRefreshLike) {
        self.likeListOffset = 0;
        [self requestLikeUsers];
    }
    if(self.needToRefreshHate) {
        self.hateListOffset = 0;
        [self requestHateUsers];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (XTHomePageLikeAndHateCollectionView *)likeCollectionView {
    if(!_likeCollectionView) {
        _likeCollectionView = [XTHomePageLikeAndHateCollectionView likeAndHateCollectionView];
        _likeCollectionView.pageStyle = XTHomePageLikeAndHateCollectionViewStyleLike;
        
        _likeCollectionView.removeAllDataBlock = ^() {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"%@like",[XTUserStore sharedManager].user.userID]];
        };
        
        @weakify(self);
        XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self requestLikeUsers];
        }];
        _likeCollectionView.footer = footer;
    }
    return _likeCollectionView;
}

- (XTHomePageLikeAndHateCollectionView *)hateCollectionView {
    if(!_hateCollectionView) {
        _hateCollectionView = [XTHomePageLikeAndHateCollectionView likeAndHateCollectionView];
        _hateCollectionView.pageStyle = XTHomePageLikeAndHateCollectionViewStyleHate;

        @weakify(self);
        XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self requestHateUsers];
        }];
        _hateCollectionView.footer = footer;
        
        _hateCollectionView.removeAllDataBlock = ^() {
            @strongify(self);
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.hateCollectionView style:YYTBlankViewStyleBlank eventClick:nil];
            blankView.tipString = @"发你一张好汪卡";
            blankView.headerStyle = YYTBlankHeaderStyleFear;
        };
    }
    return _hateCollectionView;
}

- (void)backButtonEvnet:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editModeClick:(UIButton *)sender {
    if(self.pageMode == XTHomePageLikeAndHateCollectionViewModeNormal) {
        self.pageMode = XTHomePageLikeAndHateCollectionViewModeEdit;
        [sender setImage:[UIImage imageNamed:@"xt_like_hate_ensure"] forState:UIControlStateNormal];
    }else if(self.pageMode == XTHomePageLikeAndHateCollectionViewModeEdit) {
        self.pageMode = XTHomePageLikeAndHateCollectionViewModeNormal;
        [sender setImage:[UIImage imageNamed:@"xt_like_hate_edit"] forState:UIControlStateNormal];
    }
    
    self.likeCollectionView.pageMode = self.pageMode;
    self.hateCollectionView.pageMode = self.pageMode;
    [self.likeCollectionView reloadData];
    [self.hateCollectionView reloadData];
}

- (void)addClick:(id)sender {
    XTAddLikeAndHateViewController *addVC = [[XTAddLikeAndHateViewController alloc] initWithNibName:@"XTAddLikeAndHateViewController" bundle:nil];
    addVC.buttonStyle = self.currentSelectTag == TagSelectItemTypeLike ? XTUserCollectionViewCellButtonStyleLike : XTUserCollectionViewCellButtonStyleHate;
    addVC.shouldRefresh = ^() {
        self.needToRefreshLike = YES;
        self.needToRefreshHate = YES;
    };
//    //测试使用
//    addVC.displayType = XTAddLikeAndHateGuidePage;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)addTitleBar {
    NSArray* titleArray = @[@"喜欢", @"嫌弃"];
    
    [self addTitleSliderBarByArray:titleArray];
    
    @weakify(self);
    self.titleSliderBar.tilteSliderBarSelectedBlock = ^(NSInteger index) {
        @strongify(self);
        [self.view bringSubviewToFront:self.addButton];
        if (index > self.currentSelectTag) {
            [self changeToSelectView:index];
            if([self.hateCollectionView.userArray count] == 0) {
                [self requestHateUsers];
            }
        } else {
            [self changeToSelectView:index];
        }
    };
}

- (void)addItems {
    UIImage* img = UIIMAGE(@"na_back_brown");
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:img forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [leftBtn addTarget:self action:@selector(backButtonEvnet:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(0, 0, 35, 35);
    [editBtn setImage:[UIImage imageNamed:@"xt_like_hate_edit"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editModeClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];

}

- (void)refreshPage:(NSNotification *)notification {
//    XTUserCollectionViewCellButtonStyle style = [notification.object integerValue];
//    if(style == XTUserCollectionViewButtonStyleLike) {
//        self.needToRefreshLike = YES;
//    }else if(style == XTUserCollectionViewButtonStyleHate) {
//        self.needToRefreshHate = YES;
//    }
}

- (void)requestLikeUsers {
    
    if(self.likeListOffset == 0) {
        [YYTHUD showLoadingAddedTo:self.view];
    }
    
    NSDictionary *parameters = @{
                                 @"uid" : [XTUserStore sharedManager].user.userID,
                                 @"offset": @(self.likeListOffset),
                                 @"size": @"24"
                                 };
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:@"picture/sub/list/mysub.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"--%@",responseObject);

        [YYTBlankView hideFromView:self.likeCollectionView];
        [self.likeCollectionView.footer endRefreshing];
        
        NSError *artistsError = nil;
        NSArray *artistsArray = [MTLJSONAdapter modelsOfClass:[XTOrderArtist class] fromJSONArray:responseObject[@"simpleArtistSubModels"] error:&artistsError];
        if(self.likeListOffset == 0) {
            [self.likeCollectionView.userArray removeAllObjects];
        }
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.likeCollectionView.userArray];
        [tempArray addObjectsFromArray:artistsArray];
        self.likeCollectionView.userArray = tempArray;
        [self.likeCollectionView reloadData];
        
        if([self.likeCollectionView.userArray count] == 0 && self.likeListOffset == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.likeCollectionView style:YYTBlankViewStyleBlank eventClick:nil];
            blankView.tipString = @"我轻轻的划一划手指 没有留下一个喜欢";
            blankView.headerStyle = YYTBlankHeaderStyleLike;
        }
        
        self.likeListOffset += 24;
        
        if([artistsArray count] == 0) {
            self.likeCollectionView.footer.hidden = YES;
        }else {
            self.likeCollectionView.footer.hidden = NO;
        }

        [YYTHUD hideLoadingFrom:self.view];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:self.view];
        [self.likeCollectionView.footer endRefreshing];
        if([self.likeCollectionView.userArray count] == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.likeCollectionView style:YYTBlankViewStyleNetworkError eventClick:^{
                [self requestLikeUsers];
            }];
            blankView.error = error;
        }else {
            [YYTHUD showPromptAddedTo:self.view withText:[error xtErrorMessage] withCompletionBlock:nil];
        }
    }];
}

- (void)requestHateUsers {
    
    if(self.hateListOffset == 0) {
        [YYTHUD showLoadingAddedTo:self.view];
    }
    
    NSDictionary *parameters = @{
                                 @"uid" : [XTUserStore sharedManager].user.userID,
                                 @"offset": @(self.hateListOffset),
                                 @"size": @"24"
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:@"picture/sub/blacklist.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [YYTBlankView hideFromView:self.hateCollectionView];
        
        [self.hateCollectionView.footer endRefreshing];
        NSError *artistsError = nil;
        NSArray *artistsArray = [MTLJSONAdapter modelsOfClass:[XTOrderArtist class] fromJSONArray:responseObject error:&artistsError];
        
        if(self.hateListOffset == 0) {
            [self.hateCollectionView.userArray removeAllObjects];
        }
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.hateCollectionView.userArray];
        [tempArray addObjectsFromArray:artistsArray];
        self.hateCollectionView.userArray = tempArray;
        [self.hateCollectionView reloadData];
        
        self.hateListOffset += 24;
        
        if([artistsArray count] == 0) {
            self.hateCollectionView.footer.hidden = YES;
        }else {
            self.hateCollectionView.footer.hidden = NO;
        }

        if([self.hateCollectionView.userArray count] == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.hateCollectionView style:YYTBlankViewStyleBlank eventClick:nil];
            blankView.tipString = @"发你一张好汪卡";
            blankView.headerStyle = YYTBlankHeaderStyleFear;
            
        }
        
        [YYTHUD hideLoadingFrom:self.view];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:self.view];
        [self.hateCollectionView.footer endRefreshing];
        if([self.hateCollectionView.userArray count] == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.hateCollectionView style:YYTBlankViewStyleNetworkError eventClick:^{
                [self requestHateUsers];
            }];
            blankView.error = error;
        }else {
            [YYTHUD showPromptAddedTo:self.view withText:[error xtErrorMessage] withCompletionBlock:nil];
        }
    }];
}

#pragma mark Gesture
- (void)onSwipeLeftEvent:(UISwipeGestureRecognizer*)gesture
{
    //如果动画没有执行完成返回
    if ([self.titleSliderBar titleSliderBarIsAnimation])
        return;
    
    //如果在最右返回
    if (self.currentSelectTag == TagSelectItemTypeHate)
        return;
    
    NSInteger tag = self.currentSelectTag + 1;
    
    if (tag > TagSelectItemTypeHate)
        tag = TagSelectItemTypeHate;
    
    if (tag == self.currentSelectTag)
        return;
    
    [self changeSelectState:tag];
    
    if([self.hateCollectionView.userArray count] == 0) {
        [self requestHateUsers];
    }
}

- (void)onSwipeRightEvent:(UISwipeGestureRecognizer*)gesture
{
    //如果动画没有执行完成返回
    if ([self.titleSliderBar titleSliderBarIsAnimation])
        return;
    
    //如果在最左返回
    if (self.currentSelectTag == TagSelectItemTypeLike)
        return;
    
    NSInteger tag = self.currentSelectTag - 1;
    
    if (tag < TagSelectItemTypeLike)
        tag = TagSelectItemTypeLike;
    
    if (tag == self.currentSelectTag)
        return;
    
    [self changeSelectState:tag];
 
}

#pragma mark 处理滑动或者选择顶部控件时的操作
- (void)changeSelectState:(NSInteger)selectTag {
    //设置顶部slider位置
    [self.titleSliderBar animationToNext:selectTag];
    
    //切换视图
    [self changeToSelectView:selectTag];
    
    
}

- (void)changeToSelectView:(NSInteger)selectTag {
    UIView* curView = nil;
    UIView* selectView = nil;
    
    if (self.currentSelectTag == TagSelectItemTypeLike) {
        curView = self.likeCollectionView;
    } else{
        curView = self.hateCollectionView;
    }
    
    if (selectTag == TagSelectItemTypeLike) {
        
        selectView = self.likeCollectionView;
        
    } else {
        
        selectView = self.hateCollectionView;
        
    }
    
    NSInteger directionFlag = (selectTag > self.currentSelectTag) ? 1 : -1;
    
    //重置当前选中
    self.currentSelectTag = selectTag;
    
    [self.view addSubview:selectView];
    [self.view bringSubviewToFront:self.addButton];
    
    CGFloat startY = 0.0f; //起始点
    CGFloat sortH = SCREEN_SIZE.height - 65.0f;
    CGFloat sortW = SCREEN_SIZE.width;
    
    selectView.frame = CGRectMake(sortW*directionFlag, startY, sortW, sortH);
    
    [UIView animateWithDuration:XTTitleSliderAnimationTime animations:^{
        
        selectView.frame = CGRectMake(0, startY, sortW, sortH);
        curView.frame = CGRectMake(-sortW * directionFlag, startY, sortW, sortH);
        
    } completion:^(BOOL finished) {
        [curView removeFromSuperview];
        [self.view bringSubviewToFront:self.addButton];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
