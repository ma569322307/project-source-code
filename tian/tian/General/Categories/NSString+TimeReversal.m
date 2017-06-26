//
//  NSString+TimeReversal.m
//  YinYueTai_iPhone
//
//  Created by airspuer on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+TimeReversal.h"
@implementation NSString(NSString_TimeReversal)
-(NSDate*)stringToDate
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[NSLocale currentLocale]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    return [inputFormatter dateFromString:self];
}

-(NSDate*)stringToDateWithForm:(NSString *)format
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init] ;
    [inputFormatter setLocale:[NSLocale currentLocale]];
    [inputFormatter setDateFormat:format];
    return [inputFormatter dateFromString:self];
}
-(NSDate*)clockStringToDate
{
    NSString *dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [self stringToDateWithForm:dateFormat];
}
+(NSString*)dateTimestamp:(NSTimeInterval)timeSeconds
{
    NSString *dateFormat = @"HH:mm";
    time_t now;
    time(&now);
    int distance = (int)difftime(now, timeSeconds);
    if (!(distance < 60 * 60 * 60 *24))
    {
        dateFormat = @"MM-dd HH:mm";
    }
    
    return [NSString dateTimestamp:timeSeconds withFormat:dateFormat];
}
/**
 *  评论显示时间格式、
 *
 
 */
+(NSString*)commentDateTimestamp:(NSTimeInterval)timeSeconds
{
    NSString *dateFormat = @"MM-dd HH:mm";
    time_t now;
    time(&now);
    int distance = (int)difftime(now, timeSeconds/1000);
    if (!(distance < 60 * 60 * 60 *24))
    {
        dateFormat = @"yyyy-MM-dd";
    }
    
    return [NSString dateTimestamp:timeSeconds withFormat:dateFormat];
}
+(NSString*)dateTimestamp:(NSTimeInterval)timeSeconds withFormat:(NSString *)dateFormat
{
    NSString *_timestamp;
    time_t t = (time_t)(timeSeconds / 1000);
    
    NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        if ([dateFormat isExist]) {
            dateFormatter.dateFormat = dateFormat;
        }else{
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
    }
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    _timestamp = [dateFormatter stringFromDate:date];
    return _timestamp;
}

+(TimeType)diffTimesType:(NSTimeInterval)timeSeconds
{
    time_t t = (time_t)(timeSeconds / 1000);
    time_t now;
    time(&now);
    int distance = (int)difftime(now, t);
    if (distance < 0) distance = 0;
    if(distance > 60 * 60 * 24)
        return DATE;
    return TIME;
}
//计算两个时间戳时间间隔返回s
+(int)diffTimeWithEndTime:(NSTimeInterval)endTime WithStarTime:(NSTimeInterval)starTime
{
    //difftime(endtime, startime)
    time_t theEndtime = (time_t)(endTime / 1000);
    time_t theStartime = (time_t)(starTime / 1000);

    int distance = (int)difftime(theEndtime, theStartime);
    if (distance < 0)
        distance = 0;
    return distance;
}

+ (NSString *)parseTime:(NSTimeInterval)timeSeconds{
    NSString *_timestamp = nil;
    time_t t = (time_t)(timeSeconds / 1000);
    time_t now;
    time(&now);
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy年MM月dd日";
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    _timestamp = [dateFormatter stringFromDate:date];
    return _timestamp;
}

+(NSString*)diffTimestamp:(NSTimeInterval)timeSeconds
{
	NSString *_timestamp = nil;
    time_t t = (time_t)(timeSeconds / 1000);
    time_t now;
    time(&now);
    int distance = (int)difftime(now, t);
    if (distance < 0)
    {
        distance = 0;
    }
    
    if (distance < 60)
    {
        //_timestamp = [NSString stringWithFormat:@"%d%@", distance, @"刚刚"];
        _timestamp = [NSString stringWithFormat:@"%@", @"刚刚"];
    }
    else if (distance < 60 * 60)
    {
        distance = distance / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, @"分钟前"];
    }
    else if (distance < 60 * 60 * 24)
    {
        distance = distance / 60 / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, @"小时前"];
    }
