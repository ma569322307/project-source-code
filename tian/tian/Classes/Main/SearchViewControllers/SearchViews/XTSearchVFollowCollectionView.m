//
//  XTSearchArtistFollowCollectionView.m
//  tian
//
//  Created by huhuan on 15/6/15.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchVFollowCollectionView.h"
#import "XTVFollowCollectionViewCell.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTOrderArtist.h"

@interface XTSearchVFollowCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation XTSearchVFollowCollectionView

static NSString *vCellIdentifier = @"vCell";

+ (XTSearchVFollowCollectionView *)vCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 14.f/320.f*SCREEN_SIZE.width;
    layout.minimumInteritemSpacing = 14.f/320.f*SCREEN_SIZE.width;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    XTSearchVFollowCollectionView *vCV = [[XTSearchVFollowCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    vCV.backgroundColor = [UIColor clearColor];
    vCV.dataSource = vCV;
    vCV.delegate = vCV;
    vCV.showsHorizontalScrollIndicator = NO;
    vCV.showsVerticalScrollIndicator = NO;
    
    [vCV registerNib:[UINib nibWithNibName:@"XTVFollowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:vCellIdentifier];
    return vCV;
}

- (void)configureArtistCollectionView {

}

- (void)requestFollowApiWithUserId:(NSString *)userId andRequestIdName:(NSString *)name  andApiAddress:(NSString *)apiAddress {
    
    NSDictionary *parameters = @{
                                 name: userId,
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager POST:apiAddress parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.vArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XTVFollowCollectionViewCell *cell = (XTVFollowCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:vCellIdentifier forIndexPath:indexPath];
    [cell configureArtistCell:self.vArray[indexPath.row]];
    @weakify(self);
    cell.buttonClick = ^(XTOrderArtist *artistModel, BOOL isSelected) {
        @strongify(self);
        if(isSelected) {
            [self requestFollowApiWithUserId:[NSString stringWithFormat:@"%@",@(artistModel.artistId)]
                            andRequestIdName:@"uid"
                               andApiAddress:@"friendships/create.json"];
        }else {
            [self requestFollowApiWithUserId:[NSString stringWithFormat:@"%@",@(artistModel.artistId)]
                            andRequestIdName:@"uid"
                               andApiAddress:@"friendships/delete.json"];
        }
    };
    return cell;
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(138.f/320.f*SCREEN_SIZE.width, 172/320.f*SCREEN_SIZE.width);
}
@end
