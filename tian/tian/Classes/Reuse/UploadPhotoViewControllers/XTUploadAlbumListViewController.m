//
//  XTUploadAlbumListViewController.m
//  tian
//
//  Created by 曹亚云 on 15-6-24.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUploadAlbumListViewController.h"
#import "XTDefaultAlbumTableViewCell.h"
#import "XTAlbumListTableViewCell.h"
#import "XTUserStore.h"
#import "XTSubStore.h"
#import "XTUserAccountInfo.h"
#import "XTAlbumInfo.h"
#import "XTNewAlbumViewController.h"
@interface XTUploadAlbumListViewController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView  *editAlbumTableView;
@property (nonatomic, strong) NSMutableArray *albumInfoItem;
@property (nonatomic, assign) NSInteger pageCount;
@end

@implementation XTUploadAlbumListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateNewAlbumList)
                                                     name:@"updateNewAlbumListNotification"
                                                   object:nil];
        self.pageCount = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    YYTBarButtonItem *rightBaritem = [YYTBarButtonItem barItemWithImageName:@"na_add" target:self action:@selector(newAlbum)];
    self.navigationItem.rightBarButtonItem = rightBaritem;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;

    UIView *statusAndNavigationBarBgView = [UIView new];
    statusAndNavigationBarBgView.backgroundColor = UIColorFromRGB(0xececec);
    [self.view addSubview:statusAndNavigationBarBgView];
    [statusAndNavigationBarBgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(@-64);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    [self editAlbumTableView];
    
    __weak XTUploadAlbumListViewController *wself = self;
    XTGifHeader *header = [XTGifHeader headerWithRefreshingBlock:^{
        [wself loadAblumListNewData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.editAlbumTableView.header = header;
    [self.editAlbumTableView.header beginRefreshing];
}

- (UITableView *)editAlbumTableView{
    if (!_editAlbumTableView) {
        _editAlbumTableView = [UITableView new];
        _editAlbumTableView.backgroundColor = [UIColor clearColor];
        _editAlbumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _editAlbumTableView.dataSource = self;
        _editAlbumTableView.delegate = self;
        [self.view addSubview:_editAlbumTableView];
        
        [_editAlbumTableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(8, 8, 8, 8));
        }];
    }
    return _editAlbumTableView;
}

- (void)loadAblumListNewData
{
    XTSubStore *subStore = [[XTSubStore alloc] init];
    NSString *userId = [[XTUserStore sharedManager] user].userID;
    self.editAlbumTableView.footer.hidden = NO;
    [self.editAlbumTableView.footer endRefreshing];
    __weak XTUploadAlbumListViewController *wself = self;
    [subStore fetchUserAlbumFromUserId:[userId intValue]
                              Location:0
                                length:DefaultLoadCount
                       completionBlock:^(NSArray *albumItems, NSError *error) {
                           if (!error) {
                               wself.albumInfoItem = [NSMutableArray arrayWithArray:albumItems];
                               [wself.editAlbumTableView reloadData];
                               if ([albumItems count] == 0) {
                                   wself.editAlbumTableView.footer.hidden = YES;
                               }else if ([albumItems count] > 0){
                                   self.pageCount = 1;
                                   if (!wself.editAlbumTableView.footer) {
                                       XTGifFooter *footer = [XTGifFooter footerWithRefreshingBlock:^{
                                           [wself loadAblumListMoreData];
                                       }];
                                       wself.editAlbumTableView.footer = footer;
                                   }
                               }
                           }
                           [self.editAlbumTableView.header endRefreshing];
                       }];
}

- (void)loadAblumListMoreData{
    XTSubStore *subStore = [[XTSubStore alloc] init];
    NSString *userId = [[XTUserStore sharedManager] user].userID;
    @weakify(self);
    [subStore fetchUserAlbumFromUserId:[userId intValue]
                              Location:self.pageCount*DefaultLoadCount
                                length:DefaultLoadCount
                       completionBlock:^(NSArray *albumItems, NSError *error) {
                           if (!error) {
                               @strongify(self);
                               if ([albumItems count] == 0) {
                                   self.editAlbumTableView.footer.hidden = YES;
                               }else{
                                   self.pageCount += 1;
                                   self.editAlbumTableView.footer.hidden = NO;
                                   @weakify(self);
                                   //数据去重
                                   [self.albumInfoItem addObjectsFromArray:albumItems withCheckKey:@"id" completionBlock:^{
                                       @strongify(self);
                                       [self.editAlbumTableView reloadData];
                                   }];
//                                   [self.albumInfoItem addObjectsFromArray:albumItems];
//                                   [self.editAlbumTableView reloadData];
                               }
                           }
                           [self.editAlbumTableView.footer endRefreshing];
                       }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == XTAlbumListTypeMove) {
        return [self.albumInfoItem count];
    }
    return [self.albumInfoItem count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DefaultAlbumCell = @"XTDefaultAlbumTableViewCell";
    static NSString *AlbumListCell = @"XTAlbumListTableViewCell";
    if (self.type == XTAlbumListTypeUpload && indexPath.row == 0) {
        XTDefaultAlbumTableViewCell *cell = (XTDefaultAlbumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:DefaultAlbumCell];
        if (cell == nil) {
            cell = [[XTDefaultAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DefaultAlbumCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    XTAlbumListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumListCell];
    if (cell == nil) {
        cell = [[XTAlbumListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AlbumListCell];
    }
    
    [cell.separateLineView updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(cell.contentView);
        make.height.equalTo(@0.5);
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    XTAlbumInfo *item = [self.albumInfoItem objectAtIndex:self.type?indexPath.row:indexPath.row-1];
//    [cell.headPortraitImageView sd_setImageWithURL:item.cover placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        //[YYTConfig sharedConfig].networkFlow = receivedSize;
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
//        [cell.headPortraitImageView setImage:image];
//        [cell.headPortraitImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//        [cell.headPortraitImageView setContentMode:UIViewContentModeScaleAspectFill];
//        [cell.headPortraitImageView setClipsToBounds:YES];
//        cell.headPortraitImageView.alpha = 0.0;
//        [UIView animateWithDuration:1.0f animations:^{
//            cell.headPortraitImageView.alpha = 1.0;
//        }];
//    }];
    [cell.headPortraitImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    [cell.headPortraitImageView setContentMode:UIViewContentModeScaleAspectFill];
    [cell.headPortraitImageView setClipsToBounds:YES];
    [cell.headPortraitImageView an_setImageWithURL:item.cover placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
    cell.titleLabel.text = item.title;
    cell.contentLabel.text = [NSString stringWithFormat:@"(%ld)",item.picCount];
    if (indexPath.row == [self.albumInfoItem count]) {
        [cell.separateLineView updateConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(cell.contentView);
            make.height.equalTo(@0.5);
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [self.albumInfoItem count]) {
        return 85.0f;
    }
    return 85.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!(self.type == XTAlbumListTypeUpload && indexPath.row == 0)) {
        XTAlbumInfo *item = [self.albumInfoItem objectAtIndex:self.type?indexPath.row:indexPath.row-1];
        NSDictionary *dic = @{@"albumID": [NSNumber numberWithLong:item.id],
                              @"albumTitle": item.title};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSelectedAlbumNotification" object:dic];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSelectedAlbumNotification" object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)newAlbum{
    XTNewAlbumViewController *newAlbum = [[XTNewAlbumViewController alloc] init];
    [self.navigationController pushViewController:newAlbum animated:YES];
}

- (void)updateNewAlbumList{
    [self loadAblumListNewData];
}

@end
