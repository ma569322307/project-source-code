//
//  XTHomePageViewController.m
//  tian
//
//  Created by 尚毅 杨 on 15/4/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHomePageViewController.h"
#import "XTHotMyTopivViewController.h"
#import "XTTabBarController.h"
#import "XTTitleSliderBar.h"

#import "XTPublicSquareViewController.h"
#import "XTLikeViewController.h"
#import "XTHotViewController.h"
#import "XTHomePageLikeAndHateViewController.h"
#import "XTSearchIndexViewController.h"

#import "XTShareImageDownloader.h"

#import "XTImageInfo.h"
#import "XTUserStore.h"
@interface XTHomePageViewController ()

@property (nonatomic, strong) XTTitleSliderBar *titleSliderBar;
@property (nonatomic, strong) XTPublicSquareViewController *publicSquareViewController;
@property (nonatomic, strong) XTLikeViewController *likeViewController;
@property (nonatomic, strong) XTHotViewController *hotViewController;
@property (nonatomic, assign) NSInteger theSelectedIndex;

@end

@implementation XTHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self addItems];
    NSString *indexKey = [NSString stringWithFormat:@"%@like",[XTUserStore sharedManager].user.userID];
    BOOL needLike = [[NSUserDefaults standardUserDefaults] boolForKey:indexKey];
    if (needLike) {
        self.theSelectedIndex = 1;
        
        
    }else{
        self.theSelectedIndex = 0;
    }
    
    [self.titleSliderBar animationToNext:self.theSelectedIndex];
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_SIZE.width*3, 0);
    self.bgScrollView.scrollsToTop = NO;
    self.bgScrollView.delaysContentTouches = NO;
    
    [self changeView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTopAndRefreshView:) name:@"scrollToTopAndRefreshView" object:nil];

}

- (void)scrollTopAndRefreshView:(NSNotification *)notification
{
    NSInteger tabarSelectdIndex = [notification.object integerValue];
    CLog(@"home == ==notification.object = = = =%ld",tabarSelectdIndex);
    if (tabarSelectdIndex == 0) {
    switch (self.theSelectedIndex) {
        case 0:
        {
            [self.publicSquareViewController.waterFallControl.collectionView.header beginRefreshing];
            break;
        }
        case 1:
        {
            [self.likeViewController.waterFallControl.collectionView.header beginRefreshing];
            break;
        }
        case 2:
        {
            [self.hotViewController.topicTableView.header beginRefreshing];
            break;
        }
        default:
            break;
    }
    }
}
- (void)changeView
{
    switch (self.theSelectedIndex) {
        case 0:
        {
            if (![self.bgScrollView.subviews containsObject:self.publicSquareViewController.view]) {
                self.publicSquareViewController.view.frame = CGRectMake(0, 0, SCREEN_SIZE.width, CGRectGetHeight(self.bgScrollView.frame)-64);
                [self.bgScrollView addSubview:self.publicSquareViewController.view];
                [self addChildViewController:self.publicSquareViewController];
            }
            self.publicSquareViewController.waterFallControl.collectionView.scrollsToTop = YES;
            self.likeViewController.waterFallControl.collectionView.scrollsToTop = NO;
            self.hotViewController.topicTableView.scrollsToTop = NO;
            break;
        }
        case 1:
        {
            if (![self.bgScrollView.subviews containsObject:self.likeViewController.view]) {
                self.likeViewController.view.frame = CGRectMake(SCREEN_SIZE.width, 0, SCREEN_SIZE.width, CGRectGetHeight(self.bgScrollView.frame)-64);
                [self.bgScrollView addSubview:self.likeViewController.view];
                [self addChildViewController:self.likeViewController];
            }
            self.publicSquareViewController.waterFallControl.collectionView.scrollsToTop = NO;
            self.likeViewController.waterFallControl.collectionView.scrollsToTop = YES;
            self.hotViewController.topicTableView.scrollsToTop = NO;
            break;
        }
        case 2:
        {
            if (![self.bgScrollView.subviews containsObject:self.hotViewController.view]) {
                self.hotViewController.view.frame = CGRectMake(SCREEN_SIZE.width*2, 0, SCREEN_SIZE.width, CGRectGetHeight(self.bgScrollView.frame)-54);
                [self.bgScrollView addSubview:self.hotViewController.view];
                [self addChildViewController:self.hotViewController];
            }
            self.publicSquareViewController.waterFallControl.collectionView.scrollsToTop = NO;
            self.likeViewController.waterFallControl.collectionView.scrollsToTop = NO;
            self.hotViewController.topicTableView.scrollsToTop = YES;
            break;
        }
            
        default:
            break;
    }
    [self.bgScrollView setContentOffset:CGPointMake(SCREEN_SIZE.width*self.theSelectedIndex, 0) animated:YES];
}
#pragma mark -
- (XTPublicSquareViewController *)publicSquareViewController
{
    if (!_publicSquareViewController) {
        _publicSquareViewController = [[XTPublicSquareViewController alloc]init];
    }
    return _publicSquareViewController;
}
- (XTLikeViewController *)likeViewController
{
    if(!_likeViewController)
    {
        _likeViewController = [[XTLikeViewController alloc]init];
        
    }
    return _likeViewController;
}
- (XTHotViewController *)hotViewController
{
    if (!_hotViewController) {
        _hotViewController = [[XTHotViewController alloc]init];
    }
    return _hotViewController;
}

#pragma mark - scrollview Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat scrollViewContentOffsetx = scrollView.contentOffset.x;
//    [self.titleSliderBar bottomLineScrollToButtonCenterWith:scrollViewContentOffsetx];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float contentOffset = scrollView.contentOffset.x;
    NSInteger endSelected = self.theSelectedIndex;
    if (contentOffset<SCREEN_SIZE.width) {
        endSelected = 0;
    }else if (contentOffset>=SCREEN_SIZE.width&&contentOffset<SCREEN_SIZE.width*2)
    {
        endSelected = 1;
    }else
    {
        endSelected = 2;
    }
    
    
    if (endSelected!=self.theSelectedIndex) {
        self.theSelectedIndex = endSelected;
        [self.titleSliderBar animationToNext:endSelected];
        [self changeView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addItems
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:UIIMAGE(@"homePage_artistSet") forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];


    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:UIIMAGE(@"homePage_Search") forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    NSArray *titleArray = @[@"广场",@"喜欢",@"关注"];
    self.titleSliderBar = [[XTTitleSliderBar alloc] initWIthTitleArray:titleArray];
    CGFloat width = [self.titleSliderBar getTitleSliderBarWidth];
    [self.titleSliderBar setFrame:CGRectMake(0, 0, width, XTTitleSliderBarHeight)];
    self.navigationItem.titleView = self.titleSliderBar;
    
    __weak XTHomePageViewController *weakSelf = self;
    self.titleSliderBar.tilteSliderBarSelectedBlock = ^(NSInteger index)
    {
        weakSelf.theSelectedIndex = index;
        [weakSelf changeView];
    };
}

- (void)clickLeftBtn
{
    XTHomePageLikeAndHateViewController *likeAndHateVC = [[XTHomePageLikeAndHateViewController alloc] init];
    [self.navigationController pushViewController:likeAndHateVC animated:YES];
}

- (void)clickRightBtn
{
    XTSearchIndexViewController *searchVC = [[XTSearchIndexViewController alloc] initWithNibName:@"XTSearchIndexViewController" bundle:nil];
    [self.navigationController pushViewController:searchVC animated:YES];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"scrollToTopAndRefreshView" object:nil];
}
@end
