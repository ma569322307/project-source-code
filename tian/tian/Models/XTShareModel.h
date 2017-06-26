//
//  XTShareModel.h
//  tian
//
//  Created by Jiajun Zheng on 15/7/10.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTShareSheet.h"

@interface XTShareModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *imageNameSelected;
@property (nonatomic, assign) NSInteger index;
///根据给定类型获取全部模型
+(NSArray *)shareModelListWithShareType:(XTShareSheetItemType)type;
@end
