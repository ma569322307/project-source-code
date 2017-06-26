//
//  XTLocalImageStoreManage.h
//  tian
//
//  Created by Jiajun Zheng on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <Foundation/Foundation.h>
// 本地图片存储读取管理工具
@interface XTLocalImageStoreManage : NSObject
// 每一轮图片操作的专属key（时间点）
@property (nonatomic, copy) NSString *timeKey;
// io操作队列
@property (SDDispatchQueueSetterSementics, nonatomic) dispatch_queue_t ioQueue;


/// 生成日期字符串(每次贴纸刷新)
-(void)timeStringCreate;
+(instancetype)sharedLocalImageStoreManage;
/// 存储合成图片
-(void)storePhoto:(UIImage *)photo withKey:(NSString *)key completion:(void (^)())completionBlock;
/// 存储logo
-(void)storeLogo:(UIImage *)logo completion:(void(^)())completionBlock;
/// 根据索引存储合成图片
//-(BOOL)storePhoto:(UIImage *)image withIndexPath:(NSInteger)index completion:(void(^)())completionBlock;
/// 储存系统logo
-(void)storeSystemLogos;
/// 删除logo
-(BOOL)deleteLogoWithImageName:(NSString *)name;
/// 删除合成图片
-(BOOL)deletePhotoWithImageName:(NSString *)name;
/// logoInfo数组
-(NSArray *)logoInfoArray;
/// 合成图片Info数组
-(NSArray *)photoInfoArray;
/// logoInfo图片
-(UIImage *)logoImageWithName:(NSString *)name;
/// 合成图片
-(UIImage *)photoImageWithName:(NSString *)name;
/// 删除所有合成图片
+(BOOL)deletePhotoFolder;
/// 判断总logo数目
-(BOOL)canAddLogo;
/**
 *  匹配当前文件夹信息和给定的文件名数组
 *
 *  @param nameArray 给定的所有图片名称
 *  @param timeKey   区分每次合成的key
 *
 *  @return 返回缺少的图片名称Set，如果图片过多，内部自动删除
 */
-(NSSet *)checkDifferenceBetweenLocalPhotoListAndGivenArray:(NSArray *)nameArray andTimeKey:(NSString *)timeKey;
/// 添加整个本地文件
-(void)addPhotoInfoWithNameArray:(NSArray *)nameArray compelectionBlock:(void(^)())compelectionBlock;
@end
