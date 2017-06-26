//
//  XTSearchArtistTableView.m
//  tian
//
//  Created by huhuan on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchArtistTableView.h"
#import "XTSearchTopicCollectionView.h"
#import "XTUserCollectionView.h"
#import "JKUtil.h"
#import "XTSearchAllModel.h"
#import "XTSearchArtistModel.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTUserHomePageViewController.h"
#import "UIViewController+Extend.h"
#import "XTUserStore.h"

@interface XTSearchArtistTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *searchTableHeaderView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *headerNameLabel;
@property (nonatomic, strong) UIButton *headerFavorateButton;

@property (nonatomic, strong) UIView *singleUserView;
@property (nonatomic, strong) XTUserCollectionView *userCollectionView;
@property (nonatomic, strong) XTSearchTopicCollectionView *topicCollectionView;

@end

@implementation XTSearchArtistTableView

+ (XTSearchArtistTableView *)searchArtistTableView {
    
    XTSearchArtistTableView *searchArtistTV = [[XTSearchArtistTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    searchArtistTV.backgroundColor = [UIColor clearColor];
    searchArtistTV.dataSource = searchArtistTV;
    searchArtistTV.delegate = searchArtistTV;
    searchArtistTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchArtistTV.tableHeaderView = searchArtistTV.searchTableHeaderView;
    searchArtistTV.scrollEnabled = NO;
    return searchArtistTV;
}

- (UIView *)searchTableHeaderView {
    if(!_searchTableHeaderView) {
        _searchTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0., 0., self.frame.size.width, 85.f)];
        _searchTableHeaderView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:12.f];
        titleLabel.textColor = [JKUtil getColor:@"7b7b7b"];
        titleLabel.text = @"相关艺人";

        [_searchTableHeaderView addSubview:titleLabel];
        
        [titleLabel updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(@2);
            make.left.offset(@13);
            make.width.equalTo(@100);
            make.height.equalTo(@17);
        }];
    }
    
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2;
    
    return _searchTableHeaderView;
}

- (XTUserCollectionView *)userCollectionView {
    if(!_userCollectionView) {
        _userCollectionView = [XTUserCollectionView userCollectionViewWithPageStyle:XTUserCollectionViewStyleVertical CellStyle:XTUserCollectionViewCellStyleFans buttonStyle:XTUserCollectionViewCellButtonStyleFollow];
        _userCollectionView.isArtist = YES;
    }
    
    return _userCollectionView;
}

- (XTSearchTopicCollectionView *)topicCollectionView {
    if(!_topicCollectionView) {
        _topicCollectionView = [XTSearchTopicCollectionView searchTopicCollectionView];
    }
    
    return _topicCollectionView;
}

- (float)tableViewHeight {
    
    float topicCellHeight = 0.f;
    float sectionHeight = 0.f;
    
    if([self.artistModel.topics count] > 0) {
        if([self.artistModel.topics count] > 6) {
            topicCellHeight = 144;
        }else {
            topicCellHeight = ([self.artistModel.topics count]+1)/2*48;
        }
        sectionHeight += 25;
    }
    if([self.artistModel.pics count] > 0) {
        sectionHeight += 25;
    }
    
    if([self.artistModel.artists count] > 1) {
        return SCREEN_SIZE.height-64-60-10;
    }else if([self.artistModel.artists count] == 1){
        return topicCellHeight + 90.f + sectionHeight;
    }else {
        return topicCellHeight + sectionHeight;
    }
}

- (void)configureHeaderView {
    [self.singleUserView removeFromSuperview];
    [self.userCollectionView removeFromSuperview];
    
    if([self.artistModel.artists count] == 1) {
        self.singleUserView = [[UIView alloc] init];
        self.singleUserView.backgroundColor = [UIColor whiteColor];
        [_searchTableHeaderView addSubview:self.singleUserView];
        
        self.headerImageView = [[UIImageView alloc] init];
        [self.singleUserView addSubview:self.headerImageView];
        
        self.headerNameLabel = [[UILabel alloc] init];
        self.headerNameLabel.backgroundColor = [UIColor clearColor];
        self.headerNameLabel.font = [UIFont systemFontOfSize:12.f];
        self.headerNameLabel.textColor = [JKUtil getColor:@"7b7b7b"];
        [self.singleUserView addSubview:self.headerNameLabel];
        
        self.headerFavorateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.headerFavorateButton.titleLabel setFont:[UIFont systemFontOfSize:11.f]];
        [self.headerFavorateButton setBackgroundColor:UIColorFromRGB(0xfbe510)];
        [self.headerFavorateButton setTitleColor:UIColorFromRGB(0x4f242b)
                                        forState:UIControlStateNormal];
        [self.headerFavorateButton setTitle:@"喜欢"
                                   forState:UIControlStateNormal];
        [self.headerFavorateButton addTarget:self action:@selector(favorateClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.singleUserView addSubview:self.headerFavorateButton];

        _searchTableHeaderView.frame = CGRectMake(0., 0., self.frame.size.width, 95.f);
        [self adjustFavorateButtonStatus];
        
        self.headerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        [self.headerImageView addGestureRecognizer:singleTap];
        
        [self.singleUserView updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(@5);
            make.right.offset(@-5);
            make.bottom.offset(@-5);
            make.height.equalTo(@70);
        }];
        
        [self.headerImageView updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(@5);
            make.left.offset(@13);
            make.width.equalTo(@65);
            make.height.equalTo(@65);
        }];
        
        [self.headerNameLabel updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.singleUserView);
            make.left.equalTo(self.headerImageView.mas_right).offset(@10);
            make.height.equalTo(@17);
        }];
        
        [self.headerFavorateButton updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.singleUserView);
            make.right.offset(@-10);
            make.width.equalTo(@93);
            make.height.equalTo(@29);
        }];
        [self.headerImageView layoutIfNeeded];
        self.headerImageView.layer.masksToBounds = YES;
        self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2.f;
    }else if([self.artistModel.artists count] > 1) {
        [_searchTableHeaderView addSubview:self.userCollectionView];
        
        _searchTableHeaderView.frame = CGRectMake(0., 0., self.frame.size.width, self.frame.size.height);

        [self.userCollectionView updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(@5);
            make.right.offset(@-5);
            make.bottom.offset(@0);
            make.top.offset(@25);
        }];
    }
    
    self.tableHeaderView = self.searchTableHeaderView;
    
}

