//
//  JKImagePickerController.m
//  JKImagePicker
//
//  Created by Jecky on 15/1/9.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import "JKImagePickerController.h"
#import "JKUtil.h"
#import "JKAssetsGroupsView.h"
#import "UIView+JKPicker.h"
#import "JKAssetsViewCell.h"
#import "JKAssetsCollectionFooterView.h"
#import "JKPromptView.h"
#import "JKPhotoBrowser.h"
#import "PhotoAlbumManager.h"
#import "XTCommonMacro.h"
#import "YYTAlertView.h"
#import "XTImageEditorViewController.h"
#import "UIImage+Capture.h"
#import "AddPhotoViewController.h"
#import "XTLocalImageStoreManage.h"

ALAssetsFilter * ALAssetsFilterFromJKImagePickerControllerFilterType(JKImagePickerControllerFilterType type) {
    switch (type) {
        case JKImagePickerControllerFilterTypeNone:
            return [ALAssetsFilter allAssets];
            break;
            
        case JKImagePickerControllerFilterTypePhotos:
            return [ALAssetsFilter allPhotos];
            break;
            
        case JKImagePickerControllerFilterTypeVideos:
            return [ALAssetsFilter allVideos];
            break;
    }
}


@interface JKImagePickerController ()
<
JKAssetsGroupsViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
JKAssetsViewCellDelegate,
JKPhotoBrowserDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
RSKImageCropViewControllerDelegate
>

@property (nonatomic, strong) ALAssetsLibrary     *assetsLibrary;
@property (nonatomic, strong) NSArray *groupTypes;

@property (nonatomic, assign) BOOL showsAssetsGroupSelection;

@property (nonatomic, strong) UILabel      *titleLabel;
@property (nonatomic, strong) UIButton     *titleButton;
@property (nonatomic, strong) UIButton     *arrowImageView;

@property (nonatomic, strong) UIButton              *touchButton;
@property (nonatomic, strong) UIView                *overlayView;
@property (nonatomic, strong) JKAssetsGroupsView    *assetsGroupsView;


@property (nonatomic, strong) ALAssetsGroup *selectAssetsGroup;
@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (nonatomic, assign) NSUInteger numberOfAssets;
@property (nonatomic, assign) NSUInteger numberOfPhotos;
@property (nonatomic, assign) NSUInteger numberOfVideos;

@property (nonatomic, strong) UIView     *toolbar;
@property (nonatomic, strong) UIButton      *selectButton;//暂时废弃
@property (nonatomic, strong) UIButton      *finishButton;
@property (nonatomic, strong) UILabel       *finishLabel;
@property (nonatomic, strong) UIButton      *previewButton;//预览按钮

@property (nonatomic, strong) UICollectionView   *collectionView;

//// 相册胶卷数组
//@property (nonatomic, assign) ALAssetsGroup *photoAlbumGroup;
//// 照片流数组
//@property (nonatomic, assign) ALAssetsGroup *photoStreamGroup;
// 拍照判断
@property (nonatomic, assign) BOOL afterTakingPhoto;
@end

@implementation JKImagePickerController

- (id)init
{
    self = [super init];
    if (self) {
        self.filterType = JKImagePickerControllerFilterTypePhotos;
        self.afterTakingPhoto = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    // 获取索引
//    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//        self.photoAlbumGroup = group;
//    } failureBlock:^(NSError *error) {}];
//    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//        self.photoStreamGroup = group;
//    } failureBlock:^(NSError *error) {}];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.backItem.hidesBackButton = YES;
    UIImage* bgImg = [UIImage imageNamed:@"Tabbar_nav_title"];
    
    
    self.navigationItem.leftBarButtonItem = nil;
    //self.navigationController.navigationBar.translucent = YES;
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpProperties];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self collectionView];
    [self toolbar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadAssetsGroups];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
        [YYTAlertView showHalfTypeAlertViewWithTitle:@"温馨提示" message:@"请在iphone的“设置-隐私-照片”选项中，允许舔访问你的手机相册" completaionBlock:^(NSInteger index) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (void)setUpProperties
{
    // Property settings
    self.groupTypes = @[@(ALAssetsGroupLibrary),
                        @(ALAssetsGroupSavedPhotos),
                        @(ALAssetsGroupPhotoStream),
                        @(ALAssetsGroupAlbum)];

    self.navigationItem.titleView = self.titleButton;
    
    
}

- (void)cancelEventDidTouched
{
    if ([_delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [_delegate imagePickerControllerDidCancel:self];
    }
}

- (void)assetsGroupDidSelected
{
    self.showsAssetsGroupSelection = YES;
    
    if (self.showsAssetsGroupSelection) {
        [self showAssetsGroupView];
    }
}

- (void)selectOriginImage
{
    _selectButton.selected = !_selectButton.selected;

}

- (void)assetsGroupsDidDeselected
{
    self.showsAssetsGroupSelection = NO;
    [self hideAssetsGroupView];
}

- (void)showAssetsGroupView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.touchButton];
    
    self.overlayView.alpha = 0.0f;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.assetsGroupsView.xttop = 0;
                         self.overlayView.alpha = 0.85f;
                     }completion:^(BOOL finished) {
                         
                     }];
}

