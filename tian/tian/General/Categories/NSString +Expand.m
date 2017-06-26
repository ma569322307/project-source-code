//
//  NSString +Expand.m
//  Jaypop
//
//  Created by airspuer  on 13-3-10.
//  Copyright (c) 2013年 airspuer . All rights reserved.
//

#import "NSString +Expand.h"

@implementation NSString (NSString_Expand)

-(BOOL)isExist
{
    if (!self) {
        
        return NO;
        
    }
    
    if (self == NULL) {
        
        return NO;
        
    }
    
    if ([self isKindOfClass:[NSNull class]]) {
        
        return NO;
        
    }
    
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        
        return NO;
        
    }
    
    return YES;
//    
//    if(self && self.length > 0)
//        return TRUE;
//    return FALSE;
}

-(NSString*) trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSString*)genderChangeToStr
{
    NSString* genderStr = @"保密";
    if([self isEqualToString:@"m"])
        genderStr = @"男";
    else if([self isEqualToString:@"f"])
        genderStr = @"女";
    return genderStr;
}
-(NSString*)strChangeToGendr
{
    NSString* gender = @"n";
    if([self isEqualToString:@"男"])
        gender = @"m";
    else if([self isEqualToString:@"女"])
        gender = @"f";
    return gender;
}


-(BOOL)hasSubString:(NSString *)aString{

    NSRange range = [self rangeOfString:aString];
    if (range.location != NSNotFound) {
        return YES;
    }else{
        return NO;
    }
}


@end
