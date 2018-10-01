//
//  HelpClass.m
//  BillKeeper
//
//  Created by ShanJunqing on 11-6-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelpClass.h"

#include <sys/types.h>
#include <sys/sysctl.h>


#pragma mark - ---------------------------HSBColor---------------------------
@implementation HSBColor

@synthesize red;
@synthesize green;
@synthesize blue;
@synthesize alpha;
@synthesize brightness;
@synthesize saturation;
@synthesize hue;

@end

#pragma mark - ---------------------------HelpClass---------------------------
@implementation HelpClass

#pragma mark - 排序方法
//排序 objects排序对象 soryNames排序字段集合 ascending:对应排序字段的排序方式 YES升序 NO降序
+ (void)sortObjects:(NSMutableArray *)objects soryNames:(NSArray *)soryNames ascendings:(NSArray *)ascendings
{	
	NSMutableArray *sortDescriptArray = [[NSMutableArray alloc] init];
		
	for(NSInteger i = 0; i < [soryNames count]; i++)
	{
		NSString *soryName = [soryNames objectAtIndex:i];
		BOOL ascending = [[ascendings objectAtIndex:i] boolValue];
		
		NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:soryName ascending:ascending];
		[sortDescriptArray addObject:sortDescriptor];
	}
	[objects sortUsingDescriptors:sortDescriptArray];
}
#pragma mark - 改变颜色 方法
+ (UIColor *)getDeepColorByColor:(CGColorRef)color
{
	HSBColor *hsbColor = [HelpClass hsbColorWithColor:color];
	
	return [UIColor colorWithHue:hsbColor.hue saturation:hsbColor.saturation brightness:hsbColor.brightness-0.2 alpha:1];
}
+ (HSBColor*)hsbColorWithColor:(CGColorRef)color
{
	NSInteger numComponents = CGColorGetNumberOfComponents(color);
	CGFloat red = 0, green = 0, blue = 0, alpha = 0;
	if (numComponents == 4)
	{
		const CGFloat *components = CGColorGetComponents(color);
		red = components[0];
		green = components[1];
		blue = components[2];
		alpha = components[3];
	}	
	return [HelpClass hsbColorWithRed:red green:green blue:blue alpha:alpha];	
}
+ (HSBColor*)hsbColorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
{
    HSBColor* toReturn = [[HSBColor alloc] init];
	
	toReturn.red = red;
	toReturn.green = green;
	toReturn.blue = blue;
	toReturn.alpha = alpha;
	
    float colorArray[3];
    colorArray[0] = red; 
    colorArray[1] = green; 
    colorArray[2] = blue;

    int max = 0;
    int min = 0;
    for(int i=1; i<3; i++)
    {
        if(colorArray[i] > colorArray[max])
            max=i;
        if(colorArray[i] < colorArray[min])
            min=i;
    }
	
    if(max==min)
    {
        toReturn.hue=0;
        toReturn.saturation=0;
        toReturn.brightness=colorArray[0];
    }
    else
    {
        toReturn.brightness=colorArray[max];
		
        toReturn.saturation=(colorArray[max]-colorArray[min])/(colorArray[max]);
		
		switch (max)
		{
			case 0: //Red
				toReturn.hue = (colorArray[1]-colorArray[2])/(colorArray[max]-colorArray[min])*60/360;
				break;
			case 1: //Green
				toReturn.hue = (2.0 + (colorArray[2]-colorArray[0])/(colorArray[max]-colorArray[min]))*60/360;
				break;
			default: //Blue
				toReturn.hue = (4.0 + (colorArray[0]-colorArray[1])/(colorArray[max]-colorArray[min]))*60/360;
				break;
		}
    }
    return toReturn;
}
@end

#pragma mark - ---------------------------NSCalendar---------------------------
@implementation NSCalendar (Custom)

+ (NSCalendar *)timezoneCalendar
{
	return [NSCalendar currentCalendar];
}
+ (NSCalendar *)localCalendar
{

	return [NSCalendar currentCalendar];
}
+ (NSCalendar *)GMTCalendar
{

	return [NSCalendar currentCalendar];
}

@end

#pragma mark - ---------------------------NSDate---------------------------
@implementation NSDate (Custom)

