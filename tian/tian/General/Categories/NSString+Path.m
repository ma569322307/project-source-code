//
//  NSString+Path.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "NSString+Path.h"

@implementation NSString (Path)
#pragma mark - 返回Document下文件名的路径
+(NSString *)pathForDocumentWithFileName:(NSString *)fileName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:fileName];
}

-(BOOL)pathExists{
    BOOL isDir;
    return [[NSFileManager defaultManager] fileExistsAtPath:self isDirectory:&isDir];
}
@end
