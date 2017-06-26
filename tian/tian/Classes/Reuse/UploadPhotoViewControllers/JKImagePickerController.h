//
//  JKImagePickerController.h
//  JKImagePicker
//
//  Created by Jecky on 15/1/9.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "JKAssets.h"
#import "UploadPhotoViewController.h"
typedef NS_ENUM(NSUInteger, JKImagePickerControllerFilterType) {
    JKImagePickerControllerFilterTypeNone,
    JKImagePickerControllerFilterTypePhotos,
    JKImagePickerControllerFilterTypeVideos
};

UIKIT_EXTERN ALAssetsFilter * ALAssetsFilterFromJKImagePickerControllerFilterType(JKImagePickerControllerFilterType type);

@class JKImagePickerController;

@protocol JKImagePickerControllerDelegate <NSObject>

@optional
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source;
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source;
- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker;
- (NSArray *)imagePickerControllerCheckRepeatNameList:(JKImagePickerController *)imagePicker;
@end

@interface JKImagePickerController : XTRootViewController

@property (nonatomic, weak) id<JKImagePickerControllerDelegate> delegate;
@property (nonatomic, assign) JKImagePickerControllerFilterType filterType;
@property (nonatomic, assign) BOOL showsCancelButton;
@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) BOOL needSquareCrop;
@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;
@property (nonatomic, assign) NSUInteger alreadySelectedNumber;
@property (nonatomic, strong) NSMutableArray     *selectedAssetArray;
@property (nonatomic, strong) NSMutableArray     *selectedAssetIndexArray;
@property (nonatomic, strong) NSMutableArray *oldArray;
@property (nonatomic, strong) NSMutableArray *oldIndexArray;
@property (nonatomic, assign, getter=isNeedPush) BOOL needPush;
// 判断从哪里过来
@property (nonatomic, assign,getter=isNeedPop) BOOL needPop;
//从图册跳转
@property (nonatomic, assign) XTUploadPhotoType type;
//相册信息
@property (nonatomic, strong) XTAlbumInfo *albumInfo;
@end