- (void)hideAssetsGroupView
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.assetsGroupsView.xttop = -self.assetsGroupsView.xtheight;
                         self.overlayView.alpha = 0.0f;
                     }completion:^(BOOL finished) {
                         [_touchButton removeFromSuperview];
                         _touchButton = nil;
                         
                         [_overlayView removeFromSuperview];
                         _overlayView = nil;
                     }];
    
}

- (void)previewPhotoesSelected
{
    [self passSelectedAssets];
}

- (void)browerPhotoes:(NSArray *)array page:(NSInteger)page isClickPreviewBtn:(BOOL)isClickPreviewBtn
{
    JKPhotoBrowser  *photoBorwser = [[JKPhotoBrowser alloc] initWithFrame:[UIScreen mainScreen].bounds];
    photoBorwser.delegate = self;
    photoBorwser.pickerController = self;
    photoBorwser.currentPage = page;
    photoBorwser.assetsArray = [NSMutableArray arrayWithArray:array];
    photoBorwser.assetsIndexArray = [NSMutableArray arrayWithArray:self.selectedAssetIndexArray];
    if (isClickPreviewBtn) {
        photoBorwser.type = JKPhotoBrowserTypeSelected;
    }else{
        photoBorwser.type = JKPhotoBrowserTypeAll;
    }
    [photoBorwser show:YES];
}

#pragma mark - Managing Assets
- (void)passSelectedAssets
{
    // Load assets from URLs
    __block NSMutableArray *assets = [NSMutableArray array];
    
    for (JKAssets *jka in self.selectedAssetArray) {
        __weak typeof(self) weakSelf = self;
        
        [self.assetsLibrary assetForURL:jka.assetPropertyURL
             resultBlock:^(ALAsset *asset)
         {
             if (asset){
                 // Add asset
                 [assets addObject:asset];
                 // Check if the loading finished
                 if (assets.count == weakSelf.selectedAssetArray.count) {
                     [weakSelf browerPhotoes:assets page:0 isClickPreviewBtn:YES];
                 }

             }
             else {
                 // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
                 
                 [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                    usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                  {
                      [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                          if([result.defaultRepresentation.url isEqual:jka.assetPropertyURL])
                          {
                              // Add asset
                              [assets addObject:result];
                              // Check if the loading finished
                              if (assets.count == weakSelf.selectedAssetArray.count) {
                                  [weakSelf browerPhotoes:assets page:0 isClickPreviewBtn:YES];
                              }

                              *stop = YES;
                          }
                      }];
                  }
                  
                                  failureBlock:^(NSError *error)
                  {
                      NSLog(@"Error: Cannot load asset from photo stream - %@", [error localizedDescription]);
                      
                      
                  }];
             }
             
         }
            failureBlock:^(NSError *error)
         {
             NSLog(@"Error: Cannot load asset - %@", [error localizedDescription]);
             
         }
         ];
    }
}
// 记录照片索引
- (void)saveSavedPhotosIndex:(NSArray *)assetsGroups andsavedPhotos:(ALAssetsGroup *)savePhotos{
    
    for (int i = 0; i<assetsGroups.count; i++) {
        ALAssetsGroup *groups = assetsGroups[i];
        if (groups == savePhotos) {
            [[NSUserDefaults standardUserDefaults] setInteger:i forKey:kLastPhotoGroup];
            return;
        }
    }
    return;
    
}

- (void)loadAssetsGroups
{
    
    // Load assets groups
    __weak typeof(self) weakSelf = self;
    [self loadAssetsGroupsWithTypes:self.groupTypes
                         completion:^(NSArray *assetsGroups) {
                             if ([assetsGroups count]>0) {
                                 weakSelf.titleButton.enabled = YES;
                                 NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:kLastPhotoGroup];
                                 if (index >= [assetsGroups count]) {
                                     index = 0;
                                 }
                                 if (weakSelf.afterTakingPhoto) {
                                     for (ALAssetsGroup *group in assetsGroups) {
                                         if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos)
                                         {
                                             weakSelf.selectAssetsGroup = group;
                                             // 记录照片索引
                                             [weakSelf saveSavedPhotosIndex:assetsGroups andsavedPhotos:group];
                                         }
                                     }
                                 }else{
                                     weakSelf.selectAssetsGroup = [assetsGroups objectAtIndex:index];
                                 }
                                 self.afterTakingPhoto = NO;
                                 weakSelf.assetsGroupsView.assetsGroups = assetsGroups;
                                 
                                 NSMutableDictionary  *dic = [NSMutableDictionary dictionaryWithCapacity:0];
                                 for (JKAssets  *asset in weakSelf.selectedAssetArray) {
                                     if (asset.groupPropertyID) {
                                         NSInteger  count = [[dic objectForKey:asset.groupPropertyID] integerValue];
                                         [dic setObject:[NSNumber numberWithInteger:count+1] forKey:asset.groupPropertyID];
                                     }
                                 }
                                 weakSelf.assetsGroupsView.selectedAssetCount = dic;
                                 [weakSelf resetFinishFrame];
                                 
                             }else{
                                 weakSelf.titleButton.enabled = NO;
                             }
                         }];
    
    // Validation
}

