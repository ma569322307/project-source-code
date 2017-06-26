//
//  XTShareManager.m
//  tianPicture
//
//  Created by 尚毅 杨 on 15/3/10.
//  Copyright (c) 2015年 cc. All rights reserved.
//


#import "XTShareManager.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>//QQ空间
#import "XTCommonMacro.h"
#import "XTUserStore.h"
#import "NSError+XTError.h"
//#import "XTHotStore.h"
#import "XTUserStore.h"
#import <SDWebImage/SDWebImageManager.h>
#import "XTShareImageDownloader.h"
#import "YYTAlertView.h"
#import "XTShareStatistic.h"
#define kOptypeKey @"optype"
#define kOpuidKey @"opuid"
#define kTokenKey  @"token"
#define kExpires_inKey @"expires_in"
#define kRedirectURI @"http://www.yinyuetai.com/tian/oauth2_callback"
#define kShareDefaultImage UIIMAGE(@"ShareIcon")
#define kShareBaseUrl @"http://m.yinyuetai.com/tian/"
#define kShareDownload @"http://www.yinyuetai.com/apps/app/v2?name=tian&channel=100001001"
#define kShareSinaID @"http://www.yinyuetai.com/apps/app/v2?name=tian&channel=100001001"

@interface XTShareManager ()
{
    void(^_loginBlock)();
//    XTHotStore *_store;
}
@end
//typedef void (^sinaloginBlock)(void);


@implementation XTShareManager
+ (instancetype)sharedManager
{
    static XTShareManager *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[self alloc] init];
    });
    return _shareManager;
}

- (id)init {
    self = [super init];
    if (self) {
        _tencentOAuth =[[TencentOAuth alloc] initWithAppId:@"1104332950" andDelegate:self];
        [WXApi registerApp:@"wxc8b1a54d24eb3e93" withDescription:@"舔~"];
        [WeiboSDK enableDebugMode:YES];
        [WeiboSDK registerApp:@"3583787489"];
//        _store = [[XTHotStore alloc] init];
    }
    return self;
}
- (void)shareWithTitle:(NSString *)title withMvDesc:(NSString *)desc withImage:(UIImage *)image withShareModeType:(XTShareModeType)modeType withPid:(long)pid withShareSheetType:(XTShareSheetItemType)type withCompletionBlock:(AlertViewBlock)completion{
    if (!image && modeType == XTShareModeTypePicture) {
        //        [self showTipViewWithTitle:@"分享图片不能为空" Type:TIP_ERROR];
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"分享图片不能为空" withCompletionBlock:nil];
        NSLog(@"%@",@"分享图片不能为空");
        return;
    }
    self.modeType = modeType;
    self.desc = desc;
    self.pid = pid;
    self.image = image;
    self.title = title;
    [XTShareSheet showWithType:type withCompletionBlock:^(NSInteger index) {
        if (index == 0) {
            //点击了取消
            if (completion) {
                completion(index);
            }
            return;
        }
        if (index == 1) {
            //处理微信分享
            NSLog(@"处理微信分享");
            [self shareWeiXinScene:WXSceneSession];
            return;
        }
        if (index == 2) {
            //处理朋友圈分享
            NSLog(@"处理朋友圈分享");
            [self shareWeiXinScene:WXSceneTimeline];
            return;
        }
        if (index == 3) {
            //处理QQ分享
            NSLog(@"处理QQ分享");
            [self shareQQFriend];
            return;
        }
        if (index == 4) {
            //处理QQ空间分享
            NSLog(@"处理QQ空间分享");
            [self shareQQzone];
            return;
        }
        if (index == 5) {
            //处理微博分享
            NSLog(@"处理微博分享");
            [self shareSinaAction];
            return;
        }
        // 其他按钮其他处理
        if (completion) {
            completion(index - kShareCollectionViewColumnNumber);
        }
    }];
}

- (void)shareWithMvDesc:(NSString *)desc withImage:(UIImage *)image withShareModeType:(XTShareModeType)modeType withPid:(long)pid withShareSheetType:(XTShareSheetItemType)type withCompletionBlock:(AlertViewBlock)completion
{
    [self shareWithTitle:nil withMvDesc:desc withImage:image withShareModeType:modeType withPid:pid withShareSheetType:type withCompletionBlock:completion];
}
//拼接所有分享内容
//typedef NS_ENUM (NSInteger, XTShareModeType) {
//    XTShareModeTypeAtlas,                   //设置分享
//    XTShareModeTypePicture,                 //图片详情分享
//    XTShareModeTypeTopicDetails,            //话题详情
//    XTShareModeTypeSeries,                  //系列内容分享页面
//    XTShareModeTypePicShare,                //独家原创分享页面
//    XTShareModeTypeStar,                    //专属艺人分享页面
//    XTShareModeTypeHotEvent,                //热点事件分享页面
//    XTShareModeTypeTopic,                   //热门话题分享页面
//    XTShareModeTypeBigV,                    //大V宣传分享页面
//    XTShareModeTypeGraphic                  //无用
//};

