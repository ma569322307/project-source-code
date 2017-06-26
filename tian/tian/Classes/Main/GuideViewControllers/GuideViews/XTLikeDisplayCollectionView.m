//
//  XTLikeDisplayCollectionView.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/6.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTLikeDisplayCollectionView.h"
#import "XTLikeDisplayCell.h"
#import "XTUserCollectionView.h"
#import "YYTHUD.h"
#import <Mantle/EXTScope.h>
#import "MTLModel.h"
#import "XTSearchUserModel.h"
#import "XTOrderArtist.h"
#define kItemSize CGSizeMake(kItemWidthHeight, kItemWidthHeight)
typedef enum{
    XTLikeDisplayNone = 0,
    XTLikeDisplayShow,
    XTLikeDisplayDismiss
}XTLikeDisplayType;
@interface XTLikeDisplayCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,XTUserCollectionViewDelegate,XTUserCollectionViewCellDelegate>
@property (nonatomic, strong) NSMutableArray *displayModels;
// 需要动画显示的索引
@property (nonatomic, assign) NSInteger anmationIndex;
// 动画类型
@property (nonatomic, assign) XTLikeDisplayType anmationType;
@end

@implementation XTLikeDisplayCollectionView
static NSString * const reuseIdentifier = @"likeCell";
+(instancetype)likeDisplay{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.itemSize = kItemSize;
    XTLikeDisplayCollectionView *view = [[self alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    view.dataSource = view;
    view.delegate = view;
    [view registerClass:[XTLikeDisplayCell class] forCellWithReuseIdentifier:reuseIdentifier];
    view.backgroundColor = [UIColor clearColor];
    view.showsHorizontalScrollIndicator = NO;
    view.backgroundView = [[UIVisualEffectView alloc] init];
    [view addNotifications];
    view.contentInset = UIEdgeInsetsMake(0, 18, 0, 10);
    return view;
}
//添加通知
-(void)addNotifications{
    //添加选择喜欢取消喜欢通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseLike:) name:kCellButtonClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChangeSuccess:) name:@"UserStatusChangeSuccessNotification" object:nil];
}
-(void)chooseLike:(NSNotification *)note{
    //获取到模型
    self.userInteractionEnabled = NO;
    MTLModel *userModel = note.userInfo[@"model"];
    BOOL isSelected = [note.userInfo[@"selected"] integerValue];
    if (!isSelected) {
        //添加艺人到列表
        [self addDisplay:userModel];
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.displayModels.count -1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }else{
        //取消艺人在列表中
        [self deleteDisplay:userModel];
    }
}

-(void)userStatusChangeSuccess:(NSNotification *)note{
    self.userInteractionEnabled = YES;
}

#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.displayModels.count == 0) {
        return 1;
    }
    return self.displayModels.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XTLikeDisplayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (self.displayModels.count == 0) {
        cell.addName = @"GuideAdd";
    }else{
        MTLModel *model = self.displayModels[indexPath.item];
        cell.model = model;
        @weakify(self);
        [cell setCancelClick:^(MTLModel *model) {
            @strongify(self);
            self.userInteractionEnabled = NO;
            [self deleteDisplay:model];
        }];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    cell.transform = CGAffineTransformIdentity;
    if (indexPath.item == self.anmationIndex) {
        // 展示动画
        if (self.anmationType == XTLikeDisplayShow) {
            cell.transform = CGAffineTransformMakeScale(0, 0);
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.9 options:UIViewAnimationOptionTransitionNone animations:^{
                cell.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.anmationIndex = -1;
                self.anmationType = XTLikeDisplayNone;
            }];
        }else if (self.anmationType == XTLikeDisplayDismiss) { // 消失动画
            // 消失的时候动画过程不允许其他操作 防止数组越界
            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.25 animations:^{
                cell.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                if (self.anmationIndex == -1) {
                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                    return;
                }
                MTLModel *model = self.displayModels[self.anmationIndex];
                [self.displayModels removeObject:model];
                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                [self reloadData];
                self.anmationIndex = -1;
                self.anmationType = XTLikeDisplayNone;
            }];
        }
        
    }
}
//-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    cell.transform = CGAffineTransformIdentity;
//    if (indexPath.item == self.anmationIndex) {
//        // 展示动画
//        if (self.anmationType == XTLikeDisplayShow) {
//            cell.transform = CGAffineTransformMakeScale(0, 0);
//            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.9 options:UIViewAnimationOptionTransitionNone animations:^{
//                cell.transform = CGAffineTransformIdentity;
//            } completion:^(BOOL finished) {
//                self.anmationIndex = -1;
//                self.anmationType = XTLikeDisplayNone;
//            }];
//        }else if (self.anmationType == XTLikeDisplayDismiss) { // 消失动画
//            // 消失的时候动画过程不允许其他操作 防止数组越界
//            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
//            [UIView animateWithDuration:0.25 animations:^{
//                cell.transform = CGAffineTransformMakeScale(0.001, 0.001);
//            } completion:^(BOOL finished) {
//                if (self.anmationIndex == -1) {
//                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
//                    return;
//                }
//                [self performBatchUpdates:^{
//                    MTLModel *model = self.displayModels[self.anmationIndex];
//                    [self.displayModels removeObject:model];
//                    if (self.displayModels.count != 0) {
//                        [self deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.anmationIndex inSection:0]]];
//                    }
//                } completion:^(BOOL finished) {
//                    self.anmationIndex = -1;
//                    self.anmationType = XTLikeDisplayNone;
//                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
//                    [self reloadData];
//                }];
//            }];
//        }
//        
//    }
//}

-(void)addDisplay:(MTLModel *)model{
    [self.displayModels addObject:model];
    self.anmationIndex = self.displayModels.count -1;
    self.anmationType = XTLikeDisplayShow;
    [self reloadData];
}
-(void)deleteDisplay:(MTLModel *)model{
    
    long searchUserId = 0;
    if([model isKindOfClass:[XTSearchUserModel class]]) {
        XTSearchUserModel *tempModel = (XTSearchUserModel *)model;
        searchUserId = tempModel.userId;
    }else if([model isKindOfClass:[XTOrderArtist class]]) {
        XTOrderArtist *tempModel = (XTOrderArtist *)model;
        searchUserId = tempModel.artistId;
    }
    NSInteger index = 0;
    for (MTLModel *model in self.displayModels) {
        long tempUserId = 0;
        if([model isKindOfClass:[XTSearchUserModel class]]) {
            XTSearchUserModel *tempModel = (XTSearchUserModel *)model;
            tempUserId = tempModel.userId;
        }else if([model isKindOfClass:[XTOrderArtist class]]) {
            XTOrderArtist *tempModel = (XTOrderArtist *)model;
            tempUserId = tempModel.artistId;
        }
        
        if(searchUserId == tempUserId) {
            self.anmationIndex = index;
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
            self.anmationType = XTLikeDisplayDismiss;
            [self reloadData];
            break;
        }
        index++;
    }
}

#pragma mark XTUserCollectionViewDelegate
-(BOOL)sholdChangeInfo{
    if (self.displayModels.count >= 9) {
        return NO;
    }
    return YES;
}

#pragma mark 懒加载
-(NSMutableArray *)displayModels{
    if (_displayModels == nil) {
        _displayModels = [NSMutableArray array];
    }
    return _displayModels;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
