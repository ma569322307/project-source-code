//
//  XTLocalImageStoreManage.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTLocalImageStoreManage.h"
#import "NSString+Path.h"
#import "SDImageCache.h"
#import "XTUploadSingleModel.h"
#import "UIImage+Size.h"
#import "XTLocalPhotoModel.h"

@interface XTLocalImageStoreManage ()
@end

@implementation XTLocalImageStoreManage
/// 文件夹名
static NSString *logoPathName = @"YYTLogo";
static NSString *photoPathName = @"YYTPhoto";
/// 内容文件名
static NSString *logoInfoName = @"YYTLogo.plist";
static NSString *photoInfoName = @"YYTPhoto.plist";
/// 单例创建
+(instancetype)sharedLocalImageStoreManage{
    static XTLocalImageStoreManage *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[self alloc] init];
        _shareManager.ioQueue = dispatch_queue_create("com.YYT.LocalDownloader", DISPATCH_QUEUE_SERIAL);
        //创建logo文件夹
        [self createLogoFolder];
    });
    return _shareManager;
}
/// 生成日期字符串
-(void)timeStringCreate{
    // 根据保存时间创建文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"mmss"; //设置日期格式
    NSString *date = [formatter stringFromDate:[NSDate date]];
    self.timeKey = date;
}
#pragma mark 路径
/// logoInfo路径
+(NSString *)logoInfoFileName{
    NSString *path = [self localImageStoreFolderWithName:logoPathName];
    return [path stringByAppendingPathComponent:logoInfoName];
}
/// 合成图片Info路径
+(NSString *)photoInfoFileName{
    NSString *path = [self localImageStoreFolderWithName:photoPathName];
    return [path stringByAppendingPathComponent:photoInfoName];
}
/// 根据文件夹名获取文件路径
+(NSString *)localImageStoreFolderWithName:(NSString *)name{
    // 根据文件名获取路径
    return [NSString pathForDocumentWithFileName:name];
}
/// 根据路径名称获取具体Info文件名
+(NSString *)fileNameWithPathName:(NSString *)pathName{
    if ([pathName isEqualToString:logoPathName]) {
        return [self logoInfoFileName];
    }
    return [self photoInfoFileName];
}

#pragma mark 创建文件夹
/// 创建logo文件夹
+(BOOL)createLogoFolder{
    return [self creatFolderWithPathName:logoPathName];
}
/// 创建合成图片文件夹
+(BOOL)createPhotoFolder{
    return [self creatFolderWithPathName:photoPathName];
}
/// 根据文件夹名创建文件夹
+(BOOL)creatFolderWithPathName:(NSString *)pathName{
    NSString *path = [self localImageStoreFolderWithName:pathName];
    if (![path pathExists]) {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:NULL];
    }
    return YES;
}