//-(void)createSinaShareInfo{
//    switch (self.modeType) {
//        case XTShareModeTypeAtlas:
//            
//            break;
//            
//        case XTShareModeTypePicture:
//            
//            break;
//            
//        case XTShareModeTypeTopicDetails:
//            
//            break;
//            
//        case XTShareModeTypeSeries:
//            
//            break;
//            
//        case XTShareModeTypePicShare:
//            
//            break;
//            
//        case XTShareModeTypeStar:
//            
//            break;
//            
//        case XTShareModeTypeHotEvent:
//            
//            break;
//            
//        case XTShareModeTypeTopic:
//            
//            break;
//            
//        case XTShareModeTypeBigV:
//            
//            break;
//            
//        case XTShareModeTypeGraphic:
//            
//            break;
//        
//    }
//}
//例子分享
//-(void)desStringByTypes{
//    NSString *url;
//    NSString *typeURL;
//    NSString *title;
//    NSString *des;
//    UIImage *image = self.image;
//    switch (self.modeType) {
//        case XTShareModeTypeAtlas:
//            url = @"http://www.yinyuetai.com/apps/app/v2?name=tian&channel=100001001";
//            des = [NSString stringWithFormat:@"这里有好多偶像的独家高清大图哟，我舔得好开心！做一只高端的舔屏饭就来舔吧！"];
//            title = @"舔";
//            image = [XTShareImageDownloader shareImage];
//            break;
//        
//        case XTShareModeTypePicture:
//            typeURL = @"pictureDetails";
//            url = [NSString stringWithFormat:@"%@%@PC?pid=%zd",typeURL,kShareBaseUrl,self.pid];
//            des = [NSString stringWithFormat:@"%@,食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！",self.desc];
//            title = @"分享的图片";
//            break;
//            
//        case XTShareModeTypeTopicDetails:
//            typeURL = @"topicDetails";
//            url = [NSString stringWithFormat:@"%@%@PC?pid=%zd",typeURL,kShareBaseUrl,self.pid];
//            des = [NSString stringWithFormat:@"%@,食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！",self.desc];
//            title = self.title;
//            break;
//            
//        case XTShareModeTypeSeries:
//            typeURL = @"seriesSharePage";
//            url = [NSString stringWithFormat:@"%@%@PC?pid=%zd",typeURL,kShareBaseUrl,self.pid];
//            des = [NSString stringWithFormat:@"%@",self.desc];
//            title = self.title;
//            break;
//            
//        case XTShareModeTypePicShare:
//            typeURL = @"picSharePage";
//            url = [NSString stringWithFormat:@"%@%@PC?pid=%zd",typeURL,kShareBaseUrl,self.pid];
//            if (self.desc.length <= 0) {
//                des = @"食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！";
//            }else{
//                des = self.title;
//            }
//            des = [NSString stringWithFormat:@"%@",des];
//            title = self.title;
//            break;
//            
//        case XTShareModeTypeStar:
//            typeURL = @"starPage";
//            url = [NSString stringWithFormat:@"%@%@PC?pid=%zd",typeURL,kShareBaseUrl,self.pid];
//            des = [NSString stringWithFormat:@"%@",self.desc];
//            title = self.title;
//            break;
//            
//        case XTShareModeTypeHotEvent:
//            typeURL = @"hotEventPage";
//            url = [NSString stringWithFormat:@"%@%@PC?pid=%zd",typeURL,kShareBaseUrl,self.pid];
//            des = [NSString stringWithFormat:@"%@",self.desc];
//            title = self.title;
//            break;
//            
//        case XTShareModeTypeTopic:
//            typeURL = @"topicShare";
//            url = [NSString stringWithFormat:@"%@%@PC?pid=%zd",typeURL,kShareBaseUrl,self.pid];
//            des = [NSString stringWithFormat:@"食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！"];
//            title = self.title;
//            break;
//            
//        case XTShareModeTypeBigV:
//            typeURL = @"vSharePage";
//            url = [NSString stringWithFormat:@"%@%@PC?pid=%zd",typeURL,kShareBaseUrl,self.pid];
//            des = [NSString stringWithFormat:@"%@",self.desc];
//            title = self.title;
//            break;
//            
//        case XTShareModeTypeGraphic:
//            break;
//    }
//}

-(void)createShareInfo{
    NSString *url;
    NSString *typeURL;
    NSString *des;
    WBMessageObject *message = [WBMessageObject message];
    UIImage *image = self.image;
    NSData *dataObj;
    WBImageObject *imageObj;
    // 描述截取长度
    self.desc = [self checkLengthWithString:self.desc];
    
    // 分享统计
    NSString *platform = kPlatformSINAWEIBO;
    NSString *datatype = [self shareTypeStringWithType:self.modeType];
    NSInteger dataId = self.pid;
    [[XTShareStatistic sharedShareStatistic] setShareValueWithPlatform:platform datatype:datatype dataId:dataId];
//    NSString *s =;
    switch (self.modeType) {
        case XTShareModeTypeAtlas:
            url = kShareDownload;
            des = [NSString stringWithFormat:@"#舔APP# 这里有好多偶像的独家高清大图哟，我舔得好开心！做一只高端的舔屏饭就来舔吧！@舔APP %@",url];
            //分享内容
            dataObj = UIImageJPEGRepresentation([UIImage imageNamed:@"ShareSinaImage.jpg"], 1.0);
            message.text = des;
            imageObj = [WBImageObject object];
            imageObj.imageData = dataObj;
            message.imageObject = imageObj;
            break;
            
        case XTShareModeTypePicture:
            typeURL = @"pictureDetails";
            url = [NSString stringWithFormat:@"%@%@PC?pid=%zd",kShareBaseUrl,typeURL,self.pid];
            des = [NSString stringWithFormat:@"#舔App# %@%@ @舔APP>>>%@",self.desc,[self checkCommondWithString:self.desc],url];
            //分享内容
            dataObj = UIImageJPEGRepresentation(image, 1.0);
            message.text = des;
            imageObj = [WBImageObject object];
            imageObj.imageData = dataObj;
            message.imageObject = imageObj;
            break;
            
        case XTShareModeTypeTopicDetails:
            typeURL = @"topicDetails";
            url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
            des = [NSString stringWithFormat:@"#舔App# %@%@ @舔APP>>>%@",self.desc,[self checkCommondWithString:self.desc],url];
            //分享内容
            dataObj = UIImageJPEGRepresentation(image, 1.0);
            message.text = des;
            imageObj = [WBImageObject object];
            imageObj.imageData = dataObj;
            message.imageObject = imageObj;
            break;
            
        case XTShareModeTypeSeries:
            typeURL = @"seriesSharePage";
            url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
            des = [NSString stringWithFormat:@"#舔App# %@ %@ @舔APP>>>%@",self.desc,[self checkCommondWithString:self.desc],url];
            //分享内容
            dataObj = UIImageJPEGRepresentation(image, 1.0);
            message.text = des;
            imageObj = [WBImageObject object];
            imageObj.imageData = dataObj;
            message.imageObject = imageObj;
            break;
            
        case XTShareModeTypePicShare:
            typeURL = @"picSharePage";
            url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
            des = [NSString stringWithFormat:@"#舔App# %@ %@ @舔APP>>>%@",self.desc,[self checkCommondWithString:self.desc],url];
            //分享内容
            dataObj = UIImageJPEGRepresentation(image, 1.0);
            message.text = des;
            imageObj = [WBImageObject object];
            imageObj.imageData = dataObj;
            message.imageObject = imageObj;
            break;
            
        case XTShareModeTypeStar:
            typeURL = @"starPage";
            url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
            des = [NSString stringWithFormat:@"#舔App# %@ %@ @舔APP>>>%@",self.desc,[self checkCommondWithString:self.desc],url];
            //分享内容
            dataObj = UIImageJPEGRepresentation(image, 1.0);
            message.text = des;
            imageObj = [WBImageObject object];
            imageObj.imageData = dataObj;
            message.imageObject = imageObj;
            break;
            
        case XTShareModeTypeHotEvent:
            typeURL = @"hotEventPage";
            url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
            des = [NSString stringWithFormat:@"#舔App# %@ %@ @舔APP>>>%@",self.desc,[self checkCommondWithString:self.desc],url];
            //分享内容
            dataObj = UIImageJPEGRepresentation(image, 1.0);
            message.text = des;
            imageObj = [WBImageObject object];
            imageObj.imageData = dataObj;
            message.imageObject = imageObj;
            break;
            
        case XTShareModeTypeTopic:
            typeURL = @"topicShare";
            url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
            des = [NSString stringWithFormat:@"#舔App# %@ %@ @舔APP>>>%@",self.desc,[self checkCommondWithString:self.desc],url];
            //分享内容
            dataObj = UIImageJPEGRepresentation(image, 1.0);
            message.text = des;
            imageObj = [WBImageObject object];
            imageObj.imageData = dataObj;
            message.imageObject = imageObj;
            break;
            
        case XTShareModeTypeBigV:
            typeURL = @"vSharePage";
            url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
            des = [NSString stringWithFormat:@"#舔App# %@ %@ @舔APP>>>%@",self.desc,[self checkCommondWithString:self.desc],url];
            //分享内容
            dataObj = UIImageJPEGRepresentation(image, 1.0);
            message.text = des;
            imageObj = [WBImageObject object];
            imageObj.imageData = dataObj;
            message.imageObject = imageObj;
            break;
    }
    //    //开始分享
    //    NSData *dataObj = UIImageJPEGRepresentation(image, 0.3);
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    
    NSLog(@"跳转网址%@",url);
    NSLog(@"分享的内容%@",des);
    NSLog(@"分享内容的长度%zd",self.desc.length);
    NSLog(@"分享内容的长度%zd",des.length);
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    
    [WeiboSDK sendRequest:request];
    
    // 分享统计记录
    
}
-(NSString *)checkCommondWithString:(NSString *)string{
    if (string.length == 0) {
        return @"食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！";
    }else
    {
        return @" 食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！";
    }
}

