//
//  EPNormalClass.h
//  PocketExpense
//
//  Created by MV on 11-11-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//-------------这个类 是用来设置 根据时间有关的方法的
@class Transaction;
@interface EPNormalClass : NSObject
{
    NSString *currenyStr;
    NSNumberFormatter *numberFmt;
    NSString *dbVersionStr;
    
}

@property (nonatomic, strong) NSString *dbVersionStr;

@property (nonatomic, strong) NSString *currenyStr;
@property (nonatomic, strong) NSNumberFormatter *numberFmt;

//获取 expense 的颜色，获取 income 的颜色
- (UIColor *)getExpColor:(int)colorId;
- (UIColor *)getIncColor:(int)colorId;
- (UIImage *)getExpImage:(int)colorId;
- (UIImage *)getIncImage:(int)colorId;


//1.设置 currency 2.设置版本string 3.将一个double类型的数据转换成一个 string 类型的数据 4.判断某个日期是不是今天
-(void)setCurrenyStrBySettings;
-(void)setDBVerString;
-(NSString *)formatterString:(double)doubleContext;
-(BOOL)dateIsToday:(NSDate *)cmpDate;

//比较两个日期谁比较大
-(int)dateCompare:(NSDate *)dt1 withDate:(NSDate *)dt2;
-(int)monthCompare:(NSDate *)dt1 withDate:(NSDate *)dt2;
-(int)secondCompare:(NSDate *)dt1 withDate:(NSDate *)dt2;
-(int)weekCompare:(NSDate *)dt1 withDate:(NSDate *)dt2;

//1.获取一个月的第一天 2.获取一个月的最后一天
-(NSDate *)getMonthFirstDate:(NSDate *)date;
-(NSDate *)getMonthEndDate:(NSDate *)date ;

//1.根据某个字符串获取对应的起始时间 2.根据时间的类型获取结束时间
- (NSDate *) getStartDateWithDateType:(NSInteger)dateType fromDate:(NSDate *)startDate;
-(NSDate *)getEndDate:(NSDate *)startDate withDateString:(NSString *)dateRangeString;

//根据给定的某一天获取对应循环的第一天
-(NSDate *)getStartDate:(NSString *)dateCycleString beforCycleCount:(NSInteger )i withDate:(NSDate *)startDate;


-(NSDate *)getStartDate:(NSString *)dateCycleString beforCycleCount:(NSInteger )i;
-(NSDate *)getEndDate:(NSDate *)startDate dateCycleString:(NSString *)dateRangeString ;

-(NSDate *)getPerDate:(NSDate *)start byCycleType:(NSString *)cycleType;
-(NSDate *)getNextDate:(NSDate *)start byCycleType:(NSString *)cycleType;

-(NSDate *)getDate:(NSDate *)start byCycleType:(NSString *)cycleType;
//根据一个开始时间与结束时间一级循环的类型，获取循环的次数
-(long)getCountOfInsert:(NSDate *)start repeatEnd:(NSDate *)end typeOfRecurring:(NSString *)cycle;

-(NSDate *)getFirstSecByDate:(NSDate *)date;
-(NSDate *)getLastSecByDate:(NSDate *)date;
-(NSDate *)getCycleStartDateByMinDate:(NSDate *)minDate withCycleStartDate:(NSDate*)cycleStart withCycleType:(NSString *)cycleType isRule:(BOOL)rule;

- (NSDate *) getEndDateDateType:(NSInteger)dateType withStartDate:(NSDate *)startDate;
-(void)addNotification:(NSDate*)dateTime withAmount:(double)amount withCategoryName:(NSString *)cateString;

- (NSDate *)getStartDate:(NSString *)dateRangeString;

+ (NSString *)GetUUID;
-(NSString *)getUUIDFromData:(NSDate *)date;
-(NSString *)getSecondUUID_withNoCycleTrans:(NSDate *)noCycleDate  CycleTrans:(Transaction *)cycleTrans;

-(void)showSyncTip;
- (NSString *)formatterStringWithOutPositive:(double)doubleContext;
- (NSString *)formatterStringWithOutCurrency:(double)doubleContext;
- (NSString *)formatterStringWithOutCurrency_withFloat:(double)doubleContext;
-(NSString *)formatterAmount:(NSString *)str;

-(UIColor *)getAmountRedColor;
-(UIColor *)getAmountGreenColor;
-(UIColor *)getAmountGrayColor;
-(UIColor *)getAmountBlackColor;
-(UIColor *)getGrayColor_156_156_156;
-(UIColor *)getGrayColor_94_99_77;
-(UIColor *)getAmountBlueColor;
-(UIColor *)getDateColor_inCalendar_blueColr;
-(UIColor *)getAmountPurpleColor_632599;
-(UIColor *)getNavigationBarGray_Highlighted;
-(UIColor *)getColor_229_229_229;
-(UIColor *)getColor_204_204_204;


-(UIFont *)getDateFont_inClaendar_WithSize:(int)tmpSize;
-(UIFont *)getMoneyFont_inCalendar_WithSize:(int)tmpSize;
-(UIFont *)getMoneyFont_exceptInCalendar_WithSize:(int)tmpSize;
-(UIFont *)getMoneyFont_Avenir_LT_85_Heavy_withSzie:(int)tmpSize;
-(UIFont *)GETdateFont_Regular_withSize:(int)tmpSize;

//iPad
-(UIColor *)getiPadNavigationBarTiltleTeextColor;
-(UIColor *)getiPADNavigationBarBtnColor;
-(UIColor *)getiPADColor_42_45_51;
-(UIColor *)getiPADColor_149_150_156;


-(NSString *)changeRecurringTexttoLocalLangue:(NSString *)recurringText;
-(NSString *)changeLocalLanguetoRecurringText:(NSString *)localText;
-(NSString *)changeRecurringTypetoLocalLangue_bill:(NSString *)recurringText;
-(NSString *)changeReminderTexttoLocalLangue:(NSString *)reminderText;

-(void)setFlurryEvent_WithIdentify:(NSString *)event;
-(void)setFlurryEvent_withUpgrade:(BOOL)isPurchase;

+ (NSString*)currentLanguage;
@end