- (void)setSelectAssetsGroup:(ALAssetsGroup *)selectAssetsGroup{
    if (_selectAssetsGroup != selectAssetsGroup) {
        _selectAssetsGroup = selectAssetsGroup;
        
        NSString  *assetsName = [selectAssetsGroup valueForProperty:ALAssetsGroupPropertyName];
        self.titleLabel.text = assetsName;
        [self.titleLabel sizeToFit];
        
        CGFloat  width = CGRectGetWidth(self.titleLabel.frame)/2+2+CGRectGetWidth(self.arrowImageView.frame)+15;
        self.titleButton.xtwidth = width*2;
        
        self.titleLabel.xtcenterY = self.titleButton.xtheight/2;
        self.titleLabel.xtcenterX = self.titleButton.xtwidth/2;
        
        self.arrowImageView.xtleft = self.titleLabel.xtright + 5;
        self.arrowImageView.xtcenterY = self.titleLabel.xtcenterY;
        
        [self loadAllAssetsForGroups];
    }
}

- (void)loadAllAssetsForGroups
{
    [self.selectAssetsGroup setAssetsFilter:ALAssetsFilterFromJKImagePickerControllerFilterType(self.filterType)];
    
    // Load assets
    NSMutableArray *assets = [NSMutableArray array];
    __block NSUInteger numberOfAssets = 0;
    __block NSUInteger numberOfPhotos = 0;
    __block NSUInteger numberOfVideos = 0;
    
    [self.selectAssetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            numberOfAssets++;
            NSString *type = [result valueForProperty:ALAssetPropertyType];
            if ([type isEqualToString:ALAssetTypePhoto]){
                numberOfPhotos++;
            }else if ([type isEqualToString:ALAssetTypeVideo]){
                numberOfVideos++;
            }
            [assets addObject:result];
        }
    }];
    NSMutableArray *assetsSorted = [assets sortedArrayUsingComparator:^NSComparisonResult(ALAsset *obj1, ALAsset *obj2) {
        return YES;
    }].mutableCopy;
    self.assetsArray = assetsSorted;
    self.numberOfAssets = numberOfAssets;
    self.numberOfPhotos = numberOfPhotos;
    self.numberOfVideos = numberOfVideos;
    
    // Update view
    [self.collectionView reloadData];
}

- (void)loadAssetsGroupsWithTypes:(NSArray *)types completion:(void (^)(NSArray *assetsGroups))completion
{
    __block NSMutableArray *assetsGroups = [NSMutableArray array];
    __block NSUInteger numberOfFinishedTypes = 0;
    
    for (NSNumber *type in types) {
        __weak typeof(self) weakSelf = self;
        [self.assetsLibrary enumerateGroupsWithTypes:[type unsignedIntegerValue]
                                          usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
                                              if (assetsGroup) {
                                                  // Filter the assets group
                                                  [assetsGroup setAssetsFilter:ALAssetsFilterFromJKImagePickerControllerFilterType(weakSelf.filterType)];

                                                  // Add assets group
                                                  if (assetsGroup.numberOfAssets > 0) {
                                                      // Add assets group
                                                      [assetsGroups addObject:assetsGroup];
                                                  }
                                              } else {
                                                  numberOfFinishedTypes++;
                                              }
                                              
                                              // Check if the loading finished
                                              if (numberOfFinishedTypes == types.count) {
                                                  // Sort assets groups
                                                  NSArray *sortedAssetsGroups = [self sortAssetsGroups:(NSArray *)assetsGroups typesOrder:types];
                                                  
                                                  // Call completion block
                                                  if (completion) {
                                                      completion(sortedAssetsGroups);
                                                  }
                                              }
                                          } failureBlock:^(NSError *error) {

                                          }];
    }
}

