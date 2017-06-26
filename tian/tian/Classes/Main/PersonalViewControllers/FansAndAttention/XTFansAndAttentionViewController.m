//
//  XTFansAndAttentionViewController.m
//  tian
//	粉丝/关注
//  Created by sz42c on 15/6/4.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTFansAndAttentionViewController.h"
#import "XTAttentionLayout.h"
#import "XTSubStore.h"
#import "XTUserStore.h"
#import "XTUserCollectionViewCell.h"

#define defaultListCount 18

#define kFansCellName @"fansCell"
#define kAttentionCellName @"attentionCell"

@interface XTFansAndAttentionViewController ()

@property(nonatomic, strong) NSString*			uid;

@property(nonatomic, assign) NSInteger			leftTotalCount;
@property(nonatomic, assign) NSInteger			rightTotalCount;

@property(nonatomic, strong) XTSubStore*		subStore;
@property(nonatomic, assign) NSInteger fansPageCount;
@property(nonatomic, assign) NSInteger attentionPageCount;

@property(nonatomic, assign) BOOL isUpdateData;
@end

@implementation XTFansAndAttentionViewController

- (id)initWithUID:(NSString*)uid
{
	self = [super initWithNibName:nil bundle:nil];
	
	if (self) {
		
        self.uid = uid;
        self.leftTotalCount = 0;
        self.rightTotalCount = 0;
        self.subStore = [[XTSubStore alloc] init];
        
        self.fansPageCount = 0;
        self.attentionPageCount = 0;
        
        //注册和艺人主页联动的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserList:) name:@"RefreshUserListNotification" object:nil];
	}
	
	return self;
}