-(NSString *)checkLengthWithString:(NSString *)string{
    if (string.length >= 40) {
        NSString *result = [string substringToIndex:40];
        return [NSString stringWithFormat:@"%@...",result];
    }else{
        return string;
    }
}
// 网页分享不可行版（URL需要改变）
//-(void)createShareInfo{
//    NSString *url;
//    NSString *typeURL;
//    NSString *des;
//    WBMessageObject *message = [WBMessageObject message];
//    UIImage *image = self.image;
//    NSData *dataObj;
//    WBImageObject *imageObj;
//    WBWebpageObject *webObj;
//    switch (self.modeType) {
//        case XTShareModeTypeAtlas:
//            url = kShareDownload;
//            des = [NSString stringWithFormat:@"#舔APP# 这里有好多偶像的独家高清大图哟，我舔得好开心！做一只高端的舔屏饭就来舔吧！@舔APP %@",url];
//            image = [XTShareImageDownloader shareImage];
//            //分享内容
//            dataObj = UIImageJPEGRepresentation(image, 1);
//            message.text = des;
//            imageObj = [WBImageObject object];
//            imageObj.imageData = dataObj;
//            message.imageObject = imageObj;
//            break;
//            
//        case XTShareModeTypePicture:
//            typeURL = @"pictureDetails";
//            url = [NSString stringWithFormat:@"%@%@PC?pid=%zd",kShareBaseUrl,typeURL,self.pid];
//            des = [NSString stringWithFormat:@"#舔App# %@ 食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！@舔APP>>>%@",self.desc,url];
//            //分享内容
//            dataObj = UIImageJPEGRepresentation(image, 1);
//            message.text = des;
//            imageObj = [WBImageObject object];
//            imageObj.imageData = dataObj;
//            message.imageObject = imageObj;
//            break;
//            
//        case XTShareModeTypeTopicDetails:
//            typeURL = @"topicDetails";
//            url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
//            des = [NSString stringWithFormat:@"%@ 食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！@舔APP>>>%@",self.desc,url];
//            //分享内容
//            dataObj = UIImageJPEGRepresentation(image, 1);
//            message.text = des;
//            imageObj = [WBImageObject object];
//            imageObj.imageData = dataObj;
//            message.imageObject = imageObj;
//            break;
//            
//        case XTShareModeTypeSeries:
//            typeURL = @"seriesSharePage";
//            url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
//            // 分享内容
//            dataObj = UIImageJPEGRepresentation(image, 0.3);
//            message.text = [NSString stringWithFormat:@"%@ 食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！@舔APP",self.title];
//            webObj = [[WBWebpageObject alloc] init];
//            webObj.objectID = kShareSinaID;
//            webObj.title = self.title;
//            webObj.description = self.desc;
//            webObj.thumbnailData = dataObj;
//            webObj.webpageUrl = url;
//            message.mediaObject = webObj;
//            break;
//            
//        case XTShareModeTypePicShare:
//            typeURL = @"picSharePage";
//            url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
//            if (self.desc.length <= 0) {
//                des = @"食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！";
//            }else{
//                des = self.desc;
//            }
//            url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
//            // 分享内容
//            dataObj = UIImageJPEGRepresentation(image, 0.3);
//            message.text = [NSString stringWithFormat:@"%@ 食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！@舔APP",self.title];
//            webObj = [[WBWebpageObject alloc] init];
//            webObj.objectID = kShareSinaID;
//            webObj.title = self.title;
//            webObj.description = des;
//            webObj.thumbnailData = dataObj;
//            webObj.webpageUrl = url;
//            message.mediaObject = webObj;
//            break;
//            
//        case XTShareModeTypeStar:
//            typeURL = @"starPage";
//            url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
//            // 分享内容
//            dataObj = UIImageJPEGRepresentation(image, 0.3);
//            message.text = [NSString stringWithFormat:@"%@ 食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！@舔APP",self.title];
//            webObj = [[WBWebpageObject alloc] init];
//            webObj.objectID = kShareSinaID;
//            webObj.title = self.title;
//            webObj.description = des;
//            webObj.thumbnailData = dataObj;
//            webObj.webpageUrl = url;
//            message.mediaObject = webObj;
//            break;
//            
//        case XTShareModeTypeHotEvent:
//            typeURL = @"hotEventPage";
//            url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
//            // 分享内容
//            dataObj = UIImageJPEGRepresentation(image, 0.3);
//            message.text = [NSString stringWithFormat:@"%@ 食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！@舔APP",self.title];
//            webObj = [[WBWebpageObject alloc] init];
//            webObj.objectID = kShareSinaID;
//            webObj.title = self.title;
//            webObj.description = des;
//            webObj.thumbnailData = dataObj;
//            webObj.webpageUrl = url;
//            message.mediaObject = webObj;
//            break;
//            
//        case XTShareModeTypeTopic:
//            typeURL = @"topicShare";
//            url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
//            // 分享内容
//            dataObj = UIImageJPEGRepresentation(image, 0.3);
//            message.text = [NSString stringWithFormat:@"%@ 食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！@舔APP",self.title];
//            webObj = [[WBWebpageObject alloc] init];
//            webObj.objectID = kShareSinaID;
//            webObj.title = self.title;
//            webObj.description = des;
//            webObj.thumbnailData = dataObj;
//            webObj.webpageUrl = url;
//            message.mediaObject = webObj;
//            break;
//            
//        case XTShareModeTypeBigV:
//            typeURL = @"vSharePage";
//            url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
//            // 分享内容
//            dataObj = UIImageJPEGRepresentation(image, 0.3);
//            message.text = [NSString stringWithFormat:@"%@ 食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！@舔APP",self.title];
//            webObj = [[WBWebpageObject alloc] init];
//            webObj.objectID = kShareSinaID;
//            webObj.title = self.title;
//            webObj.description = des;
//            webObj.thumbnailData = dataObj;
//            webObj.webpageUrl = url;
//            message.mediaObject = webObj;
//            break;
//            
//        case XTShareModeTypeGraphic:
//            break;
//    }
////    //开始分享
////    NSData *dataObj = UIImageJPEGRepresentation(image, 0.3);
//    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
//    authRequest.redirectURI = kRedirectURI;
//    authRequest.scope = @"all";
//    
//    NSLog(@"跳转网址%@",url);
//    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
//    
//    [WeiboSDK sendRequest:request];
//}
#pragma mark - 新浪微博
- (BOOL)isInstallSina {
    if (![WeiboSDK isWeiboAppInstalled]) {
//        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您还没有安装新浪微博，要下载安装吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//        msgbox.tag = 829;
//        [msgbox show];
        [YYTAlertView showHalfTypeAlertViewWithTitle:@"温馨提示" message:@"你还没有安装新浪微博客户端！" completaionBlock:^(NSInteger index) {
            
        }];
        return NO;
    }
    return YES;
}
- (void)shareSinaAction {
    if (![self isInstallSina]) {
        return;
    }
    [self createShareInfo];
////    NSString *title = nil;
//    NSString *desc = nil;
//    UIImage *image = nil;
//    NSString *url = nil;
//    if (_modeType == XTShareModeTypePicture) {
////        title = @"分享图片";
//        if (_desc.length > 0) {
//            desc = _desc;
//        }else{
//            desc = @"舔了一张";
//        }
//        url = [NSString stringWithFormat:@"http://m.yinyuetai.com/tian/wap?id=%ld&type=2",self.pid];
//        desc = [NSString stringWithFormat:@"%@ 图是@音悦台-舔来的>>%@",desc,url];
//        image = self.image;
//        //图片分享统计
//        if ([[XTUserStore sharedManager] isLogin]) {
////            [_store shareStatisticsFromPlatform:@"SINA" withSourceId:self.pid completionBlock:^(id newsData, NSError *error) {
////                NSLog(@"%@, %@", newsData, error);
////            }];
//        }
//    }else if (_modeType == XTShareModeTypeGraphic) {
////        title = @"分享图文";
//        url = [NSString stringWithFormat:@"http://m.yinyuetai.com/tian/wap?id=%ld&type=1",self.pid];
//        desc = [NSString stringWithFormat:@"打开舔TIAN，偶像们咻的一下就来了，捧起花痴脸，我的偶像，我要舔舔舔舔舔！ >>%@",url];
//        image = [XTShareImageDownloader shareImage];
//    }else if (_modeType == XTShareModeTypeAtlas) {
////        title = @"分享图册";
//        desc = [NSString stringWithFormat:@"这里有好多偶像的独家高清大图 哟，我舔的好开心！做一只高端的舔屏饭就来舔TIAN吧！下载地址：%@",@"http://itunes.apple.com/cn/app/id973879340?mt=8"];
//        image = [XTShareImageDownloader shareImage];
//    }
//    NSData *dataObj = UIImageJPEGRepresentation(image, 1.0);
//    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
//    authRequest.redirectURI = kRedirectURI;
//    authRequest.scope = @"all";
//    
//    WBMessageObject *message = [WBMessageObject message];
//    message.text = desc;
//    
//    WBImageObject *imageObj = [WBImageObject object];
//    imageObj.imageData = dataObj;
//    message.imageObject = imageObj;
//    
//    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
//    [WeiboSDK sendRequest:request];
}

