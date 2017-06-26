//
//  NSMutableArray+NoRepeat.m
//  tian
//
//  Created by Jiajun Zheng on 15/8/7.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "NSMutableArray+NoRepeat.h"

@implementation NSMutableArray (NoRepeat)
-(void)addObjectsFromArray:(NSArray *)otherArray withCheckKey:(NSString *)key completionBlock:(void (^)())completionBlock{
    //子线程检查重复
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 用于检验key的set
        NSMutableSet *keySet = [NSMutableSet set];
        // 循环自身数组，将所有的key存入set
        for (NSObject *obj in self) {
            // 根据kvc 通过key值获取值
            id keyValue = [obj valueForKey:key];
            // 将获取到的值存入set
            [keySet addObject:keyValue];
        }
        // 循环需要添加的数组
        for (NSObject *obj in otherArray) {
            // 根据kvc 通过key值获取值
            id keyValue = [obj valueForKey:key];
            // 如果该值已存在，表示这个对象不需要被添加，添加不存在的对象
            if (![keySet containsObject:keyValue]) {
                [self addObject:obj];
            }
        }
        // 完成回调
        if (completionBlock) {
            //主线程回调
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
    });
    
}
-(void)addObjectsFromArray:(NSArray *)otherArray withCheckKey:(NSString *)key completionBlockWithReturnValue:(void(^)(NSMutableArray *array))completionBlock{
    //子线程检查重复
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 用于检验key的set
        NSMutableSet *keySet = [NSMutableSet set];
        // 循环自身数组，将所有的key存入set
        for (NSObject *obj in self) {
            // 根据kvc 通过key值获取值
            id keyValue = [obj valueForKey:key];
            // 将获取到的值存入set
            [keySet addObject:keyValue];
        }
        // 循环需要添加的数组
        for (NSObject *obj in otherArray) {
            // 根据kvc 通过key值获取值
            id keyValue = [obj valueForKey:key];
            // 如果该值已存在，表示这个对象不需要被添加，添加不存在的对象
            if (![keySet containsObject:keyValue]) {
                [self addObject:obj];
            }
        }
        // 完成回调
        if (completionBlock) {
            //主线程回调
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(self);
            });
        }
    });
}

@end
