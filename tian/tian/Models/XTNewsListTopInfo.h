//
//  XTNewsListTopInfo.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/9.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Mantle.h>
/**
 *
 *     图文详情类中的top5 图文模型
 */
@interface XTNewsListTopInfo : MTLModel<MTLJSONSerializing>

@property (assign, nonatomic) long gid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSURL *coverURL;
@end