- (NSArray *)sortAssetsGroups:(NSArray *)assetsGroups typesOrder:(NSArray *)typesOrder
{
    NSMutableArray *sortedAssetsGroups = [NSMutableArray array];
    
    for (ALAssetsGroup *assetsGroup in assetsGroups) {
        if (sortedAssetsGroups.count == 0) {
            [sortedAssetsGroups addObject:assetsGroup];
            continue;
        }
        
        ALAssetsGroupType assetsGroupType = [[assetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
        NSUInteger indexOfAssetsGroupType = [typesOrder indexOfObject:@(assetsGroupType)];
        
        for (NSInteger i = 0; i <= sortedAssetsGroups.count; i++) {
            if (i == sortedAssetsGroups.count) {
                [sortedAssetsGroups addObject:assetsGroup];
                break;
            }
            
            ALAssetsGroup *sortedAssetsGroup = sortedAssetsGroups[i];
            ALAssetsGroupType sortedAssetsGroupType = [[sortedAssetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
            NSUInteger indexOfSortedAssetsGroupType = [typesOrder indexOfObject:@(sortedAssetsGroupType)];
            
            if (indexOfAssetsGroupType < indexOfSortedAssetsGroupType) {
                [sortedAssetsGroups insertObject:assetsGroup atIndex:i];
                break;
            }
        }
    }
    
    return sortedAssetsGroups;
}

- (BOOL)validateNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    BOOL qualifiesMinimumNumberOfSelection = (numberOfSelections >= minimumNumberOfSelection);
    
    BOOL qualifiesMaximumNumberOfSelection = YES;
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        qualifiesMaximumNumberOfSelection = (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return (qualifiesMinimumNumberOfSelection && qualifiesMaximumNumberOfSelection);
}

- (BOOL)validateMaximumNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        return (numberOfSelections <= self.maximumNumberOfSelection - self.alreadySelectedNumber);
    }
    
    return YES;
}

#pragma mark - JKAssetsGroupsViewDelegate
- (void)assetsGroupsViewDidCancel:(JKAssetsGroupsView *)groupsView
{
    [self assetsGroupsDidDeselected];
}

- (void)assetsGroupsView:(JKAssetsGroupsView *)groupsView didSelectAssetsGroup:(ALAssetsGroup *)assGroup
{
    [self assetsGroupsDidDeselected];
    self.selectAssetsGroup = assGroup;
}

#pragma mark - setter
- (void)setShowsAssetsGroupSelection:(BOOL)showsAssetsGroupSelection{
    _showsAssetsGroupSelection = showsAssetsGroupSelection;
    
    self.arrowImageView.selected = _showsAssetsGroupSelection;
    
}
- (void)setShowsCancelButton:(BOOL)showsCancelButton{
    _showsCancelButton = showsCancelButton;
    
    // Show/hide cancel button
    if (showsCancelButton) {
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, 40, 40);
        [cancelBtn setImage:[UIImage imageNamed:@"upload_cancel"] forState:UIControlStateNormal];
        [cancelBtn setImage:[UIImage imageNamed:@"upload_cancel_sel"] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancelEventDidTouched) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
        [self.navigationItem setRightBarButtonItem:cancelItem animated:NO];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
}

- (void)finishPhotoDidSelected
{
    if(self.needSquareCrop && self.maximumNumberOfSelection == 1) {
        
        JKAssets *assets = self.selectedAssetArray.lastObject;
//        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
//        @weakify(self);
//        [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
//            @strongify(self);
//            if (asset) {
//                UIImage *tempImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
//                XTImageEditorViewController *editorController = [XTImageEditorViewController editorWithImage:tempImage];
//                editorController.delegate = self;
//                [self.navigationController pushViewController:editorController animated:YES];
//            }
//        } failureBlock:^(NSError *error) {
//            
//        }];
        
        [self.assetsLibrary assetForURL:assets.assetPropertyURL
                            resultBlock:^(ALAsset *asset)
         {
             if (asset){
                 UIImage *tempImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                 XTImageEditorViewController *editorController = [XTImageEditorViewController editorWithImage:tempImage];
                 editorController.delegate = self;
                 [self.navigationController pushViewController:editorController animated:YES];

                 
             }
             else {
                 // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
                 
                 [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                                   usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                  {
                      [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                          if([result.defaultRepresentation.url isEqual:assets.assetPropertyURL])
                          {
                              UIImage *tempImage = [UIImage imageWithCGImage:[[result defaultRepresentation] fullScreenImage]];
                              XTImageEditorViewController *editorController = [XTImageEditorViewController editorWithImage:tempImage];
                              editorController.delegate = self;
                              [self.navigationController pushViewController:editorController animated:YES];

                              *stop = YES;
                          }
                      }];
                  }
                  
                                                 failureBlock:^(NSError *error)
                  {
                      NSLog(@"Error: Cannot load asset from photo stream - %@", [error localizedDescription]);
                      
                      
                  }];
             }
             
         }
                           failureBlock:^(NSError *error)
         {
             NSLog(@"Error: Cannot load asset - %@", [error localizedDescription]);
             
         }
         ];

    }else if(self.needPush)//直接弹控制器
    {
        self.finishButton.enabled = NO;
        self.previewButton.enabled = NO;
        self.titleButton.enabled = NO;
//        [YYTHUD showLoadingAddedTo:self.view];
        UINavigationController *currentCtr = self.navigationController;
        AddPhotoViewController *addPhotoCtr = [[AddPhotoViewController alloc] init];
        addPhotoCtr.assetsArray = self.selectedAssetArray;
        addPhotoCtr.selectedAssetIndexArray = self.selectedAssetIndexArray;
        addPhotoCtr.needPop = self.needPop;
        addPhotoCtr.alreadySelectedNumber = self.alreadySelectedNumber;
        addPhotoCtr.albumInfo = self.albumInfo;
        addPhotoCtr.type = self.type;
        // 生成timeKey
        [[XTLocalImageStoreManage sharedLocalImageStoreManage] timeStringCreate];
        @weakify(self);
        [addPhotoCtr setBackBlock:^(NSMutableArray *assetsArray, NSMutableArray *selectedAssetIndexArray) {
            @strongify(self);
            self.selectedAssetArray = assetsArray;
            self.selectedAssetIndexArray = selectedAssetIndexArray;
        }];
        [currentCtr pushViewController:addPhotoCtr animated:YES];
        self.finishButton.enabled = YES;
        self.previewButton.enabled = YES;
        self.titleButton.enabled = YES;
    }else {
        if ([_delegate respondsToSelector:@selector(imagePickerController:didSelectAssets:isSource:)]) {
            [_delegate imagePickerController:self
                             didSelectAssets:self.selectedAssetArray
                                    isSource:_selectButton.selected];
        }
    }
}
// 批量删除图片
-(void)batchDelectAssertsWithArray:(NSArray *)array{
    for (NSNumber *number in array) {
        NSInteger index = number.integerValue;
        JKAssets *asset = self.selectedAssetArray[index];
        NSURL *assetURL = asset.assetPropertyURL;
        [self removeAssetsObject:assetURL];
    }
    
    //    [self.selectedAssetIndexArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //        NSNumber *selectedAssetIndex = (NSNumber *)obj;
    //        if ([selectedAssetIndex integerValue] == index) {
    //            *stop = YES;
    //            if (*stop == YES) {
    //                [_selectedAssetIndexArray removeObject:obj];
    //            }
    //        }
    //    }];
    //
    [self resetFinishFrame];
    [self.collectionView reloadData];
}

#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    UIImage *scaleImage = [croppedImage scaleToSize:CGSizeMake(500., 500.)];
    self.selectedAssetArray = [NSMutableArray arrayWithArray:@[scaleImage]];
    if ([_delegate respondsToSelector:@selector(imagePickerController:didSelectAssets:isSource:)]) {
        [_delegate imagePickerController:self
                         didSelectAssets:self.selectedAssetArray
                                isSource:_selectButton.selected];
    }
}

