//
//  NSString+TextSize.m
//  tian
//
//  Created by huhuan on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "NSString+TextSize.h"

@implementation NSString (textSize)

- (float)textHeightWithFontSize:(NSInteger)fontSize isBold:(BOOL)isBold andWidth:(float)width {
    
    return [self textWidthWithFontSize:fontSize isBold:isBold andWidth:width andHeight:CGFLOAT_MAX].height;
    
}

- (float)textWidthWithFontSize:(NSInteger)fontSize isBold:(BOOL)isBold andHeight:(float)height {
    
    return [self textWidthWithFontSize:fontSize isBold:isBold andWidth:CGFLOAT_MAX andHeight:height].width;
    
}

- (CGSize)textWidthWithFontSize:(NSInteger)fontSize isBold:(BOOL)isBold andWidth:(float)width andHeight:(float)height {
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
//    
//    NSRange allRange = [self rangeOfString:self];
//    [attrStr addAttribute:NSFontAttributeName
//                    value:isBold ? [UIFont boldSystemFontOfSize:fontSize] : [UIFont systemFontOfSize:fontSize]
//                    range:allRange];
//    [attrStr addAttribute:NSForegroundColorAttributeName
//                    value:[UIColor blackColor]
//                    range:allRange];
//    
//    NSMutableParagraphStyle *paraStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
//    [attrStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:allRange];
    
    UIFont *font = isBold ? [UIFont boldSystemFontOfSize:fontSize] : [UIFont systemFontOfSize:fontSize];
    
    NSDictionary *attribute = @{NSFontAttributeName: font};

    
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, height)
                       options:NSStringDrawingUsesLineFragmentOrigin |
                                        NSStringDrawingUsesFontLeading
                    attributes:attribute
                       context:nil];
    

    return rect.size;
}
-(NSUInteger)lengthOfBytesUsingChineseCheck{
    NSUInteger length = 0;
    for (NSInteger i = 0; i< self.length; i++) {
        NSString *str = [self substringWithRange:NSMakeRange(i, 1)];
        NSInteger subStringLength = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        if (subStringLength == 0) {
            str = [self substringWithRange:NSMakeRange(i, 2)];
            subStringLength = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            i++;
        }
        switch (subStringLength) {
            case 1:
                length += 1;
                break;
                
            case 3:
                length += 1;
                break;
                
            case 4:
                length += 1;
                break;
                
            default:
                break;
        }
    }
    return length;
}
-(NSString *)subChineseStringToIndex:(NSUInteger)to{
    NSAssert(to < [self lengthOfBytesUsingChineseCheck], @"已经超过给定的长度");
    NSInteger length = to;
    NSInteger trueTo = 0;
    if (to == 0) {
        return [self substringToIndex:0];
    }
    for (NSInteger i = 0; i< self.length; i++) {
        NSString *str = [self substringWithRange:NSMakeRange(i, 1)];
        NSInteger subStringLength = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        if (subStringLength == 0) {
            str = [self substringWithRange:NSMakeRange(i, 2)];
            subStringLength = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            i++;
        }
        switch (subStringLength) {
            case 1:
                length -= 1;
                break;
                
            case 3:
                length -= 1;
                break;
                
            case 4:
                length -= 1;
                break;
                
            default:
                break;
        }
        NSLog(@"%lu",length);
        if (length <= 0) {
            trueTo = i + 1;
            break;
        }
    }
    NSLog(@"%lu",trueTo);
    return [self substringToIndex:trueTo];
}
@end