//    else if (distance < 60 * 60 * 60 *24)
//    {
//        static NSDateFormatter *dateFormatter = nil;
//        if (dateFormatter == nil)
//        {
//            dateFormatter = [[NSDateFormatter alloc] init];
//            dateFormatter.dateFormat = @"MM-dd HH:mm";
//        }
//        
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
//        _timestamp = [dateFormatter stringFromDate:date];
//    }
    else if (distance < 60 * 60 * 24 * 16)
    {
        distance = distance / 60 / 60 / 24;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, @"天前"];
    }
    else
    {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil)
        {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd";
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
        _timestamp = [dateFormatter stringFromDate:date];
    }
    return _timestamp;
}
+(NSString*)diffTimestampOfPrivateMessageTime:(NSTimeInterval)timeSeconds
{
    
    NSString *timeStr = [self dateTimestamp:timeSeconds withFormat:@"yyyyMMdd"];
    NSDate *nowDate = [NSDate new];
    NSDateFormatter * dateForma = [[NSDateFormatter alloc] init];
    dateForma.dateFormat = @"yyyyMMdd";
    NSString *nowTimeStr = [dateForma stringFromDate:nowDate];
    
    NSInteger timeint = [timeStr integerValue];
    NSInteger nowTimeint = [nowTimeStr integerValue];
    NSString *_timestamp = nil;
    time_t t = (time_t)(timeSeconds / 1000);
//    time_t now;
//    time(&now);
//    int distance = (int)difftime(now, t);
    
    NSDateFormatter *dateFormatter = nil;
    dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    
    
    if (nowTimeint - timeint == 1)
    {
        dateFormatter.dateFormat = @"HH:mm";
        _timestamp = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:date]];
    }
    else if(nowTimeint == timeint)
    {
        dateFormatter.dateFormat = @"HH:mm";
        _timestamp = [dateFormatter stringFromDate:date];
    }else
    {
        
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        _timestamp = [dateFormatter stringFromDate:date];
    }
    return _timestamp;
}


//返回显示的时间格式
+(NSString*)timeFormat:(NSTimeInterval)totalSeconds
{
   return [[self class] diffTimestamp:totalSeconds];
    
//    NSDateComponents *componentsInfo = [NSString dateComponents:totalSeconds];
//    NSMutableString* strFormat = [[NSMutableString alloc] init];
//    NSString* appendStr = @"";
//    if(componentsInfo.hour > 0)
//    {
//        [strFormat appendString:@"HH:MM:SS"];
//    }
//    else if(componentsInfo.minute >0)
//    {
//        [strFormat appendString:@"MM:SS"];
//    }
//    else {
//        [strFormat appendString:@"SS"];
//    }
//    [strFormat appendString:appendStr];
//    return (NSString*)strFormat;
}
+(NSDateComponents*)dateComponents:(NSTimeInterval)totalSeconds
{
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:totalSeconds sinceDate:date1]; 
    
    // Get conversion hours, minutes,seconds
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *componentsInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    return componentsInfo;
}
+(NSString*)strFormattedTime:(NSTimeInterval)times
{
//    NSString* strFomat = [NSString timeFormat:times];
    return [NSString timeFormatted:times formatString:@"MM:SS"];
}
//秒转换为时分秒格式
+ (NSString *)timeFormatted:(double)totalSeconds formatString:(NSString*)strFormat
{
    if(strFormat.length == 0)
        return @"";
    NSMutableString* strTimer = [NSMutableString stringWithFormat:@"%@",[strFormat uppercaseString]];
    NSDateComponents *componentsInfo = [NSString dateComponents:totalSeconds];
    
    NSString* strHour = [NSString stringWithFormat:@"%02ld",componentsInfo.hour];
    NSString * strMin = [NSString stringWithFormat:@"%02ld", componentsInfo.minute];
    NSString* strSeconds = [NSString stringWithFormat:@"%02ld",componentsInfo.second];
    NSRange subRange;
    subRange = [strTimer rangeOfString:@"HH"];
    if(subRange.location !=NSNotFound)
    {
        [strTimer replaceCharactersInRange:subRange withString:strHour];
    }
    subRange = [strTimer rangeOfString:@"MM"];
    if(subRange.location !=NSNotFound)
    {
        [strTimer replaceCharactersInRange:subRange withString:strMin];
    }
    subRange = [strTimer rangeOfString:@"SS"];
    if(subRange.location !=NSNotFound)
    {
        [strTimer replaceCharactersInRange:subRange withString:strSeconds];
    }
    return (NSString*)strTimer;
}

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

@end
