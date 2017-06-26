//
//  NSString+TimeReversal.h
//  YinYueTai_iPhone
//
//  Created by airspuer on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum _TimeType
{
    TIME = 1,
    DATE = 2
}TimeType;

 @interface NSString (NSString_TimeReversal)
+(TimeType)diffTimesType:(NSTimeInterval)timeSeconds;
+(NSString *)timeFormatted:(double)totalSeconds formatString:(NSString*)strFormat;
+(NSString*)timeFormat:(NSTimeInterval)totalSeconds;
+(NSString*)diffTimestamp:(NSTimeInterval)timeSeconds;
+(NSString*)strFormattedTime:(NSTimeInterval)times;
+(NSString*)dateTimestamp:(NSTimeInterval)timeSeconds;
+(NSString*)dateTimestamp:(NSTimeInterval)timeSeconds withFormat:(NSString *)dateFormat;
-(NSDate*)stringToDate;
-(NSDate*)stringToDateWithForm:(NSString *)format;
-(NSDate*)clockStringToDate;
+ (NSString *)parseTime:(NSTimeInterval)timeSeconds;
+(NSString*)commentDateTimestamp:(NSTimeInterval)timeSeconds;
//计算两个时间戳时间间隔返回s
+(int)diffTimeWithEndTime:(NSTimeInterval)endTime WithStarTime:(NSTimeInterval)starTime;
-(BOOL)isExist;
//私信时间显示格式
+(NSString*)diffTimestampOfPrivateMessageTime:(NSTimeInterval)timeSeconds;
@end
