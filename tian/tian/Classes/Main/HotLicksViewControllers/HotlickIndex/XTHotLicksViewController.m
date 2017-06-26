//
//  XTHotLicksViewController.m
//  tian
//
//  Created by 尚毅 杨 on 15/4/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHotLicksViewController.h"
#import "XTHotLicksOneViewController.h"
#import "XTLickingGodViewController.h"
#import "XTSearchIndexViewController.h"
#define XTTitleBtnWidth 38
#define XTTitleSpacing  40
@interface XTHotLicksViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)NSMutableArray *titleBtnsArray;
@property (nonatomic, strong)UIImageView *btnBottomLine;

@property (nonatomic, assign)NSInteger selectedIndex;

@property (nonatomic, strong)XTHotLicksOneViewController *hotLicksVC;
@property (nonatomic, strong)XTLickingGodViewController *lickingGodVC;
@end

@implementation XTHotLicksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
  //  self.view.backgroundColor = UIColorFromRGB(0xcecece);
    [self addTitleView];
    UIButton *searchBtn;
    SETIMAGEBTN(searchBtn, @"homePage_Search", @"");
    searchBtn.frame = CGRectMake(0, 0, 40, 40);
    [searchBtn addTarget:self action:@selector(clickSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    
    self.bgScroview.contentSize = CGSizeMake(SCREEN_SIZE.width*2, SCREEN_SIZE.height-64-49);
    self.bgScroview.pagingEnabled = YES;
    self.bgScroview.tag = 100;
    [self changeViewController];
    //self.bgScroview.scrollEnabled = NO;
    
    self.navigationItem.leftBarButtonItem = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTopAndRefreshView:) name:@"scrollToTopAndRefreshView" object:nil];
    
}
- (XTHotLicksOneViewController *)hotLicksVC
{
    if (!_hotLicksVC) {
        _hotLicksVC = [[XTHotLicksOneViewController alloc] init];
    }
    return _hotLicksVC;
}
- (XTLickingGodViewController *)lickingGodVC
{
    if (!_lickingGodVC) {
        _lickingGodVC = [[XTLickingGodViewController alloc]init];
    }
    return _lickingGodVC;
}
- (void)addTitleView
{
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XTTitleBtnWidth*2+XTTitleSpacing, XTTitleBtnWidth)];
    titleView.backgroundColor = [UIColor clearColor];
    
    UIButton *hotLicksBtn;
    SETIMAGEBTN(hotLicksBtn, @"", @"");
    [hotLicksBtn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    hotLicksBtn.frame = CGRectMake(0, 0, XTTitleBtnWidth, XTTitleBtnWidth);
    hotLicksBtn.tag = 10;
    [hotLicksBtn setTitle:@"热舔" forState:UIControlStateNormal];
    [hotLicksBtn setTitleColor:UIColorFromRGB(0x4f242b) forState:UIControlStateNormal];
    hotLicksBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [titleView addSubview:hotLicksBtn];
    
    UIButton *lickGodBtn;
    SETIMAGEBTN(lickGodBtn, @"", @"");
    [lickGodBtn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    lickGodBtn.frame = CGRectMake(XTTitleBtnWidth+XTTitleSpacing, 0, XTTitleBtnWidth, XTTitleBtnWidth);
    lickGodBtn.tag = 11;
    [lickGodBtn setTitle:@"舔神" forState:UIControlStateNormal];
    [lickGodBtn setTitleColor:UIColorFromRGB(0x4f242b) forState:UIControlStateNormal];
    lickGodBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [titleView addSubview:lickGodBtn];
    
    self.btnBottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(5, XTTitleBtnWidth - 10, XTTitleBtnWidth-10, 2)];
    self.btnBottomLine.image = UIIMAGE(@"");
    [titleView addSubview:self.btnBottomLine];
    self.btnBottomLine.backgroundColor = UIColorFromRGB(0x4f242b);
    self.titleBtnsArray = [NSMutableArray arrayWithObjects:hotLicksBtn,lickGodBtn, nil];
    
    self.navigationItem.titleView = titleView;
    
}

- (void)scrollTopAndRefreshView:(NSNotification *)notification
{
    NSInteger tabarSelectdIndex = [notification.object integerValue];
    CLog(@"hotlick == ==notification.object = = = =%ld",tabarSelectdIndex);
    if (tabarSelectdIndex == 1) {
        switch (self.selectedIndex) {
            case 0:
            {
                [self.hotLicksVC.waterFallControl.collectionView.header beginRefreshing];
                break;
            }
            case 1:
            {
                [self.lickingGodVC.waterFallControl.collectionView.header beginRefreshing];
                break;
            }
            default:
                break;
        }
    }
}

- (void)clickTitleBtn:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    for (UIButton *btn in self.titleBtnsArray) {
        btn.selected = NO;
    }
    
     self.selectedIndex = sender.tag-10;
    UIButton *selectedBtn = [self.titleBtnsArray objectAtIndex:_selectedIndex];
    selectedBtn.selected = YES;
//    [UIView animateWithDuration:0.5f animations:^{
//        self.btnBottomLine.frame = CGRectMake(selectedBtn.frame.origin.x, self.btnBottomLine.frame.origin.y, self.btnBottomLine.frame.size.width, self.btnBottomLine.frame.size.height);
//        
//    }];
    
    [self changeViewController];
    
}
- (void)changeViewController
{
    switch (self.selectedIndex) {
        case 0:
        {
            
            if (![self.bgScroview.subviews containsObject:self.hotLicksVC.view]) {
                self.hotLicksVC.view.frame = CGRectMake(0, 0, SCREEN_SIZE.width, CGRectGetHeight(self.bgScroview.frame));
                [self.bgScroview addSubview:self.hotLicksVC.view];
                [self addChildViewController:self.hotLicksVC];
            }
            break;
        }
        case 1:
        {
            if (![self.bgScroview.subviews containsObject:self.lickingGodVC.view]) {
                self.lickingGodVC.view.frame = CGRectMake(SCREEN_SIZE.width, 0, SCREEN_SIZE.width, CGRectGetHeight(self.bgScroview.frame));
                [self.bgScroview addSubview:self.lickingGodVC.view];
                [self addChildViewController:self.lickingGodVC];
            }
            break;
        }
            
        default:
            break;
    }
    [self.bgScroview setContentOffset:CGPointMake(SCREEN_SIZE.width*self.selectedIndex, 0) animated:YES];
}
- (void)clickSearchBtn:(UIButton *)sender
{
    XTSearchIndexViewController *searchVC = [[XTSearchIndexViewController alloc] initWithNibName:@"XTSearchIndexViewController" bundle:nil];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - scroviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag!=100) {
        return;
    }
    float contentOffsetX = scrollView.contentOffset.x;
    
    self.btnBottomLine.frame = CGRectMake(contentOffsetX/SCREEN_SIZE.width*(XTTitleBtnWidth+XTTitleSpacing)+5, XTTitleBtnWidth-10, XTTitleBtnWidth-10, 2);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float contentOffset = scrollView.contentOffset.x;
    NSInteger endSelected = self.selectedIndex;
    if (contentOffset<SCREEN_SIZE.width) {
        endSelected = 0;
    }else
    {
        endSelected = 1;
    }
    for (UIButton *btn in self.titleBtnsArray) {
        if (btn.tag - 10 == endSelected) {
            btn.selected = YES;
        }else
        {
            btn.selected = NO;
        }
    }
    
    if (endSelected!=self.selectedIndex) {
        self.selectedIndex = endSelected;
        [self changeViewController];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"scrollToTopAndRefreshView" object:nil];
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
