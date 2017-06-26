//
//  NSString+AttributedString.m
//  tian
//
//  Created by loong on 15/7/23.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "NSString+AttributedString.h"

@implementation NSString (AttributedString)


-(NSAttributedString *)attributedStringWithSpecificString:(NSString *)str{
    NSMutableAttributedString *as_m = [[NSMutableAttributedString alloc] initWithString:self];
    
    
    NSDictionary *as_d = @{NSForegroundColorAttributeName:UIColorFromRGB(0xffe707),NSFontAttributeName:[UIFont boldSystemFontOfSize:12]};
    
    [as_m addAttributes:as_d range:[self rangeOfString:str]];
    
    [as_m addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:[self rangeOfString:@"回复"]];
    
    return [as_m copy];
}

@end
