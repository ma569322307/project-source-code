//
//  XTAddLikeAndHateViewController.m
//  tian
//
//  Created by huhuan on 15/6/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTAddLikeAndHateViewController.h"
#import "XTTabBarController.h"
#import "XTPickerView.h"
#import "XTSearchAssociateTableView.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTOrderArtist.h"
#import "XTSubStore.h"
#import "XTConfig.h"
#import "XTSearchUserModel.h"
#import <Mantle/EXTScope.h>
#import "XTLikeDisplayCollectionView.h"
#import "XTLikeDisplayCell.h"
#import "XTGuideManage.h"
typedef enum{
    XTAddLikeAndHateKeySearch = 0,
    XTAddLikeAndHateTypeSearch
}XTAddLikeAndHateSearchType;

@interface XTAddLikeAndHateViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *searchBarView;
@property (nonatomic, strong) IBOutlet UITextField *searchTextfield;
@property (nonatomic, weak) IBOutlet UIButton *clearButton;

@property (nonatomic, assign) NSInteger searchOffset;

@property (nonatomic, strong) XTPickerView *picker;
@property (nonatomic, strong) XTUserCollectionView *userCollectionView;
@property (nonatomic, strong) XTSearchAssociateTableView *associateTableView;
//显示已选艺人列表
@property (nonatomic, weak) XTLikeDisplayCollectionView *likeDisplayCollectionView;
//开添按钮
@property (nonatomic, weak) UIButton *startButton;
//上面两个的父控件
@property (nonatomic, weak) UIView *displayBackView;
//筛选按钮
@property (nonatomic, strong) YYTBarButtonItem *siftButton;
//转变成搜索
@property (nonatomic, strong) YYTBarButtonItem *chage2SearchButton;
//搜索类型
@property (nonatomic, assign) XTAddLikeAndHateSearchType searchType;

@property (nonatomic, copy) NSString *artistArea;
@property (nonatomic, copy) NSString *artistType;


@end

@implementation XTAddLikeAndHateViewController

static NSString* const requestUrl = @"/picture/sub/list/search.json";
static NSString *associateUrl = @"/search/suggest.json";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.titleView = self.searchBarView;

    self.searchBarView.frame = CGRectMake(0., 0., SCREEN_SIZE.width, 44.);
    
    [self.view addSubview:self.userCollectionView];
    self.userCollectionView.contentInset = UIEdgeInsetsMake(10., 0., 0., 0.);
    [self.userCollectionView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0., 12., 0., 12.));
    }];
    
    self.searchOffset = 0;
    
    if(self.buttonStyle == XTUserCollectionViewCellButtonStyleLike) {
        [self requestRecommendArtist];
    }else {
        self.searchTextfield.placeholder = @"JUST搜搜";
        YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view
                                style:YYTBlankViewStyleBlank
                           eventClick:nil];
        blankView.headerStyle = YYTBlankHeaderStyleForbid;
        blankView.tipString = @"扫一下雷！";
    }
    
    // 根据展示类型展示已选艺人列表
    if (self.displayType == XTAddLikeAndHateGuidePage) {
        //展示列表
        [self addConstraints];
        //展示无搜索画面
        [self showNavigationIsSearch:NO];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.userCollectionView addGestureRecognizer:singleTap];
}

- (void)handleSingleTap:(id)sender {
    if(self.associateTableView.alpha < 1.f) {
        [self.searchTextfield resignFirstResponder];
    }
}