#pragma mark 删除文件夹
/// 删除logo文件夹
+(BOOL)deleteLogoFolder{
    return [self deleteFolderWithPathName:logoPathName];
}
/// 删除合成图片文件夹
+(BOOL)deletePhotoFolder{
    return [self deleteFolderWithPathName:photoPathName];
}
/// 根据文件夹名删除文件夹
+(BOOL)deleteFolderWithPathName:(NSString *)pathName{
    NSString *path = [self localImageStoreFolderWithName:pathName];
    if ([path pathExists]) {
        return [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    }
    return YES;
}

#pragma mark 储存图片
/// 存储logo
-(void)storeLogo:(UIImage *)logo completion:(void (^)())completionBlock{
    // 储存logo
    [self storeImage:logo withKey:nil intoPathName:logoPathName withType:@2 needSmall:YES completion:completionBlock];
}
/// 存储合成图片
-(void)storePhoto:(UIImage *)photo withKey:(NSString *)key completion:(void (^)())completionBlock{
    // 储存合成图片
    [self storeImage:photo withKey:key intoPathName:photoPathName withType:nil needSmall:YES completion:completionBlock];
}
/// 存储图片到路径下
-(BOOL)storeImage:(UIImage *)image withKey:(NSString *)key intoPathName:(NSString *)pathName withType:(NSNumber *)type needSmall:(BOOL)needSmall completion:(void(^)())completionBlock{
    NSString *path = [XTLocalImageStoreManage localImageStoreFolderWithName:pathName];
    [XTLocalImageStoreManage creatFolderWithPathName:pathName];
    NSData *data = UIImagePNGRepresentation(image);
    // 获取缩略图
    UIImage *smallImage = [self smallImage:image];
    NSData *dataS;
    if (needSmall) {
        dataS = UIImagePNGRepresentation(smallImage);
    }
    NSString *name = [XTLocalImageStoreManage nameCreate];
    if (key) {
        name = key;
    }
    NSString *fileName = [path stringByAppendingPathComponent:name];
    NSString *fileNameS = [fileName stringByAppendingString:@"small"];
    // 存储图片 同步操作，防止出错
    dispatch_async(self.ioQueue, ^{
        [data writeToFile:fileName atomically:YES];
        if (needSmall) {
            [dataS writeToFile:fileNameS atomically:YES];
        }
        // 更新数据文件
        [self addImageInfoInPathName:pathName withImageName:name andType:type];
        // 如果有回调，在主线程调用回调
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
    });
    return YES;
}
-(BOOL)storePhoto:(UIImage *)image withIndexPath:(NSInteger)index completion:(void(^)())completionBlock{
    return [self storeImage:image intoPathName:photoPathName withType:nil withIndexPath:index completion:completionBlock];
}

/// 存储图片到路径下
-(BOOL)storeImage:(UIImage *)image intoPathName:(NSString *)pathName withType:(NSNumber *)type withIndexPath:(NSInteger)index completion:(void(^)())completionBlock{
    NSString *path = [XTLocalImageStoreManage localImageStoreFolderWithName:pathName];
    [XTLocalImageStoreManage creatFolderWithPathName:pathName];
    NSData *data = UIImagePNGRepresentation(image);
    // 获取缩略图
    UIImage *smallImage = [self smallImage:image]; 
    NSData *dataS = UIImagePNGRepresentation(smallImage);
    NSDictionary *dic = self.photoInfoArray[index];
    NSString *name = dic[@"name"];
    NSString *fileName = [path stringByAppendingPathComponent:name];
    NSString *fileNameS = [fileName stringByAppendingString:@"small"];
    // 先删除原先的图片
    [self deletePhotoWithImageName:fileName];
    // 存储图片 同步操作，防止出错
    dispatch_async(self.ioQueue, ^{
        [data writeToFile:fileName atomically:YES];
        [dataS writeToFile:fileNameS atomically:YES];
        // 更新数据文件
        [self addImageInfoInPathName:pathName withImageName:name andType:type];
        // 如果有回调，在主线程调用回调
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
    });
    return YES;
}
/// 小图
-(UIImage *)smallImage:(UIImage *)image{
    CGFloat scale = image.size.width / image.size.height;
    NSLog(@"W%f,H%f",image.size.width,image.size.height);
    if (scale > (SCREEN_SIZE.width / SCREEN_SIZE.height)) {
        if (image.size.width < SCREEN_SIZE.width) {
            return image;
        }
        return [image scaleImageWithWidth:SCREEN_SIZE.width];
    }
    if (image.size.height < SCREEN_SIZE.height) {
        return image;
    }
    return [image scaleImageWithHeight:SCREEN_SIZE.height];
//    NSData *data = UIImageJPEGRepresentation(image, 0.5);
//    return [UIImage imageWithData:data];
//    return [image scaleImageWithWidth:image.size.width * 0.999999];
}

/// 储存系统logo
-(void)storeSystemLogos{
    if ([self logoInfoArray]) {
        return;
    }
    // 根据系统信息导入系统自带的logo
    NSArray *array = [XTUploadSingleModel uploadLogoSingleModelWithSystemList];
    // 根据系统信息导入图片
    NSBlockOperation *last;
    for (XTUploadSingleModel *model in array) {
        //存入操作
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            UIImage *image = [UIImage imageNamed:model.name];
            [self storeImage:image withKey:nil intoPathName:logoPathName withType:model.type needSmall:YES completion:nil];
        }];
        //添加依赖
        if (last) {
            [blockOperation addDependency:last];
        }
        [[NSOperationQueue mainQueue] addOperation:blockOperation];
        last = blockOperation;
    }
}

#pragma mark 删除图片
///删除单张logo图片
-(BOOL)deleteLogoWithImageName:(NSString *)name{
    return [self deleteImageInPathName:logoPathName withName:name andType:@2];
}
-(BOOL)deletePhotoWithImageName:(NSString *)name{
    return [self deleteImageInPathName:photoPathName withName:name andType:nil];
}
/// 删除图片
-(BOOL)deleteImageInPathName:(NSString *)pathName withName:(NSString *)name andType:(NSNumber *)type{
    NSString *path = [XTLocalImageStoreManage localImageStoreFolderWithName:pathName];
    NSString *fileName = [path stringByAppendingPathComponent:name];
    NSString *fileNameS = [fileName stringByAppendingString:@"small"];
    [self deleteImageInfoInPathName:pathName withImageName:name andType:type];
    [[NSFileManager defaultManager] removeItemAtPath:fileNameS error:NULL];
    return [[NSFileManager defaultManager] removeItemAtPath:fileName error:NULL];
}
#pragma mark 读取图片
/// 读取logo图片
-(UIImage *)getLogoWithName:(NSString *)name{
    return [self getImageWithName:name fromeLocalPathName:logoPathName];
}
/// 读取合成图片
-(UIImage *)getPhotoWithName:(NSString *)name{
    return [self getImageWithName:name fromeLocalPathName:photoPathName];
}
/// 读取图片
-(UIImage *)getImageWithName:(NSString *)name fromeLocalPathName:(NSString *)pathName{
    NSString *path = [XTLocalImageStoreManage localImageStoreFolderWithName:pathName];
    NSString *fileName = [path stringByAppendingPathComponent:name];
    // 获取图片
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    // 返回图片
    return [UIImage imageWithData:data];
}

