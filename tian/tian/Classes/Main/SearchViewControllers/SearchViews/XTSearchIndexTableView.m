//
//  XTSearchIndexTableView.m
//  tian
//
//  Created by huhuan on 15/6/11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchIndexTableView.h"
#import "XTSearchTopicCollectionView.h"
#import "XTSearchTagCollectionView.h"
#import "XTUserCollectionView.h"
#import "JKUtil.h"
#import <Mantle/EXTScope.h>

@interface XTSearchIndexTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) XTSearchTopicCollectionView *topicCollectionView;
@property (nonatomic, strong) XTSearchTagCollectionView *tagCollectionView;
@property (nonatomic, strong) XTUserCollectionView *hotStarsCollectionView;
@property (nonatomic, strong) XTUserCollectionView *hotUsersCollectionView;

@property (nonatomic, strong) UILabel *artistPageNumLabel;
@property (nonatomic, strong) UILabel *userPageNumLabel;

@end

@implementation XTSearchIndexTableView

+ (XTSearchIndexTableView *)searchIndexTableView {

    XTSearchIndexTableView *searchIndexTV = [[XTSearchIndexTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    searchIndexTV.backgroundColor = [UIColor clearColor];
    searchIndexTV.dataSource = searchIndexTV;
    searchIndexTV.delegate = searchIndexTV;
    searchIndexTV.contentInset = UIEdgeInsetsMake(-30., 0., 0., 0.);
    searchIndexTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return searchIndexTV;
}

- (XTSearchTopicCollectionView *)topicCollectionView {
    if(!_topicCollectionView) {
        _topicCollectionView = [XTSearchTopicCollectionView searchTopicCollectionView];
    }
    
    return _topicCollectionView;
}

- (XTSearchTagCollectionView *)tagCollectionView {
    if(!_tagCollectionView) {
        _tagCollectionView = [XTSearchTagCollectionView searchTagCollectionView];
    }
    
    return _tagCollectionView;
}

- (XTUserCollectionView *)hotStarsCollectionView {
    if(!_hotStarsCollectionView) {
        _hotStarsCollectionView = [XTUserCollectionView userCollectionViewWithPageStyle:XTUserCollectionViewStyleHorizontal CellStyle:XTUserCollectionViewCellStyleFans buttonStyle:XTUserCollectionViewCellButtonStyleLike];
        _hotStarsCollectionView.isArtist = YES;
        @weakify(self);
        _hotStarsCollectionView.pageNum = ^(NSString *pageNum){
            @strongify(self);
            self.artistPageNumLabel.text = pageNum;
        };
    }
    
    return _hotStarsCollectionView;
}

- (XTUserCollectionView *)hotUsersCollectionView {
    if(!_hotUsersCollectionView) {
        _hotUsersCollectionView = [XTUserCollectionView userCollectionViewWithPageStyle:XTUserCollectionViewStyleHorizontal CellStyle:XTUserCollectionViewCellStyleDefault buttonStyle:XTUserCollectionViewCellButtonStyleFollow];
        @weakify(self);
        _hotUsersCollectionView.pageNum = ^(NSString *pageNum){
            @strongify(self);
            self.userPageNumLabel.text = pageNum;
        };
    }
    
    return _hotUsersCollectionView;
}

- (UILabel *)artistPageNumLabel {
    if(!_artistPageNumLabel) {
        _artistPageNumLabel = [[UILabel alloc] init];
        _artistPageNumLabel.backgroundColor = [UIColor clearColor];
        _artistPageNumLabel.font = [UIFont systemFontOfSize:12.f];
        _artistPageNumLabel.textColor = [JKUtil getColor:@"7b7b7b"];
        _artistPageNumLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _artistPageNumLabel;
}

- (UILabel *)userPageNumLabel {
    if(!_userPageNumLabel) {
        _userPageNumLabel = [[UILabel alloc] init];
        _userPageNumLabel.backgroundColor = [UIColor clearColor];
        _userPageNumLabel.font = [UIFont systemFontOfSize:12.f];
        _userPageNumLabel.textColor = [JKUtil getColor:@"7b7b7b"];
        _userPageNumLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _userPageNumLabel;
}

- (void)configureSearchIndexTableView {
    self.artistPageNumLabel.text = [NSString stringWithFormat:@"1/%@",@((self.indexModel.artists.count-1)/3+1)];
    self.userPageNumLabel.text = [NSString stringWithFormat:@"1/%@",@(([self.indexModel.users count]-1)/3+1)];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SearchIndexCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    for(UIView *v in [cell.contentView subviews]) {
        [v removeFromSuperview];
    }

    switch (indexPath.section) {
        case 0:
        {
            self.topicCollectionView.topicArray = self.indexModel.topics;
            [self.topicCollectionView reloadData];
            [cell.contentView addSubview:self.topicCollectionView];
            [self.topicCollectionView updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0., 14., 0., 14.));
            }];
        }
            break;
        case 1:
        {
            self.tagCollectionView.tagArray = self.indexModel.tags;
            [self.tagCollectionView reloadData];
            [cell.contentView addSubview:self.tagCollectionView];
            [self.tagCollectionView updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0., 14., 0., 14.));
            }];
        }
            break;
        case 2:
        {
            self.hotStarsCollectionView.userArray = self.indexModel.artists;
            self.hotStarsCollectionView.isArtist = YES;
            [self.hotStarsCollectionView reloadData];
            [cell.contentView addSubview:self.hotStarsCollectionView];
            [self.hotStarsCollectionView updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
            }];
        }
            break;
        case 3:
        {
            self.hotUsersCollectionView.userArray = self.indexModel.users;
            self.hotUsersCollectionView.isArtist = NO;
            [self.hotUsersCollectionView reloadData];
            [cell.contentView addSubview:self.hotUsersCollectionView];
            [self.hotUsersCollectionView updateConstraints:^(MASConstraintMaker *make) {
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
    
    [sectionTitleLabel updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0., 14., 0., 0.));
    }];
    
    switch (section) {
        case 0:{
            if([self.indexModel.topics count] > 0) {
                sectionTitleLabel.text = @"热搜话题";
            }
        }
            break;
        case 1:{
            if([self.indexModel.tags count] > 0) {
                sectionTitleLabel.text = @"热搜标签";
            }
        }
            break;
        case 2: {
            if([self.indexModel.artists count] > 0) {
                sectionTitleLabel.text = @"热搜明星";
                
                [headerView addSubview:self.artistPageNumLabel];
                
                [self.artistPageNumLabel updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 14.));
                }];
            }
        }
            break;
        case 3: {
            if([self.indexModel.users count] > 0) {
                sectionTitleLabel.text = @"热搜用户";
                [headerView addSubview:self.userPageNumLabel];
                
                [self.userPageNumLabel updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 14.));
                }];
            }
        }
            
            break;
            
        default:
            break;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if(section == 0) {
        if([self.indexModel.topics count] == 0) {
            return 0.f;
        }
    }else if(section == 1) {
        if([self.indexModel.tags count] == 0) {
            return 0.f;
        }
    }else if(section == 2) {
        if([self.indexModel.artists count] == 0) {
            return 0.f;
        }
    }else if(section == 3) {
        if([self.indexModel.users count] == 0) {
            return 0.f;
        }
    }
    return 25.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        if([self.indexModel.topics count] == 0) {
            return 0.f;
        }else {
            if([self.indexModel.topics count] > 6) {
                return 144.f;
            }else {
                return ([self.indexModel.topics count]+1)/2*48;
            }
        }
    }else if(indexPath.section == 1) {
        if([self.indexModel.tags count] == 0) {
            return 0.f;
        }else {
            return 144.f;
        }
    }else if(indexPath.section == 2) {
        if([self.indexModel.artists count] == 0) {
            return 0.f;
        }else {
            return 122/320.f*SCREEN_SIZE.width;
        }
    }else if(indexPath.section == 3) {
        if([self.indexModel.users count] == 0) {
            return 0.f;
        }else {
            return 122/320.f*SCREEN_SIZE.width;
        }
    }
    return 0;
    
}

@end