- (void)handleSingleTap:(id)sender {
    
    XTUserHomePageType type = XTUserHomePageTypeArtist;
    XTSearchUserModel *artistModel = (XTSearchUserModel *)[self.artistModel.artists firstObject];
    if(artistModel.userId == [[XTUserStore sharedManager].user.userID longLongValue]) {
        return;
    }
    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%@",@(artistModel.userId)];
    controller.type = type;
    controller.userType = XTAccountCommon;
    [[UIViewController topViewController] pushViewController:controller animated:YES];
}

- (void)requestFavorateApiWithUserId:(NSString *)userId andApiAddress:(NSString *)apiAddress {
    
    NSDictionary *parameters = @{
                                 @"artistId": userId,
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager POST:apiAddress parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject[@"rs"] integerValue] != 200) {
            [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"请求失败" withCompletionBlock:^{
                XTSearchUserModel *artistModel = (XTSearchUserModel *)[self.artistModel.artists firstObject];
                if([artistModel.like isEqualToString:@"1"]) {
                    artistModel.like = @"0";
                    [self adjustFavorateButtonStatus];
                    
                }else {
                    artistModel.like = @"1";
                    [self adjustFavorateButtonStatus];
                }
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:^{
            XTSearchUserModel *artistModel = (XTSearchUserModel *)[self.artistModel.artists firstObject];
            if([artistModel.like isEqualToString:@"1"]) {
                artistModel.like = @"0";
                [self adjustFavorateButtonStatus];
                
            }else {
                artistModel.like = @"1";
                [self adjustFavorateButtonStatus];
            }
        }];
    }];
}

- (void)adjustFavorateButtonStatus {
    
    XTSearchUserModel *artistModel = (XTSearchUserModel *)[self.artistModel.artists firstObject];
    if([artistModel.like isEqualToString:@"1"]) {
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
    
    XTSearchUserModel *artistModel = (XTSearchUserModel *)[self.artistModel.artists firstObject];
    if([artistModel.like isEqualToString:@"1"]) {
        artistModel.like = @"0";
        [self adjustFavorateButtonStatus];
        [self requestFavorateApiWithUserId:[NSString stringWithFormat:@"%@",@(artistModel.userId)]
                             andApiAddress:@"picture/sub/delete.json"];
    }else {
        artistModel.like = @"1";
        [self adjustFavorateButtonStatus];
        [self requestFavorateApiWithUserId:[NSString stringWithFormat:@"%@",@(artistModel.userId)]
                             andApiAddress:@"picture/sub/create.json"];
    }
    
}

- (void)configureSearchArtistTableView {
    
    [self configureHeaderView];
    if([self.artistModel.artists count] == 1) {
        XTSearchUserModel *artistModel = [self.artistModel.artists firstObject];
        [self.headerImageView an_setImageWithURL:[NSURL URLWithString:artistModel.headImg]];
        self.headerNameLabel.text = artistModel.name;
        
    }else if([self.artistModel.artists count] > 1) {
        self.userCollectionView.userArray = self.artistModel.artists;
        [self.userCollectionView reloadData];
    }
    
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
            self.topicCollectionView.topicArray = self.artistModel.topics;
            [self.topicCollectionView reloadData];
            [cell.contentView addSubview:self.topicCollectionView];
            [self.topicCollectionView updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0., 14., 0., 14.));
            }];
        }
            break;
            
        case 1:
        {
            
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
        case 0:
            sectionTitleLabel.text = @"相关话题";
            break;
        case 1:
            sectionTitleLabel.text = @"24小时最热";
            break;
            
        default:
            break;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        if([self.artistModel.topics count] == 0) {
            return 0.f;
        }
    }else if(section == 1) {
        if([self.artistModel.pics count] == 0) {
            return 0.f;
        }
    }
    return 25.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        if([self.artistModel.topics count] == 0) {
            return 0.f;
        }else {
            if([self.artistModel.topics count] > 6) {
                return 144.f;
            }else {
                return ([self.artistModel.topics count]+1)/2*48;
            }
        }
    }else if(indexPath.section == 1) {
        return 0.f;
    }

    return 0;
    
}

@end