#pragma mark 图片名
/// 创建储存名字
+(NSString *)nameCreate{
    // 根据保存时间创建文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss"; //设置日期格式
    NSString *date = [formatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%@%zd",date,arc4random_uniform(100000)];
}

#pragma mark 添加图片信息
/// 添加Logo本地文件列表
-(void)addLogoInfoWithImageName:(NSString *)name{
    // 获取路径
    return [self addImageInfoInPathName:logoPathName withImageName:name andType:@2];
}
/// 添加合成图片本地文件列表
-(void)addPhotoInfoWithImageName:(NSString *)name{
    // 获取路径
    return [self addImageInfoInPathName:photoPathName withImageName:name andType:nil];
}
/// 添加本地文件列表
-(void)addImageInfoInPathName:(NSString *)pathName withImageName:(NSString *)name andType:(NSNumber *)type{
    // 获取文件名
    NSString *fileName = [XTLocalImageStoreManage fileNameWithPathName:pathName];
    NSMutableArray *arrayM = [NSMutableArray arrayWithContentsOfFile:fileName];
    NSString *nameS = [name stringByAppendingString:@"small"];
    if (!arrayM) {
        // 文件不存在,创建
        arrayM = [self createImageInfoFileInPathName:pathName];
    }
    // 文件存在
    if (name) {// 没有文件名表示第一次创建logo文件夹
        // logo需要类型
        if (type) {
            NSDictionary *dic = @{
                                  @"name" : name,
                                  @"type" : type,
                                  @"smallName" : nameS
                                  };
            // 添加数据
            [arrayM addObject:dic];
        }else{
            NSDictionary *dic = @{
                                  @"name" : name,
                                  @"smallName" : nameS,
                                  @"timeKey" : self.timeKey
                                  };
            // 判断重复
            if ([self checkInfoRepeat:name inList:arrayM]) {
                return;
            }
            // 添加数据
            [arrayM addObject:dic];
        }
    }
    // 重新写入
    [arrayM writeToFile:fileName atomically:YES];
    
}
/// 添加整个本地文件
-(void)addPhotoInfoWithNameArray:(NSArray *)nameArray compelectionBlock:(void(^)())compelectionBlock{
    // 获取文件名
    NSString *fileName = [XTLocalImageStoreManage photoInfoFileName];
    NSMutableArray *arrayM = [NSMutableArray arrayWithContentsOfFile:fileName];
    NSMutableArray *result = [NSMutableArray array];
    if (arrayM) {
        // 删除同一次的所有信息
        for (NSDictionary *dic in arrayM) {
            if (![dic[@"timeKey"] isEqualToString:self.timeKey]) {
                [result addObject:dic];
            }
        }
    }
    for (NSString *name in nameArray) {
        NSString *nameS = [name stringByAppendingString:@"small"];
        NSDictionary *dic = @{
                              @"name" : name,
                              @"smallName" : nameS,
                              @"timeKey" : self.timeKey
                              };
        [result addObject:dic];
    }
    dispatch_async(self.ioQueue, ^{
        // 重新写入
        [result writeToFile:fileName atomically:YES];
        if (compelectionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compelectionBlock();
            });
        }
    });
}
// 判断当前的数组中信息是否已经存在
-(BOOL)checkInfoRepeat:(NSString *)name inList:(NSArray *)array{
    NSMutableSet *set = [NSMutableSet set];
    // 所有名字列表保存
    for (NSDictionary *dic in array) {
        [set addObject:dic[@"name"]];
    }
    // 判断是否存在
    if ([set containsObject:name]) {
        return YES;
    }
    return NO;
}
#pragma mark 删除图片信息
/// 删除Logo本地文件列表
-(void)deleteLogoInfoWithImageName:(NSString *)name{
    // 获取路径
    return [self deleteImageInfoInPathName:logoPathName withImageName:name andType:@2];
}
/// 删除合成图片本地文件列表
-(void)deletePhotoInfoWithImageName:(NSString *)name{
    // 获取路径
    return [self deleteImageInfoInPathName:photoPathName withImageName:name andType:nil];
}
/// 删除本地文件列表
-(void)deleteImageInfoInPathName:(NSString *)pathName withImageName:(NSString *)name andType:(NSNumber *)type{
    // 获取文件名
    NSString *fileName = [XTLocalImageStoreManage fileNameWithPathName:pathName];
    NSMutableArray *arrayM = [NSMutableArray arrayWithContentsOfFile:fileName];
    // 根据名称寻找
    for (NSDictionary *dic in arrayM) {
        if ([dic[@"name"] isEqualToString:name]){
            [arrayM removeObject:dic];
            break;
        }
    }
    // 重新写入
    [arrayM writeToFile:fileName atomically:YES];
}