- (void)ssoSinaLogin:(void (^)(void))block
{
    if (![self isInstallSina]) {
        return;
    }
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
    _loginBlock = block;
}

#pragma mark - QQ空间
- (BOOL)isInstallQQ:(NSString *)desc {
    if (![QQApi isQQInstalled]) {
        NSString *des = [NSString stringWithFormat:@"你还没有安装QQ客户端！"];
//        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:des delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//        msgbox.tag = 831;
//        [msgbox show];
        [YYTAlertView showHalfTypeAlertViewWithTitle:@"温馨提示" message:des completaionBlock:^(NSInteger index) {
            
        }];
        return NO;
    }
    return YES;
}
- (void)shareQQzone {
    if (![self isInstallQQ:@"QQ空间"]) {
        return;
    }
//    NSString *title = nil;
//    NSString *desc = nil;
//    UIImage *image = nil;
//    NSURL *url = nil;
//    if (_modeType == XTShareModeTypePicture) {
//        title = @"分享图片";
//        if (_desc.length > 0) {
//            desc = _desc;
//        }else{
//            desc = @"分享一张图片";
//        }
//        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yinyuetai.com/tian/wap?id=%ld&type=2",self.pid]];
//        image = self.image;
//        //图片分享统计
//        if ([[XTUserStore sharedManager] isLogin]) {
////            [_store shareStatisticsFromPlatform:@"QZONE" withSourceId:self.pid completionBlock:^(id newsData, NSError *error) {
////                NSLog(@"%@, %@", newsData, error);
////            }];
//        }
//
//    }else if (_modeType == XTShareModeTypeGraphic) {
//        title = @"分享图文";
//        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yinyuetai.com/tian/wap?id=%ld&type=1",self.pid]];
//        desc = @"打开舔TIAN，偶像们咻的一下就来了，捧起花痴脸，我的偶像，我要舔舔舔舔舔！";
//        image = kShareDefaultImage;
//    }else if (_modeType == XTShareModeTypeAtlas) {
//        image = kShareDefaultImage;
//        title = @"分享图册";
//        desc = @"这里有好多偶像的独家高清大图 哟，我舔的好开心！做一只高端的舔屏饭就来舔TIAN吧！";
//        url = [NSURL URLWithString:@"http://itunes.apple.com/cn/app/id973879340?mt=8"];
//    }
    NSString *url;
    NSString *typeURL;
    NSString *title;
    NSString *des;
    UIImage *image = self.image;
    
    // 分享统计
    NSString *platform = kPlatformQZONE;
    NSString *datatype = [self shareTypeStringWithType:self.modeType];
    NSInteger dataId = self.pid;
    [[XTShareStatistic sharedShareStatistic] setShareValueWithPlatform:platform datatype:datatype dataId:dataId];
    switch (self.modeType) {
        case XTShareModeTypeAtlas:
            
            des = [NSString stringWithFormat:@"这里有好多偶像的独家高清大图哟，我舔得好开心！做一只高端的舔屏饭就来舔吧！"];
            title = @"舔";
            image = kShareDefaultImage;
            break;
            
        case XTShareModeTypePicture:
            typeURL = @"pictureDetails";
            des = [NSString stringWithFormat:@"%@ 食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！",self.desc];
            title = @"分享的图片";
            break;
            
        case XTShareModeTypeTopicDetails:
            typeURL = @"topicDetails";
            des = [NSString stringWithFormat:@"%@ 食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！",self.desc];
            title = self.title;
            break;
            
        case XTShareModeTypeSeries:
            typeURL = @"seriesSharePage";
            des = [NSString stringWithFormat:@"%@",self.desc];
            title = self.title;
            break;
            
        case XTShareModeTypePicShare:
            typeURL = @"picSharePage";
            if (self.desc.length <= 0) {
                des = @"食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！";
            }else{
                des = self.desc;
            }
            des = [NSString stringWithFormat:@"%@",des];
            title = self.title;
            break;
            
        case XTShareModeTypeStar:
            typeURL = @"starPage";
            des = [NSString stringWithFormat:@"%@",self.desc];
            title = self.title;
            break;
            
        case XTShareModeTypeHotEvent:
            typeURL = @"hotEventPage";
            des = [NSString stringWithFormat:@"%@",self.desc];
            title = self.title;
            break;
            
        case XTShareModeTypeTopic:
            typeURL = @"topicShare";
            des = [NSString stringWithFormat:@"食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！"];
            title = self.title;
            break;
            
        case XTShareModeTypeBigV:
            typeURL = @"vSharePage";

            des = [NSString stringWithFormat:@"%@",self.desc];
            title = self.title;
            break;
    }
    //开始分享
    NSData *dataObj;
    if(self.modeType == XTShareModeTypePicture){
        url = [NSString stringWithFormat:@"%@%@PC?pid=%zd",kShareBaseUrl,typeURL,self.pid];
        dataObj = UIImageJPEGRepresentation(image, 1.0);
    }else if (self.modeType != XTShareModeTypeAtlas) {
        dataObj = UIImageJPEGRepresentation(image, 0.3);
        url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
    }else{
        dataObj = UIImageJPEGRepresentation(image, 1.0);
        url = kShareDownload;
    }
    NSLog(@"跳转网址%@",url);
    NSLog(@"分享的标题%@",title);
    NSLog(@"分享的内容%@",des);
    NSURL *urlLink = [NSURL URLWithString:url];
    QQApiVideoObject *videoObj = [QQApiVideoObject objectWithURL:urlLink
                                                           title:title
                                                     description:des
                                                 previewImageData:dataObj];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:videoObj];
    QQApiSendResultCode sent = 0;
    sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];
}

