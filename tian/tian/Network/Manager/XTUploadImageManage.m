//
//  XTUploadImageManage.m
//  StarPicture
//
//  Created by 曹亚云 on 15-3-4.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTUploadImageManage.h"
#import "JKAssets.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTSubStore.h"
#import "NSError+XTError.h"
#import "XTLocalPhotoModel.h"
#import "XTLocalImageStoreManage.h"
#import "XTUserFilesInfo.h"
#import "UIViewController+Extend.h"
#import "XTTabBarController.h"
#import "XTLocalImageStoreManage.h"
#define BaseUrl @"http://image.yinyuetai.com/edit"
static XTUploadImageManage *uploadImageManage;
@implementation XTUploadImageManage
+ (id)shareUploadImageManage
{
    @synchronized([XTUploadImageManage class])
    {
        if(!uploadImageManage)
        {
            uploadImageManage = [[XTUploadImageManage alloc] init];
            uploadImageManage.uploadManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
            uploadImageManage.uploadManager.operationQueue.maxConcurrentOperationCount = 1;
            uploadImageManage.imageInfoStr = [[NSMutableString alloc] initWithCapacity:0];
            uploadImageManage.isContinueUploadImage = YES;
        }
        return uploadImageManage;
    }
    return nil;
}

- (void)uploadAlbumImage:(NSMutableArray *)assetArray
{
    [UIViewController tabBarController].isImageUploadComplete = NO;
    self.imageCount = (int)[assetArray count];
    for (int pageNumber = 1; pageNumber <= [assetArray count]; pageNumber++) {
        JKAssets *asset = [assetArray objectAtIndex:pageNumber-1];
        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                [self uploadImage:image withIndex:pageNumber];
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
}

- (void)uploadImages:(NSArray *)photoArray
{
    [UIViewController tabBarController].isImageUploadComplete = NO;
    self.isContinueUploadImage = YES;
    self.imageCount = (int)[photoArray count];
    for (int pageNumber = 1; pageNumber <= [photoArray count]; pageNumber++) {
        if (self.isContinueUploadImage) {
            XTLocalPhotoModel *model = [photoArray objectAtIndex:pageNumber-1];
            UIImage *image = [[XTLocalImageStoreManage sharedLocalImageStoreManage] photoImageWithName:model.name];
            [self uploadImage:image withIndex:pageNumber];
        }else{
            return;
        }
    }
}

- (void)uploadImagePicker:(UIImage *)image
{
    [UIViewController tabBarController].isImageUploadComplete = NO;
    int pageNumber = 1;
    self.imageCount = pageNumber;
    [self uploadImage:image withIndex:pageNumber];
}

- (void)uploadImage:(UIImage *)image withIndex:(int)index
{
    if ([[XTHTTPRequestOperationManager sharedManager] reachable] == NO) {
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow
                         withText:@"网络未连接"
              withCompletionBlock:nil];
        [UIViewController tabBarController].isImageUploadComplete = YES;
        return;
    }
    NSData *contentData = UIImageJPEGRepresentation(image, 1);
    NSString *key = @"file";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss"; //设置日期格式
    NSString *fileName = [formatter stringFromDate:[NSDate date]];
    
    NSString *contentType = @"multipart/form-data";
    
    NSDictionary *parameters1 = nil;
    if (self.type == XTUploadImageTypeHeadPortrait) {
        parameters1 = [NSDictionary dictionaryWithObjectsAndKeys:
                       @"20x20,50x50,100x100,180x180", @"sizes",
                       @"file", @"srcImg",
                       @"scale", @"op",
                       @"1", @"uniform",
                       @"0", @"zoomUp", nil];
    }else{
        parameters1 = [NSDictionary dictionaryWithObjectsAndKeys:
                       @"320x0,640x0", @"sizes",
                       @"file", @"srcImg",
                       @"scale", @"op",
                       @"1", @"uniform",
                       @"0", @"zoomUp", nil];
    }
    NSDictionary *parameters2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"1", @"saveOriginal",
                                 @"save", @"op",
                                 @"starpicture", @"plan",
                                 @"0", @"belongId", nil];
    NSArray *parameArray = [NSArray arrayWithObjects:parameters1, parameters2, nil];
    NSData *jsonData = nil;
    if ([NSJSONSerialization isValidJSONObject:parameArray]){
        NSError *error = nil;
        jsonData = [NSJSONSerialization dataWithJSONObject:parameArray
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:jsonData, @"cmd", nil];
    AFHTTPRequestOperation *operation = [self.uploadManager POST:BaseUrl
                                                      parameters:dic
                                       constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:contentData
                                        name:key
                                    fileName:fileName
                                    mimeType:contentType];
        }
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"1111111111:上传接口返回数据：%@",responseObject);
            NSDictionary *dic = (NSDictionary *)responseObject;
            if (![dic objectForKey:@"images"]) {
                self.isContinueUploadImage = NO;
                [UIViewController tabBarController].isImageUploadComplete = YES;
                [self cancelOperation];
                [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"照片上传失败" withCompletionBlock:nil];
                return;
            }
            NSArray *array = [dic objectForKey:@"images"];
            NSDictionary *dic0 = [array objectAtIndex:0];
            NSDictionary *dic1 = @{
                                  [NSString stringWithFormat:@"images[%d].url",index-1]:[dic0 objectForKey:@"path"],
                                  [NSString stringWithFormat:@"images[%d].width",index-1]:[dic0 objectForKey:@"width"],
                                  [NSString stringWithFormat:@"images[%d].height",index-1]:[dic0 objectForKey:@"height"]
                                  };
            
            [self.albumParameterDic addEntriesFromDictionary:dic1];
            
            if (index == self.imageCount) {
                [UIViewController tabBarController].isImageUploadComplete = YES;                
                XTSubStore *subStore = [[XTSubStore alloc] init];
                switch (self.type) {
                    case XTUploadImageTypeAlbum:{
                        [subStore uploadImageToAlbum:self.albumParameterDic
                                     completionBlock:^(BOOL isSucceed, NSError *error) {
                                         [XTLocalImageStoreManage deletePhotoFolder];
                                         if (!error && isSucceed) {
                                             [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"照片上传成功" withCompletionBlock:^{
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlbumDetailNotification" object:nil];
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlbumListNotification" object:nil];
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlbumHeadNotification" object:nil];
                                             }];
                                         }else{
                                             NSString *result = [error xtErrorMessage];
                                             // 提示上传失败
                                             NSLog(@"上传图片失败:%@",result);
                                             if ([[result substringToIndex:4] isEqualToString:@"网络错误"]) {
                                                 result = @"网络错误,上传失败";
                                             }else if(result == nil){
                                                 result = @"上传失败";
                                             }
                                             [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:result withCompletionBlock:nil];
                                         }
                                     }];
                    }
                        break;
                    case XTUploadImageTypeHeadPortrait:{
                        /*
                        self.userFilesInfo.headImg = [NSURL URLWithString:[dic0 objectForKey:@"path"]];
                        [subStore editUserFilesWithUserFiles:self.userFilesInfo
                                             completionBlock:^(BOOL isSucceed, NSError *error) {
                                                 NSDictionary *dic = nil;
                                                 if (!error && isSucceed) {
                                                     dic = [NSDictionary dictionaryWithObjectsAndKeys:@"粉丝资料修改成功",@"message", nil];
                                                 }else{
                                                     dic = [NSDictionary dictionaryWithObjectsAndKeys:[error xtErrorMessage],@"message", nil];
                                                 }
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:UploadImageSucceedNotification object:dic];
                                             }];*/
                        NSURL *headImageURL = [NSURL URLWithString:[dic0 objectForKey:@"path"]];
                        [subStore editUserFilesWithHeadImg:headImageURL
                                           completionBlock:^(BOOL isSucceed, NSError *error) {
                                                 NSDictionary *dic = nil;
                                                 if (!error && isSucceed) {
                                                     dic = [NSDictionary dictionaryWithObjectsAndKeys:@"粉丝资料修改成功",@"message", nil];
                                                 }else{
                                                     dic = [NSDictionary dictionaryWithObjectsAndKeys:[error xtErrorMessage],@"message", nil];
                                                 }
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:UploadImageSucceedNotification object:dic];
                                             }];
                    }
                        break;
                    case XTUploadImageTypeHeadTopic:{
                        [self.topicParameterDic setObject:[dic0 objectForKey:@"path"] forKey:@"image"];
                        [subStore createTopic:self.topicParameterDic
                              completionBlock:^(BOOL isSucceed, NSError *error) {
                                                 NSDictionary *dic = nil;
                                                 if (!error && isSucceed) {
                                                     dic = [NSDictionary dictionaryWithObjectsAndKeys:@"照片上传成功",@"message", nil];
                                                 }else{
                                                     dic = [NSDictionary dictionaryWithObjectsAndKeys:[error xtErrorMessage],@"message", nil];
                                                 }
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:UploadImageSucceedNotification object:dic];
                                             }];
                    }
                        break;
                    case XTUploadImageTypeHeadPortraitBg:{
                        [subStore editUserHeadPortraitBg:[dic0 objectForKey:@"path"]
                                         completionBlock:^(BOOL isSucceed, NSError *error) {
                                  NSDictionary *dic = nil;
                                  if (!error && isSucceed) {
                                      dic = [NSDictionary dictionaryWithObjectsAndKeys:@"背景图片上传成功",@"message", nil];
                                  }else{
                                      dic = [NSDictionary dictionaryWithObjectsAndKeys:[error xtErrorMessage],@"message", nil];
                                  }
                                  [[NSNotificationCenter defaultCenter] postNotificationName:UploadImageSucceedNotification object:dic];
                              }];
                    }
                        break;
                    case XTUploadImageTypeTopic:{
                        [subStore uploadImageToTopic:self.albumParameterDic
                                     completionBlock:^(BOOL isSucceed, NSError *error) {
                                         NSDictionary *dic = nil;
                                         if (!error && isSucceed) {
                                             dic = [NSDictionary dictionaryWithObjectsAndKeys:@"照片上传成功",@"message", nil];
                                         }else{
                                             dic = [NSDictionary dictionaryWithObjectsAndKeys:[error xtErrorMessage],@"message", nil];
                                         }
                                         [[NSNotificationCenter defaultCenter] postNotificationName:UploadImageSucceedNotification object:dic];
                                     }];
                    }
                        break;
                    case XTUploadImageTypeHeadTopicUpdate:{
                        
                        [self.topicParameterDic setObject:[dic0 objectForKey:@"path"] forKey:@"image"];
                        [subStore updateTopicBgImage:self.topicParameterDic
                                     completionBlock:^(BOOL isSucceed, NSError *error) {
                                         NSDictionary *dic = nil;
                                         if (!error && isSucceed) {
                                             dic = [NSDictionary dictionaryWithObjectsAndKeys:@"照片上传成功",@"message", nil];
                                         }else{
                                             dic = [NSDictionary dictionaryWithObjectsAndKeys:[error xtErrorMessage],@"message", nil];
                                         }
                                         [[NSNotificationCenter defaultCenter] postNotificationName:UploadImageSucceedNotification object:dic];
                                     }];
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"2222222222:上传接口返回错误数据：%@",error);
            [UIViewController tabBarController].isImageUploadComplete = YES;//是否结束上传标识
            self.isContinueUploadImage = NO;//是否继续上传图片
            [self cancelOperation];//取消上传操作
            if (self.type == XTUploadImageTypeAlbum) {
                [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow
                                 withText:@"照片上传失败"
                      withCompletionBlock:^{
                          [XTLocalImageStoreManage deletePhotoFolder];//删除本地上传的图片
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadProgress"
                                                                              object:nil];//隐藏进度标签
                      }];
                
            }else{
                NSDictionary *dic = @{@"message": [error xtErrorMessage]};
                [[NSNotificationCenter defaultCenter] postNotificationName:UploadImageSucceedNotification
                                                                    object:dic];
            }
            return;
        }];
    if (self.type == XTUploadImageTypeAlbum) {
        [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                            long long totalBytesWritten,
                                            long long totalBytesExpectedToWrite) {
            NSLog(@"百分比:%f",totalBytesWritten*1.0/totalBytesExpectedToWrite);
            float percent = totalBytesWritten*1.0/totalBytesExpectedToWrite;
            int page = index;
            
            NSString *percentStr =[NSString stringWithFormat:@"%f",percent];
            if (page == self.imageCount && [percentStr intValue] == 1) {
                [self postProgress:percent currentPage:page totalPage:self.imageCount isLastImage:YES];
            }else{
                [self postProgress:percent currentPage:page totalPage:self.imageCount isLastImage:NO];
            }
        }];
    }
    
    /*传图的另一种方式
     // 1. Create `AFHTTPRequestSerializer` which will create your request.
     AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
     
     // 2. Create an `NSMutableURLRequest`.
     NSMutableURLRequest *request =
     [serializer multipartFormRequestWithMethod:@"POST"
     URLString:BaseUrl
     parameters:dic
     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
     [formData appendPartWithFileData:contentData
     name:key
     fileName:fileName
     mimeType:contentType];
     }];
     
     // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     manager.operationQueue.maxConcurrentOperationCount = 1;
     AFHTTPRequestOperation *operation =
     [manager HTTPRequestOperationWithRequest:request
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSLog(@"Success %@", responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"Failure %@", error.description);
     }];
     
     // 4. Set the progress block of the operation.
     [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
     long long totalBytesWritten,
     long long totalBytesExpectedToWrite) {
     NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
     }];
     
     // 5. Begin!
     [operation start];
     */
}

- (void)postProgress:(float)percent
         currentPage:(int)currentPage
           totalPage:(int)totalPage
         isLastImage:(BOOL)isLastImage
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:percent], @"percent",
                         [NSNumber numberWithInteger:currentPage], @"currentPage",[NSNumber numberWithInteger:totalPage], @"totalPage",[NSNumber numberWithBool:isLastImage], @"isLastImage", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadProgress" object:dic];
}

- (void)cancelOperation{
    [uploadImageManage.uploadManager.operationQueue cancelAllOperations];
}
@end