#pragma mark 创建储存文件
/// 创建新文件并且返回该数组
-(NSMutableArray *)createImageInfoFileInPathName:(NSString *)pathName{
    // 根据名称判断是哪个路径
    if ([pathName isEqualToString:logoPathName]) {
        // 创建logo信息文件
        return [self createLogoInfoFile];
    }
    // 创建photo信息文件
    return [self createPhotoInfoFile];
    
}
/// 创建logo信息文件(只会创建一次)
-(NSMutableArray *)createLogoInfoFile{
    // 创建数组
    NSMutableArray *arrayM = [NSMutableArray array];
    return arrayM;
}
/// 创建合成图片信息文件
-(NSMutableArray *)createPhotoInfoFile{
    // 创建数组
    NSMutableArray *arrayM = [NSMutableArray array];
    return arrayM;
}
#pragma mark 判断总数目
/// 判断总logo数目
-(BOOL)canAddLogo{
    NSArray *array = [self logoInfoArray];
    NSLog(@"%zd",array.count);
    if (array.count >= 41) {
        return NO;
    }
    return YES;
}
#pragma mark 读取图片信息数组
/// logoInfo数组
-(NSArray *)logoInfoArray{
    return [NSArray arrayWithContentsOfFile:[XTLocalImageStoreManage logoInfoFileName]];
}
/// 合成图片Info数组
-(NSArray *)photoInfoArray{
    return [NSArray arrayWithContentsOfFile:[XTLocalImageStoreManage photoInfoFileName]];
}

#pragma mark 读取一张图片
/// logoInfo图片
-(UIImage *)logoImageWithName:(NSString *)name{
    NSString *path = [XTLocalImageStoreManage localImageStoreFolderWithName:logoPathName];
    NSString *fileName = [path stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:fileName];
}
/// 合成图片
-(UIImage *)photoImageWithName:(NSString *)name{
    NSString *path = [XTLocalImageStoreManage localImageStoreFolderWithName:photoPathName];
    NSString *fileName = [path stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:fileName];
}
#pragma mark 判断整体信息
-(NSSet *)checkDifferenceBetweenLocalPhotoListAndGivenArray:(NSArray *)nameArray andTimeKey:(NSString *)timeKey{
    // 本地图片数组
    NSMutableArray *LocalArrayM = [NSMutableArray arrayWithArray:[XTLocalPhotoModel localPhotoModelWithList]];
    // 需要删除的图片数组
    NSMutableArray *delectArrayM = [NSMutableArray array];
    // 需要添加的资源名称数组
    NSMutableSet *addSetM = [NSMutableSet set];
    
    // 本地图片的set
    NSMutableSet *localSet = [NSMutableSet set];
    // 循环自身数组，将所有的key存入set
    for (NSObject *obj in LocalArrayM) {
        // 根据kvc 通过key值获取值
        NSString *keyValue = [obj valueForKey:@"name"];
        // 将获取到的值存入set
        [localSet addObject:keyValue];
    }
    // 相册列表的set
    NSMutableSet *photoSet = [NSMutableSet set];
    // 循环自身数组，将所有的名称存入set
    for (NSString *str in nameArray) {
        // 将获取到的值存入set
        [photoSet addObject:str];
    }
    
    // 相册数组和本地set进行比较，产生需要添加的图片数组
    for (NSString *str in nameArray) {
        if (![localSet containsObject:str]) {
            [addSetM addObject:str];
        }
    }
    
    // 本地数组和相册set进行比较，产生需要删除的图片数组
    for (NSObject *obj in LocalArrayM) {
        // 根据kvc 通过key值获取值
        NSString *keyValue = [obj valueForKey:@"name"];
        NSString *timeKey = [obj valueForKey:@"timeKey"];
        if (![photoSet containsObject:keyValue] && [timeKey isEqualToString:self.timeKey]) {
            [delectArrayM addObject:obj];
        }
    }
    // 删除需要删除的对象
    for (NSObject *obj in delectArrayM) {
        // 根据kvc 通过key值获取值
        NSString *keyValue = [obj valueForKey:@"name"];
        [self deletePhotoWithImageName:keyValue];
    }
    // 返回需要添加的数组
    return addSetM;
}
@end