///导航栏切换
-(void)showNavigationIsSearch:(BOOL)isSearch{
    if (isSearch) {
        self.searchType = XTAddLikeAndHateKeySearch;
        self.title = nil;
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.titleView = self.searchBarView;
        return;
    }
    self.searchType = XTAddLikeAndHateTypeSearch;
    //初始不需要搜索
    self.navigationItem.titleView = nil;
    //初始化导航栏内容
    self.title = @"开始挑食";
    //添加按钮
    self.navigationItem.rightBarButtonItems = @[self.chage2SearchButton,self.siftButton];
}
- (void)addConstraints{
    //背景视图约束
  NSLayoutConstraint *backLeft =
      [NSLayoutConstraint constraintWithItem:self.displayBackView
                                   attribute:NSLayoutAttributeLeft
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                   attribute:NSLayoutAttributeLeft
                                  multiplier:1
                                    constant:0];
  NSLayoutConstraint *backRight =
      [NSLayoutConstraint constraintWithItem:self.displayBackView
                                   attribute:NSLayoutAttributeRight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                   attribute:NSLayoutAttributeRight
                                  multiplier:1
                                    constant:0];
  NSLayoutConstraint *backBottom =
      [NSLayoutConstraint constraintWithItem:self.displayBackView
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                   attribute:NSLayoutAttributeBottom
                                  multiplier:1
                                    constant:0];
  NSLayoutConstraint *backHeight =
      [NSLayoutConstraint constraintWithItem:self.displayBackView
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1
                                    constant:75];
  //开添按钮约束
  NSLayoutConstraint *startCenterY =
      [NSLayoutConstraint constraintWithItem:self.startButton
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.displayBackView
                                   attribute:NSLayoutAttributeCenterY
                                  multiplier:1
                                    constant:0];
    NSLayoutConstraint *startRight =
    [NSLayoutConstraint constraintWithItem:self.startButton
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.displayBackView
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                  constant:-12];

  //展示collectionView
  NSLayoutConstraint *collecionViewRight =
      [NSLayoutConstraint constraintWithItem:self.likeDisplayCollectionView
                                   attribute:NSLayoutAttributeRight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.startButton
                                   attribute:NSLayoutAttributeLeft
                                  multiplier:1
                                    constant:-12];
  NSLayoutConstraint *collecionViewLeft =
      [NSLayoutConstraint constraintWithItem:self.likeDisplayCollectionView
                                   attribute:NSLayoutAttributeLeft
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.displayBackView
                                   attribute:NSLayoutAttributeLeft
                                  multiplier:1
                                    constant:0];
  NSLayoutConstraint *collecionViewCenterY =
      [NSLayoutConstraint constraintWithItem:self.likeDisplayCollectionView
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.displayBackView
                                   attribute:NSLayoutAttributeCenterY
                                  multiplier:1
                                    constant:0];
  NSLayoutConstraint *collecionViewHeight =
      [NSLayoutConstraint constraintWithItem:self.likeDisplayCollectionView
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1
                                    constant:kItemWidthHeight + 4];

    //添加约束
  [self.view addConstraints:@[ backBottom, backLeft, backRight ]];
  [self.displayBackView addConstraints:@[
    backHeight,
    startCenterY,
    startRight,
    collecionViewCenterY,
    collecionViewHeight,
    collecionViewLeft,
    collecionViewRight
  ]];
    //设置代理
    self.userCollectionView.infoDelegate = (id)self.likeDisplayCollectionView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    //如果引导进入，没有tabBar
    if (self.displayType == XTAddLikeAndHateGuidePage) {
        return;
    }
    
    XTTabBarController *tabBarCtr = (XTTabBarController *)self.parentViewController.parentViewController;
    [tabBarCtr hideBottomViewWhenPushed];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //如果引导进入，没有tabBar
    if (self.displayType == XTAddLikeAndHateGuidePage) {
        return;
    }
}

- (IBAction)clearButtonClick:(id)sender {
    self.searchTextfield.text = @"";
    self.clearButton.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.associateTableView.alpha = 0.f;
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)closeButtonClick:(id)sender {
    //如果是展示动画，不关闭该视图，只是转换模式
    if (self.displayType == XTAddLikeAndHateGuidePage) {
        [self showNavigationIsSearch:NO];
        return;
    }
    //正常模式
    [self.searchTextfield resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)requestSearchArtist {
    
    [YYTHUD showLoadingAddedTo:self.view];
    
    self.userCollectionView.userArray = nil;
    [self.userCollectionView reloadData];
    [YYTBlankView hideFromView:self.view];
    NSMutableDictionary *requestDic = [@{
                                         @"offset"     : @(self.searchOffset),
                                         @"size"       : @"24"
                                         } mutableCopy];
    if([self.artistArea length] > 0 && [self.artistType length] > 0) {
        requestDic[@"area"] = self.artistArea;
        requestDic[@"property"] = self.artistType;
    }else {
        requestDic[@"key"] = [self.searchTextfield.text length] > 0 ? self.searchTextfield.text : @"";
    }
    self.artistArea = nil;
    self.artistType = nil;
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:requestUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [YYTHUD hideLoadingFrom:self.view];
        [self.userCollectionView.footer endRefreshing];
        NSError *error = nil;
        NSLog(@"responseObject:%@",responseObject);
        
        NSArray *artistArray = [MTLJSONAdapter modelsOfClass:[XTSearchUserModel class] fromJSONArray:responseObject error:&error];
        NSLog(@"%@",artistArray);
        
       self.userCollectionView.userArray = artistArray;
        [self.userCollectionView reloadData];
        
        if([artistArray count] == 0) {
            [self.userCollectionView.footer setHidden:YES];
        }else {
            [self.userCollectionView.footer setHidden:NO];
            self.searchOffset += 24;
        }
        
        if([artistArray count] == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleBlank eventClick:nil];
            blankView.headerStyle = YYTBlankHeaderStyleBowl;
            blankView.tipString = @"没有找到你搜索的东西，图库君(●—●)等你反馈";
            [self.view bringSubviewToFront:self.associateTableView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:self.view];
        [self.userCollectionView.footer endRefreshing];
        YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
            [self requestSearchArtist];
        }];
        blankView.error = error;
        [self.view bringSubviewToFront:self.associateTableView];
    }];
}