/**
 *
 *   QQsso登录
 */
- (void)ssoQQLogin:(void (^)(void))block
{
    if (![self isInstallQQ:@"QQ"]) {
        return;
    }
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_IDOL,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_PIC_T,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_DEL_IDOL,
                            kOPEN_PERMISSION_DEL_T,
                            kOPEN_PERMISSION_GET_FANSLIST,
                            kOPEN_PERMISSION_GET_IDOLLIST,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_GET_REPOST_LIST,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                            kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                            nil];
    
    [_tencentOAuth authorize:permissions inSafari:NO];
    _loginBlock = block;
}

#pragma mark - QQ好友
- (void)shareQQFriend {
    if (![QQApi isQQInstalled]) {
//        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您还没有安装QQ，要下载安装吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//        msgbox.tag = 831;
//        [msgbox show];
        [YYTAlertView showHalfTypeAlertViewWithTitle:@"温馨提示" message:@"你还没有安装QQ客户端！" completaionBlock:^(NSInteger index) {
            
        }];
        return;
    }
//    NSString *title = nil;
//    NSString *desc = nil;
//    UIImage *image = nil;
//    NSURL *url = nil;
//    if (_modeType == XTShareModeTypePicture) {
//        title = @"分享图片";
//        if (_desc.length > 0) {
//            desc = _desc;
//        }else{
//            desc = @"分享一张图片";
//        }
//        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yinyuetai.com/tian/wap?id=%ld&type=2",self.pid]];
//        image = self.image;
//        //图片分享统计
//        if ([[XTUserStore sharedManager] isLogin]) {
////            [_store shareStatisticsFromPlatform:@"QQ" withSourceId:self.pid completionBlock:^(id newsData, NSError *error) {
////                NSLog(@"%@, %@", newsData, error);
////            }];
//        }
//
//    }else if (_modeType == XTShareModeTypeGraphic) {
//        title = @"分享图文";
//        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yinyuetai.com/tian/wap?id=%ld&type=1",self.pid]];
//        desc = @"打开舔TIAN，偶像们咻的一下就来了，捧起花痴脸，我的偶像，我要舔舔舔舔舔！";
//        image = kShareDefaultImage;
//    }else if (_modeType == XTShareModeTypeAtlas) {
//        image = kShareDefaultImage;
//        title = @"分享图册";
//        desc = @"这里有好多偶像的独家高清大图 哟，我舔的好开心！做一只高端的舔屏饭就来舔TIAN吧！";
//        url = [NSURL URLWithString:@"http://itunes.apple.com/cn/app/id973879340?mt=8"];
//    }
    NSString *url;
    NSString *typeURL;
    NSString *title;
    NSString *des;
    UIImage *image = self.image;
    
    // 分享统计
    NSString *platform = kPlatformQQ;
    NSString *datatype = [self shareTypeStringWithType:self.modeType];
    NSInteger dataId = self.pid;
    [[XTShareStatistic sharedShareStatistic] setShareValueWithPlatform:platform datatype:datatype dataId:dataId];
    switch (self.modeType) {
        case XTShareModeTypeAtlas:
            url = kShareDownload;
            des = [NSString stringWithFormat:@"这里有好多偶像的独家高清大图哟，我舔得好开心！做一只高端的舔屏饭就来舔吧！"];
            title = @"舔";
            image = kShareDefaultImage;
            break;
            
        case XTShareModeTypePicture:
            typeURL = @"pictureDetails";
            des = [NSString stringWithFormat:@"%@ 食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！",self.desc];
            title = @"分享的图片";
            break;
            
        case XTShareModeTypeTopicDetails:
            typeURL = @"topicDetails";
            des = [NSString stringWithFormat:@"%@ 食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！",self.desc];
            title = self.title;
            break;
            
        case XTShareModeTypeSeries:
            typeURL = @"seriesSharePage";
            des = [NSString stringWithFormat:@"%@",self.desc];
            title = self.title;
            break;
            
        case XTShareModeTypePicShare:
            typeURL = @"picSharePage";
            if (self.desc.length <= 0) {
                des = @"食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！";
            }else{
                des = self.desc;
            }
            des = [NSString stringWithFormat:@"%@",des];
            title = self.title;
            break;
            
        case XTShareModeTypeStar:
            typeURL = @"starPage";
            des = [NSString stringWithFormat:@"%@",self.desc];
            title = self.title;
            break;
            
        case XTShareModeTypeHotEvent:
            typeURL = @"hotEventPage";
            des = [NSString stringWithFormat:@"%@",self.desc];
            title = self.title;
            break;
            
        case XTShareModeTypeTopic:
            typeURL = @"topicShare";
            des = [NSString stringWithFormat:@"食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！"];
            title = self.title;
            break;
            
        case XTShareModeTypeBigV:
            typeURL = @"vSharePage";
            des = [NSString stringWithFormat:@"%@",self.desc];
            title = self.title;
            break;
    }
    //开始分享
    NSData *dataObj;
    if(self.modeType == XTShareModeTypePicture){
        url = [NSString stringWithFormat:@"%@%@PC?pid=%zd",kShareBaseUrl,typeURL,self.pid];
        dataObj = UIImageJPEGRepresentation(image, 1.0);
    }else if (self.modeType != XTShareModeTypeAtlas) {
        dataObj = UIImageJPEGRepresentation(image, 0.3);
        url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
    }else{
        dataObj = UIImageJPEGRepresentation(image, 1.0);
        url = kShareDownload;
    }
    NSLog(@"分享的网址%@",url);
    NSLog(@"分享的标题%@",title);
    NSLog(@"分享的内容%@",des);
    NSURL *urlLink = [NSURL URLWithString:url];
    QQApiVideoObject *videoObj = [QQApiVideoObject objectWithURL:urlLink
                                                           title:title
                                                     description:des
                                                previewImageData:dataObj];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:videoObj];
    QQApiSendResultCode sent = 0;
    sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

