//
//  NSString+Path.h
//  tian
//
//  Created by Jiajun Zheng on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)
/**
 *  给定一个Document下的文件名，返回该路径
 *
 *  @param fileName 文件名
 *
 *  @return 返回路径
 */
+(NSString *)pathForDocumentWithFileName:(NSString *)fileName;
/**
 *  给定一个路径，判断该路径是否存在
 *
 *  @return 是否存在
 */
-(BOOL)pathExists;
@end
