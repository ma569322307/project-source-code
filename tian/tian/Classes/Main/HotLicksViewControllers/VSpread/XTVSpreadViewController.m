//
//  XTVSpreadViewController.m
//  tian
//
//  Created by huhuan on 15/7/7.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTVSpreadViewController.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTHotLicksCommonArtistInfo.h"
#import "XTVSpreadCollectionView.h"
#import "XTShareManager.h"
#import "XTImageInfo.h"
#import "SDWebImagePrefetcher.h"

@interface XTVSpreadViewController ()

@property (nonatomic, strong) NSURL *vFirstImageUrl;
@property (nonatomic, strong) XTVSpreadCollectionView *spreadCollectionView;
@property (nonatomic, assign) NSInteger picOffset;
@property (nonatomic, copy  ) NSString                    *vAdviceStr;
@property (nonatomic, strong) UIImage *firstImage;

@end

@implementation XTVSpreadViewController

static NSString *vUserUrl = @"/operate/show/vuser.json";
static NSString *spreadPicUrl = @"/operate/show/pic.json";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([self.recTitle length] > 0) {
        self.title = self.recTitle;
    }else {
        self.title = @"大V宣传";
    }
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0, 0, 40, 40);
    [shareButton setImage:[UIImage imageNamed:@"share_brown"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareButton];
    
    self.spreadCollectionView = [XTVSpreadCollectionView spreadCollectionView];
    self.spreadCollectionView.hidden = YES;
    [self.view addSubview:self.spreadCollectionView];
    [self.spreadCollectionView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
    }];
    @weakify(self);
    self.spreadCollectionView.loadMore = ^() {
        @strongify(self);
        [self requestPicInfo];
    };
    self.picOffset = 0;
    [self requestVUserInfo];
}

- (void)clickNaBackBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareClick:(id)sender {
    if(self.firstImage) {
        [[XTShareManager sharedManager] shareWithTitle:self.recTitle withMvDesc:self.vAdviceStr withImage:self.firstImage withShareModeType:XTShareModeTypeBigV withPid:self.recId  withShareSheetType:XTShareSheetItemNone withCompletionBlock:nil];
    }else {
        [YYTHUD showPromptAddedTo:self.view withText:@"图片未下载成功，暂时不能分享" withCompletionBlock:nil];
    }
}

- (void)requestVUserInfo {
    
    [YYTHUD showLoadingAddedTo:self.view];
    
    NSDictionary *requestDic = @{@"id" : @(self.recId)};
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:vUserUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [YYTBlankView hideFromView:self.view];
        NSError *err = nil;
        XTHotLicksCommonArtistInfo *artistInfo = [MTLJSONAdapter modelOfClass:[XTHotLicksCommonArtistInfo class] fromJSONDictionary:responseObject error:&err];
        self.vAdviceStr = artistInfo.basic.content;
        self.spreadCollectionView.hidden = NO;
        artistInfo.pictures = nil;
        [self.spreadCollectionView configureSpreadCollectionViewWithCommonArtistInfo:artistInfo];
        [self.spreadCollectionView.waterFallControl reloadCollectionViewData];
        
        [self requestPicInfo];
        
        [YYTHUD hideLoadingFrom:self.view];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:self.view];
        YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
            [self requestVUserInfo];
        }];
        blankView.error = error;
    }];
    
}

- (void)requestPicInfo {
    NSDictionary *requestDic = @{
                                 @"id" : @(self.recId),
                                 @"offset" : @(self.picOffset),
                                 @"size" : @"24"
                                 };
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:spreadPicUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        NSArray *picInfo = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:responseObject error:&err];
        
        if(self.picOffset == 0 && [picInfo count] > 0) {
            XTImageInfo *imageInfo = [picInfo firstObject];
            self.vFirstImageUrl = imageInfo.url;
            [self downloadFirstImage];
        }
        
        [self.spreadCollectionView.waterFallControl stopWaterViewAnimating];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.spreadCollectionView.waterFallControl.dataArray];
        
        //去重
        [tempArray addObjectsFromArray:picInfo withCheckKey:@"id" completionBlockWithReturnValue:^(NSMutableArray *array) {
            
            self.spreadCollectionView.waterFallControl.dataArray = array;
            [self.spreadCollectionView.waterFallControl reloadCollectionViewData];
            if([picInfo count] == 0) {
                [self.spreadCollectionView.waterFallControl hidenTheFooterView:YES];
            }else {
                self.picOffset += 24;
                [self.spreadCollectionView.waterFallControl hidenTheFooterView:NO];
            }
        }]; 
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)downloadFirstImage {
    UIImage *headerImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:self.vFirstImageUrl.absoluteString];
    if(!headerImage) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:self.vFirstImageUrl options:SDWebImageRetryFailed | SDWebImageLowPriority
                                                       progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                           self.firstImage = image;
                                                       }];
    }else {
        self.firstImage = headerImage;
    }
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
