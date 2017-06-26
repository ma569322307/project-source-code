//
//  XTLikeAndCollectionViewController.m
//  tian
//
//  Created by 刘佳 on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTLoveAndCollectViewController.h"
#import "XTTitleSliderBar.h"
#import "XTTabBarController.h"
#import "RAMCollectionViewFlemishBondLayout.h"
#import "XTLoveAndCollectCollectionView.h"
#import "XTSubStore.h"
#import "XTImgDetailViewController.h"
#import "XTImageInfo.h"
#import "XTUserStore.h"
#define kMaxNum 20

typedef NS_ENUM(NSInteger, tagSelectItemType) {
    
    tagSelect_item_love = 0,
    tagSelect_item_collect
    
};

@interface XTLoveAndCollectViewController ()

@property(nonatomic, strong) NSString*                          uid;

@property(nonatomic, strong) NSMutableArray*                    loveArray;
@property(nonatomic, strong) NSMutableArray*                    collectArray;

@property(nonatomic, strong) XTLoveAndCollectCollectionView*	loveCollectionView;
@property(nonatomic, strong) XTLoveAndCollectCollectionView*	collectCollectionView;

@property(nonatomic, assign) tagSelectItemType                  currentSelectTag;

@property(nonatomic, assign) BOOL                               isComeToRefreshLove;
@property(nonatomic, assign) BOOL                               isComeToRefreshCollect;

@property(nonatomic, strong) XTSubStore*		subStore;
@property(nonatomic, assign) NSInteger lovePageCount;
@property(nonatomic, assign) NSInteger collectPageCount;
@end

@implementation XTLoveAndCollectViewController

- (id)initWithUID:(NSString*)uid
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        
        self.uid = uid;
        
        self.isComeToRefreshLove = NO;
        self.isComeToRefreshCollect = YES;
        
        self.currentSelectTag = tagSelect_item_love;
        
        self.loveArray = [NSMutableArray arrayWithCapacity:8];
        self.collectArray = [NSMutableArray arrayWithCapacity:8];
        
        self.subStore = [[XTSubStore alloc] init];
        self.lovePageCount = 0;
        self.collectPageCount = 0;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self addTitleBar];
    
    [self addItems];
    
    [self.view addSubview:self.loveCollectionView];
    
    [self.loveCollectionView.waterFallControl waterViewTriggerRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.navigationController setNavigationBarHidden:NO];
    
    XTTabBarController *tabBarCtr = (XTTabBarController *)self.parentViewController.parentViewController;
    [tabBarCtr hideBottomViewWhenPushed];
    
//    if (!self.isComeToRefreshLove) {
//        [self.loveCollectionView.waterFallControl waterViewTriggerRefresh];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[self.navigationController setNavigationBarHidden:YES];
    
}

