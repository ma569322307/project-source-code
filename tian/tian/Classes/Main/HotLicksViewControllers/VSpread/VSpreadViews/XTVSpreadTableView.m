//
//  XTVSpreadHeaderTableView.m
//  tian
//
//  Created by huhuan on 15/7/7.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTVSpreadTableView.h"
#import "XTVSpreadTableViewHeader.h"
#import "XTSearchAlbumCollectionView.h"
#import "XTHotLicksCommonArtistInfo.h"
#import "JKUtil.h"

@interface XTVSpreadTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *albumPageNumLabel;
@property (nonatomic, assign) float headerHeight;

@property (nonatomic, strong) XTVSpreadTableViewHeader *spreadTableViewHeader;
@property (nonatomic, strong) XTSearchAlbumCollectionView *albumCollectionView;

@end

@implementation XTVSpreadTableView

+ (XTVSpreadTableView *)spreadTableView {
    XTVSpreadTableView *spreadTV = [[XTVSpreadTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    spreadTV.backgroundColor = [UIColor clearColor];
    spreadTV.dataSource = spreadTV;
    spreadTV.delegate = spreadTV;
    spreadTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    spreadTV.tableHeaderView = spreadTV.spreadTableViewHeader;
    spreadTV.scrollEnabled = NO;
    return spreadTV;
}

- (UIView *)spreadTableViewHeader {
    if(!_spreadTableViewHeader) {
        _spreadTableViewHeader = [XTVSpreadTableViewHeader spreadTableViewHeader];
    }
    
    return _spreadTableViewHeader;
}

- (XTSearchAlbumCollectionView *)albumCollectionView {
    if(!_albumCollectionView) {
        _albumCollectionView = [XTSearchAlbumCollectionView albumCollectionViewWithCollectionViewStyle:XTSearchAlbumCollectionViewStyleHorizontal];
        @weakify(self);
        _albumCollectionView.pageNum = ^(NSString *pageNum){
            @strongify(self);
            self.albumPageNumLabel.text = pageNum;
        };
    }
    
    return _albumCollectionView;
}

- (UILabel *)albumPageNumLabel {
    if(!_albumPageNumLabel) {
        _albumPageNumLabel = [[UILabel alloc] init];
        _albumPageNumLabel.backgroundColor = [UIColor clearColor];
        _albumPageNumLabel.font = [UIFont systemFontOfSize:12.f];
        _albumPageNumLabel.textColor = [JKUtil getColor:@"7b7b7b"];
        _albumPageNumLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _albumPageNumLabel;
}

- (void)configureSpreadTableView {
    
    [self.spreadTableViewHeader configureHeaderWithUserInfo:self.artistInfo.user andRecsInfo:self.artistInfo.basic];
    
    self.headerHeight = self.spreadTableViewHeader.frame.size.height;
    self.tableHeaderView = nil;
    [self performSelector:@selector(resetHeader) withObject:nil afterDelay:0.01f];
    [self reloadData];
    
    self.albumCollectionView.albumArray = self.artistInfo.albums;
    [self.albumCollectionView reloadData];

}

- (void)resetHeader {
    self.spreadTableViewHeader.frame = CGRectMake(0., 0., SCREEN_SIZE.width, self.headerHeight);
    self.tableHeaderView = self.spreadTableViewHeader;
}

- (float)tableViewHeight {
    return 30+self.spreadTableViewHeader.frame.size.height + 214/320.f*SCREEN_SIZE.width+15;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SearchAllCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.section) {
        case 0:
        {
            [cell.contentView addSubview:self.albumCollectionView];
            [self.albumCollectionView updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0., 14., 0., 14.));
            }];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    
    UILabel *sectionTitleLabel = [[UILabel alloc] init];
    sectionTitleLabel.backgroundColor = [UIColor clearColor];
    sectionTitleLabel.font = [UIFont systemFontOfSize:12.f];
    sectionTitleLabel.textColor = [JKUtil getColor:@"7b7b7b"];
    [headerView addSubview:sectionTitleLabel];
    
    headerView.frame = CGRectMake(0., 0., tableView.frame.size.width, 25.f);
    
    [sectionTitleLabel updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0., 14., 0., 0.));
    }];
    
    switch (section) {
        case 0: {
            sectionTitleLabel.text = @"相关相册";
            [headerView addSubview:self.albumPageNumLabel];
            
            [self.albumPageNumLabel updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
            }];
        }
            break;
        case 1: {
            sectionTitleLabel.text = @"图片推荐";
            [headerView addSubview:self.albumPageNumLabel];
        }
            break;

        default:
            break;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1) {
        return 0;
    }
    return 214/320.f*SCREEN_SIZE.width;
    
}

@end