-(void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [controller.navigationController popViewControllerAnimated:YES];
}

static NSString *kJKImagePickerCellIdentifier = @"kJKImagePickerCellIdentifier";
static NSString *kJKAssetsFooterViewIdentifier = @"kJKAssetsFooterViewIdentifier";

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetsArray count]+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    JKAssetsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJKImagePickerCellIdentifier forIndexPath:indexPath];

    cell.delegate = self;
    if ([indexPath row]<=0) {
        cell.asset = nil;
    }else{
        ALAsset *asset = self.assetsArray[indexPath.row-1];
        cell.asset = asset;
        cell.assetIndex = [NSNumber numberWithInteger:indexPath.row-1];
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        cell.isSelected = [self assetIsSelected:assetURL];
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 46.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        JKAssetsCollectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                      withReuseIdentifier:kJKAssetsFooterViewIdentifier
                                                                                             forIndexPath:indexPath];
        
        switch (self.filterType) {
            case JKImagePickerControllerFilterTypeNone:{
                NSString *format;
                if (self.numberOfPhotos == 1) {
                    if (self.numberOfVideos == 1) {
                        format = @"format_photo_and_video";
                    } else {
                        format = @"format_photo_and_videos";
                    }
                } else if (self.numberOfVideos == 1) {
                    format = @"format_photos_and_video";
                } else {
                    format = @"format_photos_and_videos";
                }
                footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(format,
                                                                                                  @"JKImagePickerController",
                                                                                                  nil),
                                             self.numberOfPhotos,
                                             self.numberOfVideos
                                             ];
                break;
            }
                
            case JKImagePickerControllerFilterTypePhotos:{
                NSString *format = (self.numberOfPhotos == 1) ? @"format_photo" : @"format_photos";
                footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(format,
                                                                                                  @"JKImagePickerController",
                                                                                                  nil),
                                             self.numberOfPhotos
                                             ];
                break;
            }
                
            case JKImagePickerControllerFilterTypeVideos:{
                NSString *format = (self.numberOfVideos == 1) ? @"format_video" : @"format_videos";
                footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(format,
                                                                                                  @"JKImagePickerController",
                                                                                                  nil),
                                             self.numberOfVideos
                                             ];
                break;
            }
        }
        
        return footerView;
    }
    
    return nil;
}