- (void)requestRecommendArtist {
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    XTSubStore *subStore = [[XTSubStore alloc] init];

    [subStore fetchArtistRecommendFromLocation:0 length:10 completionBlock:^(NSArray *artistItems, NSError *error) {
        [YYTBlankView hideFromView:self.view];
        if (!error) {
            self.userCollectionView.userArray = artistItems;
            [self.userCollectionView reloadData];
            if (self.displayType == XTAddLikeAndHateGuidePage) {
                self.userCollectionView.contentInset = UIEdgeInsetsMake(10, 0, 75, 0);
            }
        }else {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
                [self requestRecommendArtist];
            }];
            blankView.error = error;
        }
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
    }];
}

- (void)requestSearchAssociateInfo {
    NSDictionary *requestDic = @{@"deviceinfo" : [[XTConfig sharedManager] deviceInfo], @"keyword" : self.searchTextfield.text, @"soType" : @"artist"};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:associateUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.associateTableView.associateArray = responseObject[@"data"];
        [self.associateTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}
//转变到搜索界面
-(void)change2SearchClick{
    [self showNavigationIsSearch:YES];
}
-(void)siftClick{
    @weakify(self);
    [self.picker setPickerSelectedBlock:^(NSDictionary *dic) {
        //返回选择的数据
        NSLog(@"选择了 %@ 语种的 %@",dic[@"language"][@"text"],dic[@"artist"][@"text"]);
        NSLog(@"选择了 %@ 语种的 %@",dic[@"language"][@"type"],dic[@"artist"][@"type"]);
        @strongify(self);
        self.artistArea = dic[@"language"][@"type"];
        self.artistType = dic[@"artist"][@"type"];
        self.searchOffset = 0;
        [self requestSearchArtist];
    }];
    [self.picker show];
}
//开舔点击
-(void)startClick{
    [UIApplication sharedApplication].keyWindow.rootViewController = [XTGuideManage createDispayViewController];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldTextDidChange:(NSNotification *)notification {
    if([self.searchTextfield.text length] > 0) {
        self.clearButton.hidden = NO;
        [self requestSearchAssociateInfo];
        [UIView animateWithDuration:0.3 animations:^{
            self.associateTableView.alpha = 1.f;
        } completion:^(BOOL finished) {
        }];
    }else {
        self.clearButton.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.associateTableView.associateArray = nil;
            [self.associateTableView reloadData];
            self.associateTableView.alpha = 0.f;
        } completion:^(BOOL finished) {
        }];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([textField.text length] > 0) {
        self.clearButton.hidden = NO;
        [self requestSearchAssociateInfo];
        [UIView animateWithDuration:0.3 animations:^{
            self.associateTableView.alpha = 1.f;
        } completion:^(BOOL finished) {
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        self.clearButton.hidden = YES;
        self.associateTableView.associateArray = nil;
        [self.associateTableView reloadData];
        self.associateTableView.alpha = 0.f;
    } completion:^(BOOL finished) {
    }];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([self.searchTextfield.text length] == 0) {
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"搜索内容不能为空" withCompletionBlock:nil];
        return NO;
    }
    self.clearButton.hidden = YES;
    self.searchOffset = 0;
    [self requestSearchArtist];
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 懒加载
- (XTUserCollectionView *)userCollectionView {
    if(!_userCollectionView) {
        _userCollectionView = [XTUserCollectionView userCollectionViewWithPageStyle:XTUserCollectionViewStyleVertical CellStyle:XTUserCollectionViewCellStyleFans buttonStyle:self.buttonStyle];
        if(self.displayType == XTAddLikeAndHateGuidePage) {
            _userCollectionView.needDelay = YES;
        }
        
        @weakify(self);
        _userCollectionView.shouldRefresh = ^() {
            @strongify(self);
            if(self.shouldRefresh) {
                self.shouldRefresh();
            }
        };
        _userCollectionView.isArtist = YES;
    }
    return _userCollectionView;
}

- (XTSearchAssociateTableView *)associateTableView {
    if(!_associateTableView) {
        _associateTableView = [XTSearchAssociateTableView associateTableView];
        _associateTableView.alpha = 0.f;
        
        @weakify(self);
        _associateTableView.cellClick = ^(NSString *keyword) {
            @strongify(self);
            [self.searchTextfield resignFirstResponder];
            self.searchTextfield.text = keyword;
            self.searchOffset = 0;
            [self requestSearchArtist];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.associateTableView.alpha = 0.f;
            } completion:^(BOOL finished) {
            }];
        };
        [self.view addSubview:_associateTableView];
        [_associateTableView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
        }];
    }
    return _associateTableView;
}
-(XTLikeDisplayCollectionView *)likeDisplayCollectionView{
    if (_likeDisplayCollectionView == nil) {
        XTLikeDisplayCollectionView *view = [XTLikeDisplayCollectionView likeDisplay];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.displayBackView addSubview:view];
        _likeDisplayCollectionView = view;
    }
    return _likeDisplayCollectionView;
}
-(UIButton *)startButton{
    if (_startButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"GuideLikeStart"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"GuideLikeStart_sel"] forState:UIControlStateHighlighted];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [btn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
        [self.displayBackView addSubview:btn];
        _startButton = btn;
    }
    return _startButton;
}
-(UIView *)displayBackView{
    if (_displayBackView == nil) {
        if ([UIDevice currentDevice].systemVersion.doubleValue > 8.0 ) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:effect];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:view];
            _displayBackView = view;
        }else{
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:view];
            _displayBackView = view;
        }
        
    }
    return _displayBackView;
}
-(YYTBarButtonItem *)chage2SearchButton{
    if (_chage2SearchButton == nil) {
        YYTBarButtonItem *rightBaritem = [YYTBarButtonItem barItemWithImageName:@"homePage_Search" target:self action:@selector(change2SearchClick)];
        _chage2SearchButton = rightBaritem;
    }
    return _chage2SearchButton;
}
-(YYTBarButtonItem *)siftButton{
    if (_siftButton == nil) {
        YYTBarButtonItem *rightBaritem = [YYTBarButtonItem barItemWithImageName:@"GuideSift" target:self action:@selector(siftClick)];
        _siftButton = rightBaritem;
    }
    return _siftButton;
}
-(XTPickerView *)picker{
    if (_picker == nil) {
        NSMutableArray *arryM = [NSMutableArray array];
        NSArray *languageList = @[
                               @{@"type" : @"ML", @"text" : @"内地"},
                               @{@"type" : @"HT", @"text" : @"港台"},
                               @{@"type" : @"US", @"text" : @"欧美"},
                               @{@"type" : @"KR", @"text" : @"韩语"},
                               @{@"type" : @"JP", @"text" : @"日语"},
                               @{@"type" : @"ACG", @"text" : @"二次元"},
                               @{@"type" : @"Other", @"text" : @"其他"},
                               ];
        [arryM addObject:languageList];
        NSArray *artistList = @[
                                @{@"type" : @"Girl", @"text" : @"女歌手"},
                                @{@"type" : @"Boy", @"text" : @"男歌手"},
                                @{@"type" : @"Combo", @"text" : @"乐队组合"},
                                @{@"type" : @"Other", @"text" : @"其他"},
                                ];
        [arryM addObject:artistList];
        _picker = [XTPickerView pickerViewWithDataSource:arryM.copy];
        _picker.alwaysRefresh = YES;
        _picker.componentNumber = 2;
    }
    return _picker;
}

@end