+ (NSDateFormatter *)localDateFormatter
{
	static NSDateFormatter *dateFormatter;
	if(!dateFormatter)
	{
		dateFormatter = [[NSDateFormatter alloc] init];
	}
	return dateFormatter;
}
+ (NSDateFormatter *)timezoneDateFormatter
{
	static NSDateFormatter *timezoneDateFormatter;
	if(!timezoneDateFormatter)
	{
		timezoneDateFormatter = [[NSDateFormatter alloc] init];
	}
	return timezoneDateFormatter;
}
+ (NSDateFormatter *)GMTDateFormatter
{
	static NSDateFormatter *GMTDateFormatter;
	if(!GMTDateFormatter)
	{
		GMTDateFormatter = [[NSDateFormatter alloc] init];
		[GMTDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	}
	return GMTDateFormatter;
}
+ (NSLocale *)locale
{
	static NSLocale *locale;
	if(!locale)
	{
		locale = [NSLocale currentLocale];
	}
	return locale;
}

#pragma mark - NSDate 处理的方法
/**日期格式化 
 *
 * style 样式 
 * type  是跟本地化还是直接根据样式
 **/
- (NSString *)formatterStyle:(NSString *)style styleType:(DateFormatterType)styleType calendarType:(NSCalendarType)calendarType
{
	NSDateFormatter *formatter = nil;	
	switch (calendarType)
	{
		case NSCalendarTypeLocal:
			formatter = [NSDate localDateFormatter];
			break;
		case NSCalendarTypeTimezone:
			formatter = [NSDate timezoneDateFormatter];
			break;
		case NSCalendarTypeGMT:
			formatter = [NSDate GMTDateFormatter];
			break;
		default:
			formatter = [[NSDateFormatter alloc] init];
			break;
	}
	switch (styleType)
	{
		case DateFormatterTypeLocal:
			[formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:style options:0 locale:[NSLocale currentLocale]]];
			break;
		case DateFormatterTypeCustom:
			[formatter setDateFormat:style];
			break;
		default:
			break;
	}	
	return [formatter stringFromDate:self];
}
/**获取date的具体属性值
 *
 **/
- (NSInteger)getDateInfoType:(DateInfoType)dateInfoType calendarType:(NSCalendarType)calendarType
{
	NSCalendar *calendar = nil;	
	switch (calendarType)
	{
		case NSCalendarTypeLocal:
			calendar = [NSCalendar localCalendar];
			break;
		case NSCalendarTypeTimezone:
			calendar = [NSCalendar timezoneCalendar];
			break;
		case NSCalendarTypeGMT:
			calendar = [NSCalendar GMTCalendar];
			break;
		default:
			calendar = [NSCalendar currentCalendar];
			break;
	}	
	unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
						 NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit |
						 NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit |
						 NSQuarterCalendarUnit | NSWeekOfYearCalendarUnit;
	NSDateComponents *dc = [calendar components:flags fromDate:self];
	switch (dateInfoType)
	{
		case DateInfoTypeYear:
			return [dc year];
			break;
		case DateInfoTypeMonth:
			return [dc month];
			break;
		case DateInfoTypeDay:
			return [dc day];
			break;
		case DateInfoTypeHour:
			return [dc hour];
			break;
		case DateInfoTypeMinute:
			return [dc minute];
			break;
		case DateInfoTypeSecond:
			return [dc second];
			break;
		case DateInfoTypeWeek:
			return [dc week];
			break;
		case DateInfoTypeWeekday:
			return [dc weekday];
			break;
		case DateInfoTypeWeekdayOrdinal:
			return [dc weekdayOrdinal];
			break;
		case DateInfoTypeQuarter:
			return [dc quarter];
			break;
		case DateInfoTypeWeekOfYear:
			return [dc weekOfYear];
			break;
		default:
			return -1;
			break;
	}	
}
/**获取dete的当年一共有多少周
 *
 **/
- (NSInteger)getDateWeekCount:(NSCalendarType)calendarType
{
	NSCalendar *calendar = nil;
	switch (calendarType)
	{
		case NSCalendarTypeLocal:
			calendar = [NSCalendar localCalendar];
			break;
		case NSCalendarTypeTimezone:
			calendar = [NSCalendar timezoneCalendar];
			break;
		case NSCalendarTypeGMT:
			calendar = [NSCalendar GMTCalendar];
			break;
		default:
			calendar = [NSCalendar currentCalendar];
			break;
	}
	return [calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSYearCalendarUnit forDate:self].length;
}
/**拼合时间 1 
 *
 *type == GetDateTypeAddSubtract:  在date的基础上加减 
 *type == GetDateTypeModification: 在date的基础上直接修改其属性 某个参数为-1时 表示此属性不修改
 **/
