//
//  XTLikeAndHateViewController.m
//  tian
//
//  Created by sz42c on 15/6/11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTLikeAndHateViewController.h"
#import "XTTitleSliderBar.h"
#import "XTTabBarController.h"
#import "XTSubStore.h"
#import "XTOrderArtist.h"
#import "XTUserCollectionViewCell.h"
#import "XTAttentionLayout.h"
#import "XTBlacklistStore.h"
#import "XTBlackListInfo.h"
#import "XTUserStore.h"
#define defaultListCount 18

#define kLikeCellName @"likeCell"
#define kHateCellName @"hateCell"

@interface XTLikeAndHateViewController ()

@property(nonatomic, strong) NSString*			uid;
@property(nonatomic, assign) NSInteger			leftTotalCount;
@property(nonatomic, strong) XTSubStore*		subStore;
@property(nonatomic, assign) NSInteger likePageCount;
@property(nonatomic, assign) NSInteger hatePageCount;
@property(nonatomic, assign) BOOL isUpdateData;

@end

@implementation XTLikeAndHateViewController

- (id)initWithUID:(NSString*)uid
{
	self = [super initWithNibName:nil bundle:nil];
	
	if (self) {
		
		self.uid = uid;
        
        self.leftArray = [NSMutableArray arrayWithCapacity:8];
        self.leftTotalCount = 0;
        
        self.rightArray = [NSMutableArray arrayWithCapacity:8];
        
        self.subStore = [[XTSubStore alloc] init];
        
        self.likePageCount = 0;
        self.hatePageCount = 0;
	}
	
	return self;
}
#pragma mark 重写的方法
- (NSArray*)titleArray
{
    return @[@"喜欢", @"嫌弃"];
}

- (void)leftBeginRefreshing
{
    [self.leftCollectionView.header beginRefreshing];
}

- (void)rightBeginRefreshing
{
    [self.rightCollectionView.header beginRefreshing];
}