#pragma mark - 微信分享
- (void)WXLogin:(void (^)(void))block
{
    SendAuthReq *req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"1024";
    [WXApi sendReq:req];
    _loginBlock = block;
}
- (void)weiXinLoginWithToken:(NSString *)token opuid:(NSString*)opuid
{
//        NSLog(@"========> %s, %@",__func__, token);
        NSMutableDictionary *authData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         token,@"token",
                                         opuid,@"opuid",
                                         @"WEIXIN",@"optype",nil];
        NSLog(@"%@",authData);
        [[XTUserStore sharedManager] loginFromSocialPlatform:authData Withcompletion:^(id user, NSError *error) {
//            NSLog(@"%@, error :%@",user,  error);
            if (!error) {
                [YYTHUD showPromptAddedTo:XTKeyWindow withText:@"登录成功" withCompletionBlock:^{
                    if (_loginBlock) {
                        _loginBlock();
                    }
                }];
            }else{
                [YYTHUD showPromptAddedTo:XTKeyWindow withText:@"登录失败" withCompletionBlock:nil];
                
            }
            
        }];
    
}
- (void)getWXAccessTokenWithCode:(NSString *)wxCode
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",APPID_WeiXin,APPSecret_WeiXin,wxCode];
    __weak XTShareManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 "expires_in" = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 */
                
                NSString * access_token = [dic objectForKey:@"access_token"];
                NSString * openid = [dic objectForKey:@"openid"];
                [weakSelf weiXinLoginWithToken:access_token opuid:openid];
                
            }
        });
    });  
}