- (NSDate *)getDateByYear:(NSInteger)year
					month:(NSInteger)month
					  day:(NSInteger)day
					 hour:(NSInteger)hour
				   minute:(NSInteger)min
				   second:(NSInteger)sec
			  getDatetype:(GetDateType)getDatetype
			 calendarType:(NSCalendarType)calendarType
{
	NSCalendar *calendar = nil;
	switch (calendarType)
	{
		case NSCalendarTypeLocal:
			calendar = [NSCalendar localCalendar];
			break;
		case NSCalendarTypeTimezone:
			calendar = [NSCalendar timezoneCalendar];
			break;
		case NSCalendarTypeGMT:
			calendar = [NSCalendar GMTCalendar];
			break;
		default:
			calendar = [NSCalendar currentCalendar];
			break;
	}
	NSDate *tempDate = [NSDate date];
	switch (getDatetype)
	{
		case GetDateTypeAddSubtract:
		{
			NSDateComponents *dc = [[NSDateComponents alloc] init];	
			[dc setYear:year];
			[dc setMonth:month];
			[dc setDay:day];
			[dc setHour:hour];
			[dc setMinute:min];
			[dc setSecond:sec];	
			tempDate = [calendar dateByAddingComponents:dc toDate:self options:0];
		}
			break;
		case GetDateTypeModification:
		{
			unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
						
			NSDateComponents *dc = [calendar components:flags fromDate:self];
			if(year != -1)	[dc setYear:year];
			if(month != -1) [dc setMonth:month];
			if(day != -1)	[dc setDay:day];
			if(hour != -1)	[dc setHour:hour];
			if(min != -1)	[dc setMinute:min];
			if(sec != -1)	[dc setSecond:sec];
			
			tempDate = [calendar dateFromComponents:dc];
		}
			break;
		default:
			break;
	}	
	return tempDate;
}
/**拼合时间 2
 *
 *self: 年月日部分
 *time:	时分秒部分
 **/
- (NSDate *)getDateTimeDate:(NSDate *)time calendarType:(NSCalendarType)calendarType
{
	NSInteger h = !time ? 0 : [time getDateInfoType:DateInfoTypeHour calendarType:calendarType];
	NSInteger m = !time ? 0 : [time getDateInfoType:DateInfoTypeMinute calendarType:calendarType];
	NSInteger s = !time ? 0 : [time getDateInfoType:DateInfoTypeSecond calendarType:calendarType];
	
	return [self getDateByYear:-1 month:-1 day:-1 hour:h minute:m second:s getDatetype:GetDateTypeModification calendarType:calendarType];
}
/**日期差
 *
 **/
- (NSInteger)getDateDiffToDate:(NSDate *)endDate dateInfoType:(DateInfoType)dateInfoType calendarType:(NSCalendarType)calendarType
{
	NSCalendar *calendar = nil;
	switch (calendarType)
	{
		case NSCalendarTypeLocal:
			calendar = [NSCalendar localCalendar];
			break;
		case NSCalendarTypeTimezone:
			calendar = [NSCalendar timezoneCalendar];
			break;
		case NSCalendarTypeGMT:
			calendar = [NSCalendar GMTCalendar];
			break;
		default:
			calendar = [NSCalendar currentCalendar];
			break;
	}
	NSDateComponents *dc = nil;	
	switch (dateInfoType)
	{
		case DateInfoTypeYear:
			dc = [calendar components:NSYearCalendarUnit fromDate:self toDate:endDate options:0];
			return [dc year];
			break;
		case DateInfoTypeMonth:
			dc = [calendar components:NSMonthCalendarUnit fromDate:self toDate:endDate options:0];
			return [dc month];
			break;
		case DateInfoTypeDay:
			dc = [calendar components:NSDayCalendarUnit fromDate:self toDate:endDate options:0];
			return [dc day];
			break;
		case DateInfoTypeHour:
			dc = [calendar components:NSHourCalendarUnit fromDate:self toDate:endDate options:0];
			return [dc hour];
			break;
		case DateInfoTypeMinute:
			dc = [calendar components:NSMinuteCalendarUnit fromDate:self toDate:endDate options:0];
			return [dc minute];
			break;
		case DateInfoTypeSecond:
			dc = [calendar components:NSSecondCalendarUnit fromDate:self toDate:endDate options:0];
			return [dc second];
			break;
		case DateInfoTypeWeek:
			dc = [calendar components:NSWeekCalendarUnit fromDate:self toDate:endDate options:0];
			return [dc week];
			break;
		default:
			return 0;
			break;
	}
}
/**判断日期 是否在范围内
 *
 **/