- (void)backButtonEvnet:(UIButton*)sender
{
    if (self.isUpdateData) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserDetailNotifition" object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UICollectionView*)leftCollectionView
{
    if (_leftCollectionView == nil) {
        
        XTAttentionLayout* xtLayout = [[XTAttentionLayout alloc] init];
        _leftCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, (SCREEN_SIZE.height - 64.0f)) collectionViewLayout:xtLayout];
        [_leftCollectionView registerNib:[UINib nibWithNibName:@"XTUserCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kLikeCellName];
        [_leftCollectionView setDelegate:self];
        [_leftCollectionView setDataSource:self];
        [_leftCollectionView setAlwaysBounceVertical:YES];
        [_leftCollectionView setBackgroundColor:[UIColor whiteColor]];
        
        __block XTLikeAndHateViewController* _self = self;
        
        _leftCollectionView.header = [XTGifHeader headerWithRefreshingBlock:^{
            [_self leftRequest:YES];
        }];
        _leftCollectionView.footer = [XTGifFooter footerWithRefreshingBlock:^{
            [_self leftRequest:NO];
        }];
        
        [_leftCollectionView.footer setHidden:YES];
    }
    
    
    return _leftCollectionView;
    
}

- (UICollectionView*)rightCollectionView
{
    if (_rightCollectionView == nil) {
        
        XTAttentionLayout* xtLayout = [[XTAttentionLayout alloc] init];
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, (SCREEN_SIZE.height - 64.0f)) collectionViewLayout:xtLayout];
        [_rightCollectionView registerNib:[UINib nibWithNibName:@"XTUserCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kHateCellName];
        [_rightCollectionView setDelegate:self];
        [_rightCollectionView setDataSource:self];
        [_rightCollectionView setAlwaysBounceVertical:YES];
        [_rightCollectionView setBackgroundColor:[UIColor whiteColor]];
        
        __block XTLikeAndHateViewController* _self = self;
        _rightCollectionView.header = [XTGifHeader headerWithRefreshingBlock:^{
            [_self rightRequest];
        }];
    }
    
    return _rightCollectionView;
}

- (UICollectionViewCell*)leftCellWith:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath
{
    __block XTLikeAndHateViewController* _self = self;
    
   XTOrderArtist* item = (XTOrderArtist*)[self.leftArray objectAtIndex:indexPath.row];
    
    __weak XTUserCollectionViewCell* cell = (XTUserCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kLikeCellName forIndexPath:indexPath];
    
    cell.buttonNormalTitle = @"喜欢";
    cell.buttonSelectedTitle = @"取消喜欢";
    cell.cellStyle = XTUserCollectionViewCellStyleFans;
    cell.buttonStyle = XTUserCollectionViewCellButtonStyleLike;
    [cell configureUserCell:item];
    
    cell.buttonClick = ^(MTLModel *userModel, BOOL isSelected, NSIndexPath *indexPath) {
        
        XTOrderArtist* _item = (XTOrderArtist*)userModel;
        [_self doLikeByUID:_item.artistId isSelected:isSelected cell:cell];
        [_self resetCellData:_self.leftArray uid:_item.artistId isAddLike:isSelected];
        if ([self.uid isEqualToString:[XTUserStore sharedManager].user.userID]) {
            [_self removeLikeOrHate:_self.leftArray withArtistID:_item.artistId];
        }
    };
    
    return cell;
}

- (UICollectionViewCell*)rightCellWith:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath
{
    __block XTLikeAndHateViewController* _self = self;
    
    XTOrderArtist* item = (XTOrderArtist*)[self.rightArray objectAtIndex:indexPath.row];
    
    __weak XTUserCollectionViewCell* cell = cell = (XTUserCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kHateCellName forIndexPath:indexPath];
    
    cell.buttonNormalTitle = @"嫌弃";
    cell.buttonSelectedTitle = @"取消嫌弃";
    cell.cellStyle = XTUserCollectionViewCellStyleFans;
    cell.buttonStyle = XTUserCollectionViewCellButtonStyleHate;
    
    [cell configureUserCell:item];
    
    cell.buttonClick = ^(MTLModel *userModel, BOOL isSelected, NSIndexPath *indexPath) {
        
        XTOrderArtist* _item = (XTOrderArtist*)userModel;
        [_self doHateByUID:_item.artistId  isSelected:isSelected cell:cell];
        [_self resetCellData:_self.rightArray uid:_item.artistId isAddHate:isSelected];
        if ([self.uid isEqualToString:[XTUserStore sharedManager].user.userID]) {
            [_self removeLikeOrHate:_self.rightArray withArtistID:_item.artistId];
        }
    };
    
    return cell;
}

#pragma mark request
- (void)leftRequest:(BOOL)isRefresh
{
    __block XTLikeAndHateViewController* _self = self;
    
    NSInteger location = isRefresh ?  0 : self.likePageCount*DefaultLoadCount;
    
    [_subStore fetchMySubArtistFromUserId:[self.uid integerValue] location:location length:DefaultLoadCount completionBlock:^(NSArray *userItems, NSInteger totalCount, NSError *error) {
        
        [YYTBlankView hideFromView:_leftCollectionView];
        if (!error) {
            
            if (isRefresh) {
                self.likePageCount = 1;
                [_self.leftArray removeAllObjects];
                [_self.leftCollectionView.footer setHidden:NO];
            }else{
                self.likePageCount += 1;
            }
            
            if ([_self.leftArray count] <= 0 && [userItems count] <= 0) {
                YYTBlankView *blankView = [YYTBlankView showBlankInView:_leftCollectionView style:YYTBlankViewStyleBlank eventClick:nil];
                if ([self.uid isEqualToString:[XTUserStore sharedManager].user.userID]) {
                    blankView.tipString = @"我轻轻的划一划手指 没有留下一个喜欢";
                }else{
                    blankView.tipString = @"谁会是TA的第一个喜欢呢？";
                }
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"%@like",[XTUserStore sharedManager].user.userID]];
            }
            
            if ([_self.leftArray count] > 0) {
                @weakify(_self);
                //数据去重
                [_self.leftArray addObjectsFromArray:userItems withCheckKey:@"artistId" completionBlock:^{
                    @strongify(_self);
                    [_self.leftCollectionView reloadData];
                }];
            }else{
                [_self.leftArray addObjectsFromArray:userItems];
                [_self.leftCollectionView reloadData];
            }
            
            _self.leftTotalCount = totalCount;
            
        } else {
            
            NSLog(@"error = %@", [error description]);
            YYTBlankView *blankView = [YYTBlankView showBlankInView:_leftCollectionView style:YYTBlankViewStyleNetworkError eventClick:^{
                [self leftRequest:YES];
            }];
            blankView.error = error;
        }
        
        //收起下拉或者上拉
        if (isRefresh) {
            [_self.leftCollectionView.header endRefreshing];
        } else {
            [_self.leftCollectionView.footer endRefreshing];
        }
        
        //设置
        if ([userItems count] == 0) {
            [_self.leftCollectionView.footer setHidden:YES];
        }
    }];
}

- (void)rightRequest
{
    __block XTLikeAndHateViewController* _self = self;
    
    [[XTBlacklistStore sharedManager] fetchBlackListWith:[self.uid integerValue] completionBlock:^(NSArray* blacklist, NSError *error) {
        
        [YYTBlankView hideFromView:_rightCollectionView];
        if (!error) {
            
            if ([blacklist count] == 0) {
                YYTBlankView *blankView = [YYTBlankView showBlankInView:_rightCollectionView style:YYTBlankViewStyleBlank eventClick:nil];
                if ([self.uid isEqualToString:[XTUserStore sharedManager].user.userID]) {
                    blankView.tipString = @"发你一张好汪卡";
                }else{
                    blankView.tipString = @"你还不能查看TA嫌弃的明星哦！";
                }
            }
            [self.rightArray removeAllObjects];
            
            [_self.rightArray addObjectsFromArray:blacklist];
            
            [_self.rightCollectionView reloadData];
            
        } else {
            
             //TODO:＋错误提示
            YYTBlankView *blankView = [YYTBlankView showBlankInView:_rightCollectionView style:YYTBlankViewStyleNetworkError eventClick:^{
                [self rightRequest];
            }];
            blankView.error = error;
        }
    
        [_self.rightCollectionView.header endRefreshing];
    }];
}

