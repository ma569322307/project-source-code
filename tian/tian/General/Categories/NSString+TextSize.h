//
//  NSString+TextSize.h
//  tian
//
//  Created by huhuan on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (textSize)

- (float)textHeightWithFontSize:(NSInteger)fontSize isBold:(BOOL)isBold andWidth:(float)width;

- (float)textWidthWithFontSize:(NSInteger)fontSize isBold:(BOOL)isBold andHeight:(float)height;

- (NSUInteger)lengthOfBytesUsingChineseCheck;
- (NSString *)subChineseStringToIndex:(NSUInteger)to;
@end
