//
//  XTPictureInfoModel.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/14.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTPictureInfoModel : NSObject
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *thumbnailPic;
@property (nonatomic, copy) NSString *middlePic;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) NSInteger commendCount;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) BOOL selected;

+(NSMutableArray *)pictureURLListWithList:(NSArray *)array;
+(NSMutableArray *)pictureInfoListWithList:(NSArray *)array;
@end
