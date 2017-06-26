//
//  XTSearchUsersTableView.m
//  tian
//
//  Created by huhuan on 15/6/13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchAllTableView.h"
#import "XTUserCollectionView.h"
#import "XTSearchTopicCollectionView.h"
#import "XTSearchAlbumCollectionView.h"
#import "JKUtil.h"
#import "XTSearchAllModel.h"
#import <Mantle/EXTScope.h>
#import "XTHTTPRequestOperationManager.h"
#import "XTUserHomePageViewController.h"
#import "UIViewController+Extend.h"
#import "XTUserStore.h"

@interface XTSearchAllTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView      *searchTableHeaderView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel     *headerNameLabel;
@property (nonatomic, strong) UIButton    *headerFavorateButton;

@property (nonatomic, strong) UILabel     *userPageNumLabel;
@property (nonatomic, strong) UILabel     *albumPageNumLabel;

@property (nonatomic, strong) XTUserCollectionView        *userCollectionView;
@property (nonatomic, strong) XTSearchTopicCollectionView *topicCollectionView;
@property (nonatomic, strong) XTSearchAlbumCollectionView *albumCollectionView;

@end

@implementation XTSearchAllTableView

+ (XTSearchAllTableView *)searchAllTableView; {

    XTSearchAllTableView *searchAllTV = [[XTSearchAllTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    searchAllTV.backgroundColor       = [UIColor clearColor];
    searchAllTV.dataSource            = searchAllTV;
    searchAllTV.delegate              = searchAllTV;
    searchAllTV.separatorStyle        = UITableViewCellSeparatorStyleNone;
    searchAllTV.tableHeaderView       = searchAllTV.searchTableHeaderView;
    searchAllTV.scrollEnabled         = NO;
  
    return searchAllTV;
    
}

- (UIView *)searchTableHeaderView {
    if(!_searchTableHeaderView) {
        _searchTableHeaderView                 = [[UIView alloc] init];
        _searchTableHeaderView.backgroundColor = [UIColor whiteColor];

        self.headerImageView                   = [[UIImageView alloc] init];
        [_searchTableHeaderView addSubview:self.headerImageView];

        self.headerNameLabel                   = [[UILabel alloc] init];
        self.headerNameLabel.backgroundColor   = [UIColor clearColor];
        self.headerNameLabel.font              = [UIFont systemFontOfSize:12.f];
        self.headerNameLabel.textColor         = [JKUtil getColor:@"7b7b7b"];
        [_searchTableHeaderView addSubview:self.headerNameLabel];

        self.headerFavorateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.headerFavorateButton.titleLabel setFont:[UIFont systemFontOfSize:11.f]];
        [self.headerFavorateButton setBackgroundColor:UIColorFromRGB(0xfbe510)];
        [self.headerFavorateButton setTitleColor:UIColorFromRGB(0x4f242b)
                                        forState:UIControlStateNormal];
        [self.headerFavorateButton addTarget:self action:@selector(favorateClick:) forControlEvents:UIControlEventTouchUpInside];
        [_searchTableHeaderView addSubview:self.headerFavorateButton];
        
        _searchTableHeaderView.frame = CGRectMake(0., 0., self.frame.size.width, 85.f);
        
        [self.headerImageView updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(@13);
            make.left.offset(@13);
            make.width.equalTo(@65);
            make.height.equalTo(@65);
        }];
        
        [self.headerNameLabel updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_searchTableHeaderView);
            make.left.equalTo(self.headerImageView.mas_right).offset(@10);
            make.height.equalTo(@17);
        }];

        [self.headerFavorateButton updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_searchTableHeaderView);
            make.right.offset(@-10);
            make.width.equalTo(@93);
            make.height.equalTo(@29);
        }];
        
        [self.headerImageView layoutIfNeeded];
        self.headerImageView.layer.masksToBounds = YES;
        self.headerImageView.layer.cornerRadius  = self.headerImageView.frame.size.width/2.f;
        
    }
    
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius  = self.headerImageView.frame.size.width/2;
    
    self.headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.headerImageView addGestureRecognizer:singleTap];
    
    return _searchTableHeaderView;
}

- (XTUserCollectionView *)userCollectionView {
    if(!_userCollectionView) {
        _userCollectionView = [XTUserCollectionView userCollectionViewWithPageStyle:XTUserCollectionViewStyleHorizontal CellStyle:XTUserCollectionViewCellStyleTagAndSex buttonStyle:XTUserCollectionViewCellButtonStyleFollow];
        @weakify(self);
        _userCollectionView.pageNum = ^(NSString *pageNum){
            @strongify(self);
            self.userPageNumLabel.text = pageNum;
        };
    }
    
    return _userCollectionView;
}

