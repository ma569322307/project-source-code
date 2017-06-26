//
//  XTFollowInfo.h
//  StarPicture
//
//  Created by 尚毅 杨 on 15/3/6.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Mantle.h>

/**
 *  关注模型类
 *
 */
@interface XTFollowInfo : MTLModel<MTLJSONSerializing>
@property (assign, nonatomic) int pid;
@property (strong, nonatomic) NSURL *picUrl;
@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) int height;
@property (assign, nonatomic) int width;
@end
