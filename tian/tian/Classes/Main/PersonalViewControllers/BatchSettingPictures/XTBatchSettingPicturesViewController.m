
//
//  XTBatchSettingPicturesViewController.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/13.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTBatchSettingPicturesViewController.h"
#import "XTBatchSettingPhotoListView.h"
#import "XTSubStore.h"
#import "XTPictureInfoModel.h"
#import <Mantle/EXTScope.h>
#import "YYTAlertView.h"
#import "XTUploadAlbumListViewController.h"
#define kBatchSettingBottomButtonHeight 50
@interface XTBatchSettingPicturesViewController ()
///图片展示视图
@property (nonatomic, strong) XTBatchSettingPhotoListView *collectionView;
///按钮背景视图
@property (nonatomic, strong) UIImageView *buttonBackGroundImageView;
///移动按钮
@property (nonatomic, strong) UIButton *movingButton;
///删除按钮
@property (nonatomic, strong) UIButton *deleteButton;
///点击的索引列表
@property (nonatomic, strong) NSMutableArray *indexArray;
///判断是否做过改动
@property (nonatomic, assign,getter=isNeedRefresh) BOOL needRefresh;
@end

@implementation XTBatchSettingPicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    [self Constraints];
}
- (void)setAlbumId:(NSInteger)albumId{
    _albumId = albumId;
    self.collectionView.albumId = albumId;
}
- (void)Constraints{
    [self.view addSubview:self.collectionView];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    if (self.settingType == XTBatchSettingPictures) {
        self.title = @"批量操作";
        [self.view addSubview:self.buttonBackGroundImageView];
        [self.buttonBackGroundImageView addSubview:self.movingButton];
        [self.buttonBackGroundImageView addSubview:self.deleteButton];
        //背景约束
        [self.buttonBackGroundImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(kBatchSettingBottomButtonHeight);
        }];
        //移动按钮
        [self.movingButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.buttonBackGroundImageView.centerX).multipliedBy(0.5);
            make.centerY.equalTo(self.buttonBackGroundImageView.centerY);
        }];
        //删除按钮
        [self.deleteButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.buttonBackGroundImageView.centerX).multipliedBy(1.5);
            make.centerY.equalTo(self.buttonBackGroundImageView.centerY);
        }];
        //添加完按钮先判断
        [self checkButtonEnable];
        return;
    }
    if (self.settingType == XTBatchSettingPictures) {
        self.title = @"选择图片(0)";
    }else{
        self.title = @"选择图片";
    }
}
-(void)setSettingType:(XTBatchSettingType)settingType{
    _settingType = settingType;
    if (self.settingType == XTBatchSettingPictures) {
        self.collectionView.bottomInset = kBatchSettingBottomButtonHeight;
    }
}
-(void)savingIndex:(NSInteger)index{
    // 如果是-1表示清空数组
    if (index == -1) {
        self.indexArray = nil;
        [self checkButtonEnable];
        return;
    }
    //判断当前索引是否存在
    for (NSNumber *i in self.indexArray) {
        if (i.integerValue == index) {
            [self.indexArray removeObject:i];
            //移除需要判断
            [self checkButtonEnable];
            return;
        }
    }
    [self.indexArray addObject:@(index)];
    //添加需要判断
    [self checkButtonEnable];
}
//判断是否需要点亮按钮
- (void)checkButtonEnable{
    self.movingButton.enabled = self.indexArray.count != 0;
    self.deleteButton.enabled = self.indexArray.count != 0;
    if (self.settingType == XTBatchSettingPictures) {
        self.title = [NSString stringWithFormat:@"选择图片(%zd)",self.indexArray.count];
    }
}
- (void)movingClick{
    ///跳转界面选择图册
    XTUploadAlbumListViewController *albumListController = [[XTUploadAlbumListViewController alloc] init];
    albumListController.title = @"移动到图册";
    albumListController.type = XTAlbumListTypeMove;
    [self.navigationController pushViewController:albumListController animated:YES];
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectNewAlbumID:) name:@"updateSelectedAlbumNotification" object:nil];
}

