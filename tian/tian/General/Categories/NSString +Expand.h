//
//  NSString +Expand.h
//  Jaypop
//
//  Created by airspuer  on 13-3-10.
//  Copyright (c) 2013年 airspuer . All rights reserved.
//

#import <Foundation/Foundation.h>

 @interface NSString (NSString_Expand)
-(BOOL)isExist;
-(NSString*)genderChangeToStr;
-(NSString*)strChangeToGendr;
-(NSString*)trim;
-(BOOL)hasSubString:(NSString *)aString;

@end
