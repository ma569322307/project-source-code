//
//  XTSearchUsersViewController.m
//  tian
//
//  Created by huhuan on 15/6/13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchUsersViewController.h"
#import "XTSearchArtistCollectionView.h"
#import "XTSearchVFollowCollectionView.h"
#import "XTUserCollectionView.h"
#import "XTConfig.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTOrderArtist.h"
#import "XTSearchUserModel.h"
#import "XTSearchArtistModel.h"
#import <Mantle/EXTScope.h>

@interface XTSearchUsersViewController ()

@property (nonatomic, strong) IBOutlet UIView *contentView;

@property (nonatomic, strong) IBOutlet UIButton *artistButton;
@property (nonatomic, strong) IBOutlet UIButton *vButton;
@property (nonatomic, strong) IBOutlet UIButton *userButton;

@property (nonatomic, strong) XTSearchArtistCollectionView *artistCollectionView;
@property (nonatomic, strong) XTSearchVFollowCollectionView *vCollectionView;
@property (nonatomic, strong) XTUserCollectionView *userCollectionView;

@property (nonatomic, assign) NSInteger artistOffset;
@property (nonatomic, assign) NSInteger vOffset;
@property (nonatomic, assign) NSInteger userOffset;

@end

@implementation XTSearchUsersViewController

static NSString* const requestUrl = @"/search/so.json";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.artistOffset = 0;
    self.vOffset = 0;
    self.userOffset = 0;
    self.artistButton.selected = YES;
    self.vButton.selected      = NO;
    self.userButton.selected   = NO;
    
}

- (IBAction)searchArtist:(id)sender {
    self.artistButton.selected = YES;
    self.vButton.selected      = NO;
    self.userButton.selected   = NO;
    [self clearContentView];
    
    if(!self.artistCollectionView.artistModel) {
        [self requestArtistInfo];
    }else {
        [self.contentView addSubview:self.artistCollectionView];
        [self.artistCollectionView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
        }];
    }
}

- (IBAction)searchV:(id)sender {
    self.artistButton.selected = NO;
    self.vButton.selected      = YES;
    self.userButton.selected   = NO;
    [self clearContentView];
    
    if([self.vCollectionView.vArray count] == 0) {
        [self requestVInfo];
    }else {
        [self.contentView addSubview:self.vCollectionView];
        [self.vCollectionView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0., 14.f/320.f*SCREEN_SIZE.width, 0., 14.f/320.f*SCREEN_SIZE.width));
        }];
    }
}

- (IBAction)searchUser:(id)sender {
    self.artistButton.selected = NO;
    self.vButton.selected      = NO;
    self.userButton.selected   = YES;
    [self clearContentView];
    
    if([self.userCollectionView.userArray count] == 0) {
        [self requestUserInfo];
    }else {
        [self.contentView addSubview:self.userCollectionView];
        [self.userCollectionView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0., 14.f/320.f*SCREEN_SIZE.width, 0., 14.f/320.f*SCREEN_SIZE.width));
        }];
    }

}

- (XTSearchArtistCollectionView *)artistCollectionView {
    if(!_artistCollectionView) {
        _artistCollectionView = [XTSearchArtistCollectionView searchArtistCollectionView];
        @weakify(self);
        _artistCollectionView.loadMore = ^() {
            @strongify(self);
            [self requestArtistInfo];
        };
    }
    return _artistCollectionView;
}

- (XTSearchVFollowCollectionView *)vCollectionView {
    if(!_vCollectionView) {
        _vCollectionView = [XTSearchVFollowCollectionView vCollectionView];
        @weakify(self);
        XTGifFooter *gifFooter = [XTGifFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self requestVInfo];
        }];
        _vCollectionView.footer = gifFooter;
    }
    return _vCollectionView;
}