//取消或者增加喜欢操作
- (void)doLikeByUID:(NSInteger)uid isSelected:(BOOL)isSelected cell:(XTUserCollectionViewCell*)cell
{
    if (isSelected) {
        
        //取消喜欢
        [_subStore deleteSubscribeArtistFromArtistId:uid completionBlock:^(id favoriteVideos, NSError *error) {
            
            if (!error) {
                
                NSInteger rs = [favoriteVideos[@"rs"] integerValue];
                
                if (rs != 200){
                    [cell changeButtonStatus];
                }else{
                    self.isUpdateData = YES;
                }
                
            } else {
                
                [cell changeButtonStatus];
            }
        }];
       
    } else {
       
        //增加喜欢
        [_subStore subscribeArtistFromArtistId:uid completionBlock:^(id data, NSError *error) {
            
            if (!error) {
                
                NSInteger rs = [data[@"rs"] integerValue];
                
                if (rs != 200){
                    [cell changeButtonStatus];
                }else{
                    self.isUpdateData = YES;
                }
                
            } else {
                
                [cell changeButtonStatus];
            }
        }];
    }
}

//取消或者增加嫌弃操作
- (void)doHateByUID:(NSInteger)uid isSelected:(BOOL)isSelected cell:(XTUserCollectionViewCell*)cell
{
    if (isSelected) {
        
        //取消嫌弃
        [[XTBlacklistStore sharedManager] blackListDelWith:uid type:1 completionBlock:^(id result, NSError *error) {
            
            if (!error) {
                
                NSInteger rs = [result[@"rs"] integerValue];
                
                if (rs != 200){
                    [cell changeButtonStatus];
                }else{
                    self.isUpdateData = YES;
                }
                
            } else {
                
                [cell changeButtonStatus];
            }
        }];
       
    } else {
        
        //增加嫌弃
        [[XTBlacklistStore sharedManager] blackListAddWith:uid type:1 completionBlock:^(id result, NSError *error) {
            
            if (!error) {
                
                NSInteger rs = [result[@"rs"] integerValue];
                
                if (rs != 200){
                    [cell changeButtonStatus];
                }else{
                    self.isUpdateData = YES;
                }
                
            } else {
                
                [cell changeButtonStatus];
            }
        }];
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)resetCellData:(NSArray*)array uid:(NSInteger)uid isAddLike:(BOOL)isAddLike
{
    for (XTOrderArtist* info in array) {
        
        if (info.artistId == uid) {
            
            info.subStatus = isAddLike;
            
            break;
        }
    }
}

- (void)resetCellData:(NSArray*)array uid:(NSInteger)uid isAddHate:(BOOL)isAddHate
{
    for (XTOrderArtist* info in array) {
        
        if (info.artistId == uid) {
            
            info.black = isAddHate;
            
            break;
        }
    }
}

- (void)removeLikeOrHate:(NSMutableArray *)array withArtistID:(NSInteger)artistID
{
    for (XTOrderArtist *artistInfo in array) {
        
        if (artistInfo.artistId == artistID) {
            
            [array removeObject:artistInfo];
            if (array == self.rightArray) {
                [self.rightCollectionView reloadData];
                if ([array count] == 0) {
                    YYTBlankView *blankView = [YYTBlankView showBlankInView:_rightCollectionView style:YYTBlankViewStyleBlank eventClick:nil];
                    if ([self.uid isEqualToString:[XTUserStore sharedManager].user.userID]) {
                        blankView.tipString = @"发你一张好汪卡";
                    }else{
                        blankView.tipString = @"你还不能查看TA嫌弃的明星哦！";
                    }
                }
            }else if (array == self.leftArray){
                [self.leftCollectionView reloadData];
                if ([array count] == 0) {
                    YYTBlankView *blankView = [YYTBlankView showBlankInView:_leftCollectionView style:YYTBlankViewStyleBlank eventClick:nil];
                    if ([self.uid isEqualToString:[XTUserStore sharedManager].user.userID]) {
                        blankView.tipString = @"我轻轻的划一划手指 没有留下一个喜欢";
                    }else{
                        blankView.tipString = @"谁会是TA的第一个喜欢呢？";
                    }
                }
            }
            break;
        }
    }
}

@end
