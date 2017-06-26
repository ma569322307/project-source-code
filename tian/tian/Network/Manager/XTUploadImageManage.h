//
//  XTUploadImageManage.h
//  StarPicture
//
//  Created by 曹亚云 on 15-3-4.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperationManager, XTUserFilesInfo;
typedef enum {
    XTUploadImageTypeAlbum = 0,     //上传图片到相册
    XTUploadImageTypeTopic,         //上传图片到话题
    XTUploadImageTypeHeadPortrait,  //上传头像
    XTUploadImageTypeHeadPortraitBg,//上传头像背景
    XTUploadImageTypeHeadTopic,     //上传话题头图
    XTUploadImageTypeHeadTopicUpdate//更新话题头图
} XTUploadImageType;

#define UploadImageSucceedNotification @"UploadImageSucceedNotification"

@interface XTUploadImageManage : NSObject
@property (nonatomic, strong) AFHTTPRequestOperationManager *uploadManager;
@property (nonatomic, strong) NSMutableDictionary *albumParameterDic;
@property (nonatomic, strong) XTUserFilesInfo *userFilesInfo;
@property (nonatomic, strong) NSMutableDictionary *topicParameterDic;
@property (nonatomic, strong) NSMutableString *imageInfoStr;
@property (nonatomic, assign) int imageCount;
@property (nonatomic, assign) BOOL isLastImage;
@property (nonatomic, assign) XTUploadImageType type;
@property (nonatomic, assign) BOOL isContinueUploadImage;
+ (id)shareUploadImageManage;
- (void)uploadAlbumImage:(NSMutableArray *)assetArray;//从相册选取图片上传
- (void)uploadImages:(NSArray *)photoArray;
- (void)uploadImagePicker:(UIImage *)image;//自己拍照上传
- (void)cancelOperation;//取消上传操作
@end