- (XTUserCollectionView *)userCollectionView {
    if(!_userCollectionView) {
        _userCollectionView = [XTUserCollectionView userCollectionViewWithPageStyle:XTUserCollectionViewStyleVertical CellStyle:XTUserCollectionViewCellStyleDefault buttonStyle:XTUserCollectionViewCellButtonStyleFollow];
        
        @weakify(self);
        XTGifFooter *gifFooter = [XTGifFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self requestUserInfo];
        }];
        _userCollectionView.footer = gifFooter;
        
    }
    return _userCollectionView;
}

- (void)refreshViewController {
    self.artistCollectionView.artistModel = nil;
    self.vCollectionView.vArray = nil;
    self.userCollectionView.userArray = nil;
    self.artistOffset = 0;
    self.artistButton.selected = YES;
    self.vButton.selected      = NO;
    self.userButton.selected   = NO;
    [self clearContentView];
    [self.artistCollectionView configureSearchArtistCollectionView];
    [self.artistCollectionView reloadData];
    [self requestArtistInfo];
}

- (void)clearContentView {
    [YYTBlankView hideFromView:self.view];
    for(UIView *v in [self.contentView subviews]) {
        [v removeFromSuperview];
    }
}

- (NSDictionary *)requestInfoDictionary:(NSString *)searchType {
    
    NSString *searchText = [self.keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger searchOffset = 0;
    if([searchType isEqualToString:@"artist"]) {
        searchOffset = self.artistOffset;
    }else if([searchType isEqualToString:@"v"]){
        searchOffset = self.vOffset;
    }else if([searchType isEqualToString:@"user"]){
        searchOffset = self.userOffset;
    }
    
    NSDictionary *requestDic = @{
                                 @"deviceinfo" : [[XTConfig sharedManager] deviceInfo],
                                 @"keyword"    : searchText ? searchText : @"",
                                 @"soType"     : searchType,
                                 @"order"      : @"",
                                 @"offset"     : @(searchOffset),
                                 @"size"       : @"24"
                                 };
    return requestDic;

}

- (void)requestReportArtist {
    
    NSString *searchText = [self.keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSDictionary *requestDic = @{
                                 @"artistName" : searchText ? searchText : @""
                                 };
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager POST:@"feedback/artist.json" parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"报告成功" withCompletionBlock:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:nil];
    }];
}

- (void)requestArtistInfo {
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:requestUrl parameters:[self requestInfoDictionary:@"artist"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        [YYTBlankView hideFromView:self.view];
        
        XTSearchArtistModel *artistModel = [MTLJSONAdapter modelOfClass:[XTSearchArtistModel class] fromJSONDictionary:responseObject error:&error];

        if(!self.artistCollectionView.artistModel) {
            self.artistCollectionView.artistModel = artistModel;
            
            [self.artistCollectionView configureSearchArtistCollectionView];
            [self.contentView addSubview:self.artistCollectionView];
            [self.artistCollectionView reloadData];
        }else {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.artistCollectionView.artistModel.pics];
            
            [tempArray addObjectsFromArray:artistModel.pics withCheckKey:@"id" completionBlockWithReturnValue:^(NSMutableArray *array) {
                
                self.artistCollectionView.artistModel.pics = array;
                [self.artistCollectionView configureSearchArtistCollectionView];
                [self.contentView addSubview:self.artistCollectionView];
                [self.artistCollectionView reloadData];
            }];
            
        }

        if([artistModel.pics count] == 0) {
            [self.artistCollectionView.waterFallControl hidenTheFooterView:YES];
        }else {
            [self.artistCollectionView.waterFallControl hidenTheFooterView:NO];
            self.artistOffset += 24;
        }
        [self.artistCollectionView.waterFallControl stopWaterViewAnimating];
        
        [self.artistCollectionView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
        }];
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        
        if([self.artistCollectionView.artistModel.topics count] == 0 &&
           [self.artistCollectionView.artistModel.pics count] == 0 &&
           [self.artistCollectionView.artistModel.artists count] == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleBlank eventClick:^{
                [self requestReportArtist];
            }];
            blankView.headerStyle = YYTBlankHeaderStyleCry;
            blankView.tipString = @"你家偶像躲猫猫ing，我们找不到(≥◇≤)";
            blankView.buttonTitle = @"去报告 ";
            [self.view bringSubviewToFront:blankView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        [self.artistCollectionView.waterFallControl stopWaterViewAnimating];

        if([self.artistCollectionView.artistModel.topics count] == 0 &&
           [self.artistCollectionView.artistModel.pics count] == 0 &&
           [self.artistCollectionView.artistModel.artists count] == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
                [self.artistCollectionView configureSearchArtistCollectionView];
                [self.artistCollectionView reloadData];
                [self requestArtistInfo];
            }];
            [self.view bringSubviewToFront:blankView];
        }
    }];
}