- (BOOL)IsDateBetweenInclusiveBegin:(NSDate *)beginDate end:(NSDate *)endDate
{
	return [self compare:beginDate] != NSOrderedAscending && [self compare:endDate] != NSOrderedDescending;
}
/**获取date当周 7天
 *
 **/
- (NSMutableArray *)getDateWeekArray:(NSCalendarType)calendarType
{
	NSCalendar *calendar = nil;
	switch (calendarType)
	{
		case NSCalendarTypeLocal:
			calendar = [NSCalendar localCalendar];
			break;
		case NSCalendarTypeTimezone:
			calendar = [NSCalendar timezoneCalendar];
			break;
		case NSCalendarTypeGMT:
			calendar = [NSCalendar GMTCalendar];
			break;
		default:
			calendar = [NSCalendar currentCalendar];
			break;
	}
	NSMutableArray *weekList = [NSMutableArray array];
	NSDate *weekFirstDate = nil;
	[calendar rangeOfUnit:NSWeekCalendarUnit startDate:&weekFirstDate interval:NULL forDate:self];
	[weekList addObject:weekFirstDate];
	for(int i = 1; i < 7; i ++)
	{
		NSDate *tempDate = [weekFirstDate getDateByYear:0 month:0 day:i hour:0 minute:0 second:0 getDatetype:GetDateTypeAddSubtract calendarType:calendarType];
		tempDate = [tempDate getStartTimeInDay:calendarType];
		[weekList addObject:tempDate];
	}
	NSArray *sortArray = [weekList sortedArrayUsingSelector:@selector(compare:)];
	[weekList removeAllObjects];
	[weekList addObjectsFromArray:sortArray];
	
	return weekList;
}
/** 获取date当月天数
 *
 */
-(NSMutableArray *)getDateMonthArray:(NSCalendarType)calendarType
{
	NSCalendar *calendar = nil;
	switch (calendarType)
	{
		case NSCalendarTypeLocal:
			calendar = [NSCalendar localCalendar];
			break;
		case NSCalendarTypeTimezone:
			calendar = [NSCalendar timezoneCalendar];
			break;
		case NSCalendarTypeGMT:
			calendar = [NSCalendar GMTCalendar];
			break;
		default:
			calendar = [NSCalendar currentCalendar];
			break;
	}	
	NSMutableArray *monthList = [NSMutableArray array];
	NSDate *monthFirstDate = nil;
	[calendar rangeOfUnit:NSMonthCalendarUnit startDate:&monthFirstDate interval:NULL forDate:self];
	[monthList addObjectsFromArray:[monthFirstDate getDateWeekArray:calendarType]];
	NSInteger int1 = [[monthFirstDate formatterStyle:@"yyyyMM" styleType:DateFormatterTypeCustom calendarType:calendarType] integerValue];
	for(int i = 1; ; i++)
	{
		NSDate *date = [monthFirstDate getDateByYear:0 month:0 day:i*7 hour:0 minute:0 second:0 getDatetype:GetDateTypeAddSubtract calendarType:calendarType];
		NSMutableArray *weekList = [date getDateWeekArray:calendarType];
		NSInteger int2 = [[[weekList objectAtIndex:0] formatterStyle:@"yyyyMM" styleType:DateFormatterTypeCustom calendarType:calendarType] integerValue];
		if(int1 != int2)
		{	break;}
		[monthList addObjectsFromArray:weekList];
	}
	NSArray *sortArray = [monthList sortedArrayUsingSelector:@selector(compare:)];
	[monthList removeAllObjects];
	[monthList addObjectsFromArray:sortArray];
	
	return monthList;
}
/**获取一年多少天
 *
 **/
- (NSInteger)getYearDayCount:(NSCalendarType)calendarType
{
	NSDate *year1 = [self getDateByYear:-1 month:1 day:1 hour:0 minute:0 second:0 getDatetype:GetDateTypeModification calendarType:calendarType];
	NSDate *year2 = [year1 getDateByYear:1 month:0 day:0 hour:0 minute:0 second:0 getDatetype:GetDateTypeAddSubtract calendarType:calendarType];

	return [year1 getDateDiffToDate:year2 dateInfoType:DateInfoTypeDay calendarType:calendarType];
}
/**是否是24小时制
 *
 **/
- (BOOL)dateIs24h
{		
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24Hour = (amRange.location == NSNotFound && pmRange.location == NSNotFound);	
    return is24Hour;
}
/**获取一天开始时间
 *
 **/
