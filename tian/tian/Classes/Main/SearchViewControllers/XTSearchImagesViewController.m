//
//  XTSearchImagesViewController.m
//  tian
//
//  Created by huhuan on 15/6/23.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchImagesViewController.h"
#import "XTSearchImageCollectionView.h"
#import "XTSearchAlbumCollectionView.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTImageInfo.h"
#import "XTAlbumInfo.h"
#import "XTConfig.h"

@interface XTSearchImagesViewController ()

@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UIButton *artistButton;
@property (nonatomic, strong) IBOutlet UIButton *albumButton;

@property (nonatomic, strong) XTSearchImageCollectionView *imageCollectionView;
@property (nonatomic, strong) XTSearchAlbumCollectionView *albumCollectionView;
@property (nonatomic, assign) NSInteger imageOffset;
@property (nonatomic, assign) NSInteger albumOffset;

@end

@implementation XTSearchImagesViewController

static NSString* const requestUrl = @"/search/so.json";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageOffset = 0;
    self.albumOffset = 0;
    self.artistButton.selected = YES;
    self.albumButton.selected  = NO;
}

- (IBAction)searchImages:(id)sender {
    
    self.artistButton.selected = YES;
    self.albumButton.selected  = NO;
    
    [self clearContentView];
    
    if([self.imageCollectionView.imageArray count] == 0) {
        [self requestImageInfo];
    }else {
        [self.contentView addSubview:self.imageCollectionView];
        [self.imageCollectionView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
        }];
    }
}

- (IBAction)searchAlbums:(id)sender {
    
    self.artistButton.selected = NO;
    self.albumButton.selected  = YES;
    
    [self clearContentView];
    
    if([self.albumCollectionView.albumArray count] == 0) {
        [self requestAlbumInfo];
    }else {
        [self.contentView addSubview:self.albumCollectionView];
        [self.albumCollectionView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0));
        }];
    }
}

- (XTSearchImageCollectionView *)imageCollectionView {
    if(!_imageCollectionView) {
        _imageCollectionView = [XTSearchImageCollectionView imageCollectionView];
        @weakify(self);
        _imageCollectionView.loadMore = ^(){
            @strongify(self);
            [self requestImageInfo];
        };
    }
    return _imageCollectionView;
}

- (XTSearchAlbumCollectionView *)albumCollectionView {
    if(!_albumCollectionView) {
        _albumCollectionView = [XTSearchAlbumCollectionView albumCollectionViewWithCollectionViewStyle:XTSearchAlbumCollectionViewStyleVertical];
        _albumCollectionView.contentInset = UIEdgeInsetsMake(0., 15., 0., 15.);
        @weakify(self);
        XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self requestAlbumInfo];
        }];
        _albumCollectionView.footer = footer;
    }
    return _albumCollectionView;
}

- (void)refreshViewController {
    self.artistButton.selected = YES;
    self.albumButton.selected  = NO;
    self.imageOffset = 0;
    self.albumOffset = 0;
    self.imageCollectionView.imageArray = nil;
    self.albumCollectionView.albumArray = nil;
    [self requestImageInfo];
    [self.imageCollectionView reloadCollectView];
    [self.imageCollectionView reloadData];
    [self.albumCollectionView reloadData];
}

- (void)clearContentView {
    [YYTBlankView hideFromView:self.view];
    for(UIView *v in [self.contentView subviews]) {
        [v removeFromSuperview];
    }
}

- (NSDictionary *)requestInfoDictionary:(NSString *)searchType {
    
    NSInteger searchOffset = 0;
    if([searchType isEqualToString:@"pic"]) {
        searchOffset = self.imageOffset;
    }else if([searchType isEqualToString:@"album"]){
        searchOffset = self.albumOffset;
    }
    
    NSString *searchText = [self.keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
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

- (void)requestImageInfo {
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:requestUrl parameters:[self requestInfoDictionary:@"pic"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        if(![responseObject isKindOfClass:[NSNull class]]) {
            NSArray *imageArray = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:responseObject[@"data"] error:&error];
            
            if([self.imageCollectionView.imageArray count] == 0) {
                self.imageCollectionView.imageArray = imageArray;
                [self.imageCollectionView reloadCollectView];
                [self.imageCollectionView reloadData];
            }else {
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.imageCollectionView.imageArray];
                
                [tempArray addObjectsFromArray:imageArray withCheckKey:@"id" completionBlockWithReturnValue:^(NSMutableArray *array) {
                    
                    self.imageCollectionView.imageArray = array;
                    [self.imageCollectionView reloadCollectView];
                    [self.imageCollectionView reloadData];
                }];
                
            }
            
            [self.contentView addSubview:self.imageCollectionView];
            
            if([imageArray count] == 0) {
                [self.imageCollectionView.waterFallControl hidenTheFooterView:YES];
            }else {
                [self.imageCollectionView.waterFallControl hidenTheFooterView:NO];
                self.imageOffset += 24;
            }
            [self.imageCollectionView.waterFallControl stopWaterViewAnimating];
            
            [self.imageCollectionView updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
            }];
        }else {
            [self.imageCollectionView.waterFallControl hidenTheFooterView:YES];
        }
        
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        
        if([self.imageCollectionView.imageArray count] == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleBlank eventClick:nil];
            blankView.headerStyle = YYTBlankHeaderStyleCry;
            blankView.tipString = @"没有找到你搜索的东西，图库君(●—●)等你反馈";
            [self.view bringSubviewToFront:blankView];
        }else {
            [YYTBlankView hideFromView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        
        if([self.imageCollectionView.imageArray count] == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
                [self requestImageInfo];
            }];
            [self.view bringSubviewToFront:blankView];
        }else {
            [YYTBlankView hideFromView:self.view];
        }
    }];
}

- (void)requestAlbumInfo {
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:requestUrl parameters:[self requestInfoDictionary:@"album"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        if(![responseObject isKindOfClass:[NSNull class]]) {
            NSArray *albumArray = [MTLJSONAdapter modelsOfClass:[XTAlbumInfo class] fromJSONArray:responseObject[@"data"] error:&error];
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.albumCollectionView.albumArray];
            [tempArray addObjectsFromArray:albumArray withCheckKey:@"id" completionBlockWithReturnValue:^(NSMutableArray *array) {
                self.albumCollectionView.albumArray = array;
                [self.contentView addSubview:self.albumCollectionView];
                [self.albumCollectionView reloadData];
                
                [self.albumCollectionView updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
                }];
                
                if([self.albumCollectionView.albumArray count] == 0) {
                    YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleBlank eventClick:nil];
                    blankView.headerStyle = YYTBlankHeaderStyleCry;
                    blankView.tipString = @"没有找到你搜索的东西，图库君(●—●)等你反馈";
                    [self.view bringSubviewToFront:blankView];
                }else {
                    [YYTBlankView hideFromView:self.view];
                }
                
            }];
            
            if([albumArray count] == 0) {
                [self.albumCollectionView.footer setHidden:YES];
            }else {
                [self.albumCollectionView.footer setHidden:NO];
                self.albumOffset += 24;
            }
            
        }
 
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        
        if([self.albumCollectionView.albumArray count] == 0) {
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
                [self requestImageInfo];
            }];
            [self.view bringSubviewToFront:blankView];
        }else {
            [YYTBlankView hideFromView:self.view];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