#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-20)/3

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4, 6, 4, 6);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JKAssetsViewCell *cell = (JKAssetsViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell photoDidChecked];
//    [self browerPhotoes:self.assetsArray page:indexPath.row-1 isClickPreviewBtn:NO];
}

#pragma mark - getter
- (void)photoBrowser:(JKPhotoBrowser *)photoBrowser didSelectAtIndex:(NSInteger)index
{
//    ALAsset *asset = self.assetsArray[index];
//    NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
//    [self addAssetsObject:assetURL];
//    [self.selectedAssetIndexArray addObject:[NSNumber numberWithInteger:index]];
//    [self resetFinishFrame];
//    [self.collectionView reloadData];
    
}

- (void)photoBrowser:(JKPhotoBrowser *)photoBrowser didDeselectAtIndex:(NSInteger)index
{
    ALAsset *asset = self.assetsArray[index];
    NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    [self removeAssetsObject:assetURL];
//    [self.selectedAssetIndexArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSNumber *selectedAssetIndex = (NSNumber *)obj;
//        if ([selectedAssetIndex integerValue] == index) {
//            *stop = YES;
//            if (*stop == YES) {
//                [_selectedAssetIndexArray removeObject:obj];
//            }
//        }
//    }];
//    
    [self resetFinishFrame];
    [self.collectionView reloadData];
}
- (void)photoBrowserDidClickDoneButton:(JKPhotoBrowser *)photoBrowser withDeleteIndexArray:(NSArray *)array{
    [self batchDelectAssertsWithArray:array];
//    [self finishPhotoDidSelected];
}
- (BOOL)photoBrowserCheckDoneEnable:(JKPhotoBrowser *)photoBrowser{
    return !self.finishButton.hidden;
    
}
#pragma mark- UIImagePickerViewController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(self.needSquareCrop && self.maximumNumberOfSelection == 1) {
        [picker dismissViewControllerAnimated:NO completion:^{
            XTImageEditorViewController *editorController = [XTImageEditorViewController editorWithImage:image];
            editorController.delegate = self;
            [self.navigationController pushViewController:editorController animated:YES];
        }];
    }else {
    
//    __weak typeof(self) weakSelf = self;
    NSString  *assetsName = [self.selectAssetsGroup valueForProperty:ALAssetsGroupPropertyName];
    [[PhotoAlbumManager sharedManager] saveImage:image
                                         toAlbum:assetsName
                                 completionBlock:^(ALAsset *asset, NSError *error) {
                                     if (error == nil && asset) {
                                         NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
                                         [self addAssetsObject:assetURL];
                                         // 拍完照片开始刷新数据
                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                             // 跳转到胶卷页面
                                             self.afterTakingPhoto = YES;
                                             [self loadAssetsGroups];
                                             [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
                                         });
//                                         [weakSelf finishPhotoDidSelected];
                                     }
                                 }];
    
    [picker dismissViewControllerAnimated:NO completion:^{
        // 开始储存图片
        [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    }];
    }

    
}

#pragma mark - JKAssetsViewCellDelegate
- (void)startPhotoAssetsViewCell:(JKAssetsViewCell *)assetsCell
{
    if (self.selectedAssetArray.count>=self.maximumNumberOfSelection - self.alreadySelectedNumber) {
        NSString  *str = [NSString stringWithFormat:@"最多选择%@张照片",@(self.maximumNumberOfSelection)];
//        [JKPromptView showWithImageName:@"picker_alert_sigh" message:str];
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:str withCompletionBlock:nil];
        return;
    }
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        pickerController.allowsEditing = NO;
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerController animated:YES completion:^{
        }];
    }
}

- (void)didSelectItemAssetsViewCell:(JKAssetsViewCell *)assetsCell
{
    if (self.selectedAssetArray.count>=self.maximumNumberOfSelection - self.alreadySelectedNumber) {
        NSString  *str = [NSString stringWithFormat:@"最多选择%@张照片",@(self.maximumNumberOfSelection)];
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:str withCompletionBlock:nil];
    }
    
    BOOL  validate = [self validateMaximumNumberOfSelections:(self.selectedAssetArray.count + 1)];
    if (validate) {
        // Add asset URL
        NSURL *assetURL = [assetsCell.asset valueForProperty:ALAssetPropertyAssetURL];
        [self addAssetsObject:assetURL];
        [self.selectedAssetIndexArray addObject:assetsCell.assetIndex];
        [self resetFinishFrame];
        assetsCell.isSelected = YES;
    }

}