- (NSDate*)getStartTimeInDay:(NSCalendarType)calendarType
{
	NSCalendar *calendar = nil;
	switch (calendarType)
	{
		case NSCalendarTypeLocal:
			calendar = [NSCalendar localCalendar];
			break;
		case NSCalendarTypeTimezone:
			calendar = [NSCalendar timezoneCalendar];
			break;
		case NSCalendarTypeGMT:
			calendar = [NSCalendar GMTCalendar];
			break;
		default:
			calendar = [NSCalendar currentCalendar];
			break;
	}
	NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
	return [calendar dateFromComponents:components];
}
/**获取一天结束时间
 *
 **/
- (NSDate *)getEndTimeInDay:(NSCalendarType)calendarType
{
	NSCalendar *calendar = nil;
	switch (calendarType)
	{
		case NSCalendarTypeLocal:
			calendar = [NSCalendar localCalendar];
			break;
		case NSCalendarTypeTimezone:
			calendar = [NSCalendar timezoneCalendar];
			break;
		case NSCalendarTypeGMT:
			calendar = [NSCalendar GMTCalendar];
			break;
		default:
			calendar = [NSCalendar currentCalendar];
			break;
	}
	NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
	NSDate *date = [calendar dateFromComponents:components];
	components = [components init];
	[components setDay:+1];
	[components setSecond:-1];
	
	return 	[calendar dateByAddingComponents:components toDate:date options:0];
}
/**获取一周的第一天
 *
 **/
- (NSDate *)getFirstDayInWeek:(NSCalendarType)calendarType
{
	NSCalendar *calendar = nil;
	switch (calendarType)
	{
		case NSCalendarTypeLocal:
			calendar = [NSCalendar localCalendar];
			break;
		case NSCalendarTypeTimezone:
			calendar = [NSCalendar timezoneCalendar];
			break;
		case NSCalendarTypeGMT:
			calendar = [NSCalendar GMTCalendar];
			break;
		default:
			calendar = [NSCalendar currentCalendar];
			break;
	}
	NSDate *weekFirstDate = nil;
	[calendar rangeOfUnit:NSWeekCalendarUnit startDate:&weekFirstDate interval:NULL forDate:self];
	return weekFirstDate;
}
/**获取一个月的第一天
 *
 **/
- (NSDate *)getFirstDayInMonth:(NSCalendarType)calendarType
{
	NSCalendar *calendar = nil;
	switch (calendarType)
	{
		case NSCalendarTypeLocal:
			calendar = [NSCalendar localCalendar];
			break;
		case NSCalendarTypeTimezone:
			calendar = [NSCalendar timezoneCalendar];
			break;
		case NSCalendarTypeGMT:
			calendar = [NSCalendar GMTCalendar];
			break;
		default:
			calendar = [NSCalendar currentCalendar];
			break;
	}
	NSDate *monthFirstDate = nil;
	[calendar rangeOfUnit:NSMonthCalendarUnit startDate:&monthFirstDate interval:NULL forDate:self];
	return monthFirstDate;
}
/**
 *
 **/
- (NSDate *)conversionDate:(NSCalendarType)typeOld typeNew:(NSCalendarType)typeNew
{
	NSCalendar *calendarOld = nil;
	switch (typeOld)
	{
		case NSCalendarTypeLocal:
			calendarOld = [NSCalendar localCalendar];
			break;
		case NSCalendarTypeTimezone:
			calendarOld = [NSCalendar timezoneCalendar];
			break;
		case NSCalendarTypeGMT:
			calendarOld = [NSCalendar GMTCalendar];
			break;
		default:
			calendarOld = [NSCalendar currentCalendar];
			break;
	}
	NSCalendar *calendarNew = nil;
	switch (typeNew)
	{
		case NSCalendarTypeLocal:
			calendarNew = [NSCalendar localCalendar];
			break;
		case NSCalendarTypeTimezone:
			calendarNew = [NSCalendar timezoneCalendar];
			break;
		case NSCalendarTypeGMT:
			calendarNew = [NSCalendar GMTCalendar];
			break;
		default:
			calendarNew = [NSCalendar currentCalendar];
			break;
	}
	NSDateComponents* components = [calendarOld components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:self];
	return [calendarNew dateFromComponents:components];
	
//	NSInteger hour = [self getDateInfoType:DateInfoTypeHour calendarType:typeOld];
//	NSInteger min = [self getDateInfoType:DateInfoTypeMinute calendarType:typeOld];
//	NSInteger sec = [self getDateInfoType:DateInfoTypeSecond calendarType:typeOld];
//
//	NSDateComponents* components = [calendarOld components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:self];
//	[components setHour:hour];
//	[components setMinute:min];
//	[components setSecond:sec];
//	return [calendarNew dateFromComponents:components];
}
/** 获取当前时间下一个小时的整点
 *
 **/