- (void)addItems
{
    UIImage* img = UIIMAGE(@"na_back_brown");
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:img forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [leftBtn addTarget:self action:@selector(backButtonEvnet:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}

- (void)addTitleBar
{
    NSArray* titleArray = @[@"赞过", @"收藏"];
    
    [self addTitleSliderBarByArray:titleArray];
    
    __block XTLoveAndCollectViewController* _self = self;
    self.titleSliderBar.tilteSliderBarSelectedBlock = ^(NSInteger index) {
        
        if (index > _self.currentSelectTag) {
            [_self changeToSelectView:index];
        } else {
            [_self changeToSelectView:index];
        }
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)backButtonEvnet:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Gesture
- (void)onSwipeLeftEvent:(UISwipeGestureRecognizer*)gesture
{
    //如果动画没有执行完成返回
    if ([self.titleSliderBar titleSliderBarIsAnimation])
        return;
    
    //如果在最右返回
    if (self.currentSelectTag == tagSelect_item_collect)
        return;
    
    NSInteger tag = self.currentSelectTag + 1;
    
    if (tag > tagSelect_item_collect)
        tag = tagSelect_item_collect;
    
    if (tag == self.currentSelectTag)
        return;
    
    [self changeSelectState:tag];
}

- (void)onSwipeRightEvent:(UISwipeGestureRecognizer*)gesture
{
    //如果动画没有执行完成返回
    if ([self.titleSliderBar titleSliderBarIsAnimation])
        return;
    
    //如果在最左返回
    if (self.currentSelectTag == tagSelect_item_love)
        return;
    
    NSInteger tag = self.currentSelectTag - 1;
    
    if (tag < tagSelect_item_love)
        tag = tagSelect_item_love;
    
    if (tag == self.currentSelectTag)
        return;
    
    [self changeSelectState:tag];
}

#pragma mark 处理滑动或者选择顶部控件时的操作
- (void)changeSelectState:(NSInteger)selectTag
{
    //设置顶部slider位置
    [self.titleSliderBar animationToNext:selectTag];
    
    //切换视图
    [self changeToSelectView:selectTag];
    
}

- (void)changeToSelectView:(NSInteger)selectTag
{
    UIView* curView = nil;
    UIView* selectView = nil;
    
    if (self.currentSelectTag == tagSelect_item_love) {
        curView = self.loveCollectionView;
    } else{
        curView = self.collectCollectionView;
    }
    
    if (selectTag == tagSelect_item_love) {
        
        selectView = self.loveCollectionView;
        
        if (self.isComeToRefreshLove) {
            
            self.isComeToRefreshLove = NO;
            
            [self.loveCollectionView.waterFallControl waterViewTriggerRefresh];
        }
        
    } else {
        
        selectView = self.collectCollectionView;
        
        if (self.isComeToRefreshCollect) {
            
            self.isComeToRefreshCollect = NO;
            
            [self.collectCollectionView.waterFallControl waterViewTriggerRefresh];
        }
    }
    
    NSInteger directionFlag = (selectTag > self.currentSelectTag) ? 1 : -1;
    
    //重置当前选中
    self.currentSelectTag = selectTag;
    
    [self.view addSubview:selectView];
    
    CGFloat startY = 0.0f; //起始点
    CGFloat sortH = SCREEN_SIZE.height - 64.0f;
    CGFloat sortW = SCREEN_SIZE.width;
    
    selectView.frame = CGRectMake(sortW*directionFlag, startY, sortW, sortH);
    
    [UIView animateWithDuration:XTTitleSliderAnimationTime animations:^{
        
        selectView.frame = CGRectMake(0, startY, sortW, sortH);
        curView.frame = CGRectMake(-sortW * directionFlag, startY, sortW, sortH);
        
    } completion:^(BOOL finished) {
        
        [curView removeFromSuperview];
    }];
}

#pragma mark 计算用户区域 高度
- (CGFloat)calculateUserAreaHight
{
    return SCREEN_SIZE.height - 64.0f;
}

- (XTLoveAndCollectCollectionView*)loveCollectionView
{
    if (_loveCollectionView == nil) {
        
        _loveCollectionView = [XTLoveAndCollectCollectionView loveAndCollectCollectionViewWithCellType:XTWaterFallViewCellType_imageAndLike];
        [_loveCollectionView setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64.0f)];
    }
    
    __block XTLoveAndCollectViewController* _self = self;
    
    _loveCollectionView.loadRefreshBlock = ^() {
        
        [_self requestLove:YES];
    };
    
    _loveCollectionView.loadMoreBlock = ^() {
     
        [_self requestLove:NO];
    };
    
    _loveCollectionView.clickCellIndexRowBlock = ^(NSInteger row){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
        XTImgDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
        controller.pidArr = [_self getAllIdArray:_self.loveArray];
        controller.curIndex = row;
        [[UIViewController topViewController] pushViewController:controller animated:YES];
    };
    
    return _loveCollectionView;
}

- (XTLoveAndCollectCollectionView*)collectCollectionView
{
    if (_collectCollectionView == nil) {
        
        _collectCollectionView = [XTLoveAndCollectCollectionView loveAndCollectCollectionViewWithCellType:XTWaterFallViewCellType_imageAndCollection];
    }
    
    __block XTLoveAndCollectViewController* _self = self;
    
    _collectCollectionView.loadRefreshBlock = ^() {
        
        [_self requestCollect:YES];
    };
    
    _collectCollectionView.loadMoreBlock = ^() {
        
        [_self requestCollect:NO];
    };
    
    _collectCollectionView.clickCellIndexRowBlock = ^(NSInteger row){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
        XTImgDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
        controller.pidArr = [_self getAllIdArray:_self.collectArray];
        controller.curIndex = row;
        [[UIViewController topViewController] pushViewController:controller animated:YES];
    };
    
    return _collectCollectionView;
}

- (NSMutableArray *)getAllIdArray:(NSMutableArray *)dataArray
{
    NSMutableArray *mArray = [NSMutableArray array];
    for (XTImageInfo *imgInfo in dataArray) {
        [mArray addObject:[NSString stringWithFormat:@"%ld",imgInfo.id]];
    }
    return mArray;
}

- (void)requestLove:(BOOL)isRefresh
{
    __block XTLoveAndCollectViewController* _self = self;
    
    NSInteger location = isRefresh ?  0 : self.lovePageCount*DefaultLoadCount;
    
    if (isRefresh) {
        
        //刷新的话重新显示上拉
        [_self.loveCollectionView.waterFallControl hidenTheFooterView:NO];
    }
    
    [_subStore fetchUserCommendWithUserId:[self.uid integerValue] offset:location size:DefaultLoadCount completionBlock:^(NSArray *array, NSError *error) {
        
        [YYTBlankView hideFromView:_loveCollectionView];
        
        if (!error) {
            
            if ([_self.loveArray count] <= 0 && [array count] <= 0) {
                YYTBlankView *blankView = [YYTBlankView showBlankInView:_loveCollectionView style:YYTBlankViewStyleBlank eventClick:nil];
                if ([self.uid isEqualToString:[XTUserStore sharedManager].user.userID]) {
                    blankView.tipString = @"我轻轻的划一划手指 没有留下一个喜欢";
                }else{
                    blankView.tipString = @"没有好食分享给你";
                }
            }
            
            if (isRefresh) {
                self.lovePageCount = 1;
                [_self.loveArray removeAllObjects];
            }else{
                self.lovePageCount += 1;
            }
            
            if (array == nil || array.count <= 0) {
                
                //隐藏上拉
                [_self.loveCollectionView.waterFallControl stopWaterViewAnimating];
                [_self.loveCollectionView.waterFallControl hidenTheFooterView:YES];
                
                return;
                
            } else {
                if ([_self.loveArray count] > 0) {
                    @weakify(_self);
                    //数据去重
                    [_self.loveArray addObjectsFromArray:array withCheckKey:@"id" completionBlock:^{
                        @strongify(_self);
                        [_self.loveCollectionView configureCollectionViewWithArray:_self.loveArray];
                    }];
                }else{
                    [_self.loveArray addObjectsFromArray:array];
                    [_self.loveCollectionView configureCollectionViewWithArray:_self.loveArray];
                    
                }
            }
            
        } else {
            
            //TODO:报错
            YYTBlankView *blankView = [YYTBlankView showBlankInView:_loveCollectionView style:YYTBlankViewStyleNetworkError eventClick:^{
                [self requestLove:YES];
            }];
            blankView.error = error;
        }
        
        [_self.loveCollectionView.waterFallControl stopWaterViewAnimating];
    }];
}

- (void)requestCollect:(BOOL)isRefresh
{
    __block XTLoveAndCollectViewController* _self = self;
    
    NSInteger location = isRefresh ?  0 : self.collectPageCount*DefaultLoadCount;
    
    if (isRefresh) {
        
        //刷新的话重新显示上拉
        [_self.collectCollectionView.waterFallControl hidenTheFooterView:NO];
    }
    
    [_subStore fetchUserFavoriteWithUserId:[self.uid integerValue] offset:location size:DefaultLoadCount completionBlock:^(NSArray *array, NSError *error) {
        [YYTBlankView hideFromView:_collectCollectionView];
        if (!error) {
            if ([_self.collectArray count] <=0 && [array count] <= 0) {
                YYTBlankView *blankView = [YYTBlankView showBlankInView:_collectCollectionView style:YYTBlankViewStyleBlank eventClick:nil];
                if ([self.uid isEqualToString:[XTUserStore sharedManager].user.userID]) {
                    blankView.tipString = @"我轻轻的划一划手指 没有留下一个喜欢";
                }else{
                    blankView.tipString = @"没有好食分享给你";
                }
            }
            
            if (isRefresh) {
                self.collectPageCount = 1;
                [_self.collectArray removeAllObjects];
            }else{
                self.collectPageCount += 1;
            }
            
            if (array == nil || array.count <= 0) {
                
                //隐藏上拉
                [_self.collectCollectionView.waterFallControl stopWaterViewAnimating];
                [_self.collectCollectionView.waterFallControl hidenTheFooterView:YES];

                return;
                
            } else {
                if ([_self.collectArray count] > 0) {
                    @weakify(_self);
                    //数据去重
                    [_self.collectArray addObjectsFromArray:array withCheckKey:@"id" completionBlock:^{
                        @strongify(_self);
                        [_self.collectCollectionView configureCollectionViewWithArray:_self.collectArray];
                    }];
                }else{
                    [_self.collectArray addObjectsFromArray:array];
                    [_self.collectCollectionView configureCollectionViewWithArray:_self.collectArray];
                }
            }
            
        } else {
            
            //TODO:报错
            YYTBlankView *blankView = [YYTBlankView showBlankInView:_collectCollectionView style:YYTBlankViewStyleNetworkError eventClick:^{
                [self requestCollect:YES];
            }];
            blankView.error = error;
        }
        
        [_self.collectCollectionView.waterFallControl stopWaterViewAnimating];
    }];
}
@end

