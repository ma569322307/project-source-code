//
//  XTRootViewController.m
//  tian
//
//  Created by 尚毅 杨 on 15/4/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"
#import <MBProgressHUD.h>

#import "XHTransitionProtocol.h"
#import "UICollectionView+XHIndexPath.h"
#import "XHUIKitMacro.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#define XTViewBackGroundColor UIColorFromRGB(0xececec)
@interface XTRootViewController ()
@property (nonatomic,strong)MBProgressHUD *mbProgressHUD;

@property (nonatomic, strong) UICollectionView *rootCollectionView;
@property (nonatomic, assign) CGSize imageSize;
@end

@implementation XTRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBackgroundImage];
    [self addBackNavigationItem];
//    YYTBarButtonItem *leftBaritem = [YYTBarButtonItem barItemWithImageName:@"na_back_brown"
//                                                                    target:self
//                                                                    action:@selector(clickNaBackBtn:)];
//    self.navigationItem.leftBarButtonItem = leftBaritem;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    NSArray *controllerArray = self.navigationController.viewControllers;
    if(controllerArray) {
        if(self == [controllerArray lastObject] && [controllerArray count] > 1) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"NO",@"isShowTabBar",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isShowTabBarNotification" object:dic];
        }
    }
    
    id<UIViewControllerTransitionCoordinator> tc = self.navigationController.topViewController.transitionCoordinator;
    [tc animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if(![context isInteractive]) {
            if(self == [controllerArray lastObject] && [controllerArray count] == 1) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"YES",@"isShowTabBar",nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"isShowTabBarNotification" object:dic];
            }
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.needTranform = NO;
    NSArray *controllerArray = self.navigationController.viewControllers;
    if(self == [controllerArray lastObject] && [controllerArray count] == 1) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"YES",@"isShowTabBar",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isShowTabBarNotification" object:dic];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setNavBackgroundImage
{
    self.navigationController.navigationBar.backItem.hidesBackButton = YES;
    UIImage* bgImg = [UIImage imageNamed:@"Tabbar_nav_title"];

    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)addBackNavigationItem
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 35, 35);
    [backBtn setImage:[UIImage imageNamed:@"na_back_brown"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(clickNaBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)clickNaBackBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tranformPushWithCollectionView:(UICollectionView *)collectionView
                             imageSize:(CGSize)imageSize
                          currentIndex:(NSInteger)index {

    self.rootCollectionView = collectionView;
    self.imageSize = imageSize;

        _navigationControllerDelegate = [[XHNavigationControllerDelegate alloc] initWithNavigationController:self.navigationController
                                                                                  panGestureRecognizerEnable:NO];
    
    [collectionView setCurrentIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];

}

- (XHNavigationControllerDelegate *)navigationControllerDelegate {
    return _navigationControllerDelegate;
}

#pragma mark - XHTransitionProtocol

- (void)viewWillAppearWithPageIndex:(NSInteger)pageIndex {
    UICollectionViewScrollPosition position = UICollectionViewScrollPositionCenteredVertically & UICollectionViewScrollPositionCenteredHorizontally;
    CGFloat imageHeight = self.imageSize.height * ([UIScreen mainScreen].bounds.size.width - 16*3)/2.0f / self.imageSize.width;
    if (imageHeight > 400) {
        position = UICollectionViewScrollPositionTop;
    }
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:pageIndex inSection:0];
    [self.rootCollectionView setCurrentIndexPath:currentIndexPath];
    if (pageIndex < 2) {
        [self.rootCollectionView setContentOffset:CGPointZero animated:NO];
    } else {
        [self.rootCollectionView scrollToItemAtIndexPath:currentIndexPath atScrollPosition:position animated:NO];
    }
}

- (UICollectionView *)transitionCollectionView {
    return self.rootCollectionView;
}

/*
////////////////////////////////////     HUD        /////////////////
//HUD
-(void)showMBHUDWithText:(NSString *)text
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    _mbProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (text&&text.length>0) {
        _mbProgressHUD.labelText = text;
    }
    _mbProgressHUD.dimBackground = YES;
    //    [_mbProgressHUD show:YES];
}
-(void)showMBHUD
{
    [self showMBHUDWithText:nil];
}
- (void)hideMBHUDAfter:(NSTimeInterval)afTime
{
    [_mbProgressHUD hide:YES afterDelay:afTime];
}
- (void)hideMBHUD
{
    [self hideMBHUDAfter:0.0f];
}

////////////////////       TIPView         ////////////////
- (void)showTipViewWithTitle:(NSString *)title Type:(TIPTYPE)type
{
    XTUITipView *tip = [[XTUITipView alloc]initWithTitle:title withType:type];
    [tip show];
}
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