- (void)requestVInfo {

    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:requestUrl parameters:[self requestInfoDictionary:@"v"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        [YYTBlankView hideFromView:self.view];
        
        NSArray *vArray = [MTLJSONAdapter modelsOfClass:[XTOrderArtist class] fromJSONArray:responseObject error:&error];
        self.vCollectionView.vArray = vArray;
        [self.contentView addSubview:self.vCollectionView];
        [self.vCollectionView reloadData];
        
        [self.vCollectionView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0., 14.f/320.f*SCREEN_SIZE.width, 0., 14.f/320.f*SCREEN_SIZE.width));
        }];
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        
        [self.vCollectionView.footer endRefreshing];
        
        if([vArray count] == 0) {
            [self.vCollectionView.footer setHidden:YES];
        }else {
            [self.vCollectionView.footer setHidden:NO];
            self.vOffset += 24;
        }
        
        if([self.vCollectionView.vArray count] == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleBlank eventClick:^{
                [self requestArtistInfo];
            }];
            blankView.headerStyle = YYTBlankHeaderStyleCry;
            blankView.tipString = @"没有找到你搜索的东西，图库君(●—●)等你反馈";
            [self.view bringSubviewToFront:blankView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        [self.vCollectionView.footer endRefreshing];
        if([self.vCollectionView.vArray count] == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
                [self requestVInfo];
            }];
            [self.view bringSubviewToFront:blankView];
        }
    }];
    
}

- (void)requestUserInfo {
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:requestUrl parameters:[self requestInfoDictionary:@"user"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        [YYTBlankView hideFromView:self.view];
        NSArray *userArray = [MTLJSONAdapter modelsOfClass:[XTSearchUserModel class] fromJSONArray:responseObject error:&error];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:        self.userCollectionView.userArray];
        
        [tempArray addObjectsFromArray:userArray withCheckKey:@"userId" completionBlockWithReturnValue:^(NSMutableArray *array) {
            self.userCollectionView.userArray = array;
            
            [self.contentView addSubview:self.userCollectionView];
            [self.userCollectionView reloadData];
            
            [self.userCollectionView updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0., 14.f/320.f*SCREEN_SIZE.width, 0., 14.f/320.f*SCREEN_SIZE.width));
            }];
            
            if([self.userCollectionView.userArray count] == 0) {
                YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleBlank eventClick:^{
                    [self requestArtistInfo];
                }];
                blankView.headerStyle = YYTBlankHeaderStyleCry;
                blankView.tipString = @"没有找到你搜索的东西，图库君(●—●)等你反馈";
                [self.view bringSubviewToFront:blankView];
            }
        }];
        
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        
        [self.userCollectionView.footer endRefreshing];
        
        if([userArray count] == 0) {
            [self.userCollectionView.footer setHidden:YES];
        }else {
            [self.userCollectionView.footer setHidden:NO];
            self.userOffset += 24;
        }
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        [self.userCollectionView.footer endRefreshing];
        if([self.userCollectionView.userArray count] == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
                [self requestUserInfo];
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