- (void)shareWeiXinScene:(int)scene {
//    m.yinyuetai.com/tian/wap?id={id}&type=2
//    type =1  是图文   =2 是图片
    if (![WXApi isWXAppInstalled]) {
//        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您还没有安装微信，要下载安装吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//        msgbox.tag = 834;
//        [msgbox show];
        [YYTAlertView showHalfTypeAlertViewWithTitle:@"温馨提示" message:@"你还没有安装微信客户端！" completaionBlock:^(NSInteger index) {
            
        }];
        return;
    }
//    NSString *title = nil;
//    NSString *desc = nil;
//    UIImage *image = nil;
//    NSString *url = nil;
//    if (_modeType == XTShareModeTypePicture) {
//        title = @"分享图片";
//        if (_desc.length > 0) {
//            desc = _desc;
//        }else{
//            desc = @"分享一张图片";
//        }
//        url = [NSString stringWithFormat:@"http://m.yinyuetai.com/tian/wap?id=%ld&type=2",self.pid];
//        image = self.image;
//        //图片分享统计
//        if (scene == WXSceneSession) {
//            if ([[XTUserStore sharedManager] isLogin]) {
////                [_store shareStatisticsFromPlatform:@"WEIXIN" withSourceId:self.pid completionBlock:^(id newsData, NSError *error) {
////                    NSLog(@"%@, %@", newsData, error);
////                }];
//            }
//        }else{
//            if ([[XTUserStore sharedManager] isLogin]) {
////                [_store shareStatisticsFromPlatform:@"PENGYOUQUAN" withSourceId:self.pid completionBlock:^(id newsData, NSError *error) {
////                    NSLog(@"%@, %@", newsData, error);
////                }];
//            }
//        }
//    }else if (_modeType == XTShareModeTypeGraphic) {
//        title = @"分享图文";
//        url = [NSString stringWithFormat:@"http://m.yinyuetai.com/tian/wap?id=%ld&type=1",self.pid];
//        desc = @"打开舔TIAN，偶像们咻的一下就来了，捧起花痴脸，我的偶像，我要舔舔舔舔舔！";
//        image = kShareDefaultImage;
//    }else if (_modeType == XTShareModeTypeAtlas) {
//        title = @"分享图册";
//        desc = @"这里有好多偶像的独家高清大图 哟，我舔的好开心！做一只高端的舔屏饭就来舔TIAN吧！";
//        image = kShareDefaultImage;
//        url = [NSString stringWithFormat:@"%@",@"http://itunes.apple.com/cn/app/id973879340?mt=8"];
//    }
    
    NSString *url;
    NSString *typeURL;
    NSString *title;
    NSString *des;
    UIImage *image = self.image;
    
    // 分享统计
    NSString *platform = scene?kPlatformPENGYOUQUAN:kPlatformWEIXIN;
    NSString *datatype = [self shareTypeStringWithType:self.modeType];
    NSInteger dataId = self.pid;
    [[XTShareStatistic sharedShareStatistic] setShareValueWithPlatform:platform datatype:datatype dataId:dataId];
    
    switch (self.modeType) {
        case XTShareModeTypeAtlas:
            // 底层地址测试
            url = kShareDownload;
            des = [NSString stringWithFormat:@"这里有好多偶像的独家高清大图哟，我舔得好开心！做一只高端的舔屏饭就来舔吧！"];
            title = @"舔";
            image = kShareDefaultImage;
            break;
            
        case XTShareModeTypePicture:
            typeURL = @"pictureDetails";
            des = [NSString stringWithFormat:@"%@ 食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！",self.desc];
            title = @"分享的图片";
            break;
            
        case XTShareModeTypeTopicDetails:
            typeURL = @"topicDetails";
            des = [NSString stringWithFormat:@"%@ 食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！",self.desc];
            title = self.title;
            break;
            
        case XTShareModeTypeSeries:
            typeURL = @"seriesSharePage";
            des = [NSString stringWithFormat:@"%@",self.desc];
            title = self.title;
            break;
            
        case XTShareModeTypePicShare:
            typeURL = @"picSharePage";
            if (self.desc.length <= 0) {
                des = @"食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！";
            }else{
                des = self.desc;
            }
            des = [NSString stringWithFormat:@"%@",des];
            title = self.title;
            break;
            
        case XTShareModeTypeStar:
            typeURL = @"starPage";
            des = [NSString stringWithFormat:@"%@",self.desc];
            title = self.title;
            break;
            
        case XTShareModeTypeHotEvent:
            typeURL = @"hotEventPage";
            des = [NSString stringWithFormat:@"%@",self.desc];
            title = self.title;
            break;
            
        case XTShareModeTypeTopic:
            typeURL = @"topicShare";
            des = [NSString stringWithFormat:@"食色性也,千万不要跟自己的人性做斗争，来这里舔一舔吧！"];
            title = self.title;
            break;
            
        case XTShareModeTypeBigV:
            typeURL = @"vSharePage";
            des = [NSString stringWithFormat:@"%@",self.desc];
            title = self.title;
            break;
    }
    //开始分享
    UIImage *imageTemp;
    if (self.modeType == XTShareModeTypePicture){
        imageTemp = [self checkImage:image withSize:32 * 1024];
        url = [NSString stringWithFormat:@"%@%@PC?pid=%zd",kShareBaseUrl,typeURL,self.pid];
    }else if (self.modeType != XTShareModeTypeAtlas) {
        imageTemp = [self checkImage:image withSize:32 * 1024];
        url = [NSString stringWithFormat:@"%@%@PC?id=%zd",kShareBaseUrl,typeURL,self.pid];
    }else{
        imageTemp = image;
    }
    NSLog(@"分享的网址%@",url);
    NSLog(@"分享的标题%@",title);
    NSLog(@"分享的内容%@",des);
    NSData *dataObj = UIImageJPEGRepresentation(imageTemp, 1.0);
    image = [UIImage imageWithData:dataObj];
    NSLog(@"%zd",dataObj.length);
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = des;
    if (scene == 1) {
        message.title = des;
    }
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}
-(UIImage *)checkImage:(UIImage *)image withSize:(NSUInteger)size{
    
    UIImage *imageTemp = [self scaleImage:image toScale:0.5];
    NSData *dataObj = UIImageJPEGRepresentation(imageTemp, 1.0);
    NSLog(@"%zd",dataObj.length);
    if (dataObj.length > size) {
        return [self checkImage:imageTemp withSize:size];
    }else{
        return imageTemp;
    }
}
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
#pragma mark - TencentLoginDelegate
- (void)tencentDidLogin
{
    NSLog(@"========> %s, %@",__func__, _tencentOAuth.accessToken);
    NSMutableDictionary *authData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     _tencentOAuth.accessToken,@"token",
                                     _tencentOAuth.openId,@"opuid",
                                     @"QQ",@"optype",nil];
    NSLog(@"%@",authData);
    [[XTUserStore sharedManager] loginFromSocialPlatform:authData Withcompletion:^(id user, NSError *error) {
        NSLog(@"%@, error :%@",user,  error);
        if (!error) {
            [YYTHUD showPromptAddedTo:XTKeyWindow withText:@"登录成功" withCompletionBlock:^{
                if (_loginBlock) {
                    _loginBlock();
                }
            }];
        }else{
            [YYTHUD showPromptAddedTo:XTKeyWindow withText:@"登录失败" withCompletionBlock:nil];

        }
    }];

}