- (NSDate *)getNextHour:(NSCalendarType)calendarType
{
	NSCalendar *calendar = nil;
	switch (calendarType)
	{
		case NSCalendarTypeLocal:
			calendar = [NSCalendar localCalendar];
			break;
		case NSCalendarTypeTimezone:
			calendar = [NSCalendar timezoneCalendar];
			break;
		case NSCalendarTypeGMT:
			calendar = [NSCalendar GMTCalendar];
			break;
		default:
			calendar = [NSCalendar currentCalendar];
			break;
	}
	NSDate *d = [[NSDate date] conversionDate:NSCalendarTypeLocal typeNew:calendarType];
	d = [d getDateByYear:-1 month:-1 day:-1 hour:-1 minute:0 second:0 getDatetype:GetDateTypeModification calendarType:calendarType];
	d = [d getDateByYear:0 month:0 day:0 hour:1 minute:0 second:0 getDatetype:GetDateTypeAddSubtract calendarType:calendarType];
	d = [self getDateTimeDate:d calendarType:calendarType];
	
	return d;
}

@end

#pragma mark - ---------------------------NSString---------------------------
@implementation NSString (Custom)

/**时间格式化
 *
 **/ 
+ (NSString *)formatterTime:(NSInteger)second type:(TimeFormatterType)type
{
	NSInteger hour = 0;
	NSInteger min = 0;
	NSInteger sec = 0;
	
	NSString *hStr = @"";
	NSString *mStr = @"";
	NSString *sStr = @"";
	
	sec = second % 60;
	min = second / 60 % 60;
	hour = second / 60 / 60;
	
	sStr = [NSString stringWithFormat:@"%ld", (long)sec];
	mStr = [NSString stringWithFormat:@"%ld", (long)min];
	hStr = [NSString stringWithFormat:@"%ld", (long)hour];
	
	if (sec < 10)
		sStr = [NSString stringWithFormat:@"0%@", sStr];
	if(min < 10)
		mStr = [NSString stringWithFormat:@"0%@", mStr];
	if(hour < 10)
		hStr = [NSString stringWithFormat:@"0%@", hStr];
	
	switch (type)
	{
		case TimeFormatterTypeYMH:
			return [NSString stringWithFormat:@"%@:%@:%@",hStr, mStr, sStr];
			break;
		case TimeFormatterTypeMH:
		{
			if(second < 3600)
				return [NSString stringWithFormat:@"%@:%@", mStr, sStr];
			else
				return [NSString stringWithFormat:@"%@:%@:%@",hStr, mStr, sStr];
		}
			break;
		default:
			return nil;
			break;
	}
}
/**千位符
 *
 *str 格式化字符串
 *shu 保留小数位数+1
 **/
- (NSString *)qianWeiFuByxiaoshu:(NSInteger)shu
{	
	NSInteger i = ([self length] - shu) / 3;
	NSInteger j = ([self length] - shu) % 3;
	
	NSString *tStr1 = @"";
	NSString *tStr2 = @"";
	
	if(j != 0)
		tStr1 = [[self substringWithRange:NSMakeRange(0, j)] stringByAppendingString:@","];
	
	tStr2 = [self substringFromIndex:j];
	
	for(int k = 0; k < i; k++)
	{
		if(k == i - 1)
			tStr1 = [tStr1 stringByAppendingString:[tStr2 substringFromIndex:k * 3]];
		else
			tStr1 = [[tStr1 stringByAppendingString:[tStr2 substringWithRange:NSMakeRange(k * 3, 3)]] stringByAppendingString:@","];
	}
	
	return tStr1;
}
- (NSUInteger)matchRegular:(NSString *)regularStr
{
    NSError *error = nil;
	
	NSRegularExpressionOptions options1 = NSRegularExpressionCaseInsensitive;
	NSMatchingOptions options2 = NSMatchingReportProgress;
	
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern: regularStr
                                                                            options: options1
                                                                              error: &error];
    NSUInteger matches = [regexp numberOfMatchesInString: self
                                                 options: options2
                                                   range: NSMakeRange(0, [self length])];
    return matches;
}
+ (NSString *)createUUID
{
	CFUUIDRef udid = CFUUIDCreate(NULL);
	NSString *udidString = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, udid));
	
    return udidString;
}
@end

#pragma mark - ---------------------------UIImage---------------------------
@implementation UIImage (Custom)

