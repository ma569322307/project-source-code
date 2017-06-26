//
//  XTHomePageLikeAndHateCollectionView.m
//  tian
//
//  Created by huhuan on 15/6/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHomePageLikeAndHateCollectionView.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTOrderArtist.h"
#import "XTBlacklistStore.h"
#import "XTSubStore.h"
#import "NSError+XTError.h"

@interface XTHomePageLikeAndHateCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) BOOL isRemoving;

@end

@implementation XTHomePageLikeAndHateCollectionView

static NSString *userCellIdentifier = @"userCell";

+ (XTHomePageLikeAndHateCollectionView *)likeAndHateCollectionView {
    UICollectionViewFlowLayout *verticalLayout = [[UICollectionViewFlowLayout alloc] init];
    verticalLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    verticalLayout.minimumLineSpacing = 20;
    verticalLayout.minimumInteritemSpacing = 0;
    verticalLayout.itemSize = CGSizeMake(103.f/320.f*SCREEN_SIZE.width, 90);
    verticalLayout.sectionInset = UIEdgeInsetsMake(0., 0., 0., 0.);
    
    XTHomePageLikeAndHateCollectionView *userCV = [[XTHomePageLikeAndHateCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:verticalLayout];
    userCV.backgroundColor = [UIColor clearColor];
    userCV.dataSource = userCV;
    userCV.delegate = userCV;
    userCV.showsHorizontalScrollIndicator = NO;
    userCV.showsVerticalScrollIndicator = NO;
    userCV.isRemoving = NO;
    
    [userCV registerNib:[UINib nibWithNibName:@"XTHomePageLikeAndHateCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:userCellIdentifier];
    
    return userCV;
}

- (void)removeArtistFromServerWithUserId:(NSString *)userId indexPath:(NSIndexPath *)indexPath model:(XTOrderArtist *)model{

    if(self.pageStyle == XTHomePageLikeAndHateCollectionViewStyleLike) {
        XTSubStore *subStore = [[XTSubStore alloc] init];
        [subStore deleteSubscribeArtistFromArtistId:[userId integerValue] completionBlock:^(id responseObject, NSError *error) {
            if(error) {
//                @weakify(self);
                [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:^{
//                    @strongify(self);
                    [self performBatchUpdates:^{
                        [self.userArray insertObject:model atIndex:indexPath.row];
                        [self insertItemsAtIndexPaths:@[indexPath]];
                    } completion:^(BOOL finished) {
                        [self reloadData];
                        self.isRemoving = NO;
                    }];
                }];
            }else {
                self.isRemoving = NO;
            }
        }];
    }else if(self.pageStyle == XTHomePageLikeAndHateCollectionViewStyleHate) {
        [[XTBlacklistStore sharedManager] blackListDelWith:[userId integerValue] type:1 completionBlock:^(id result, NSError *error) {
            if(error) {
                @weakify(self);
                [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:^{
                    @strongify(self);
                    [self performBatchUpdates:^{
                        [self.userArray insertObject:model atIndex:indexPath.row];
                        [self insertItemsAtIndexPaths:@[indexPath]];
                    } completion:^(BOOL finished) {
                        [self reloadData];
                        self.isRemoving = NO;
                    }];
                }];
            }else {
                self.isRemoving = NO;
            }
        }];
        
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.userArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XTHomePageLikeAndHateCollectionViewCell *cell = (XTHomePageLikeAndHateCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:userCellIdentifier forIndexPath:indexPath];
    
    [cell configureUserCell:self.userArray[indexPath.row] andCellMode:self.pageMode andIndexPath:indexPath];
    cell.removeClickBlock = ^(XTOrderArtist *artist, NSIndexPath *cellIndexPath){
        if(self.isRemoving) {
            return ;
        }else {
            self.isRemoving = YES;
        }
        [self removeArtistFromServerWithUserId:[NSString stringWithFormat:@"%@",@(artist.artistId)] indexPath:indexPath model:self.userArray[indexPath.row]];
        [self performBatchUpdates:^{
            [self.userArray removeObjectAtIndex:cellIndexPath.row];
            [self deleteItemsAtIndexPaths:@[cellIndexPath]];
        } completion:^(BOOL finished) {
            [self reloadData];
            if([self.userArray count] == 0 && self.removeAllDataBlock) {
                self.removeAllDataBlock();
            }
        }];
        
    };
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