- (void)selectNewAlbumID:(NSNotification *)note{
    NSNumber *newAlbumID = note.object[@"albumID"];
    [self movingAction:newAlbumID.integerValue];
}
- (void)deleteClick{
    ///删除处理提示
    @weakify(self);
    [YYTAlertView showFullTypeAlertViewWithTitle:@"提示" message:@"是否删除选择的图片" completaionBlock:^(NSInteger index) {
        @strongify(self);
        if (index == 1) {
            [self deleteAction];
           [[NSNotificationCenter defaultCenter]postNotificationName:@"updateAlbumHeadNotification" object:nil userInfo:nil];
        }
    }];
}
- (void)deleteAction{
    [YYTHUD showLoadingAddedTo:self.view];
    [self.indexArray sortUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        return obj1.integerValue > obj2.integerValue;
    }];
    NSLog(@"当前选择的坐标：%@",self.indexArray);
    ///删除操作
    @weakify(self);
    [[[XTSubStore alloc] init] deleteAlbumPicturesWithAlbumID:self.albumId pids:[self selectedIDList] completionBlock:^(id results, NSError *error) {
        @strongify(self);
        [YYTHUD hideLoadingFrom:self.view];
        if (error != nil) {
            NSLog(@"%@",error);
            [YYTHUD showPromptAddedTo:self.view withText:@"删除失败" withCompletionBlock:nil];
            
            return;
        }
        self.needRefresh = YES;
        @weakify(self);
        [YYTHUD showPromptAddedTo:self.view withText:@"删除成功" withCompletionBlock:^{
            @strongify(self);
            self.indexArray = nil;
            [self checkButtonEnable];
            [self.collectionView.header beginRefreshing];
        }];
        
    }];

}
- (void)movingAction:(NSInteger)newAlbumID{
    //销毁监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    ///移动处理
    [YYTHUD showLoadingAddedTo:self.view];
    [self.indexArray sortUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        return obj1.integerValue > obj2.integerValue;
    }];
    NSLog(@"当前选择的坐标：%@",self.indexArray);
    ///删除操作
    @weakify(self);
    [[[XTSubStore alloc] init] movePicturesFromAlbumID:self.albumId toAlbumID:newAlbumID pids:[self selectedIDList] completionBlock:^(id results, NSError *error) {
        @strongify(self);
        [YYTHUD hideLoadingFrom:self.view];
        if (error != nil) {
            NSLog(@"%@",error);
            [YYTHUD showPromptAddedTo:self.view withText:@"移动失败" withCompletionBlock:nil];
            return;
        }
        self.needRefresh = YES;
        @weakify(self);
        [YYTHUD showPromptAddedTo:self.view withText:@"移动成功" withCompletionBlock:^{
            @strongify(self);
            self.indexArray = nil;
            [self checkButtonEnable];
            [self.collectionView.header beginRefreshing];
        }];
        
    }];
}
// 通知其他界面刷新数据
-(void)sendChangeInfoToRefreshInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlbumListNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlbumDetailNotification" object:nil];
}

- (void)clickNaBackBtn:(UIButton *)sender
{
    //如果需要刷新发送刷新通知
    if (self.isNeedRefresh) {
        //让其他界面刷新数据
        [self sendChangeInfoToRefreshInfo];
    }
    // 弹出
    [self.navigationController popViewControllerAnimated:YES];
}
//根据索引获取模型
-(NSArray *)selectedList{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSNumber *index in self.indexArray) {
        [arrayM addObject:self.collectionView.pictureList[index.integerValue]];
    }
    return arrayM.copy;
}
//获取图片id列表
-(NSSet *)selectedIDList{
    NSMutableSet *arrayM = [NSMutableSet set];
    for (XTPictureInfoModel *model in [self selectedList]) {
        [arrayM addObject:[NSNumber numberWithInteger:model.id]];
    }
    return arrayM.copy;
}
#pragma mark 懒加载
-(XTBatchSettingPhotoListView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [XTBatchSettingPhotoListView batchSettingPhotoListCreateView];
        @weakify(self);
        [_collectionView setSelectionBlock:^(NSInteger index) {
            @strongify(self);
            if (index == -1) {
                [self savingIndex:index];
                return;
            }
            if (self.settingType == XTBatchSettingPictures) {
                ///记录所有选择的索引
                [self savingIndex:index];
            }
            if (self.completionBlock) {
                XTPictureInfoModel *model = self.collectionView.pictureList[index];
                self.completionBlock(model.picUrl);
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
        }];
    }
    return _collectionView;
}
-(UIImageView *)buttonBackGroundImageView
{
    if (_buttonBackGroundImageView == nil) {
        _buttonBackGroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tabbar_nav_title"]];
        _buttonBackGroundImageView.userInteractionEnabled = YES;
    }
    return _buttonBackGroundImageView;
}
-(UIButton *)movingButton
{
    if (_movingButton == nil) {
        _movingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _movingButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_movingButton setImage:[UIImage imageNamed:@"BatchMoving"] forState:UIControlStateNormal];
        [_movingButton setImage:[UIImage imageNamed:@"BatchMoving_sel"] forState:UIControlStateHighlighted];
        [_movingButton addTarget:self action:@selector(movingClick) forControlEvents:UIControlEventTouchUpInside];
        [_movingButton sizeToFit];
    }
    return _movingButton;
}
-(UIButton *)deleteButton
{
    if (_deleteButton == nil) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_deleteButton setImage:[UIImage imageNamed:@"BatchDeleting"] forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage imageNamed:@"BatchDeleting_sel"] forState:UIControlStateHighlighted];
        [_deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton sizeToFit];
    }
    return _deleteButton;
}
-(NSMutableArray *)indexArray
{
    if (_indexArray == nil) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}
//-(void)viewDidDisappear:(BOOL)animated{
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateAlbumHeadNotification" object:nil];
//    }
//

@end
