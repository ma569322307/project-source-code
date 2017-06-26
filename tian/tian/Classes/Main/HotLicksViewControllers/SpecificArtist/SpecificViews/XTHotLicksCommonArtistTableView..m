//
//  XTSpecificArtistTableView.m
//  tian
//
//  Created by huhuan on 15/7/1.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHotLicksCommonArtistTableView.h"
#import "XTSpecificArtistRelateCollectionView.h"
#import "JKUtil.h"
#import "XTSearchAlbumCollectionView.h"
#import "XTSpecificPictureTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import <Mantle/EXTScope.h>
#import "XTImageInfo.h"
#import "XTImgDetailViewController.h"
#import "UIViewController+Extend.h"

@interface XTHotLicksCommonArtistTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *artistPageNumLabel;
@property (nonatomic, strong) UILabel *albumPageNumLabel;

@property (nonatomic, strong) XTSpecificArtistRelateCollectionView *artistCollectionView;
@property (nonatomic, strong) XTSearchAlbumCollectionView *albumCollectionView;

@end

@implementation XTHotLicksCommonArtistTableView

static NSString *pictureCellIdentifier = @"SpecificPictureCell";

+ (XTHotLicksCommonArtistTableView *)commonArtistTableView; {
    XTHotLicksCommonArtistTableView *artistTV = [[XTHotLicksCommonArtistTableView alloc] initWithFrame:CGRectMake(0., 0., SCREEN_SIZE.width, SCREEN_SIZE.height-64) style:UITableViewStyleGrouped];
    artistTV.backgroundColor = [UIColor clearColor];
    artistTV.dataSource = artistTV;
    artistTV.delegate = artistTV;
    artistTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [artistTV registerNib:[UINib nibWithNibName:@"XTSpecificPictureTableViewCell" bundle:nil] forCellReuseIdentifier:pictureCellIdentifier];
    
    return artistTV;
    
}

- (XTSpecificArtistRelateCollectionView *)artistCollectionView {
    if(!_artistCollectionView) {
        _artistCollectionView = [XTSpecificArtistRelateCollectionView specificArtistRelateCollectionView];
    }
    return _artistCollectionView;
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

- (void)configureArtistTableView {
    [self layoutIfNeeded];
    [self.albumCollectionView layoutIfNeeded];
    self.artistCollectionView.artistArray = self.commonArtistModel.artists;
    [self.artistCollectionView reloadData];
    self.albumCollectionView.albumArray = self.commonArtistModel.albums;
    [self.albumCollectionView reloadData];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *artistCellIdentifier = @"ArtistCell";
    
    UITableViewCell *cell = nil;
    
    if(indexPath.section == 2) {
        XTSpecificPictureTableViewCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:pictureCellIdentifier];
        [pictureCell configureCell:self.commonArtistModel.pictures[indexPath.row]];
        cell = pictureCell;
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:artistCellIdentifier];
        
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:artistCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
    
    
        switch (indexPath.section) {
            case 0:
            {
                [cell.contentView addSubview:self.artistCollectionView];
                [self.artistCollectionView updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
                }];
            }
                break;
            case 1:
            {
                
                [cell.contentView addSubview:self.albumCollectionView];
                [self.albumCollectionView updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
                }];
                
            }
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    
    UILabel *sectionTitleLabel = [[UILabel alloc] init];
    sectionTitleLabel.backgroundColor = [UIColor clearColor];
    sectionTitleLabel.font = [UIFont systemFontOfSize:11.f];
    sectionTitleLabel.textColor = [JKUtil getColor:@"7f7f7f"];
    [headerView addSubview:sectionTitleLabel];
    
    headerView.frame = CGRectMake(0., 0., tableView.frame.size.width, 14.f);
    
    [sectionTitleLabel updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0., 14., 0., 0.));
    }];
    
    switch (section) {
        case 0: {
            sectionTitleLabel.text = @"相关艺人";
            [headerView addSubview:self.artistPageNumLabel];
            
            [self.artistPageNumLabel updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 14.));
            }];
            
            break;
        }
        case 1: {
            sectionTitleLabel.text = @"相关图册";
            [headerView addSubview:self.albumPageNumLabel];
            
            [self.albumPageNumLabel updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 14.));
            }];
            break;
        }
            
        default:
            break;
    }
    return headerView;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return 25.f;
    }else if(section == 2) {
        return 0.f;
    }
    
    return 25.f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 2) {
        return [self.commonArtistModel.pictures count];
    }
    return 1;
    
}

#define kSizeCollectionView  ([UIScreen mainScreen].bounds.size.width-48)/2

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        return 90;
    }else if(indexPath.section == 1) {
        return kSizeCollectionView*1.5;
    }else if(indexPath.section == 2) {
        return [tableView fd_heightForCellWithIdentifier:pictureCellIdentifier cacheByIndexPath:indexPath configuration:^(XTSpecificPictureTableViewCell *cell) {
            [cell configureCell:self.commonArtistModel.pictures[indexPath.row]];
        }];
    }
    return 0.f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 2) {
        NSMutableArray *mArray = [NSMutableArray array];
        for (XTImageInfo *imgInfo in self.commonArtistModel.pictures) {
            [mArray addObject:[NSString stringWithFormat:@"%ld",imgInfo.id]];
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
        XTImgDetailViewController *detailController = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
        NSArray *arr = mArray;
        detailController.pidArr = arr;
        detailController.curIndex = indexPath.row;
        [[UIViewController topViewController] pushViewController:detailController animated:YES];
    }
}

@end