- (XTSearchTopicCollectionView *)topicCollectionView {
    if(!_topicCollectionView) {
        _topicCollectionView = [XTSearchTopicCollectionView searchTopicCollectionView];
    }
    
    return _topicCollectionView;
}

- (XTSearchAlbumCollectionView *)albumCollectionView {
    if(!_albumCollectionView) {
        _albumCollectionView = [XTSearchAlbumCollectionView albumCollectionViewWithCollectionViewStyle:XTSearchAlbumCollectionViewStyleHorizontal];
        _albumCollectionView.contentInset = UIEdgeInsetsMake(0., 0., 0., 0.);
        @weakify(self);
        _albumCollectionView.pageNum = ^(NSString *pageNum){
            @strongify(self);
            self.albumPageNumLabel.text = pageNum;
        };
    }
    
    return _albumCollectionView;
}

- (UILabel *)userPageNumLabel {
    if(!_userPageNumLabel) {
        _userPageNumLabel                 = [[UILabel alloc] init];
        _userPageNumLabel.backgroundColor = [UIColor clearColor];
        _userPageNumLabel.font            = [UIFont systemFontOfSize:12.f];
        _userPageNumLabel.textColor       = [JKUtil getColor:@"7b7b7b"];
        _userPageNumLabel.textAlignment   = NSTextAlignmentRight;
    }
    
    return _userPageNumLabel;
}

- (UILabel *)albumPageNumLabel {
    if(!_albumPageNumLabel) {
        _albumPageNumLabel                 = [[UILabel alloc] init];
        _albumPageNumLabel.backgroundColor = [UIColor clearColor];
        _albumPageNumLabel.font            = [UIFont systemFontOfSize:12.f];
        _albumPageNumLabel.textColor       = [JKUtil getColor:@"7b7b7b"];
        _albumPageNumLabel.textAlignment   = NSTextAlignmentRight;
    }
    
    return _albumPageNumLabel;
}

/**
 *  点击header明星头像跳转详情
 */
- (void)handleSingleTap:(id)sender {
    if(self.searchAllModel.artist.userId == [[XTUserStore sharedManager].user.userID longLongValue]) {
        return;
    }

    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%@",@(self.searchAllModel.artist.userId)];
    controller.type = XTUserHomePageTypeArtist;
    controller.userType = XTAccountCommon;
    [[UIViewController topViewController] pushViewController:controller animated:YES];
}