- (void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"========> %s",__func__);
    if (_loginBlock) {
        _loginBlock();
    }
}

- (void)tencentDidNotNetWork
{
    NSLog(@"========> %s",__func__);
    if (_loginBlock) {
        _loginBlock();
    }
}

//QQ空间分享
#pragma mark - QQ空间分享结果调取方法
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [msgbox show];
            [YYTAlertView showHalfTypeAlertViewWithTitle:@"Error" message:@"App未注册" completaionBlock:nil];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [msgbox show];
            [YYTAlertView showHalfTypeAlertViewWithTitle:@"Error" message:@"发送参数错误" completaionBlock:nil];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [msgbox show];
            [YYTAlertView showHalfTypeAlertViewWithTitle:@"Error" message:@"未安装手Q" completaionBlock:nil];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [msgbox show];
            [YYTAlertView showHalfTypeAlertViewWithTitle:@"Error" message:@"API接口不支持" completaionBlock:nil];
            break;
        }
        case EQQAPISENDFAILD:
        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [msgbox show];
            [YYTAlertView showHalfTypeAlertViewWithTitle:@"Error" message:@"发送失败" completaionBlock:nil];
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持纯文本分享，请使用图文分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [msgbox show];
            [YYTAlertView showHalfTypeAlertViewWithTitle:@"Error" message:@"空间分享不支持纯文本分享，请使用图文分享" completaionBlock:nil];
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持纯图片分享，请使用图文分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [msgbox show];
            [YYTAlertView showHalfTypeAlertViewWithTitle:@"Error" message:@"空间分享不支持纯图片分享，请使用图文分享" completaionBlock:nil];
            break;
        }
//        case EQQAPISENDSUCESS:
//        {
//            [YYTAlertView showHalfTypeAlertViewWithTitle:@"提示" message:@"发送成功" completaionBlock:nil];
////            [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"发送成功" withCompletionBlock:nil];
//            break;
//        }
        default:
        {
            break;
        }
    }
}

#pragma mark -新浪登录回调
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    // 分享结果处理
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        if (response.statusCode == WeiboSDKResponseStatusCodeSentFail || response.statusCode == WeiboSDKResponseStatusCodeShareInSDKFailed) {;
            [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"分享失败" withCompletionBlock:nil];

        }else if (response.statusCode == WeiboSDKResponseStatusCodeAuthDeny){
            [[[YYTAlertView alloc] initWithTitle:@"提示" message:@"授权失败" delegate:nil verifyButtonTitle:NSLocalizedString(@"确定", nil)] show];
        }else if(response.statusCode == WeiboSDKResponseStatusCodeSuccess){
            [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"分享成功" withCompletionBlock:nil];
            //分享成功统计次数
            [[XTShareStatistic sharedShareStatistic] sendShareInfo];
        }else if(response.statusCode == WeiboSDKResponseStatusCodeUserCancel){
            [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"用户取消" withCompletionBlock:nil];
        }
        if (_loginBlock) {
            _loginBlock();
        }
    }
    // 登录处理结果
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
       // NSLog(@"%ld",response.statusCode);
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            WBAuthorizeResponse *aSinaweibo = (WBAuthorizeResponse *)response;
            NSMutableDictionary *authData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             aSinaweibo.accessToken,@"token",
                                             aSinaweibo.userID,@"opuid",
                                             @"SINA",@"optype",nil];
            NSLog(@"%@",authData);
            [[XTUserStore sharedManager] loginFromSocialPlatform:authData Withcompletion:^(id user, NSError *error) {
//                NSLog(@"%@, error :%@",user,  error);
                if (!error) {
                    [YYTHUD showPromptAddedTo:XTKeyWindow withText:@"登录成功" withCompletionBlock:^{
                        if (_loginBlock) {
                            _loginBlock();
                        }
                    }];
                    
                }else{
                    [YYTAlertView showHalfTypeAlertViewWithTitle:@"提醒" message:[error xtErrorMessage] completaionBlock:nil];
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"1" delegate:nil cancelButtonTitle:@"quding" otherButtonTitles:nil];
//                    [alertView show];
                }
            }];
        }
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    NSLog(@"%@",request);
}

-(NSDictionary*)getParamsWithLoginOpenType:(NSString*)openTypeStr
                            withOpenUserId:(NSString*)opuid
                                 withToken:(NSString*)token
                        withExpirationDate:(NSDate*)date
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if([openTypeStr length] > 0)
        [params setObject:openTypeStr forKey:kOptypeKey];
    if([opuid length] > 0)
        [params setObject:opuid forKey:kOpuidKey];
    if([token length] > 0)
        [params setObject:token forKey:kTokenKey];
    if(date)
        [params setObject:date forKey:kExpires_inKey];
    return params;
}

// 根据类型返回分享类型字段
-(NSString *)shareTypeStringWithType:(XTShareModeType)shareType{
    switch (shareType) {
        case XTShareModeTypeAtlas:
            return @"";
            break;
        case XTShareModeTypePicture:
            return @"";
            break;
        case XTShareModeTypeTopicDetails:
            return @"";
            break;
        case XTShareModeTypeSeries:
            return @"";
            break;
        case XTShareModeTypePicShare:
            return @"";
            break;
        case XTShareModeTypeStar:
            return @"";
            break;
        case XTShareModeTypeHotEvent:
            return @"";
            break;
        case XTShareModeTypeTopic:
            return @"";
            break;
        case XTShareModeTypeBigV:
            return @"";
            break;

    }
}
@end
