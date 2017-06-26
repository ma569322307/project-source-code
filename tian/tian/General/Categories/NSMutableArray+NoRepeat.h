//
//  NSMutableArray+NoRepeat.h
//  tian
//
//  Created by Jiajun Zheng on 15/8/7.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (NoRepeat)
-(void)addObjectsFromArray:(NSArray *)otherArray withCheckKey:(NSString *)key completionBlock:(void(^)())completionBlock;
-(void)addObjectsFromArray:(NSArray *)otherArray withCheckKey:(NSString *)key completionBlockWithReturnValue:(void(^)(NSMutableArray *array))completionBlock;
@end