- (void)configureSearchAllTableView {
    if([self.userCollectionView.visibleCells count] > 0) {
        [self.userCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    
    if([self.albumCollectionView.visibleCells count] > 0) {
        [self.albumCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }

    if(self.searchAllModel.artist) {
        self.tableHeaderView = self.searchTableHeaderView;
        [self.headerImageView an_setImageWithURL:[NSURL URLWithString:self.searchAllModel.artist.headImg]];
        self.headerNameLabel.text = self.searchAllModel.artist.name;
    }else {
        self.tableHeaderView = nil;
    }
    [self adjustFavorateButtonStatus];
    if([self.searchAllModel.users count] > 0) {
        self.userPageNumLabel.text = [NSString stringWithFormat:@"1/%@",@((self.searchAllModel.users.count-1)/3+1)];
    }else {
        self.userPageNumLabel.text = @"";
    }
    
    if([self.searchAllModel.albums count] > 0) {
        self.albumPageNumLabel.text = [NSString stringWithFormat:@"1/%@",@(([self.searchAllModel.albums count]-1)/2+1)];
    }else {
        self.albumPageNumLabel.text = @"";
    }
}

- (void)requestFavorateApiWithUserId:(NSString *)userId andApiAddress:(NSString *)apiAddress {
    
    NSDictionary *parameters = @{
                                 @"artistId": userId,
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager POST:apiAddress parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject[@"rs"] integerValue] != 200) {
            [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"请求失败" withCompletionBlock:^{
                if([self.searchAllModel.artist.like isEqualToString:@"1"]) {
                    self.searchAllModel.artist.like = @"0";
                    [self adjustFavorateButtonStatus];
                    
                }else {
                    self.searchAllModel.artist.like = @"1";
                    [self adjustFavorateButtonStatus];
                }
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:^{
            if([self.searchAllModel.artist.like isEqualToString:@"1"]) {
                self.searchAllModel.artist.like = @"0";
                [self adjustFavorateButtonStatus];

            }else {
                self.searchAllModel.artist.like = @"1";
                [self adjustFavorateButtonStatus];
            }
        }];
    }];
}

- (void)adjustFavorateButtonStatus {
    if([self.searchAllModel.artist.like isEqualToString:@"1"]) {
        [self.headerFavorateButton setBackgroundColor:UIColorFromRGB(0xc2c3c4)];
        [self.headerFavorateButton setTitleColor:[UIColor whiteColor]
                                        forState:UIControlStateNormal];
        [self.headerFavorateButton setTitle:@"取消喜欢"
                                   forState:UIControlStateNormal];
    }else {
        [self.headerFavorateButton setBackgroundColor:UIColorFromRGB(0xfbe510)];
        [self.headerFavorateButton setTitleColor:UIColorFromRGB(0x4f242b)
                                        forState:UIControlStateNormal];
        [self.headerFavorateButton setTitle:@"喜欢"
                                   forState:UIControlStateNormal];
    }
}

- (void)favorateClick:(UIButton *)favorateButton {
    
    if([self.searchAllModel.artist.like isEqualToString:@"1"]) {
        self.searchAllModel.artist.like = @"0";
        [self adjustFavorateButtonStatus];
        [self requestFavorateApiWithUserId:[NSString stringWithFormat:@"%@",@(self.searchAllModel.artist.userId)]
                           andApiAddress:@"picture/sub/delete.json"];
    }else {
        self.searchAllModel.artist.like = @"1";
        [self adjustFavorateButtonStatus];
        [self requestFavorateApiWithUserId:[NSString stringWithFormat:@"%@",@(self.searchAllModel.artist.userId)]
                           andApiAddress:@"picture/sub/create.json"];
    }

}

- (float)tableViewHeight {
    float tableViewHeaderHeight = 0.f;
    float userCellHeight        = 0.f;
    float topicCellHeight       = 0.f;
    float albumCellHeight       = 0.f;
    float sectionHeight         = 0.f;
    if(self.searchAllModel.artist) {
        tableViewHeaderHeight += 85;
    }
    if([self.searchAllModel.users count] > 0) {
        userCellHeight = 122/320.f*SCREEN_SIZE.width;
        sectionHeight += 25;
    }
    if([self.searchAllModel.topics count] > 0) {
        if([self.searchAllModel.topics count] > 6) {
            topicCellHeight = 144;
        }else {
            topicCellHeight = ([self.searchAllModel.topics count]+1)/2*48;
        }
        sectionHeight += 25;
    }
    if([self.searchAllModel.albums count] > 0) {
        albumCellHeight = 204/320.f*SCREEN_SIZE.width;
        sectionHeight += 25;
    }
    if([self.searchAllModel.pics count] > 0) {
        sectionHeight += 30;
    }
    return userCellHeight + topicCellHeight + albumCellHeight + tableViewHeaderHeight + sectionHeight;
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
            self.userCollectionView.userArray = self.searchAllModel.users;
            [self.userCollectionView reloadData];
            [cell.contentView addSubview:self.userCollectionView];
            [self.userCollectionView remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
            }];
        }
            break;
        case 1:
        {
            self.topicCollectionView.topicArray = self.searchAllModel.topics;
            [self.topicCollectionView reloadData];
            [cell.contentView addSubview:self.topicCollectionView];
            [self.topicCollectionView remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0., 14., 0., 14.));
            }];
        }
            break;
        case 2:
        {
            self.albumCollectionView.albumArray = self.searchAllModel.albums;
            [self.albumCollectionView reloadData];
            [cell.contentView addSubview:self.albumCollectionView];
            [self.albumCollectionView remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
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
    
    [sectionTitleLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0., 14., 0., 0.));
    }];
    
    switch (section) {
        case 0: {
            sectionTitleLabel.text = @"相关用户";
            [headerView addSubview:self.userPageNumLabel];
            
            [self.userPageNumLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 14.));
            }];
        }
            break;
        case 1:
            sectionTitleLabel.text = @"相关话题";
            break;
        case 2: {
            sectionTitleLabel.text = @"相关图册";
            [headerView addSubview:self.albumPageNumLabel];
            
            [self.albumPageNumLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 14.));
            }];
        }
            break;
        case 3:
            sectionTitleLabel.text = @"相关图片";
            break;
        default:
            break;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        if([self.searchAllModel.users count] == 0) {
            return 0.f;
        }
    }else if(section == 1) {
        if([self.searchAllModel.topics count] == 0) {
            return 0.f;
        }
    }else if(section == 2) {
        if([self.searchAllModel.albums count] == 0) {
            return 0.f;
        }
    }else if(section == 3) {
        if([self.searchAllModel.pics count] == 0) {
            return 0.f;
        }
    }
    return 25;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        if([self.searchAllModel.users count] == 0) {
            return 0.f;
        }else {
            return 122/320.f*SCREEN_SIZE.width;
        }
    }else if(indexPath.section == 1) {
        if([self.searchAllModel.topics count] > 6) {
            return 144.f;
        }else {
            return ([self.searchAllModel.topics count]+1)/2*48;
        }
    }else if(indexPath.section == 2) {
        if([self.searchAllModel.albums count] == 0) {
            return 0.f;
        }else {
            return 214/320.f*SCREEN_SIZE.width;
        }
    }else if(indexPath.section == 3) {
        return 0.f;
    }
    return 0;
    
}

@end
