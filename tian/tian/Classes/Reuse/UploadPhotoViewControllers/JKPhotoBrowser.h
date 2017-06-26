//
//  JKPhotoBrowser.h
//  JKPhotoBrowser
//
//  Created by Jecky on 14/12/29.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKImagePickerController.h"
typedef NS_ENUM(NSUInteger, JKPhotoBrowserType) {
    JKPhotoBrowserTypeAll,
    JKPhotoBrowserTypeSelected
};

@class JKPhotoBrowser;

@protocol JKPhotoBrowserDelegate <NSObject>
@optional
- (void)photoBrowser:(JKPhotoBrowser *)photoBrowser didSelectAtIndex:(NSInteger)index;
- (void)photoBrowser:(JKPhotoBrowser *)photoBrowser didDeselectAtIndex:(NSInteger)index;
- (void)photoBrowserDidClickDoneButton:(JKPhotoBrowser *)photoBrowser withDeleteIndexArray:(NSArray *)array;
- (BOOL)photoBrowserCheckDoneEnable:(JKPhotoBrowser *)photoBrowser;
@end

@interface JKPhotoBrowser : UIView

@property (nonatomic, weak) JKImagePickerController  *pickerController;
@property (nonatomic, weak) id<JKPhotoBrowserDelegate> delegate;

@property (nonatomic, strong) NSMutableArray      *assetsArray;
@property (nonatomic, strong) NSMutableArray      *assetsIndexArray;
@property (nonatomic, assign) JKPhotoBrowserType  type;

@property (nonatomic, assign) NSInteger    currentPage;


- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