/**图片的截取 
 *
 *targetSize截取大小
 **/
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
	UIImage *newImage = nil;       
	CGSize imageSize = self.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);

	if (CGSizeEqualToSize(imageSize, targetSize) == NO)
	{
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		
		if (widthFactor > heightFactor)
			scaleFactor = widthFactor; 
		else
			scaleFactor = heightFactor;
		
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;
		
		// center the image
		if (widthFactor > heightFactor)
		{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		}
		if (widthFactor < heightFactor)
		{
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	}       

	UIGraphicsBeginImageContextWithOptions(targetSize, NO, [[UIScreen mainScreen] scale]); 

	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;

	[self drawInRect:thumbnailRect];

	newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	if(newImage == nil)
		NSLog(@"could not scale image");

	UIGraphicsEndImageContext();
	return newImage;
}
/**
 *
 ***/
+ (UIImage*)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();	
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));	
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return image;
}
@end

#pragma mark - ---------------------------UIView---------------------------
@implementation UIView (Custom)

/**获取UIView指定范围内的所有View
 *
 **/
- (NSMutableArray *)getIntersectsView:(CGRect)area
{	
	NSMutableArray *subvs = [[NSMutableArray alloc] init];	
	for (UIView *aView in self.subviews)
	{
		CGRect r1 = CGRectMake((int)area.origin.x, (int)area.origin.y, (int)area.size.width, (int)area.size.height);
		CGRect r2 = CGRectMake((int)aView.frame.origin.x, (int)aView.frame.origin.y, (int)aView.frame.size.width, (int)aView.frame.size.height);

		if(CGRectIntersectsRect(r1, r2))
			[subvs addObject:aView];
	}
	return subvs;
}
/**移除view所有子view
 *
 **/
