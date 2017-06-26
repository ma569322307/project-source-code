//
//  XTImgDetailLogicModel.h
//  tian
//
//  Created by loong on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XTImgShowModel;
@class XTCommentsModel;

@interface XTImgDetailLogicModel : NSObject


@property(nonatomic,strong)XTImgShowModel *imgShowModel;

@property(nonatomic,strong)XTCommentsModel *commentsModel;


@end
