//
//  XTUserFavorateCollectionView.m
//  tian
//
//  Created by huhuan on 15/6/11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUserCollectionView.h"
#import "XTUserCollectionViewLayout.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTSearchUserModel.h"
#import "XTOrderArtist.h"
#import <Mantle/EXTScope.h>
#import "XTMessageStore.h"
#import "XTBlacklistStore.h"
#import "NSError+XTError.h"
#import "XTBlackListInfo.h"
#import "XTUserAccountInfo.h"
#import "XTUserStore.h"
@interface XTUserCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) MTLModel *transferUserModel;
@property (nonatomic, strong) NSIndexPath *transferIndexPath;
@property (nonatomic, assign) XTUserCollectionViewCellStyle userCellStyle;
@property (nonatomic, assign) XTUserCollectionViewCellButtonStyle userButtonStyle;

@end

@implementation XTUserCollectionView

static NSString *userCellIdentifier = @"userCell";

+ (XTUserCollectionView *)userCollectionViewWithPageStyle:(XTUserCollectionViewStyle)pageStyle CellStyle:(XTUserCollectionViewCellStyle)cellStyle buttonStyle:(XTUserCollectionViewCellButtonStyle)buttonStyle{
    
    UICollectionViewFlowLayout *layout = nil;
    
    if(pageStyle == XTUserCollectionViewStyleHorizontal) {
        XTUserCollectionViewLayout *horizontalLayout = [[XTUserCollectionViewLayout alloc] initWithContentSize:CGSizeMake(89.f/320.f*SCREEN_SIZE.width, 120/320.f*SCREEN_SIZE.width)];
        horizontalLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        horizontalLayout.minimumLineSpacing = 12.f/320.f*SCREEN_SIZE.width;
        horizontalLayout.minimumInteritemSpacing = 0.0;
        layout = horizontalLayout;
    }else {
        UICollectionViewFlowLayout *verticalLayout = [[UICollectionViewFlowLayout alloc] init];
        verticalLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        verticalLayout.minimumLineSpacing = 12.f/320.f*SCREEN_SIZE.width;
        verticalLayout.minimumInteritemSpacing = 12.f/320.f*SCREEN_SIZE.width;
        verticalLayout.itemSize = CGSizeMake(89.f/320.f*SCREEN_SIZE.width, 120/320.f*SCREEN_SIZE.width);
        layout = verticalLayout;
    }

    XTUserCollectionView *favorateCV = [[XTUserCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    favorateCV.backgroundColor = [UIColor clearColor];
    favorateCV.dataSource = favorateCV;
    favorateCV.delegate = favorateCV;
    favorateCV.showsHorizontalScrollIndicator = NO;
    favorateCV.showsVerticalScrollIndicator = NO;
    favorateCV.userCellStyle = cellStyle;
    favorateCV.userButtonStyle = buttonStyle;

    [favorateCV registerNib:[UINib nibWithNibName:@"XTUserCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:userCellIdentifier];
    
    if(pageStyle == XTUserCollectionViewStyleHorizontal) {
        favorateCV.pagingEnabled = YES;
    }
    // 注册通知
    [favorateCV addNotifications];
    return favorateCV;
}

- (void)requestFollowApiWithUserId:(NSString *)userId
                  andRequestIdName:(NSString *)name
                     andApiAddress:(NSString *)apiAddress
                   completionBlock:(void(^)(id result,NSError *error))block {
    
    NSDictionary *parameters = @{
                                 name: userId,
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager POST:apiAddress parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            block(responseObject,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.userArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XTUserCollectionViewCell *cell = (XTUserCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:userCellIdentifier forIndexPath:indexPath];
    
    NSString *normalTitle   = nil;
    NSString *selectedTitle = nil;
    if(self.userButtonStyle == XTUserCollectionViewCellButtonStyleLike) {
        normalTitle   = @"喜欢";
        selectedTitle = @"取消喜欢";
    }else if(self.userButtonStyle == XTUserCollectionViewCellButtonStyleHate) {
        normalTitle   = @"嫌弃";
        selectedTitle = @"取消嫌弃";
    }else if(self.userButtonStyle == XTUserCollectionViewCellButtonStyleFollow) {
        normalTitle   = @"关注";
        selectedTitle = @"取消关注";
    }else if(self.userButtonStyle == XTUserCollectionViewCellButtonStyleRemove) {
        normalTitle   = @"移除";
        selectedTitle = @"移除";
    }
    cell.userCollectionView  = self;
    cell.buttonNormalTitle   = normalTitle;
    cell.buttonSelectedTitle = selectedTitle;
    cell.cellIndexPath       = indexPath;
    cell.cellStyle           = self.userCellStyle;
    cell.buttonStyle         = self.userButtonStyle;
    cell.isArtist            = self.isArtist;
    [cell configureUserCell:self.userArray[indexPath.row]];
    @weakify(self);
    cell.buttonClick = ^(MTLModel *userModel, BOOL isSelected, NSIndexPath *indexPath) {
        @strongify(self);
        //艺人点击通知
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kCellButtonClickNotification object:nil userInfo:@{
                                                                                 @"model" : userModel,
                                                                                 @"selected" : @(isSelected)
                                                                                 }
         ];
        [self cellClickWithModel:userModel andIsSelected:isSelected andIndexPath:indexPath];
    };
    
    cell.transferModelSave = ^(MTLModel *userModel, NSIndexPath *indexPath) {
        self.transferUserModel = userModel;
        self.transferIndexPath = indexPath;
    };
    
    cell.infoDelegate = (id)self.infoDelegate;
    return cell;
    
}
///注册通知
-(void)addNotifications{
    //注册取消喜欢艺人的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLike:) name:kCancelLikeNotification object:nil];
    //注册和艺人主页联动的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserList:) name:@"RefreshUserListNotification" object:nil];
}

-(void)cancelLike:(NSNotification *)note{
    
    long searchUserId = 0;
    self.isRequesting = YES;

    //获取模型
    MTLModel *userModel = note.userInfo[@"model"];
    if([userModel isKindOfClass:[XTSearchUserModel class]]) {
        XTSearchUserModel *tempModel = (XTSearchUserModel *)userModel;
        searchUserId = tempModel.userId;
    }else if([userModel isKindOfClass:[XTOrderArtist class]]) {
        XTOrderArtist *tempModel = (XTOrderArtist *)userModel;
        searchUserId = tempModel.artistId;
    }else {
        return;
    }
    BOOL notFound = YES;
    NSInteger loopCount = 0;
    //寻找数组中的模型
    for (MTLModel *model in self.userArray) {
        
        long tempUserId = 0;
        if([model isKindOfClass:[XTSearchUserModel class]]) {
            XTSearchUserModel *tempModel = (XTSearchUserModel *)model;
            tempUserId = tempModel.userId;
        }else if([model isKindOfClass:[XTOrderArtist class]]) {
            XTOrderArtist *tempModel = (XTOrderArtist *)model;
            tempUserId = tempModel.artistId;
        }

        if(searchUserId == tempUserId) {
            notFound = NO;
            [self cellClickWithModel:model andIsSelected:YES andIndexPath:[NSIndexPath indexPathForItem:loopCount inSection:0]];
            break;
        }
        loopCount++;
    }
    
    if(notFound) {
        [self cellClickWithModel:userModel andIsSelected:YES andIndexPath:nil];
    }

    //刷新数据
    [self reloadData];
}

-(void)refreshUserList:(NSNotification *)notification {
    NSString *userId = [NSString stringWithFormat:@"%@",notification.userInfo[@"userID"]];
    NSString *status = notification.userInfo[@"status"];
    
    if(self.transferUserModel) {
        
        if ([self.transferUserModel isKindOfClass:[XTSearchUserModel class]]) {
            XTSearchUserModel *tempUserModel = (XTSearchUserModel *)self.transferUserModel;

            if([userId isEqualToString:[@(tempUserModel.userId) stringValue]]) {
                if(self.userButtonStyle == XTUserCollectionViewCellButtonStyleFollow) {
                if([status isEqualToString:@"0"]) {
                    tempUserModel.follow = @"0";
                    tempUserModel.fans -= 1;
                }else if([status isEqualToString:@"1"]) {
                    tempUserModel.follow = @"1";
                    tempUserModel.fans += 1;
                }
                }else if(self.userButtonStyle == XTUserCollectionViewCellButtonStyleLike) {
                    if([status isEqualToString:@"0"]) {
                        tempUserModel.like = @"0";
                        tempUserModel.fans -= 1;
                    }else if([status isEqualToString:@"1"]) {
                        tempUserModel.like = @"1";
                        tempUserModel.fans += 1;
                    }
                }
            }
            
        }else if ([self.transferUserModel isKindOfClass:[XTOrderArtist class]]) {
            XTOrderArtist *tempUserModel = (XTOrderArtist *)self.transferUserModel;
            if([status isEqualToString:@"0"]) {
                tempUserModel.subStatus = NO;
                tempUserModel.subNum -= 1;
            }else if([status isEqualToString:@"1"]) {
                tempUserModel.subStatus = YES;
                tempUserModel.subNum += 1;
            }
        }
        if(self.transferIndexPath) {
            [self reloadItemsAtIndexPaths:@[self.transferIndexPath]];
        }
    }
}

///cell艺人点击
- (void)cellClickWithModel:(MTLModel *)userModel andIsSelected:(BOOL)isSelected andIndexPath:(NSIndexPath *)indexPath {
    
    NSString *tempLike = nil;
    NSString *tempHate = nil;
    NSString *tempFollow = nil;
    long tempUserId = 0;
    
    if(self.userButtonStyle == XTUserCollectionViewCellButtonStyleRemove) {
        XTSearchUserModel *tempUserModel = (XTSearchUserModel *)userModel;
        tempUserId = tempUserModel.userId;
    }else {
        if([userModel isKindOfClass:[XTSearchUserModel class]]) {
            XTSearchUserModel *tempUserModel = (XTSearchUserModel *)userModel;
            if(self.userButtonStyle == XTUserCollectionViewCellButtonStyleHate) {
                tempHate = @"1";
                tempUserModel.black = isSelected ? @"0" : @"1";
            }else if(tempUserModel.like) {
                tempLike = @"1";
                tempUserModel.like = isSelected ? @"0" : @"1";
                tempUserModel.fans += isSelected ? -1 : 1;
            }else if(tempUserModel.follow) {
                tempFollow = @"1";
                tempUserModel.follow = isSelected ? @"0" : @"1";
                tempUserModel.fans += isSelected ? -1 : 1;
            }
            
            tempUserId = tempUserModel.userId;

        }else if([userModel isKindOfClass:[XTOrderArtist class]]) {
            XTOrderArtist *tempUserModel = (XTOrderArtist *)userModel;
            tempLike = @"1";
            tempUserId = tempUserModel.artistId;
            tempUserModel.subStatus = isSelected ? NO : YES;
            tempUserModel.subNum += isSelected ? -1 : 1;

        }
    }
    if(indexPath) {
        [self reloadItemsAtIndexPaths:@[indexPath]];
    }
    if(self.userButtonStyle == XTUserCollectionViewCellButtonStyleRemove) {

        [[[XTMessageStore alloc] init] removeShipendWithId:tempUserId CompletionBlock:^(BOOL removeSuccess, NSError *error) {
            self.isRequesting = NO;
        }];
        [self performBatchUpdates:^{
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.userArray];
            [tempArray removeObjectAtIndex:indexPath.row];
            self.userArray = tempArray;
            [self deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [self reloadData];
        }];
    }else {
        if(isSelected) {

            if(tempLike) {
                //取消喜欢
                [self requestFollowApiWithUserId:[NSString stringWithFormat:@"%@",@(tempUserId)]
                                andRequestIdName:@"artistId"
                                   andApiAddress:@"picture/sub/delete.json" completionBlock:^(id result, NSError *error) {
                                       if([result[@"rs"] integerValue] != 200) {
                                           if([userModel isKindOfClass:[XTSearchUserModel class]]) {
                                               XTSearchUserModel *tempUserModel = (XTSearchUserModel *)userModel;
                                               tempUserModel.like = @"1";
                                               tempUserModel.fans += 1;
                                           }else if([userModel isKindOfClass:[XTOrderArtist class]]) {
                                               XTOrderArtist *tempUserModel = (XTOrderArtist *)userModel;
                                               tempUserModel.subStatus = YES;
                                               tempUserModel.subNum += 1;
                                           }
                                           if(indexPath) {
                                               [self reloadItemsAtIndexPaths:@[indexPath]];
                                           }
                                           [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:^{
                                               [[NSNotificationCenter defaultCenter]
                                                postNotificationName:kCellButtonClickNotification object:nil userInfo:@{
                                                                                                                        @"model" : userModel,
                                                                                                                        @"selected" : @(0)
                                                                                                                        }
                                                ];
                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"UserStatusChangeSuccessNotification" object:nil];

                                           }];
                                           
                                       }
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"UserStatusChangeSuccessNotification" object:nil];
                                       if(self.needDelay) {
                                           [self performSelector:@selector(configRequestToFail) withObject:nil afterDelay:0.8];
                                       }else {
                                           self.isRequesting = NO;
                                       }
                                   }];
            }else if(tempHate) {
                //取消嫌弃
                [[XTBlacklistStore sharedManager] blackListDelWith:tempUserId type:1 completionBlock:^(id result, NSError *error) {
                    if([result[@"rs"] integerValue] != 200) {
                        if([userModel isKindOfClass:[XTSearchUserModel class]]) {
                            XTSearchUserModel *tempUserModel = (XTSearchUserModel *)userModel;
                            tempUserModel.black = @"1";
                        }
                        [self reloadItemsAtIndexPaths:@[indexPath]];
                        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:^{
                            
                        }];
                    }
                    self.isRequesting = NO;
                }];
                
            }else if(tempFollow) {
                //取消关注
                [self requestFollowApiWithUserId:[NSString stringWithFormat:@"%@",@(tempUserId)]
                                andRequestIdName:@"uid"
                                   andApiAddress:@"friendships/delete.json" completionBlock:^(id result, NSError *error) {
                                       if([result[@"rs"] integerValue] != 200) {
                                           if([userModel isKindOfClass:[XTSearchUserModel class]]) {
                                               XTSearchUserModel *tempUserModel = (XTSearchUserModel *)userModel;
                                               tempUserModel.follow = @"1";
                                               tempUserModel.fans += 1;
                                           }
                                           [self reloadItemsAtIndexPaths:@[indexPath]];
                                           [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:^{
                                               
                                           }];
                                           
                                       }
                                       self.isRequesting = NO;
                                   }];
            }
        }else {
            
            if(tempLike) {
                //喜欢
                [self requestFollowApiWithUserId:[NSString stringWithFormat:@"%@",@(tempUserId)]
                                andRequestIdName:@"artistId"
                                   andApiAddress:@"picture/sub/create.json" completionBlock:^(id result, NSError *error) {
                                       if([result[@"rs"] integerValue] != 200) {
                                           if([userModel isKindOfClass:[XTSearchUserModel class]]) {
                                               XTSearchUserModel *tempUserModel = (XTSearchUserModel *)userModel;
                                               tempUserModel.like = @"0";
                                               tempUserModel.fans -= 1;
                                           }else if([userModel isKindOfClass:[XTOrderArtist class]]) {
                                               XTOrderArtist *tempUserModel = (XTOrderArtist *)userModel;
                                               tempUserModel.subStatus = NO;
                                               tempUserModel.subNum -= 1;
                                           }
                                           if(indexPath) {
                                               [self reloadItemsAtIndexPaths:@[indexPath]];
                                           }
                                           [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:^{
                                               [[NSNotificationCenter defaultCenter]
                                                postNotificationName:kCellButtonClickNotification object:nil userInfo:@{
                                                                                                                        @"model" : userModel,
                                                                                                                        @"selected" : @(1)
                                                                                                                        }
                                                ];
                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"UserStatusChangeSuccessNotification" object:nil];
                                           }];
                                           
                                           [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@like",[XTUserStore sharedManager].user.userID]];
                                           [[NSUserDefaults standardUserDefaults] synchronize];
                                           
                                       }
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"UserStatusChangeSuccessNotification" object:nil];
                                       if(self.needDelay) {
                                           [self performSelector:@selector(configRequestToFail) withObject:nil afterDelay:0.8];
                                       }else {
                                           self.isRequesting = NO;
                                       }
                 
                                   }];
            }else if(tempHate) {
                //嫌弃
                [[XTBlacklistStore sharedManager] blackListAddWith:tempUserId type:1 completionBlock:^(id result, NSError *error) {
                    if([result[@"rs"] integerValue] != 200) {
                        if([userModel isKindOfClass:[XTSearchUserModel class]]) {
                            XTSearchUserModel *tempUserModel = (XTSearchUserModel *)userModel;
                            tempUserModel.black = @"0";
                        }
                        [self reloadItemsAtIndexPaths:@[indexPath]];
                        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:^{
                            
                        }];
                        
                    }
                    self.isRequesting = NO;
                }];
            }else if(tempFollow) {
                //关注
                [self requestFollowApiWithUserId:[NSString stringWithFormat:@"%@",@(tempUserId)]
                                andRequestIdName:@"uid"
                                   andApiAddress:@"friendships/create.json" completionBlock:^(id result, NSError *error) {
                                       if([result[@"rs"] integerValue] != 200) {
                                           if([userModel isKindOfClass:[XTSearchUserModel class]]) {
                                               XTSearchUserModel *tempUserModel = (XTSearchUserModel *)userModel;
                                               tempUserModel.follow = @"0";
                                               tempUserModel.fans -= 1;
                                           }
                                           [self reloadItemsAtIndexPaths:@[indexPath]];
                                           [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:^{
                                               
                                           }];
                                           
                                       }
                                       self.isRequesting = NO;
                                   }];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XTUserCollectionViewCellAction" object:[NSNumber numberWithInt:self.userButtonStyle]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserDetailNotifition" object:nil];
    if(self.shouldRefresh) {
        self.shouldRefresh();
    }
}

- (void)configRequestToFail {
    self.isRequesting = NO;
}

///取消监听通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - scrollview Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPage = scrollView.contentOffset.x/(SCREEN_SIZE.width-28);
    if(self.pageNum) {
        self.pageNum([NSString stringWithFormat:@"%d/%@",currentPage+1,@((self.userArray.count-1)/3+1)]);
    }
}

@end