#pragma mark 重写的方法
- (NSArray*)titleArray
{
    return @[@"粉丝", @"关注"];;
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
        [_leftCollectionView registerNib:[UINib nibWithNibName:@"XTUserCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kFansCellName];
        [_leftCollectionView setDelegate:self];
        [_leftCollectionView setDataSource:self];
        [_leftCollectionView setAlwaysBounceVertical:YES];
        [_leftCollectionView setBackgroundColor:[UIColor whiteColor]];
        
        __block XTFansAndAttentionViewController* _self = self;
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
        [_rightCollectionView registerNib:[UINib nibWithNibName:@"XTUserCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kAttentionCellName];
        [_rightCollectionView setDelegate:self];
        [_rightCollectionView setDataSource:self];
        [_rightCollectionView setAlwaysBounceVertical:YES];
        [_rightCollectionView setBackgroundColor:[UIColor whiteColor]];
        
        __block XTFansAndAttentionViewController* _self = self;
        
        _rightCollectionView.header = [XTGifHeader headerWithRefreshingBlock:^{
            [_self rightRequest:YES];
        }];
        _rightCollectionView.footer = [XTGifFooter footerWithRefreshingBlock:^{
            [_self rightRequest:NO];
        }];
        
        [_rightCollectionView.footer setHidden:YES];
    }
    
    return _rightCollectionView;
}

- (void)refreshUserList:(NSNotification *)notification {
//    NSString *userId = notification.userInfo[@"userID"];
//    NSString *status = notification.userInfo[@"status"];
}

- (UICollectionViewCell*)leftCellWith:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath
{
    XTUserAccountInfo* info = (XTUserAccountInfo*)[self.leftArray objectAtIndex:indexPath.item];
    
    __weak XTUserCollectionViewCell* cell = (XTUserCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kFansCellName forIndexPath:indexPath];
    
    cell.buttonNormalTitle = @"关注";
    cell.buttonSelectedTitle = @"取消关注";
    cell.cellStyle = XTUserCollectionViewCellStyleTagAndSex;
    [cell configureUserCell:info];
    
    __block XTFansAndAttentionViewController* _self = self;
    
    cell.buttonClick = ^(MTLModel *userModel, BOOL isSelected, NSIndexPath *indexPath) {
        
        XTUserAccountInfo* _info = (XTUserAccountInfo*)userModel;
        
        if (isSelected) {
            
            //取消关注
            [_self.subStore fetchUserDeleteSubFromUserId:[_info.userID integerValue] completionBlock:^(id data, NSError *error) {
                
                if (!error) {
                    self.isUpdateData = YES;
                    [_self resetCellData:_self.leftArray uid:_info.userID isAddAttention:NO];
                    [_self removeAttentionToArrayByUID:_info.userID];
                    
                } else {
                    
                    [cell changeButtonStatus];
                }
            }];
            
        } else {
            
            //加关注
            [_self.subStore fetchUserSubFromUserId:[_info.userID integerValue] completionBlock:^(id data, NSError *error) {
                
                if (!error) {
                    self.isUpdateData = YES;
                    [_self resetCellData:_self.leftArray uid:_info.userID isAddAttention:YES];
                    [_self addAttentionToArrayByUID:_info.userID];
                    
                } else {
                    
                    [cell changeButtonStatus];
                }
            }];
        }
    };
    
    return cell;
}

- (UICollectionViewCell*)rightCellWith:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath
{
    XTUserAccountInfo* info = (XTUserAccountInfo*)[self.rightArray objectAtIndex:indexPath.item];
    
    __weak XTUserCollectionViewCell* cell = (XTUserCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kAttentionCellName forIndexPath:indexPath];
    
    cell.buttonNormalTitle = @"关注";
    cell.buttonSelectedTitle = @"取消关注";
    cell.cellStyle = XTUserCollectionViewCellStyleTagAndSex;
    [cell configureUserCell:info];
    
    __block XTFansAndAttentionViewController* _self = self;
    
    cell.buttonClick = ^(MTLModel *userModel, BOOL isSelected, NSIndexPath *indexPath) {
        
        XTUserAccountInfo* _info = (XTUserAccountInfo*)userModel;

        if (isSelected) {
            
            //取消关注
            [_self.subStore fetchUserDeleteSubFromUserId:[_info.userID integerValue] completionBlock:^(id data, NSError *error) {
                
                if (!error) {
                    self.isUpdateData = YES;
                    [_self resetCellData:_self.leftArray uid:_info.userID isAddAttention:NO];
                    if ([self.uid isEqualToString:[XTUserStore sharedManager].user.userID]) {
                        [_self removeAttentionToArrayByUID:_info.userID];
                        [_self.leftCollectionView reloadData];
                    }
                    
                } else {
                    
                    [cell changeButtonStatus];
                }
            }];
            
        } else {
            
            //加关注
            [_self.subStore fetchUserSubFromUserId:[_info.userID integerValue] completionBlock:^(id data, NSError *error) {
                
                if (!error) {
                    self.isUpdateData = YES;
                    [_self resetCellData:_self.rightArray uid:_info.userID isAddAttention:YES];
                    
                } else {
                    
                    [cell changeButtonStatus];
                }
            }];
        }
    };
    
    return cell;
}

#pragma mark request
- (void)leftRequest:(BOOL)isRefresh
{
	__block XTFansAndAttentionViewController* _self = self;
	
	NSInteger location = isRefresh ?  0 : self.fansPageCount*DefaultLoadCount;
	
	[_subStore fetchFansListFromUserId:[self.uid integerValue] location:location length:DefaultLoadCount completionBlock:^(NSArray *userItems, NSInteger totalCount, NSError *error) {
		[YYTBlankView hideFromView:_leftCollectionView];
        if (!error) {
			
			if (isRefresh) {
                self.fansPageCount = 1;
				[_self.leftArray removeAllObjects];
				[_self.leftCollectionView.footer setHidden:NO];
            }else{
                self.fansPageCount += 1;
            }
			
            if ([_self.leftArray count] <= 0 && [userItems count] <= 0) {
                YYTBlankView *blankView = [YYTBlankView showBlankInView:_leftCollectionView style:YYTBlankViewStyleBlank eventClick:nil];
                if ([self.uid isEqualToString:[XTUserStore sharedManager].user.userID]) {
                    blankView.tipString = @"呵呵我是一只公举汪";
                }else{
                    blankView.tipString = @"你会是TA的第一个关注么？";
                }
            }
            
            if ([_self.leftArray count] > 0) {
                @weakify(_self);
                //数据去重
                [_self.leftArray addObjectsFromArray:userItems withCheckKey:@"userID" completionBlock:^{
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
		if ([_self.leftArray count] >= _self.leftTotalCount) {
			[_self.leftCollectionView.footer setHidden:YES];
		}
	}];
}

- (void)rightRequest:(BOOL)isRefresh
{
	__block XTFansAndAttentionViewController* _self = self;
	
	NSInteger location = isRefresh ?  0 : self.attentionPageCount*DefaultLoadCount;
	
	[_subStore fetchFriendshipsFromUserId:[self.uid integerValue] location:location length:DefaultLoadCount completionBlock:^(NSArray *userItems, NSInteger totalCount, NSError *error) {
		[YYTBlankView hideFromView:_rightCollectionView];
        if (!error) {
			
			if (isRefresh) {
                self.attentionPageCount = 1;
				[_self.rightArray removeAllObjects];
				[_self.rightCollectionView.footer setHidden:NO];
            }else{
                self.attentionPageCount += 1;
            }
			
            if ([_self.rightArray count] <= 0 && [userItems count] <= 0) {
                YYTBlankView *blankView = [YYTBlankView showBlankInView:_rightCollectionView style:YYTBlankViewStyleBlank eventClick:nil];
                if ([self.uid isEqualToString:[XTUserStore sharedManager].user.userID]) {
                    blankView.tipString = @"要想火，少睡觉多传图";
                }else{
                    blankView.tipString = @"来成为TA的第一个粉丝吧";
                }
            }
            
            if ([_self.rightArray count] > 0) {
                @weakify(_self);
                //数据去重
                [_self.rightArray addObjectsFromArray:userItems withCheckKey:@"userID" completionBlock:^{
                    @strongify(_self);
                    [_self.rightCollectionView reloadData];
                }];
            }else{
                [_self.rightArray addObjectsFromArray:userItems];
                [_self.rightCollectionView reloadData];
            }
			
			_self.rightTotalCount = totalCount;
			
		} else {
			
			NSLog(@"error = %@", [error description]);
            YYTBlankView *blankView = [YYTBlankView showBlankInView:_rightCollectionView style:YYTBlankViewStyleNetworkError eventClick:^{
                [self rightRequest:YES];
            }];
            blankView.error = error;
		}
		
		//收起下拉或者上拉
		if (isRefresh) {
			[_self.rightCollectionView.header endRefreshing];
		} else {
			[_self.rightCollectionView.footer endRefreshing];
		}
		
		//设置
		if ([_self.rightArray count] >= _self.rightTotalCount) {
			[_self.rightCollectionView.footer setHidden:YES];
		}
	}];
}

- (void)resetCellData:(NSArray*)array uid:(NSString*)uid isAddAttention:(BOOL)isAddAttention
{
	for (XTUserAccountInfo* info in array) {
		
		if ([info.userID isEqualToString:uid]) {
			
			info.hasFollowed = isAddAttention;
			
			break;
		}
	}
}

- (void)addAttentionToArrayByUID:(NSString*)uid
{
	for (XTUserAccountInfo* info in self.leftArray) {
		
		if ([info.userID isEqualToString:uid]) {
			
			BOOL isHave = NO;
			
			for (XTUserAccountInfo* infoToo in self.rightArray) {
				
				if ([infoToo.userID isEqualToString:uid]) {
					
					isHave = YES;
					
					break;
				}
			}
			
			if (!isHave) {
				
				[self.rightArray addObject:info];
				
				[self.rightCollectionView reloadData];
			}
			
			break;
		}
	}
}

- (void)removeAttentionToArrayByUID:(NSString*)uid
{
	for (XTUserAccountInfo* tryInfo in self.rightArray) {
		
		if ([tryInfo.userID isEqualToString:uid]) {
            [self.rightArray removeObject:tryInfo];
            [self.rightCollectionView reloadData];
            if ([self.rightArray count] == 0) {
                YYTBlankView *blankView = [YYTBlankView showBlankInView:_rightCollectionView style:YYTBlankViewStyleBlank eventClick:nil];
                if ([self.uid isEqualToString:[XTUserStore sharedManager].user.userID]) {
                    blankView.tipString = @"要想火，少睡觉多传图";
                }else{
                    blankView.tipString = @"来成为TA的第一个粉丝吧";
                }
            }
			break;
		}
	}
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