- (void)didDeselectItemAssetsViewCell:(JKAssetsViewCell *)assetsCell
{
    NSURL *assetURL = [assetsCell.asset valueForProperty:ALAssetPropertyAssetURL];
    [self removeAssetsObject:assetURL];
    [self.selectedAssetIndexArray removeObject:assetsCell.assetIndex];
    [self resetFinishFrame];
    assetsCell.isSelected = NO;


}

- (void)removeAssetsObject:(NSURL *)assetURL
{
    for (JKAssets *asset in self.selectedAssetArray) {
        if ([assetURL isEqual:asset.assetPropertyURL]) {
            [self.assetsGroupsView removeAssetSelected:asset];
            [self.selectedAssetArray removeObject:asset];
            break;
        }
    }
}

- (void)addAssetsObject:(NSURL *)assetURL
{
    NSURL *groupURL = [self.selectAssetsGroup valueForProperty:ALAssetsGroupPropertyURL];
    NSString *groupID = [self.selectAssetsGroup valueForProperty:ALAssetsGroupPropertyPersistentID];
    JKAssets  *asset = [[JKAssets alloc] init];
    asset.groupPropertyID = groupID;
    asset.groupPropertyURL = groupURL;
    asset.assetPropertyURL = assetURL;
    [self.selectedAssetArray addObject:asset];
    [self.assetsGroupsView addAssetSelected:asset];
}

- (BOOL)assetIsSelected:(NSURL *)assetURL
{
    for (JKAssets *asset in self.selectedAssetArray) {
        if ([assetURL isEqual:asset.assetPropertyURL]) {
            return YES;
        }
    }
    return NO;
}

- (void)resetFinishFrame
{
    self.finishButton.hidden = (self.selectedAssetArray.count<=0);
    self.finishLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.selectedAssetArray.count + self.alreadySelectedNumber),@(self.maximumNumberOfSelection)];
    [self.finishLabel sizeToFit];
    
//    self.finishButton.width = _finishLabel.width+10;
//    self.finishButton.right = self.view.width - 10;
//    self.finishLabel.centerX = _toolbar.centerX;
//    self.finishLabel.centerY = _toolbar.centerY;
    
    //self.navigationItem.rightBarButtonItem.enabled = (self.selectedAssetArray.count>0);
    self.previewButton.enabled = (self.selectedAssetArray.count>0);
}