-(void)removeAllChildView
{
	for(UIView *v in self.subviews)
	{
		[v removeFromSuperview];
	}
}
-(id)getViewWithNibName:(NSString *)nibName
{
	return [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
}

@end

#pragma mark - ---------------------------UIDevice---------------------------
@implementation UIDevice (Custom)

/**判断设备是iPhone还是iPad
 *
 **/
+ (BOOL)isDevicePhone
{
	static NSNumber *devicePhone;
	if(!devicePhone)
	{
		devicePhone = [NSNumber numberWithBool:[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone];
	}
	return [devicePhone boolValue];
}
/**判断设备是不是iPhone5
 *
 **/
+ (BOOL)isDeviceiPhone5
{
	static NSNumber *deviceiPhone5;
	if(!deviceiPhone5)
	{
		deviceiPhone5 = [NSNumber numberWithBool:[UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO];
	}
	return [deviceiPhone5 boolValue];
}

+ (BOOL)isDeviceiPhone6
{
    static NSNumber *deviceiPhone6;
    if(!deviceiPhone6)
    {
        deviceiPhone6 = [NSNumber numberWithBool:[UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO];
    }
    return [deviceiPhone6 boolValue];
}
+ (BOOL)isDeviceiPhone6Plus
{
    static NSNumber *deviceiPhone6Plus;
    if(!deviceiPhone6Plus)
    {
        deviceiPhone6Plus = [NSNumber numberWithBool:[UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO];
    }
    return [deviceiPhone6Plus boolValue];
}
/**获取设备型号
 *
 **/
+ (NSString*)platformString
{
	NSString *platform = [self platform];
	
	if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
	if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
	if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
	if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";

	if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
	if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";

	if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2";
	if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
	if ([platform isEqualToString:@"iPad2,5"])      return @"iPad mini 1";
	if ([platform isEqualToString:@"iPad2,6"])      return @"iPad mini 1";
	if ([platform isEqualToString:@"iPad2,7"])      return @"iPad mini 1";
	if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3";
	if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3";
	if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
	if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4";
	if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
	if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4";
   
	if ([platform isEqualToString:@"i386"])         return @"Simulator";
	
	return platform;
}
+ (NSString*)platform
{
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString* platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);
	
	return platform;
}
/**获取iOS版本
 *
 **/
+ (GetIOSVersion)getIosVersion
{
	NSString *deviceVersion = [[UIDevice currentDevice] systemVersion];
	NSInteger verNum = [[deviceVersion substringToIndex:1] integerValue];
	switch (verNum)
	{
		case 3:
			return GetIOSVersion3;
			break;
		case 4:
			return GetIOSVersion4;
			break;
		case 5:
			return GetIOSVersion5;
			break;
		case 6:
			return GetIOSVersion6;
			break;
		case 7:
			return GetIOSVersion7;
			break;
		case 8:
			return GetIOSVersion8;
			break;
		default:
			return GetIOSVersionNone;
			break;
	}
}
@end

#pragma mark - ---------------------------UIColor---------------------------
@implementation UIColor (Custom)

+ (NSString *) hexStringFromColor:(UIColor *)color
{
	CGColorRef colorRef = [color CGColor];
	NSInteger _countComponents = CGColorGetNumberOfComponents(colorRef);
	CGFloat red = 0;
	CGFloat green = 0;
	CGFloat blue = 0;
    if (_countComponents == 4) {
        const CGFloat *_components = CGColorGetComponents(colorRef);
		red = _components[0];
		green = _components[1];
		blue  = _components[2];
	}
	// Fix range if needed
	if (red < 0.0f) red = 0.0f;
	if (green < 0.0f) green = 0.0f;
	if (blue < 0.0f) blue = 0.0f;
	
	if (red > 1.0f) red = 1.0f;
	if (green > 1.0f) green = 1.0f;
	if (blue > 1.0f) blue = 1.0f;
	
	// Convert to hex string between 0x00 and 0xFF
	return [NSString stringWithFormat:@"%02X%02X%02X", (int)(red * 255), (int)(green * 255), (int)(blue * 255)];
}
+ (UIColor*)colorWithHexString:(NSString*)hexString
{
	NSInteger rgbValue = strtoul([hexString UTF8String],0,16);
	
	return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
						   green:((float)((rgbValue & 0xFF00) >> 8))/255.0
							blue:((float)(rgbValue & 0xFF))/255.0
						   alpha:1.0];
}
+ (UIColor *)getValue1CellTextLabColor
{
	return [UIColor blackColor];
}
+ (UIColor *)getValue1CellDetailLabColor
{
	return [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1];
}
+ (UIColor *)getLineColor
{
	return [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
}
@end

#pragma mark - ---------------------------UIFont---------------------------
@implementation UIFont (Custom)

+ (UIFont *)getValue1CellTextLabFont
{
//	switch ([UIDevice getIosVersion])
//	{
//		case GetIOSVersion7:
//		{
			return [UIFont systemFontOfSize:17];
//		}
//			break;
//		default:
//		{
//			return [UIFont boldSystemFontOfSize:17];
//		}
//			break;
//	}
}
+ (UIFont *)getValue1CellDetailLabFont
{
	return [UIFont systemFontOfSize:17];
}
@end

#pragma mark - ---------------------------CustomEventStore---------------------------
/*
@implementation CustomEventStore (Custom)

+(CustomEventStore *)eventStore
{
	static CustomEventStore *es;
	if(!es){
		es = [[CustomEventStore alloc] init];

		switch ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent])
		{
			case EKAuthorizationStatusNotDetermined:
			{
				[es requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
					if(granted) {
						if(![UIDevice isDevicePhone]) {
							
							AppDelegate * __weak weakSelf = [[UIApplication sharedApplication] delegate];
							dispatch_async(dispatch_get_main_queue(), ^{
								
								weakSelf.dataInit.setting = nil;
								[weakSelf.dataInit settingInit];
								[[NSNotificationCenter defaultCenter] postNotification: [NSNotification notificationWithName: iNotificationObjectChangeRefurbishInterface object: nil]];
							});
						} else {
							dispatch_async(dispatch_get_main_queue(), ^{
                                [PlannerClass refreshMainViewWhenCalendarGranted];
                            });
						}
					}
				}];
			}
				break;
			default:
				break;
		}
	}
	if([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] != EKAuthorizationStatusAuthorized) {
		return nil;
	}
	return es;
}
+(CustomEventStore *)reminderStore
{
	static CustomEventStore *rs;
	if(!rs){
		rs = [[CustomEventStore alloc] init];
		
		switch ([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder])
		{
			case EKAuthorizationStatusNotDetermined:
			{
				[rs requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
					if(granted) {
						
						dispatch_async(dispatch_get_main_queue(), ^{
							
							if(![UIDevice isDevicePhone]) {

								[[NSNotificationCenter defaultCenter] postNotification: [NSNotification notificationWithName: iNotificationObjectChangeRefurbishInterface object: nil]];
							} else {
								
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchReminderCalendars" object:nil];
							}
						});
					}
				}];
			}
				break;
			default:
				break;
		}
	}
	if([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder] != EKAuthorizationStatusAuthorized) {
		return nil;
	}
	return rs;
}


@end
*/