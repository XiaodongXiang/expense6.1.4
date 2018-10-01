//
//  HelpClass.h
//  BillKeeper
//
//  Created by ShanJunqing on 11-6-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

#pragma mark - ---------------------------HSBColor---------------------------
@interface HSBColor : NSObject
{
	float red;
	float green;
	float blue;
	float alpha;
	
	float brightness;
	float saturation;
	float hue;
}
@property (nonatomic) float red;
@property (nonatomic) float green;
@property (nonatomic) float blue;
@property (nonatomic) float alpha;

@property (nonatomic) float brightness;
@property (nonatomic) float saturation;
@property (nonatomic) float hue;

@end

#pragma mark - ---------------------------HelpClass---------------------------
@interface HelpClass : NSObject 
{

}
#pragma mark 数据库 方法
+ (void)sortObjects:(NSMutableArray *)objects soryNames:(NSArray *)soryNames ascendings:(NSArray *)ascendings;

#pragma mark 非数据库 方法
+ (UIColor *)getDeepColorByColor:(CGColorRef)color;
+ (HSBColor*)hsbColorWithColor:(CGColorRef)color;
+ (HSBColor*)hsbColorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;

@end

#pragma mark - ---------------------------NSCalendar---------------------------
@interface NSCalendar (Custom)

+ (NSCalendar *)timezoneCalendar;
+ (NSCalendar *)localCalendar;
+ (NSCalendar *)GMTCalendar;

@end

#pragma mark - ---------------------------NSDate---------------------------
typedef enum
{
	DateFormatterTypeLocal = 0,
	DateFormatterTypeCustom
}DateFormatterType;

typedef enum
{
	DateInfoTypeYear = 0,
	DateInfoTypeMonth,
	DateInfoTypeDay,
	DateInfoTypeHour,
	DateInfoTypeMinute,
	DateInfoTypeSecond,
	DateInfoTypeWeek,
	DateInfoTypeWeekday,
	DateInfoTypeWeekdayOrdinal,
	DateInfoTypeQuarter,
	DateInfoTypeWeekOfYear
} DateInfoType;

typedef enum
{
	GetDateTypeAddSubtract = 0,
	GetDateTypeModification
}GetDateType;

typedef enum
{
	NSCalendarTypeLocal = 0,
	NSCalendarTypeTimezone,
	NSCalendarTypeGMT
}NSCalendarType;

@interface NSDate (Custom)

+ (NSDateFormatter *)localDateFormatter;
+ (NSDateFormatter *)timezoneDateFormatter;
+ (NSDateFormatter *)GMTDateFormatter;
+ (NSLocale *)locale;

- (NSString *)formatterStyle:(NSString *)style styleType:(DateFormatterType)styleType calendarType:(NSCalendarType)calendarType;
- (NSInteger)getDateInfoType:(DateInfoType)dateInfoType calendarType:(NSCalendarType)calendarType;
- (NSInteger)getDateWeekCount:(NSCalendarType)calendarType;
- (NSDate *)getDateByYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)min second:(NSInteger)sec getDatetype:(GetDateType)getDatetype calendarType:(NSCalendarType)calendarType;
- (NSDate *)getDateTimeDate:(NSDate *)time calendarType:(NSCalendarType)calendarType;
- (NSInteger)getDateDiffToDate:(NSDate *)endDate dateInfoType:(DateInfoType)dateInfoType calendarType:(NSCalendarType)calendarType;
- (BOOL)IsDateBetweenInclusiveBegin:(NSDate *)beginDate end:(NSDate *)endDate;
- (NSMutableArray *)getDateWeekArray:(NSCalendarType)calendarType;
- (NSMutableArray *)getDateMonthArray:(NSCalendarType)calendarType;
- (NSInteger)getYearDayCount:(NSCalendarType)calendarType;
- (BOOL)dateIs24h;
- (NSDate*)getStartTimeInDay:(NSCalendarType)calendarType;
- (NSDate *)getEndTimeInDay:(NSCalendarType)calendarType;
- (NSDate *)getFirstDayInWeek:(NSCalendarType)calendarType;
- (NSDate *)getFirstDayInMonth:(NSCalendarType)calendarType;
- (NSDate *)conversionDate:(NSCalendarType)typeOld typeNew:(NSCalendarType)typeNew;
- (NSDate *)getNextHour:(NSCalendarType)calendarType;

@end

#pragma mark - ---------------------------NSString---------------------------
typedef enum
{
	TimeFormatterTypeYMH = 0,
	TimeFormatterTypeMH
}TimeFormatterType;

@interface NSString (Custom)

+ (NSString *)formatterTime:(NSInteger)second type:(TimeFormatterType)type;
- (NSString *)qianWeiFuByxiaoshu:(NSInteger)shu;
- (NSUInteger)matchRegular:(NSString *)regularStr;
+ (NSString *)createUUID;

@end

#pragma mark - ---------------------------UIImage---------------------------
@interface UIImage (Custom)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
+ (UIImage*)imageWithColor:(UIColor *)color size:(CGSize)size;

@end

#pragma mark - ---------------------------UIView---------------------------
@interface UIView (Custom)

-(NSMutableArray *)getIntersectsView:(CGRect)area;
-(void)removeAllChildView;
-(id)getViewWithNibName:(NSString *)nibName;

@end

#pragma mark - ---------------------------UIDevice---------------------------
@interface UIDevice (Custom)

typedef enum
{
	GetIOSVersionNone = 0,
	GetIOSVersion3 = 3,
	GetIOSVersion4,
	GetIOSVersion5,
	GetIOSVersion6,
	GetIOSVersion7,
	GetIOSVersion8
}GetIOSVersion;

+ (BOOL)isDevicePhone;
+ (BOOL)isDeviceiPhone5;
+ (BOOL)isDeviceiPhone6;
+ (BOOL)isDeviceiPhone6Plus;
+ (NSString*)platform;
+ (NSString*)platformString;
+ (GetIOSVersion)getIosVersion;

@end

#pragma mark - ---------------------------UIColor---------------------------
@interface UIColor (Custom)

+ (NSString *) hexStringFromColor:(UIColor *)color;
+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)getValue1CellTextLabColor;
+ (UIColor *)getValue1CellDetailLabColor;

+(UIColor *)getLineColor;

@end

#pragma mark - ---------------------------UIFont---------------------------
@interface UIFont (Custom)

+ (UIFont *)getValue1CellTextLabFont;
+ (UIFont *)getValue1CellDetailLabFont;

@end

#pragma mark - ---------------------------CustomEventStore---------------------------
//@interface CustomEventStore (Custom)
//
//+(CustomEventStore *)eventStore;
//+(CustomEventStore *)reminderStore;

//@end