#pragma mark - getter/setter
- (NSMutableArray *)selectedAssetArray{
    if (!_selectedAssetArray) {
        _selectedAssetArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedAssetArray;
}

- (NSMutableArray *)selectedAssetIndexArray{
    if (!_selectedAssetIndexArray) {
        _selectedAssetIndexArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedAssetIndexArray;
}

- (ALAssetsLibrary *)assetsLibrary{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (UIButton *)titleButton{
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(0, 0, 120, 30);
        UIImage  *img =[UIImage imageNamed:@"navigationbar_title_highlighted"];
        [_titleButton setBackgroundImage:nil forState:UIControlStateNormal];
        [_titleButton setBackgroundImage:[JKUtil stretchImage:img capInsets:UIEdgeInsetsMake(5, 2, 5, 2) resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
        [_titleButton addTarget:self action:@selector(assetsGroupDidSelected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

- (UIButton *)arrowImageView{
    if (!_arrowImageView) {
        UIImage  *img = [UIImage imageNamed:@"upload_arrow_down"];
        UIImage  *imgSelect = [UIImage imageNamed:@"upload_arrow_up"];
        _arrowImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _arrowImageView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        [_arrowImageView setBackgroundImage:img forState:UIControlStateNormal];
        [_arrowImageView setBackgroundImage:imgSelect forState:UIControlStateSelected];
        [self.titleButton addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self.titleButton addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (JKAssetsGroupsView *)assetsGroupsView{
    if (!_assetsGroupsView) {
        _assetsGroupsView = [[JKAssetsGroupsView alloc] initWithFrame:CGRectMake(0, -SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height)];
        _assetsGroupsView.delegate = self;
        _assetsGroupsView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_assetsGroupsView];
    }
    return _assetsGroupsView;
}

- (UIView *)overlayView{
    if (!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
        _overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85f];
        [self.view insertSubview:_overlayView belowSubview:self.assetsGroupsView];
    }
    return _overlayView;
}

- (UIButton *)touchButton{
    if (!_touchButton) {
        _touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _touchButton.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 64);
        [_touchButton addTarget:self action:@selector(assetsGroupsDidDeselected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touchButton;
}

//- (UIToolbar *)toolbar{
//    if (!_toolbar) {
//        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_SIZE.height-60-64, SCREEN_SIZE.width, 60)];
//        _toolbar.tintColor = [JKUtil getColor:@"f5f7fa"];
//        if ([_toolbar respondsToSelector:@selector(barTintColor)]) {
//            _toolbar.barTintColor = [JKUtil getColor:@"f5f7fa"];
//        }
//        _toolbar.translucent = YES;
//        _toolbar.userInteractionEnabled = YES;
//        
//        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _previewButton.frame = CGRectMake(10, 10, 40, 40);
//        [_previewButton setImage:[UIImage imageNamed:@"upload_preview"] forState:UIControlStateNormal];
//        [_previewButton setImage:[UIImage imageNamed:@"upload_preview_sel"] forState:UIControlStateHighlighted];
//        [_previewButton setImage:[UIImage imageNamed:@"upload_preview_sel"] forState:UIControlStateDisabled];
//        [_previewButton addTarget:self action:@selector(previewPhotoesSelected) forControlEvents:UIControlEventTouchUpInside];
//        [_toolbar addSubview:_previewButton];
//        
//        _finishLabel = [[UILabel alloc] init];
//        _finishLabel.backgroundColor = [UIColor clearColor];
//        _finishLabel.textColor = [UIColor grayColor];
//        _finishLabel.font = [UIFont systemFontOfSize:14];
//        _finishLabel.text = @"0/9";
//        [_finishLabel sizeToFit];
//        
//        _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _finishButton.frame = CGRectMake(0, 0, 40, 40);
//        [_finishButton setBackgroundImage:[UIImage imageNamed:@"upload_sure"] forState:UIControlStateNormal];
//        [_finishButton setBackgroundImage:[UIImage imageNamed:@"upload_sure_sel"]  forState:UIControlStateHighlighted];
//        _finishButton.xtright = SCREEN_SIZE.width-10;
//        _finishButton.xtcenterY = _previewButton.xtcenterY;
//        _finishButton.hidden = YES;
//        [_finishButton addTarget:self action:@selector(finishPhotoDidSelected) forControlEvents:UIControlEventTouchUpInside];
//        [_toolbar addSubview:_finishButton];
//        
//        _finishLabel.xtcenterY = 30.0;
//        _finishLabel.xtcenterX = SCREEN_SIZE.width/2;
//        [_toolbar addSubview:_finishLabel];
//        
//        [self.view addSubview:_toolbar];
//    }
//    return _toolbar;
//}
-(UIView *)toolbar{
    if (_toolbar == nil) {
        if ([UIDevice currentDevice].systemVersion.doubleValue > 8.0 ) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:effect];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:view];
            _toolbar = view;
        }else{
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:view];
            _toolbar = view;
        }
        _toolbar.frame = CGRectMake(0, SCREEN_SIZE.height-60-64, SCREEN_SIZE.width, 60);
        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _previewButton.frame = CGRectMake(10, 10, 40, 40);
        [_previewButton setImage:[UIImage imageNamed:@"upload_preview"] forState:UIControlStateNormal];
        [_previewButton setImage:[UIImage imageNamed:@"upload_preview_sel"] forState:UIControlStateHighlighted];
        [_previewButton setImage:[UIImage imageNamed:@"upload_preview_sel"] forState:UIControlStateDisabled];
        [_previewButton addTarget:self action:@selector(previewPhotoesSelected) forControlEvents:UIControlEventTouchUpInside];
        [_toolbar addSubview:_previewButton];
        
        _finishLabel = [[UILabel alloc] init];
        _finishLabel.backgroundColor = [UIColor clearColor];
        _finishLabel.textColor = [UIColor grayColor];
        _finishLabel.font = [UIFont systemFontOfSize:14];
        _finishLabel.text = @"0/9";
        [_finishLabel sizeToFit];
        
        _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishButton.frame = CGRectMake(0, 0, 40, 40);
        [_finishButton setBackgroundImage:[UIImage imageNamed:@"upload_sure"] forState:UIControlStateNormal];
        [_finishButton setBackgroundImage:[UIImage imageNamed:@"upload_sure_sel"]  forState:UIControlStateHighlighted];
        _finishButton.xtright = SCREEN_SIZE.width-10;
        _finishButton.xtcenterY = _previewButton.xtcenterY;
        _finishButton.hidden = YES;
        [_finishButton addTarget:self action:@selector(finishPhotoDidSelected) forControlEvents:UIControlEventTouchUpInside];
        [_toolbar addSubview:_finishButton];
        
        _finishLabel.xtcenterY = 30.0;
        _finishLabel.xtcenterX = SCREEN_SIZE.width/2;
        [_toolbar addSubview:_finishLabel];
        
        [self.view addSubview:_toolbar];
        
    }
    return _toolbar;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 4.0;
        layout.minimumInteritemSpacing = 4.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height-64) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[JKAssetsViewCell class] forCellWithReuseIdentifier:kJKImagePickerCellIdentifier];
        [_collectionView registerClass:[JKAssetsCollectionFooterView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:kJKAssetsFooterViewIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
        [self.view addSubview:_collectionView];
        
    }
    return _collectionView;
}

@end
