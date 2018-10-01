//
//  EPNormalClass.m
//  PocketExpense
//
//  Created by MV on 11-11-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "EPNormalClass.h"
#import "PokcetExpenseAppDelegate.h"
#import "BudgetTemplate.h"
#import "BudgetTransfer.h"
#import "ApplicationDBVersion.h"
#import "Transaction.h"
#import "AppDelegate_iPad.h"
#import "AppDelegate_iPhone.h"

#import "Flurry.h"

#define DEFAULTACCOUNT @"Default Account"


//application enter times A-1 B-2~3 C-4~5 D-6~10 E-11~20 F-21~50 G-50+
#define FLURRY_ENTERAPP_A                  @"5A_ENTERAPP_A"
#define FLURRY_ENTERAPP_B                  @"5B_ENTERAPP_B"
#define FLURRY_ENTERAPP_C                  @"5C_ENTERAPP_C"
#define FLURRY_ENTERAPP_D                  @"5D_ENTERAPP_D"
#define FLURRY_ENTERAPP_E                  @"5E_ENTERAPP_E"
#define FLURRY_ENTERAPP_F                  @"5F_ENTERAPP_F"
#define FLURRY_ENTERAPP_G                  @"5G_ENTERAPP_G"

//在上述条件下点击购买按钮
#define FLURRY_ENTERAPP_A1                  @"5A_ENTERAPP_A1"
#define FLURRY_ENTERAPP_B1                  @"5B_ENTERAPP_B1"
#define FLURRY_ENTERAPP_C1                  @"5C_ENTERAPP_C1"
#define FLURRY_ENTERAPP_D1                  @"5D_ENTERAPP_D1"
#define FLURRY_ENTERAPP_E1                  @"5E_ENTERAPP_E1"
#define FLURRY_ENTERAPP_F1                  @"5F_ENTERAPP_F1"
#define FLURRY_ENTERAPP_G1                  @"5G_ENTERAPP_G1"

#define FLURRY_EVENT_0  @"01_PAG_BGT"   //进入左下角预算的次数
#define FLURRY_EVENT_1  @"01_PAG_ACC"    //进入右下角acc页面的次数
#define FLURRY_EVENT_2  @"01_PAG_SRC"   //进入搜索页面进行搜索操作的次数，进一次页面搜索N次算作一次，进页面没搜索不计次
#define FLURRY_EVENT_3  @"01_PAG_BIL"   //进入账单页面的次数
#define FLURRY_EVENT_4  @"01_PAG_RPT"   //进入报告的次数
#define FLURRY_EVENT_5  @"01_PAG_CALD"   //左上角进入日历页面的次数

#define FLURRY_EVENT_6  @"02_TRANS_ADD"   //添加交易并保存的次数，其他页面的也计在一起
#define FLURRY_EVENT_7  @"02_TRANS_RELT"   //侧滑进入搜索相关页面的次数，其他页面有这个按钮的也计在一起
#define FLURRY_EVENT_8  @"02_TRANS_DUPL"   //侧滑复制交易的次数，其他页面有这个按钮的也计在一起

#define FLURRY_EVENT_9  @"03_TRANS_TSF"   //添加transfer类型交易的次数
#define FLURRY_EVENT_10  @"03_TRANS_EXP"   //添加expense类型交易的次数
#define FLURRY_EVENT_11  @"03_TRANS_INC"   //添加income类型交易的次数

#define FLURRY_EVENT_12  @"04_TRANS_UNCL"   //添加或编辑交易时设置uncleared的次数
#define FLURRY_EVENT_13  @"04_TRANS_PTO"   //添加或编辑交易时设置photo的次数
#define FLURRY_EVENT_14  @"04_TRANS_MEMO"   //添加或编辑交易时设置memo的次数
#define FLURRY_EVENT_15  @"04_TRANS_SPLT"   //添加或编辑交易时设置split的次数
#define FLURRY_EVENT_151 @"04_TRANS_RECR" //添加或编辑交易时设置recurring的次数


#define FLURRY_EVENT_16  @"05_ACC_ADD"   //添加账户的次数

#define FLURRY_EVENT_17  @"06_ACCP_UNCL"   //账户页面点击左下角uncleared按钮的次数
#define FLURRY_EVENT_18  @"06_ACCP_NETW"   //账户页面点击右下角net worth按钮的次数
#define FLURRY_EVENT_19  @"06_ACCP_CAT"   //账户页面点击上面切换到category页面的次数


#define FLURRY_EVENT_20  @"07_ACC_AUOFF"   //添加或编辑账户关闭auto cleared的次数

#define FLURRY_EVENT_21  @"08_ACC_REC"   //账户内页点击reconcile的次数
#define FLURRY_EVENT_22  @"08_ACC_HDCL"   //账户内页点击hide cleared的次数

#define FLURRY_EVENT_23  @"09_BGT_ADJ"   //设置预算并保存的次数 
#define FLURRY_EVENT_24  @"09_BGT_TSF"   //预算内页点击transfer并保存的次数

#define FLURRY_EVENT_25  @"10_BGT_LFT"   //设置显示剩余预算的次数
#define FLURRY_EVENT_26  @"10_BGT_SPD"   //设置显示已用预算的次数

#define FLURRY_EVENT_27  @"11_BIL_ADD"   //添加账单并保存的次数
#define FLURRY_EVENT_28  @"11_BIL_PAY"   //支付账单并保存的次数

#define FLURRY_EVENT_29  @"12_BIL_CALD"   //账单页面切换到日历视图的次数
#define FLURRY_EVENT_30  @"12_BIL_LIST"   //账单页面切换到列表视图的次数

#define FLURRY_EVENT_31  @"13_BIL_PYE"   //添加或编辑账单payee项并保存的次数
#define FLURRY_EVENT_32  @"13_BIL_REPT"   //添加或编辑账单repeat项并保存的次数
#define FLURRY_EVENT_33  @"13_BIL_ALRT"   //添加或编辑账单alert项并保存的次数

#define FLURRY_EVENT_34  @"14_RPT_CSH"   //报告页面进入cash flow的次数
#define FLURRY_EVENT_35  @"14_RPT_CAT"   //报告页面进入category的次数

#define FLURRY_EVENT_36  @"15_RANG_LTMO"   //报告页面range选择last month的次数
#define FLURRY_EVENT_37  @"15_RANG_THQT"   //报告页面range选择this quarter的次数
#define FLURRY_EVENT_38  @"15_RANG_LTQT"   //报告页面range选择last quarter的次数
#define FLURRY_EVENT_39  @"15_RANG_THYR"   //报告页面range选择this year的次数
#define FLURRY_EVENT_40  @"15_RANG_LTYR"   //报告页面range选择last year的次数
#define FLURRY_EVENT_41  @"15_RANG_CUST"   //报告页面range选择custom range的次数

#define FLURRY_EVENT_42  @"16_CSH_INC"   //cash flow报告选择income的次数
#define FLURRY_EVENT_43  @"16_CAT_INC"   //category报告选择income的次数

#define FLURRY_EVENT_44  @"18_SET_SYNC"   //打开同步的次数
#define FLURRY_EVENT_45  @"18_SET_BKUP"   //点击setting中backup的次数

#define FLURRY_EVENT_46  @"19_EXPT_CSV"   //发送TRANS CSV报告的次数
#define FLURRY_EVENT_47  @"19_EXPT_PDF"   //发送TRANS PDF报告的次数
#define FLURRY_EVENT_48  @"19_EXPT_CASH"   //发送CASH FLOW报告的次数


#define FLURRY_EVENT_49  @"20_ADDTRS_ACC" //从account页面添加交易的次数
#define FLURRY_EVENT_50  @"20_ADDTRS_HOME" //从Home页面添加交易的次数


@implementation EPNormalClass
@synthesize currenyStr,numberFmt,dbVersionStr;
- (id)init{
    if (self = [super init]) 
	{
        currenyStr = @"$";
        numberFmt =[[NSNumberFormatter alloc] init];
   	}
    return self;
}

#pragma mark
#pragma mark getColor
//-----------设置 expense 类型交易的颜色
- (UIColor *)getExpColor:(int)colorId
{
    
	if(colorId == 0) return [UIColor colorWithRed:255/255.0 green:115/255.0 blue:100/255.0 alpha:1.f];
    
	else if(colorId == 1) return [UIColor colorWithRed:255/255.0 green:140/255.0 blue:100/255.0 alpha:1.f];
    
	else if(colorId == 2) return [UIColor colorWithRed:255/255.0 green:186/255.0 blue:97/255.0 alpha:1.f];
    
	else if(colorId == 3) return [UIColor colorWithRed:255.0/255.0 green:206/255.0 blue:101/255.0 alpha:1.f];
    
	else if(colorId == 4) return [UIColor colorWithRed:250/255.0 green:242/255.0 blue:107/255.0 alpha:1.f];
    
	else if(colorId == 5) return [UIColor colorWithRed:180/255.0 green:157/255.0 blue:253/255.0 alpha:1.f];
    
	else if(colorId == 6) return [UIColor colorWithRed:222/255.0 green:134/255.0 blue:255/255.0 alpha:1.f];
    
	else if(colorId == 7) return [UIColor colorWithRed:222/255.0 green:176/255.0 blue:255/255.0 alpha:1.f];
    
	else if(colorId == 8)return [UIColor colorWithRed:255/255.0 green:161/255.0 blue:214/255.0 alpha:1.f];
     else
         return [UIColor colorWithRed:255/255.0 green:134/255.0 blue:168/255.0 alpha:1.f];

}

-(UIImage *)getExpImage:(int)colorId{
    if(colorId == 0)return [UIImage imageNamed:@"expense_color.png"];
    
	else if(colorId == 1) return [UIImage imageNamed:@"expense_color1.png"];
    
	else if(colorId == 2) return [UIImage imageNamed:@"expense_color2.png"];
    
	else if(colorId == 3) return [UIImage imageNamed:@"expense_color3.png"];
    
	else if(colorId == 4) return [UIImage imageNamed:@"expense_color4.png"];
    
	else if(colorId == 5) return [UIImage imageNamed:@"expense_color5.png"];
    
	else if(colorId == 6) return [UIImage imageNamed:@"expense_color6.png"];
    
	else if(colorId == 7) return [UIImage imageNamed:@"expense_color7.png"];
    
	else if(colorId == 8) return [UIImage imageNamed:@"expense_color8.png"];
    
	else if(colorId == 9) return [UIImage imageNamed:@"expense_color9.png"];
 	return [UIImage imageNamed:@"expense_color00.png"];
}

//---------------设置 income 类型的颜色
- (UIColor *)getIncColor:(int)colorId
{
	if(colorId == 0)return [UIColor colorWithRed:56/255.0 green:217/255.0 blue:95/255.0 alpha:1.f];
    
	else if(colorId == 1) return [UIColor colorWithRed:66/255.0 green:217.0/255.0 blue:41/255.0 alpha:1.f];
    
	else if(colorId == 2) return [UIColor colorWithRed:44/255.0 green:229/255.0 blue:118/255.0 alpha:1.f];
    
	else if(colorId == 3) return [UIColor colorWithRed:44/255.0 green:229/255.0 blue:201/255.0 alpha:1.f];
    
	else if(colorId == 4) return [UIColor colorWithRed:44/255.0 green:169/255.0 blue:229/255.0 alpha:1.f];
    
	else if(colorId == 5) return [UIColor colorWithRed:44/255.0 green:179/255.0 blue:229/255.0 alpha:1.f];
    
	else if(colorId == 6) return [UIColor colorWithRed:44/255.0 green:162/255.0 blue:229/255.0 alpha:1.f];
    
	else if(colorId == 7) return [UIColor colorWithRed:44/255.0 green:136/255.0 blue:229/255.0 alpha:1.f];
    
	else if(colorId == 8) return [UIColor colorWithRed:44/255.0 green:114/255.0 blue:229/255.0 alpha:1.f];
    
	return [UIColor colorWithRed:58/255.0 green:100/255.0 blue:235/255.0 alpha:1.f];
}

- (UIImage *)getIncImage:(int)colorId
{
	if(colorId == 0)return [UIImage imageNamed:@"income_color.png"];
    
	else if(colorId == 1) return [UIImage imageNamed:@"income_color1.png"];
	else if(colorId == 2) return [UIImage imageNamed:@"income_color2.png"];
    
	else if(colorId == 3) return [UIImage imageNamed:@"income_color3.png"];
    
	else if(colorId == 4) return [UIImage imageNamed:@"income_color4.png"];
    
	else if(colorId == 5) return [UIImage imageNamed:@"income_color5.png"];
    
	else if(colorId == 6) return [UIImage imageNamed:@"income_color6.png"];
    
	else if(colorId == 7) return [UIImage imageNamed:@"income_color7.png"];
    
	else if(colorId == 8) return [UIImage imageNamed:@"income_color8.png"];
	else if(colorId == 9) return [UIImage imageNamed:@"income_color9.png"];
 	return [UIImage imageNamed:@"income_color00.png"];
}



#pragma mark Formatter String
//-----------设置 currency
-(void)setCurrenyStrBySettings;
{
	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.settings == nil)
        currenyStr = @"$";
    else
    {
         NSString *typeOfDollar = appDelegate.settings.currency;
        
        NSArray *dollorArray = [typeOfDollar componentsSeparatedByString:@"-"];
        
        currenyStr = [[[dollorArray objectAtIndex:0] substringToIndex:[[dollorArray objectAtIndex:0] length]-1] copy];
         [numberFmt setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFmt setCurrencySymbol:currenyStr];
        [numberFmt setMaximumFractionDigits:2];

    }
}

-(void)setDBVerString
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSManagedObjectContext* context = appDelegate.managedObjectContext;
	NSError* errors = nil;
	//get unit from database's Setting 数据库访问 DBVersion表，获得当前的版本号
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ApplicationDBVersion"
												  inManagedObjectContext:context];
	[request setEntity:entityDesc];
	NSArray *objects = [context executeFetchRequest:request error:&errors];
	NSMutableArray *mutableObjects = [[NSMutableArray alloc] initWithArray:objects];
	long count = [mutableObjects count];
	if(count != 1) 
	{
		dbVersionStr=@"1.0.2";
	}
	ApplicationDBVersion *adbv  = [mutableObjects lastObject];
	 
    //获取当前的版本号
	dbVersionStr =adbv.versionNumber;
//    [mutableObjects release];
 
}

//-------给金额double类型转换成 NSString类型
- (NSString *)formatterString:(double)doubleContext
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *string = @"";
	if(doubleContext >= 0)
		string = [NSString stringWithFormat:@"%.2f",doubleContext];
	else
        string = [NSString stringWithFormat:@"%.2f",-doubleContext];
    
	NSArray *tmp = [string componentsSeparatedByString:@"."];
	NSNumberFormatter *numberStyle = [[NSNumberFormatter alloc] init];
	[numberStyle setNumberStyle:NSNumberFormatterDecimalStyle];
	NSString *tmpStr = [numberStyle stringFromNumber:[NSNumber numberWithDouble:[[tmp objectAtIndex:0] doubleValue]]];
	if([tmp count]<2)
	{
		string = tmpStr;
	}
	else
	{
		
		string = [[tmpStr stringByAppendingString:@"."] stringByAppendingString:[tmp objectAtIndex:1]];
	}
    
    
	NSString *typeOfDollar = appDelegate.settings.currency;
	NSArray *dollorArray = [typeOfDollar componentsSeparatedByString:@"-"];
	NSString *dollorStr = [[dollorArray objectAtIndex:0] substringToIndex:[[dollorArray objectAtIndex:0] length]-1];
    
    if (doubleContext<0) {
        dollorStr = [NSString stringWithFormat:@"-%@",dollorStr];
    }
    
	string = [dollorStr stringByAppendingString:string];
    
    if(doubleContext < 0)
		string = [NSString stringWithFormat:@"%@",string];
    
    
    
	return string;
    
}


-(NSString *)formatterAmount:(NSString *)str{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    NSString *typeOfDollar = appDelegate.settings.currency;
	NSArray *dollorArray = [typeOfDollar componentsSeparatedByString:@"-"];
	NSString *dollorStr = [[dollorArray objectAtIndex:0] substringToIndex:[[dollorArray objectAtIndex:0] length]-1];
    
    NSRange range = [str rangeOfString:dollorStr];
    if (range.location != NSNotFound) {
        NSString *newAmountString = [str  substringFromIndex:[dollorStr length]];
        return newAmountString;
    }
    else
        return str;
    
    
}
- (NSString *)formatterStringWithOutPositive:(double)doubleContext
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *string = @"";
	if(doubleContext >= 0)
		string = [NSString stringWithFormat:@"%.2f",doubleContext];
	else
        string = [NSString stringWithFormat:@"%.2f",-doubleContext];
    
	NSArray *tmp = [string componentsSeparatedByString:@"."];
	NSNumberFormatter *numberStyle = [[NSNumberFormatter alloc] init];
	[numberStyle setNumberStyle:NSNumberFormatterDecimalStyle];
	NSString *tmpStr = [numberStyle stringFromNumber:[NSNumber numberWithDouble:[[tmp objectAtIndex:0] doubleValue]]];
	if([tmp count]<2)
	{
		string = tmpStr;
	}
	else
	{
		
		string = [[tmpStr stringByAppendingString:@"."] stringByAppendingString:[tmp objectAtIndex:1]];
	}
    
    
	NSString *typeOfDollar = appDelegate.settings.currency;
	NSArray *dollorArray = [typeOfDollar componentsSeparatedByString:@"-"];
	NSString *dollorStr = [[dollorArray objectAtIndex:0] substringToIndex:[[dollorArray objectAtIndex:0] length]-1];
    
	string = [dollorStr stringByAppendingString:string];
    
    if(doubleContext < 0)
		string = [NSString stringWithFormat:@"%@",string];
    
    
    
	return string;
    
}

- (NSString *)formatterStringWithOutCurrency:(double)doubleContext
{
    NSString *string = @"";
	if(doubleContext >= 0)
		string = [NSString stringWithFormat:@"%.0f",doubleContext];
	else
        string = [NSString stringWithFormat:@"%.0f",-doubleContext];
    
	NSArray *tmp = [string componentsSeparatedByString:@"."];
	NSNumberFormatter *numberStyle = [[NSNumberFormatter alloc] init];
	[numberStyle setNumberStyle:NSNumberFormatterDecimalStyle];
	NSString *tmpStr = [numberStyle stringFromNumber:[NSNumber numberWithDouble:[[tmp objectAtIndex:0] doubleValue]]];
	if([tmp count]<2)
	{
		string = tmpStr;
	}
	else
	{
		
		string = [[tmpStr stringByAppendingString:@"."] stringByAppendingString:[tmp objectAtIndex:1]];
	}
    
    
//	NSString *typeOfDollar = appDelegate.settings.currency;
//	NSArray *dollorArray = [typeOfDollar componentsSeparatedByString:@"-"];
//	NSString *dollorStr = [[dollorArray objectAtIndex:0] substringToIndex:[[dollorArray objectAtIndex:0] length]-1];
    
    if (doubleContext<0) {
        string = [NSString stringWithFormat:@"-%@",string];
    }
    
	return string;
    
}

- (NSString *)formatterStringWithOutCurrency_withFloat:(double)doubleContext
{
    NSString *string = @"";
	if(doubleContext >= 0)
		string = [NSString stringWithFormat:@"%.2f",doubleContext];
	else
        string = [NSString stringWithFormat:@"%.2f",-doubleContext];
    
	NSArray *tmp = [string componentsSeparatedByString:@"."];
	NSNumberFormatter *numberStyle = [[NSNumberFormatter alloc] init];
	[numberStyle setNumberStyle:NSNumberFormatterDecimalStyle];
	NSString *tmpStr = [numberStyle stringFromNumber:[NSNumber numberWithDouble:[[tmp objectAtIndex:0] doubleValue]]];
	if([tmp count]<2)
	{
		string = tmpStr;
	}
	else
	{
		
		string = [[tmpStr stringByAppendingString:@"."] stringByAppendingString:[tmp objectAtIndex:1]];
	}
    
    
    //	NSString *typeOfDollar = appDelegate.settings.currency;
    //	NSArray *dollorArray = [typeOfDollar componentsSeparatedByString:@"-"];
    //	NSString *dollorStr = [[dollorArray objectAtIndex:0] substringToIndex:[[dollorArray objectAtIndex:0] length]-1];
    
    if (doubleContext<0) {
        string = [NSString stringWithFormat:@"-%@",string];
    }
    
	return string;
    
}


//-(NSString *)formatterString:(double)doubleContext
//{
//    if(doubleContext < 0)
//    {
//        
//        return  [NSString stringWithFormat:@"- %@", [numberFmt stringFromNumber:[NSNumber numberWithDouble:fabs(doubleContext)]]];
//    }
//    
//    return [NSString stringWithFormat:@"%@", [numberFmt stringFromNumber:[NSNumber numberWithDouble:doubleContext]]];
//}

#pragma mark 
#pragma mark date is today
//---------判断是不是今天
-(BOOL)dateIsToday:(NSDate *)cmpDate{
	
	NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:cmpDate];
	NSDateComponents *today = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
	if([today day] == [otherDay day] &&
	   [today month] == [otherDay month] &&
	   [today year] == [otherDay year]) {
		return TRUE;
	}
	
	return FALSE;
}
#pragma mark 
#pragma mark date compare
//---------判断两个日期哪个早哪个迟
-(int)dateCompare:(NSDate *)dt1 withDate:(NSDate *)dt2  //0 dt1=dt2 -1 dt1<dt2 1 dt1>dt2
{
	if(dt1==nil&&dt2 == nil) return 0;
	if(dt1==nil) return 1;
	
	if(dt2==nil) return -1;
	NSDateComponents *cmpday1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:dt1];
	NSDateComponents *cmpday2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:dt2];
	if([cmpday1 day] == [cmpday2 day] &&
	   [cmpday1 month] == [cmpday2 month] &&
	   [cmpday1 year] == [cmpday2 year]) {
		return 0;
	}
	
	if([cmpday1 year] > [cmpday2 year]) return 1;
	if([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] > [cmpday2 month]) return 1;
	if([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] ==[cmpday2 month]&&[cmpday1 day] > [cmpday2 day]) return 1;
	
	return -1;
	
}

-(int)monthCompare:(NSDate *)dt1 withDate:(NSDate *)dt2{
    if(dt1==nil&&dt2 == nil) return 0;
	if(dt1==nil) return 1;
	
	if(dt2==nil) return -1;
	NSDateComponents *cmpday1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:dt1];
	NSDateComponents *cmpday2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:dt2];
	if([cmpday1 month] == [cmpday2 month] &&
	   [cmpday1 year] == [cmpday2 year]) {
		return 0;
	}
	
	if([cmpday1 year] > [cmpday2 year]) return 1;
	if([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] > [cmpday2 month]) return 1;
	if([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] ==[cmpday2 month]) return 0;
	
	return -1;

}

-(int)secondCompare:(NSDate *)dt1 withDate:(NSDate *)dt2{
    if(dt1 == nil && dt2 == nil) return -2;
    else
        if(dt1 == nil &&dt2 !=nil) return 1;
        else  if(dt1 != nil &&dt2 ==nil) return -1;
    
    NSDateComponents *cmpday1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:dt1];
	NSDateComponents *cmpday2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:dt2];
	
	if([cmpday1 year] > [cmpday2 year])
        return 1;
	if([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] > [cmpday2 month])
        return 1;
	if([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] ==[cmpday2 month]&&[cmpday1 day] > [cmpday2 day])
        return 1;
	if ([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] ==[cmpday2 month]&&[cmpday1 day] == [cmpday2 day] && [cmpday1 hour]>[cmpday2 hour])
        return 1;
    if ([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] ==[cmpday2 month]&&[cmpday1 day]== [cmpday2 day] && [cmpday1 hour]>[cmpday2 hour])
        return 1;
    if ([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] ==[cmpday2 month]&&[cmpday1 day]== [cmpday2 day] && [cmpday1 hour]==[cmpday2 hour] && [cmpday1 minute]>[cmpday2 minute])
        return 1;
    if ([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] ==[cmpday2 month]&&[cmpday1 day]== [cmpday2 day] && [cmpday1 hour]==[cmpday2 hour] && [cmpday1 minute]==[cmpday2 minute] && [cmpday1 second]>[cmpday2 second])
        return 1;
    if ([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] ==[cmpday2 month]&&[cmpday1 day]== [cmpday2 day] && [cmpday1 hour]==[cmpday2 hour] && [cmpday1 minute]==[cmpday2 minute] && [cmpday1 second]==[cmpday2 second])
        return 0;
    if ([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] ==[cmpday2 month]&&[cmpday1 day]== [cmpday2 day] && [cmpday1 hour]==[cmpday2 hour] && [cmpday1 minute]==[cmpday2 minute] && [cmpday1 second]<[cmpday2 second])
        return -1;
    
	return -1;
}

-(int)weekCompare:(NSDate *)dt1 withDate:(NSDate *)dt2
{
    int firstWeekDay = 1;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([appDelegate.settings.others16 isEqualToString:@"2"])
    {
        firstWeekDay = 2;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:firstWeekDay];
    
    unsigned int unitFlagsWeek = NSYearCalendarUnit|NSWeekOfYearCalendarUnit;
    NSDateComponents *dc1 = [calendar components:unitFlagsWeek fromDate:dt1];
    NSDateComponents *dc2 = [calendar components:unitFlagsWeek fromDate:dt2];
    
    if (dc1.year==dc2.year)
    {

        if (dc1.weekOfYear==dc2.weekOfYear)
        {
            return 0;
        }
        else if (dc1.weekOfYear>dc2.weekOfYear)
            return 1;
        else
            return -1;

    }
    else if(dc1.year > dc2.year)
        return 1;
    else
        return -1;
    
}
#pragma mark 
//---------获取某一天所属星期的 第一天
-(NSDate *)getFirstDateFromWeekByDate:(NSDate *)tmpDate
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |kCFCalendarUnitWeekday;

    NSDateComponents*  parts = [[NSCalendar currentCalendar] components:flags fromDate:tmpDate];
    //直接获取这一天所在的weekday的数字
    NSInteger weekIndex = parts.weekday;

    parts.day -= (weekIndex-1) ;
    [parts setHour:0];
    [parts setSecond:0];
    [parts setMinute:0];
    return  [[NSCalendar currentCalendar] dateFromComponents:parts];

}

#pragma mark date sec
//------------获取某一天的最早的一秒的时间
-(NSDate *)getFirstSecByDate:(NSDate *)date
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents*  parts = [[NSCalendar currentCalendar] components:flags fromDate:date];
    [parts setHour:0];
    [parts setMinute:0];
    [parts setSecond:0];
    return  [[NSCalendar currentCalendar] dateFromComponents:parts];

}
//------------获取一天的最后一秒
-(NSDate *)getLastSecByDate:(NSDate *)date
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents*  parts = [[NSCalendar currentCalendar] components:flags fromDate:date];
    [parts setHour:23];
    [parts setMinute:59];
    [parts setSecond:59];
    return  [[NSCalendar currentCalendar] dateFromComponents:parts];

}
//-------------获取某一月的第一天
-(NSDate *)getMonthFirstDate:(NSDate *)date
{
	NSCalendar *cal = [NSCalendar currentCalendar];
  	NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
	NSDateComponents *comp  = [[NSDateComponents alloc] init] ;
    [comp setDay:-[components day]+1];
    [comp setHour:-[components hour]];
	[comp setMinute:-[components minute]];
	[comp setSecond:-[components second]];
	return [cal dateByAddingComponents:comp toDate:date options:0];

}
//---------------获取某一天的最后一天
-(NSDate *)getMonthEndDate:(NSDate *)date
{
	NSCalendar *cal = [NSCalendar currentCalendar];
  	NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
	NSDateComponents *comp  = [[NSDateComponents alloc] init] ;
    [comp setDay:-[components day] ];
    [comp setHour:-[components hour]+23];
	[comp setMinute:-[components minute]+55];
	[comp setSecond:-[components second]+55];
 
    [comp setMonth:1];

	return [cal dateByAddingComponents:comp toDate:date options:0];

}

//-----------获取当前时间 某个时间类型的第一天
- (NSDate *)getStartDate:(NSString *)dateRangeString
{
	NSDate *nowTime = [NSDate date];
	NSCalendar *cal = [NSCalendar currentCalendar];
  	NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:nowTime];
	NSDateComponents *comp  = [[NSDateComponents alloc] init] ;
      if([dateRangeString isEqualToString: @"Weekly"] )
	{
		[comp setDay:-[components weekday]+1];
		
	}									
    else if([dateRangeString isEqualToString: @"Biweekly"] )
	{
//		[comp setWeek:-1];
        [comp setWeekOfMonth:-1];
        [comp setDay:-[components weekday]+1];
	}									

	else if([dateRangeString isEqualToString: @"This Month"] || [dateRangeString isEqualToString: @"Month to date"] || [[dateRangeString uppercaseString] isEqualToString: @"MONTHLY"] )
	{
 		[comp setDay:-[components day]+1];
		
	}
	else if([dateRangeString isEqualToString: @"Last Month"])
	{
		[comp setDay:-[components day]+1];
		[comp setMonth:-1];
		
	}
    else if([dateRangeString isEqualToString: @"Next Month"])
	{
		[comp setDay:-[components day]+1];
		[comp setMonth:1];
		
	}

	else if([dateRangeString isEqualToString: @"This Quarter"]|| [dateRangeString isEqualToString: @"Quarter to date"] || [[dateRangeString uppercaseString] isEqualToString: @"QUARTER"] )
	{
        [comp setDay:-[components day]+1];
        
        NSInteger i = [components month]/3;
        if( i== 0)
        {
            [comp setMonth:(0-[components month]+1)];

        }
        else {
             [comp setMonth:3*i- [components month]+1];

        }
 	}
	
	else if([dateRangeString isEqualToString: @"Last Quarter"])
	{
        [comp setDay:-[components day]+1];
        
//        NSInteger i = [components month]/3;
//        if( i== 0)
//        {
//            [comp setMonth:(0-[components month]-2)];
//            
//        }
//        else {
//            [comp setMonth:(0-[components month]-3)];
//            
//        }
        NSUInteger i=[components month]%3;
        switch (i)
        {
            case 0:
            [comp setMonth:-5];
                break;
            case 1:
            [comp setMonth:-3];
                break;
            case 2:
            [comp setMonth:-4];
                break;
            default:
                break;
        }
	
	}
	
	else if([dateRangeString isEqualToString: @"This Year"]|| [dateRangeString isEqualToString: @"Year to date"] || [[dateRangeString uppercaseString] isEqualToString: @"YEARLY"] )
	{
		[comp setMonth:-[components month]+1];
		[comp setDay:-[components day]+1];
	}
   	else if([dateRangeString isEqualToString: @"Last Year"] )
	{
        [comp setYear:-1];
		[comp setMonth:-[components month]+1];
		[comp setDay:-[components day]+1];
	}

	else if([dateRangeString isEqualToString: @"Last 30 days"])
	{
		[comp setDay:-29];
		
	}
	
	else if([dateRangeString isEqualToString: @"Last 60 days"])
	{
		[comp setDay:-59];
		
	}
	
	else if([dateRangeString isEqualToString: @"Last 90 days"])
	{
		[comp setDay:-89];
		
	}								
	
	else if([dateRangeString isEqualToString: @"Last 12 Months"] )
	{
		[comp setMonth:-12];
		
	}									
	else 
    {
        [comp setYear:-100];

    }
  	
    [comp setHour:-[components hour]];
	[comp setMinute:-[components minute]];
	[comp setSecond:-[components second]];
	return [cal dateByAddingComponents:comp toDate:nowTime options:0];
}

//--------------获取当前时间 某种时间类型的最后一天
- (NSDate *) getEndDate:(NSDate *)startDate withDateString:(NSString *)dateRangeString
{
	NSCalendar *cal = [NSCalendar currentCalendar];
 	NSDateComponents *comp  = [[NSDateComponents alloc] init] ;
    if([dateRangeString isEqualToString: @"Year to date"]|| [dateRangeString isEqualToString: @"Month to date"]| [dateRangeString isEqualToString: @"Quarter to date"])
	{
	 	 
        return [self getLastSecByDate:[NSDate date]];
	
	}

    if([dateRangeString isEqualToString: @"Weekly"] )
	{
//		[comp setWeek:1];
        [comp setWeekOfMonth:1];
        [comp setDay:- 1];

	}									
    else if([dateRangeString isEqualToString: @"Biweekly"] )
	{
//		[comp setWeek: 2];
        [comp setWeekOfMonth:2];
        [comp setDay:- 1];

	}									

	else if([dateRangeString isEqualToString: @"This Month"]|| [dateRangeString isEqualToString: @"Month to date"] || [[dateRangeString uppercaseString] isEqualToString: @"MONTHLY"])
	{
		[comp setMonth:1];
		[comp setDay:- 1];
		
	}
	else if([dateRangeString isEqualToString: @"Last Month"])
	{
		[comp setMonth:1];
		[comp setDay:- 1];
		
	}
	
	else if([dateRangeString isEqualToString: @"This Quarter"]|| [dateRangeString isEqualToString: @"Quarter to date"]|| [[dateRangeString uppercaseString] isEqualToString: @"QUARTERLY"])
	{
		[comp setMonth:3];
		[comp setDay:- 1];
	}
	
	else if([dateRangeString isEqualToString: @"Last Quarter"])
	{
		[comp setMonth:3];
		[comp setDay:- 1];
		
	}
	
	else if([dateRangeString isEqualToString: @"This Year"]|| [dateRangeString isEqualToString: @"Year to date"]|| [[dateRangeString uppercaseString] isEqualToString: @"YEARLY"])
	{
		[comp setYear:1];
		[comp setDay:-1];
	}
    else if([dateRangeString isEqualToString: @"Last Year"] )
	{
        [comp setYear:1];
 		[comp setDay:-1];
	}

	else if([dateRangeString isEqualToString: @"Last 30 days"])
	{
		[comp setDay:29];
		
	}
	
	else if([dateRangeString isEqualToString: @"Last 60 days"])
	{
		[comp setDay:59];
		
	}
	
	else if([dateRangeString isEqualToString: @"Last 90 days"])
	{
		[comp setDay:89];
		
	}								
	
	else if([dateRangeString isEqualToString: @"Last 12 Months"] )
	{
		[comp setMonth:12];
		
	}
    else
    {
        [comp setYear:200];

    }
	
 	[comp  setHour:23];
	[comp setMinute:59];
	[comp setSecond:59];
	return [cal dateByAddingComponents:comp toDate:startDate options:0];
}

//------------获取当前时间某种循环类型的第一天
-(NSDate *)getStartDate:(NSString *)dateCycleString beforCycleCount:(NSInteger )i withDate:(NSDate *)startDate;
{
  	NSCalendar *cal = [NSCalendar currentCalendar];
  	NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:startDate];
	NSDateComponents *comp  = [[NSDateComponents alloc] init] ;
    if([[dateCycleString uppercaseString] isEqualToString: @"WEEKLY"] )
	{
//         [comp setWeek:-i];
        [comp setWeekOfMonth:-i];
  	}
    else if([[dateCycleString uppercaseString] isEqualToString: @"BIWEEKLY"] )
	{
//        [comp setWeek:-i*2];
        [comp setWeekOfMonth:-i*2];
  	}

	else if([[dateCycleString uppercaseString] isEqualToString: @"MONTHLY"] ||[[dateCycleString uppercaseString] isEqualToString: @"MONTH TO DATE"])
	{
 		[comp setDay:-[components day]+1];
        [comp setMonth:-i];
        
		
	}
 	else  if([[dateCycleString uppercaseString] isEqualToString: @"QUARTERLY"]||[[dateCycleString uppercaseString] isEqualToString: @"QUARTER TO DATE"])
	{
		NSInteger j= [components month] -3*([components month]/3);
		[comp setDay:-[components day]+1];
		[comp setMonth:-j-3*i+1];
		
    }
	
	else  if([[dateCycleString uppercaseString] isEqualToString: @"YEARLY"]||[[dateCycleString uppercaseString] isEqualToString: @"YEAR TO DATE"])
	{
		[comp setMonth:-[components month]+1 ];
		[comp setDay:-[components day]+1];
        [comp setYear:- i];
        
	}
 	
  	[comp setHour:-[components hour]];
	[comp setMinute:-[components minute]];
	[comp setSecond:-[components second]];
	return [cal dateByAddingComponents:comp toDate:startDate options:0];

}



-(NSDate *)getStartDate:(NSString *)dateCycleString beforCycleCount:(NSInteger )i
{
	NSDate *nowTime = [NSDate date];
	NSCalendar *cal = [NSCalendar currentCalendar];
  	NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:nowTime];
	NSDateComponents *comp  = [[NSDateComponents alloc] init] ;
    if([[dateCycleString uppercaseString] isEqualToString: @"WEEKLY"] )
	{
//        [comp setWeek:-i];
        [comp setWeekOfMonth:-i];
  	}
    else if([[dateCycleString uppercaseString] isEqualToString: @"BIWEEKLY"] )
	{
//        [comp setWeek:-i*2];
        [comp setWeekOfMonth:-i*2];
  	}

	else if([[dateCycleString uppercaseString] isEqualToString: @"MONTHLY"])
	{
 		[comp setDay:-[components day]+1];
        [comp setMonth:-i];

		
	}
 	else  if([[dateCycleString uppercaseString] isEqualToString: @"QUARTERLY"])
	{
		NSInteger j= [components month] -3*([components month]/3);
		[comp setDay:-[components day]+1];
		[comp setMonth:-j-3*i+1];
		
    }
	
	else  if([[dateCycleString uppercaseString] isEqualToString: @"YEARLY"])
	{
		[comp setMonth:-[components month]+1 ];
		[comp setDay:-[components day]+1];
        [comp setYear:- i];

	}
 	
  	[comp setHour:-[components hour]];
	[comp setMinute:-[components minute]];
	[comp setSecond:-[components second]];
	return [cal dateByAddingComponents:comp toDate:nowTime options:0];
}

-(NSDate *)getEndDate:(NSDate *)startDate dateCycleString:(NSString *)dateCycleString ;
{
	NSCalendar *cal = [NSCalendar currentCalendar];
 	NSDateComponents *comp  = [[NSDateComponents alloc] init] ;
    if([[dateCycleString uppercaseString] isEqualToString: @"WEEKLY"] )
	{
		[comp setDay:6];
  	}
    else if([[dateCycleString uppercaseString] isEqualToString: @"BIWEEKLY"] )
	{
//        [comp setWeek:1];
        [comp setWeekOfMonth:1];
		[comp setDay:6];
  	}

	else if([[dateCycleString uppercaseString] isEqualToString: @"MONTHLY"] )
        
	{
		[comp setMonth:1];
		[comp setDay:- 1];
		
	}
 	else if([[dateCycleString uppercaseString] isEqualToString: @"QUARTERLY"])
	{
		[comp setMonth:3];
		[comp setDay:- 1];
	}
	
	else if([[dateCycleString uppercaseString] isEqualToString: @"YEARLY"])
	{
		[comp setYear:1];
        [comp setDay:-1];
 	}
	
	 	
  	[comp  setHour:23];
    [comp setMinute:59];
	[comp setSecond:59];
	return [cal dateByAddingComponents:comp toDate:startDate options:0];
}
#pragma mark 
#pragma mark get date by cycle
-(NSDate *)getDate:(NSDate *)startDate byCycleType:(NSString *)cycleType
{
	NSDate* dt = nil;
   // NSDateFormatter *dayFormatter = [[[NSDateFormatter alloc] init] autorelease];
   // [dayFormatter setDateFormat:@"dd"];

	if([cycleType isEqualToString:@"Semimonthly"]||[cycleType isEqualToString:@"Half Month"])
	{
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
         NSDateComponents *components = [gregorian components:(NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit ) fromDate:startDate];
    	long dayIndex = [components day];
		if(dayIndex <15)
		{
			[components setDay:15];
 		}
		else 
		{
			[components setMonth:[components month]+1];
			[components setDay:1];
 			
		}
		dt = [gregorian dateFromComponents:components];
	}
    else if([cycleType isEqualToString:@"No Cycle"])
	{
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents* dc1 = [[NSDateComponents alloc] init];
		[dc1 setYear: 99];
		dt = [gregorian dateByAddingComponents:dc1 toDate:startDate options:0];
		
	}

	else
	{
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents* dc1 = [[NSDateComponents alloc] init];
        
        
		if([cycleType isEqualToString:@"Daily"])
		{
   			[dc1 setDay: 1];
		}
		else if([cycleType isEqualToString:@"Weekly"]||[cycleType isEqualToString:@"Week"])
		{
	 		[dc1 setDay: 7];
 		}
		else if([cycleType isEqualToString:@"Every 2 Weeks"]||[cycleType isEqualToString:@"2 Weeks"]||[cycleType isEqualToString:@"Two Weeks"])
		{
            [dc1 setDay: 14];
            //[dc1 setWeek:2];
 		}else if([cycleType isEqualToString:@"Every 3 Weeks"])
        {
            [dc1 setDay: 21];
        }
		else if([cycleType isEqualToString:@"Every 4 Weeks"])
		{
 			[dc1 setDay: 28];
 		}
		else if([cycleType isEqualToString:@"Monthly"]||[cycleType isEqualToString:@"Month"])
		{
		 	[dc1 setMonth:1];
	 	}
		else if([cycleType isEqualToString:@"Every 2 Months"])
		{
            [dc1 setMonth:2];
        }
		else if([cycleType isEqualToString:@"Every 3 Months"]||[cycleType isEqualToString:@"Tire Months"]||[cycleType isEqualToString:@"3 Months"]||[cycleType isEqualToString:@"Quarter"])
		{
            [dc1 setMonth:3];
		}
		else if([cycleType isEqualToString:@"Every 6 Months"])
		{
			[dc1 setMonth:6];
		}
		else if([cycleType isEqualToString:@"Every Year"]||[cycleType isEqualToString:@"Year"])
		{
            [dc1 setYear:1];
		}
        dt = [gregorian dateByAddingComponents:dc1 toDate:startDate options:0];
        
	}
	return dt;
}

-(NSDate *)getNextDate:(NSDate *)start byCycleType:(NSString *)cycleType
{
	NSDate* dt=nil;
    if([cycleType isEqualToString:@"Never"])
    {
        return start;
    }
	else if([cycleType isEqualToString:@"Semimonthly"])
	{
		NSCalendar *gregorian = [[NSCalendar alloc]
								 initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *componentsStart = [gregorian components:(NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit ) 
														 fromDate:start];
 		if(componentsStart.day >=1&&componentsStart.day <15)
		{
			[componentsStart setDay:15];
 		}
		else 
		{
			[componentsStart setMonth:[componentsStart month]+1];
			[componentsStart setDay:1];
 		}
		dt = [gregorian dateFromComponents:componentsStart];
	}
	else
	{
		int typedays = 0;
		if([cycleType isEqualToString:@"Daily"])
		{
			typedays = 1;
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
			[dc1 setDay: typedays];
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
		else if([cycleType isEqualToString:@"Weekly"])
		{
			typedays = 7;
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
			[dc1 setDay: typedays];
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
		else if([cycleType isEqualToString:@"Every 2 Weeks"]||[cycleType isEqualToString:@"Two Weeks"]||[cycleType isEqualToString:@"2 Weeks"])
		{
			typedays = 14;
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
			[dc1 setDay: typedays];
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
		else if([cycleType isEqualToString:@"Every 4 Weeks"])
		{
			typedays = 28;
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
			[dc1 setDay: typedays];
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
        //MONTH 用作budget获取下一个月
		else if([cycleType isEqualToString:@"Monthly"] || ([cycleType isEqualToString:@"MONTHLY"]))
		{
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
			[dc1 setMonth:1];
			
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
		else if([cycleType isEqualToString:@"Every 2 Months"])
		{
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
 			[dc1 setMonth:2];
			
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
		else if([cycleType isEqualToString:@"Every 3 Months"])
		{
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
 			[dc1 setMonth:3];
			
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
		else if([cycleType isEqualToString:@"Every 6 Months"])
		{
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
 			[dc1 setMonth:6];
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
		else if([cycleType isEqualToString:@"Every Year"])
		{
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
 			[dc1 setYear:1];
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
	}
	return dt;
}

//------获取上一个循环的时间
-(NSDate *)getPerDate:(NSDate *)start byCycleType:(NSString *)cycleType
{
	NSDate* dt=nil;
    if([cycleType isEqualToString:@"Never"])
    {
        return start;
    }
	else if([cycleType isEqualToString:@"Semimonthly"])
	{
		NSCalendar *gregorian = [[NSCalendar alloc]
								 initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *componentsStart = [gregorian components:(NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit ) 
														 fromDate:start];
 		if(componentsStart.day >=1&&componentsStart.day <15)
		{
			[componentsStart setMonth:[componentsStart month]-1];
			[componentsStart setDay:1];
			
 		}
		else 
		{
			[componentsStart setDay:15];
			
		}
		dt = [gregorian dateFromComponents:componentsStart];
	}
	else
	{
		int typedays = 0;
		if([cycleType isEqualToString:@"Daily"])
		{
			typedays = -1;
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
			[dc1 setDay: typedays];
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
		else if([cycleType isEqualToString:@"Weekly"])
		{
			typedays = -7;
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
			[dc1 setDay: typedays];
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
		else if([cycleType isEqualToString:@"Every 2 Weeks"]||[cycleType isEqualToString:@"Two Weeks"])
		{
			typedays = -14;
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
			[dc1 setDay: typedays];
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
		else if([cycleType isEqualToString:@"Every 4 Weeks"])
		{
			typedays = -28;
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
			[dc1 setDay: typedays];
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
		else if([cycleType isEqualToString:@"Monthly"])
		{
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
			[dc1 setMonth:-1];
			
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
		else if([cycleType isEqualToString:@"Every 2 Months"])
		{
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
 			[dc1 setMonth:-2];
			
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
		else if([cycleType isEqualToString:@"Every 3 Months"])
		{
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
 			[dc1 setMonth:-3];
			
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
		else if([cycleType isEqualToString:@"Every 6 Months"])
		{
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
 			[dc1 setMonth:-6];
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
		else if([cycleType isEqualToString:@"Every Year"])
		{
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents* dc1 = [[NSDateComponents alloc] init];
 			[dc1 setYear:-1];
			dt = [gregorian dateByAddingComponents:dc1 toDate:start options:0];
		}
	}
	return dt;
}

#pragma mark -
#pragma mark get start date by cycle
//获取循环bill在设定的一个时间点之后第一次循环的时间
-(NSDate *)getCycleStartDateByMinDate:(NSDate *)minDate withCycleStartDate:(NSDate*)cycleStart withCycleType:(NSString *)cycleType isRule:(BOOL)rule
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

	if([cycleType isEqualToString:@"Never"]||!rule||[cycleType isEqualToString:@"Only Once"]) return cycleStart;
 	if([appDelegate.epnc dateCompare:minDate withDate:cycleStart]<=0 ) return cycleStart;
	
    
    //bill起始时间比这个月早
	NSDate* dt=nil;
	
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:cycleStart
												  toDate:minDate options:0];
    //bill起始的时间与这个月第一天相差几天
	NSInteger days = [components day];
	
	unitFlags = NSWeekCalendarUnit;
    //获取bill开始的日期所在的星期的第一天
    NSDate *tmpCycleStart=[self getFirstDateFromWeekByDate:cycleStart];
    //获取这个月的第一天所在星期的第一天
    NSDate *tmpminDate=[self getFirstDateFromWeekByDate:minDate];
	components = [gregorian components:unitFlags
							  fromDate:tmpCycleStart
								toDate:tmpminDate options:0];
	
	//计算这两个之间相差几周
    NSInteger weeks = [components weekOfMonth];
	unitFlags = NSMonthCalendarUnit;
	components = [gregorian components:unitFlags
							  fromDate:cycleStart
								toDate:minDate options:0];
	
    //计算这两个之间相差几个月
	NSInteger months = [components month];
	unitFlags = NSYearCalendarUnit;
	components = [gregorian components:unitFlags
							  fromDate:cycleStart
								toDate:minDate options:0];
    
	//计算这两个之间相差几年
	NSInteger year = [components year];
    
    //如果循环类型是半月的话，最早的时间就是这个月的第一天
	if([cycleType isEqualToString:@"Semimonthly"])
	{
		
		dt = minDate;
		
	}
	else 
        if([cycleType isEqualToString:@"Daily"])
        {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents* dc1 = [[NSDateComponents alloc] init];
            [dc1 setDay: days];
            dt = [gregorian dateByAddingComponents:dc1 toDate:cycleStart options:0];
        }
        else if([cycleType isEqualToString:@"Weekly"])
        {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
//            [dc1 setWeek:weeks];
            [dc1 setWeekOfMonth:weeks];
            dt = [gregorian dateByAddingComponents:dc1 toDate:cycleStart options:0];
            
            if([self dateCompare:dt withDate:minDate] <0)
            {
//                [dc1 setWeek:weeks +1];
                [dc1 setWeekOfMonth:weeks+1];
                
                dt = [gregorian dateByAddingComponents:dc1 toDate:cycleStart options:0];

            }
            
        }
        else if([cycleType isEqualToString:@"Two Weeks"]||[cycleType isEqualToString:@"2 Weeks"]||[cycleType isEqualToString:@"Every 2 Weeks"])
        {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
            NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
            
            if(weeks%2 == 0)
            {
//                [dc1 setWeek: weeks ];
                [dc1 setWeekOfMonth:weeks];
                
            }
            else {
//                [dc1 setWeek:(weeks/2+1)*2];
                [dc1 setWeekOfMonth:(weeks/2+1)*2];
            }
            dt = [gregorian dateByAddingComponents:dc1 toDate:cycleStart options:0];

            if([self dateCompare:dt withDate:minDate] <0)
            {
//                [dc1 setWeek:[dc1 week]+2];
                [dc1 setWeekOfMonth:[dc1 weekOfMonth]+2];
                dt = [gregorian dateByAddingComponents:dc1 toDate:cycleStart options:0];
                
            }
            
        }
        else if([cycleType isEqualToString:@"Every 4 Weeks"])
        {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
            NSDateComponents* dc1 = [[NSDateComponents alloc] init];
            
            if(weeks%4 == 0)
            {
//                [dc1 setWeek: weeks ];
                [dc1 setWeekOfMonth:weeks];
                
            }
            else {
//                [dc1 setWeek:(weeks/4+1)*4];
                [dc1 setWeekOfMonth:(weeks/4+1)*4];
                
            }
            
            dt = [gregorian dateByAddingComponents:dc1 toDate:cycleStart options:0];

            
            if([self dateCompare:dt withDate:minDate] <0)
            {
//                [dc1 setWeek:[dc1 week]+4];
                [dc1 setWeekOfMonth:[dc1 weekOfMonth]+4];
                dt = [gregorian dateByAddingComponents:dc1 toDate:cycleStart options:0];
                
            }
        }
    
        else if([cycleType isEqualToString:@"Monthly"])
        {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
            NSDateComponents* dc1 = [[NSDateComponents alloc] init];
            [dc1 setMonth:months];
            
            dt = [gregorian dateByAddingComponents:dc1 toDate:cycleStart options:0];
        }
        else if([cycleType isEqualToString:@"Every 2 Months"])
        {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
            NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
            if(months%2 == 0)
            {
                [dc1 setMonth:(months/2)*2];
                
                
            }
            else {
                [dc1 setMonth:(months/2+1)*2];
                
            }
            
            dt = [gregorian dateByAddingComponents:dc1 toDate:cycleStart options:0];
        }
    
    
        else if([cycleType isEqualToString:@"Every 3 Months"])
        {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
            NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
            if(months%3 == 0)
            {
                [dc1 setMonth:(months/3)*3];
                
                
            }
            else {
                [dc1 setMonth:(months/3+1)*3];
                
            }
            
            dt = [gregorian dateByAddingComponents:dc1 toDate:cycleStart options:0];
        }
	
        else if([cycleType isEqualToString:@"Every Year"])
        {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
            NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
            [dc1 setYear:year];
            dt = [gregorian dateByAddingComponents:dc1 toDate:cycleStart options:0];
        }
	return dt;
}


#pragma mark 
#pragma mark get count by from date and cycle
-(long)getCycleCountByDay:(NSDate *)start dateEnd:(NSDate *)end durationDay:(int)typeCount
{
    NSInteger insertCount =0;
 	NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *components = [cal components:unitFlags
                                          fromDate:start
                                            toDate:end options:0];
    
    long totalDays = [components day];
    
    
    insertCount = totalDays/typeCount;
    return insertCount;
}

- (long)getCycleCountByMonth:(NSDate *)start dateEnd:(NSDate *)end durationMonth:(int)typeCount
{
	long insertCount = 0;
	NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSMonthCalendarUnit;
    NSDateComponents *components = [cal components:unitFlags
                                          fromDate:start
                                            toDate:end options:0];
    
    NSInteger months = [components month];
    
	if(typeCount != -1)
	{
        insertCount =months/typeCount;
    }
	else
	{
        unitFlags = NSYearCalendarUnit;
        components = [cal components:unitFlags
                            fromDate:start
                              toDate:end options:0];
		insertCount =  [components year];;
	}
	
	return insertCount;
}


-(long) getCountOfInsert:(NSDate *)start repeatEnd:(NSDate *)end typeOfRecurring:(NSString *)cycle
{
	long insertCount = 0;
	if([cycle isEqualToString:@"Semimonthly"]||[cycle isEqualToString:@"Half Month"])
	{
		NSCalendar *gregorian = [[NSCalendar alloc]
								 initWithCalendarIdentifier:NSGregorianCalendar];
        
         NSDateComponents *componentTmpStart = [gregorian components:(NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit ) fromDate:start];
    
        [componentTmpStart setDay:1];
        [componentTmpStart setHour:0];
        [componentTmpStart setMinute:0];
        [componentTmpStart setSecond:0];

		NSDate *tmpStart = [gregorian dateFromComponents:componentTmpStart];
        
        NSDateComponents *componentTmpEnd = [gregorian components:(NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit ) fromDate:end];
        
        [componentTmpEnd setDay:1];
        [componentTmpEnd setHour:0];
        [componentTmpEnd setMinute:0];
        [componentTmpEnd setSecond:0];
        
		NSDate *tmpEnd= [gregorian dateFromComponents:componentTmpEnd];
        
		NSDateComponents *components = [gregorian components:NSMonthCalendarUnit
													fromDate:tmpStart
													  toDate:tmpEnd options:0];
        
        
 		NSDateComponents *componentsStart = [gregorian components:(NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit ) 
														 fromDate:start];
        NSDateComponents *componentsEnd = [gregorian components:(NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit ) 
														 fromDate:end];
        
        NSInteger starDay = [componentsStart day];
        NSInteger endDay = [componentsEnd day];

        
        if([components month] ==0)
        {
            if (endDay>=15) {
                insertCount++;
                if(starDay ==1)
                    insertCount++;

            }
        }
        else  {
            insertCount = ([components month]-1)*2;

            if(starDay<=15)
            {
                insertCount++;
                if(starDay==1)
                    insertCount++;

            }
            if (endDay>=1) {
                insertCount++;
                if(endDay>=15)
                    insertCount++;

            }
        }
 	}
	else
	{
		if([cycle isEqualToString:@"Daily"])
		{
            insertCount = [self getCycleCountByDay:start dateEnd:end durationDay:1];
		}
		else if([cycle isEqualToString:@"Weekly"]||[cycle isEqualToString:@"Week"])
		{
            insertCount = [self getCycleCountByDay:start dateEnd:end durationDay:7] ;
		}
		else if([cycle isEqualToString:@"2 Weeks"]||[cycle isEqualToString:@"Two Weeks"]||[cycle isEqualToString:@"Every 2 Weeks"]||[cycle isEqualToString:@"Every Two Weeks"])
		{
            insertCount = [self getCycleCountByDay:start dateEnd:end durationDay:14];
		}
        else if([cycle isEqualToString:@"3 Weeks"]||[cycle isEqualToString:@"Three Weeks"]||[cycle isEqualToString:@"Every 3 Weeks"]||[cycle isEqualToString:@"Every Three Weeks"])
		{
            insertCount = [self getCycleCountByDay:start dateEnd:end durationDay:21];
		}
		else if([cycle isEqualToString:@"4 Weeks"]||[cycle isEqualToString:@"Every 4 Weeks"])
		{
            insertCount = [self getCycleCountByDay:start dateEnd:end durationDay:28];
		}
		else if([cycle isEqualToString:@"Monthly"]||[cycle isEqualToString:@"Every Month"]||[cycle isEqualToString:@"Month"])
		{
			insertCount = [self getCycleCountByMonth:start dateEnd:end durationMonth:1];
		}
		else if([cycle isEqualToString:@"Every 2 Months"]||[cycle isEqualToString:@"2 Months"])
		{
			insertCount = [self getCycleCountByMonth:start dateEnd:end durationMonth:2];
		}
		else if([cycle isEqualToString:@"Every 3 Months"]||[cycle isEqualToString:@"3 Months"]||[cycle isEqualToString:@"Quarter"])
		{
			insertCount = [self  getCycleCountByMonth:start dateEnd:end durationMonth:3];
		}
        else if([cycle isEqualToString:@"Every 4 Months"]||[cycle isEqualToString:@"4 Months"])
		{
			insertCount = [self  getCycleCountByMonth:start dateEnd:end durationMonth:4];
		}
        else if([cycle isEqualToString:@"Every 5 Months"]||[cycle isEqualToString:@"5 Months"])
		{
			insertCount = [self  getCycleCountByMonth:start dateEnd:end durationMonth:5];
		}
		else if([cycle isEqualToString:@"Every 6 Months"]||[cycle isEqualToString:@"6 Months"])
		{
			insertCount = [self  getCycleCountByMonth:start dateEnd:end durationMonth:6];
		}
		else if([cycle isEqualToString:@"Every Year"]||[cycle isEqualToString:@"Yearly"]||[cycle isEqualToString:@"Year"])
		{
			insertCount = [self  getCycleCountByMonth:start dateEnd:end durationMonth:-1];
		}
	}
 	return insertCount;
}


#pragma mark start date
-(int)returnDayNum:(NSString *)weekDay
{
	if([weekDay isEqualToString:@"Sunday"])
		return 7;
	if ([weekDay isEqualToString:@"Saturday"]) 
		return 6;
	if ([weekDay isEqualToString:@"Monday"]) 
	    return 1;
	if ([weekDay isEqualToString:@"Tuesday"])
	    return 2;
	if ([weekDay isEqualToString:@"Wednesday"])
	    return 3;
	if ([weekDay isEqualToString:@"Thursday"])
	    return 4;
	if ([weekDay isEqualToString:@"Friday"])
	    return 5;
	return 0;
}

//获取从今天开始的某一天的起始时间
- (NSDate *) getStartDateWithDateType:(NSInteger)dateType fromDate:(NSDate *)startDate//dateType 0-day 1-week 2-month 3-year
{
 	NSString *start = @"Sunday";
    
    NSDate *nowTime;
    if (startDate == nil) {
        nowTime = [NSDate date];
    }
    else
        nowTime = startDate;
	
    int firstWeekDay = 1;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([appDelegate.settings.others16 isEqualToString:@"2"])
    {
        firstWeekDay = 2;
        start = @"Monday";
    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setFirstWeekday:firstWeekDay];
    
    
	NSDateComponents *components = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:nowTime];
	if(dateType==0)
	{
		[components setDay:0];
	}
    //获取改星期的起始时间
	else if(dateType == 1)
	{
        NSDateComponents *components = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit|NSWeekdayCalendarUnit ) fromDate:nowTime];
        
        components.day = components.day - components.weekday+firstWeekDay;
        components.hour = 0;
        components.minute = 0;
        components.second = 0;
        NSDate *startDate = [cal dateFromComponents:components];
        return startDate;
	}
	else if (dateType == 2)
	{
		NSDateFormatter *dayFormatter1 = [[NSDateFormatter alloc] init];
		[dayFormatter1 setDateFormat:@"dd"];
		int days = [[dayFormatter1 stringFromDate:nowTime] intValue];
		[components setDay:-days+1];
	}
	else
	{
		NSDateFormatter *monthFormatter1 = [[NSDateFormatter alloc] init];
		[monthFormatter1 setDateFormat:@"MM"];
		int months = [[monthFormatter1 stringFromDate:nowTime] intValue];
		NSDateFormatter *dayFormatter1 = [[NSDateFormatter alloc] init];
		[dayFormatter1 setDateFormat:@"dd"];
		int days = [[dayFormatter1 stringFromDate:nowTime] intValue];
		[components setMonth:-months+1];
		[components setDay:-days+1];

	}
	[components setHour:-[components hour]];
	[components setMinute:-[components minute]];
	[components setSecond:-[components second]];
	return [cal dateByAddingComponents:components toDate:nowTime options:0];
}
- (NSDate *) getEndDateDateType:(NSInteger)dateType withStartDate:(NSDate *)startDate //dateType 0-day 1-week 2-month 3-year
{
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *component = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:startDate];
	if (dateType == 0) 
	{
		[component setDay:0];
	}
	if(dateType==1)
	{
		[component setDay:6];
	}
	else if(dateType==2)
	{
		[component setMonth:1];
		[component setDay:-1];
	}
	else if(dateType==3)
	{
		[component setYear:1];
		[component setDay:-1];
	}
	[component setHour:23];
	[component setMinute:59];
	[component setSecond:59];
	return [cal dateByAddingComponents:component toDate:startDate options:0];
}

-(void)addNotification:(NSDate*)dateTime withAmount:(double)amount withCategoryName:(NSString *)cateString
{
    
 	Class localNotificationC = NSClassFromString(@"UILocalNotification");
	if (localNotificationC) {
		UILocalNotification* localNotif = [[localNotificationC alloc] init];
		localNotif.fireDate = dateTime;
		if(cateString == nil||[cateString length] == 0)cateString =@"Not Sure";
         
 		NSString *bodyString  = [NSString stringWithFormat:@"New expense log of %@ has been added to %@.",[self formatterString:amount] ,cateString];
 		
		// Notification details
		localNotif.alertBody =bodyString;
		// Set the action button
		localNotif.alertAction = @"View";
		
		localNotif.soundName = UILocalNotificationDefaultSoundName;
		//localNotif.applicationIconBadgeNumber = 1;
		
		// Specify custom data for the notification
		NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
		localNotif.userInfo = infoDict;
		
		// Schedule the notification
		[[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
	}
}

//create uuid
+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

-(NSString *)getSecondUUID_withNoCycleTrans:(NSDate *)noCycleDate  CycleTrans:(Transaction *)cycleTrans{
    NSString *string1 = [self getUUIDFromData:noCycleDate];
    NSString *secondUUID = [NSString stringWithFormat:@"%@%@",cycleTrans.uuid,string1];
    return secondUUID;
}


-(NSString *)getUUIDFromData:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMddyyyy"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

-(void)showSyncTip{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.appAlertView !=nil)
    {
        [appDelegate.appAlertView dismissWithClickedButtonIndex:0 animated:NO];
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VC_Dropbox sync successed.", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
    appDelegate.appAlertView = alertView;
    [alertView show];
    
    [self performSelector:@selector(hideSyncTip) withObject:nil afterDelay:2];
}

-(void)hideSyncTip{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    [appDelegate hidePopView];
}

//-(void)checkifDataWrongIn4_5UpgradeTo5
//{
//    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSFetchRequest *fetchAccount = [[NSFetchRequest alloc]initWithEntityName:@"Accounts"];
//    NSError *error = nil;
//    NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchAccount error:&error];
//    [fetchAccount release];
//    
//    NSFetchRequest *fetchTrans = [[NSFetchRequest alloc]initWithEntityName:@"Transaction"];
//    NSArray *objectsTrans = [appDelegate.managedObjectContext executeFetchRequest:fetchTrans error:&error];
//    [fetchTrans release];
//    
//    //删除掉已经创建过默认账户的标记
//    if ([objects count]==0 && [objectsTrans count]>0)
//    {
//        [appDelegate.epdc deleteAllTableDataBase_exceptSeetingTable:YES];
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults removeObjectForKey:DEFAULTACCOUNT];
//        [userDefaults synchronize];
//    }
//    
//}
#pragma mark 唯一
-(UIFont *)getDateFont_inClaendar_WithSize:(int)tmpSize
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:tmpSize];
}

-(UIFont *)GETdateFont_Regular_withSize:(int)tmpSize
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:tmpSize];

}


-(UIFont *)getMoneyFont_inCalendar_WithSize:(int)tmpSize
{
    return [UIFont fontWithName:@"Avenir LT 45 Book" size:tmpSize];

}
//获取金额字体方法
-(UIFont *)getMoneyFont_exceptInCalendar_WithSize:(int)tmpSize
{

    return [UIFont fontWithName:@"Avenir LT 65 Medium" size:tmpSize];
    
}

-(UIFont *)getMoneyFont_Avenir_LT_85_Heavy_withSzie:(int)tmpSize
{
    
    //当前这个字体没有
//    return [UIFont fontWithName:@"Avenir LT 85 Heavy" size:tmpSize];
    return [UIFont fontWithName:@"Avenir-Heavy" size:tmpSize];
    
//    return [UIFont fontWithName:@"Avenir LT 55 Roman" size:tmpSize];
}


-(UIColor *)getAmountRedColor{
    return [UIColor colorWithRed:255.0/255 green:93.0/255 blue:103.0/255 alpha:1];
}

-(UIColor *)getAmountGreenColor{
    return [UIColor colorWithRed:102.0/255 green:175.0/255 blue:54.0/255 alpha:1.0];
}

-(UIColor *)getAmountGrayColor{
    return  [UIColor colorWithRed:166.0/255 green:166.0/255 blue:166.0/255 alpha:1.0];
}

-(UIColor *)getGrayColor_156_156_156{
    return  [UIColor colorWithRed:156.0/255 green:156.0/255 blue:156.0/255 alpha:1.0];

}

-(UIColor *)getAmountBlackColor{
    return  [UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1.0];

}

-(UIColor *)getAmountBlueColor{
    return  [UIColor colorWithRed:12.0/255 green:164.0/255 blue:227.0/255 alpha:1.0];
    
}

-(UIColor *)getAmountPurpleColor_632599
{
    return  [UIColor colorWithRed:63.0/255 green:25.0/255 blue:99.0/255 alpha:1.0];
}

-(UIColor *)getNavigationBarGray_Highlighted
{
    return [UIColor colorWithRed:136.f/255.f green:136.f/255.f blue:136.f/255.f alpha:1];
}
//getDateColor_inCalendar_grayColr
-(UIColor *)getGrayColor_94_99_77
{
    return  [UIColor colorWithRed:94.0/255 green:99.0/255 blue:117.0/255 alpha:1.0];

}

-(UIColor *)getDateColor_inCalendar_blueColr
{
    return  [UIColor colorWithRed:3.0/255 green:128.0/255 blue:255.0/255 alpha:1.0];
    
}

-(UIColor *)getiPadNavigationBarTiltleTeextColor
{
    return[UIColor colorWithRed:48.f/255.f green:54.f/255.f blue:66.f/255.f alpha:1];
}

-(UIColor *)getiPADNavigationBarBtnColor
{
    return[UIColor colorWithRed:99/255.f green:203/255.f blue:255/255.f alpha:1];

}

-(UIColor *)getiPADColor_42_45_51
{
    return[UIColor colorWithRed:42.f/255.f green:45.f/255.f blue:51.f/255.f alpha:1];
    
}

-(UIColor *)getiPADColor_149_150_156
{
    return[UIColor colorWithRed:149.f/255.f green:150.f/255.f blue:156.f/255.f alpha:1];
}

-(UIColor *)getColor_229_229_229
{
    return[UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1];

}
-(UIColor *)getColor_204_204_204
{
    return[UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1];
    
}

-(NSString *)changeRecurringTexttoLocalLangue:(NSString *)recurringText
{
    if ([recurringText isEqualToString:@"Never"])
    {
        return  NSLocalizedString(@"VC_Never", nil);
    }
    else if ([recurringText isEqualToString:@"Daily"])
    {
        return NSLocalizedString(@"VC_Daily", nil);
    }
    else if ([recurringText isEqualToString:@"Weekly"])
    {
        return NSLocalizedString(@"VC_Weekly", nil);
    }
    else if ([recurringText isEqualToString:@"Every 2 Weeks"])
    {
        return NSLocalizedString(@"VC_Every2Weeks", nil);
    }
    else if ([recurringText isEqualToString:@"Every 3 Weeks"])
    {
        return NSLocalizedString(@"VC_Every3Weeks", nil);
    }
    else if ([recurringText isEqualToString:@"Every 4 Weeks"])
    {
        return NSLocalizedString(@"VC_Every4Weeks", nil);
    }
    else if ([recurringText isEqualToString:@"Semimonthly"])
    {
        return NSLocalizedString(@"VC_Semimonthly", nil);
    }
    else if ([recurringText isEqualToString:@"Monthly"])
    {
        return NSLocalizedString(@"VC_Monthly", nil);
    }
    else if ([recurringText isEqualToString:@"Every 2 Months"])
    {
        return NSLocalizedString(@"VC_Every2Months", nil);
    }
    else if ([recurringText isEqualToString:@"Every 3 Months"])
    {
        return NSLocalizedString(@"VC_Every3Months", nil);
    }
    else if ([recurringText isEqualToString:@"Every 4 Months"])
    {
        return NSLocalizedString(@"VC_Every4Months", nil);
    }
    else if ([recurringText isEqualToString:@"Every 5 Months"])
    {
        return NSLocalizedString(@"VC_Every5Months", nil);
    }
    else if ([recurringText isEqualToString:@"Every 6 Months"])
    {
        return NSLocalizedString(@"VC_Every6Months", nil);
    }
    else
    {
        return NSLocalizedString(@"VC_EveryYear", nil);
    }
    
}

-(NSString *)changeLocalLanguetoRecurringText:(NSString *)localText
{
    if ([localText  isEqualToString:NSLocalizedString(@"VC_Never", nil)])
    {
        return  @"Never";
    }
    else if ([localText isEqualToString:NSLocalizedString(@"VC_Daily", nil)])
    {
        return @"Daily";
    }
    else if ([localText isEqualToString:NSLocalizedString(@"VC_Weekly", nil)])
    {
        return @"Weekly";
    }
    else if ([localText isEqualToString: NSLocalizedString(@"VC_Every2Weeks", nil)])
    {
        return @"Every 2 Weeks";
    }
    else if ([localText isEqualToString:NSLocalizedString(@"VC_Every3Weeks", nil)])
    {
        return @"Every 3 Weeks" ;
    }
    else if ([localText isEqualToString:NSLocalizedString(@"VC_Every4Weeks", nil)])
    {
        return @"Every 4 Weeks" ;
    }
    else if ([localText isEqualToString:NSLocalizedString(@"VC_Semimonthly", nil)])
    {
        return @"Semimonthly";
    }
    else if ([localText isEqualToString:NSLocalizedString(@"VC_Monthly", nil)])
    {
        return @"Monthly";
    }
    else if ([localText isEqualToString:NSLocalizedString(@"VC_Every2Months", nil)])
    {
        return @"Every 2 Months";
    }
    else if ([localText isEqualToString:NSLocalizedString(@"VC_Every3Months", nil)])
    {
        return @"Every 3 Months";
    }
    else if ([localText isEqualToString:NSLocalizedString(@"VC_Every4Months", nil)])
    {
        return @"Every 4 Months";
    }
    else if ([localText isEqualToString:NSLocalizedString(@"VC_Every5Months", nil)])
    {
        return @"Every 5 Months";
    }
    else if ([localText isEqualToString:NSLocalizedString(@"VC_Every6Months", nil)])
    {
        return @"Every 6 Months";
    }
    else
    {
        return @"Every Year";
    }
}

-(NSString *)changeRecurringTypetoLocalLangue_bill:(NSString *)recurringText
{
    if ([recurringText isEqualToString:@"Never"])
    {
        return  NSLocalizedString(@"VC_Never", nil);
    }
    else if ([recurringText isEqualToString:@"Weekly"])
    {
        return NSLocalizedString(@"VC_Weekly", nil);
    }
    else if ([recurringText isEqualToString:@"Two Weeks"])
    {
        return  NSLocalizedString(@"VC_Every2Weeks", nil);
    }
    else if ([recurringText isEqualToString:@"Every 4 Weeks"])
    {
        return  NSLocalizedString(@"VC_Every4Weeks", nil);
    }
    else if ([recurringText isEqualToString:@"Semimonthly"])
    {
        return  NSLocalizedString(@"VC_Semimonthly", nil);
    }
    else if ([recurringText isEqualToString:@"Monthly"])
    {
        return  NSLocalizedString(@"VC_Monthly", nil);
    }
    else if ([recurringText isEqualToString:@"Every 2 Months"])
    {
        return  NSLocalizedString(@"VC_Every2Months", nil);
    }
    else if ([recurringText isEqualToString:@"Every 3 Months"])
    {
        return  NSLocalizedString(@"VC_Every3Months", nil);
    }
    else
    {
        return  NSLocalizedString(@"VC_EveryYear", nil);
    }
}

-(NSString *)changeReminderTexttoLocalLangue:(NSString *)reminderText
{
    if ([reminderText isEqualToString:@"None"])
    {
        return  NSLocalizedString(@"VC_None", nil);
    }
    else if ([reminderText isEqualToString:@"1 day before"])
    {
        return NSLocalizedString(@"VC_1daybefore", nil);
    }
    else if ([reminderText isEqualToString:@"2 days before"])
    {
        return  NSLocalizedString(@"VC_2daysbefore", nil);
    }
    else if ([reminderText isEqualToString:@"3 days before"])
    {
        return  NSLocalizedString(@"VC_3daysbefore", nil);
    }
    else if ([reminderText isEqualToString:@"1 week before"])
    {
        return  NSLocalizedString(@"VC_1weekbefore", nil);
    }
    else if ([reminderText isEqualToString:@"2 weeks before"])
    {
        return  NSLocalizedString(@"VC_2weeksbefore", nil);
    }
    else
    {
        return  NSLocalizedString(@"VC_ondateofevent", nil);
    }
}

-(void)setFlurryEvent_WithIdentify:(NSString *)event
{
        [Flurry logEvent:event];
}
-(void)setFlurryEvent_withUpgrade:(BOOL)isPurchase
{
    //获取laucn的次数
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    long enterappCount = [userDefaults integerForKey:ENTERAPP_COUNT];
    
    if (isPurchase)
    {
        if (enterappCount<=1)
        {
            [Flurry logEvent:FLURRY_ENTERAPP_A1];
        }
        else if (enterappCount<=3)
        {
            [Flurry logEvent:FLURRY_ENTERAPP_B1];
        }
        else if (enterappCount <=5)
        {
            [Flurry logEvent:FLURRY_ENTERAPP_C1];
        }
        else if (enterappCount <= 10)
        {
            [Flurry logEvent:FLURRY_ENTERAPP_D1];
        }
        else if (enterappCount <= 20)
        {
            [Flurry logEvent:FLURRY_ENTERAPP_E1];
        }
        else if (enterappCount <= 50)
        {
            [Flurry logEvent:FLURRY_ENTERAPP_F1];
        }
        else{
            [Flurry logEvent:FLURRY_ENTERAPP_G1];
        }
        
    }
    else
    {
        if (enterappCount<=1)
        {
            [Flurry logEvent:FLURRY_ENTERAPP_A];
        }
        else if (enterappCount<=3)
        {
            [Flurry logEvent:FLURRY_ENTERAPP_B];
        }
        else if (enterappCount <=5)
        {
            [Flurry logEvent:FLURRY_ENTERAPP_C];
        }
        else if (enterappCount <= 10)
        {
            [Flurry logEvent:FLURRY_ENTERAPP_D];
        }
        else if (enterappCount <= 20)
        {
            [Flurry logEvent:FLURRY_ENTERAPP_E];
        }
        else if (enterappCount <= 50)
        {
            [Flurry logEvent:FLURRY_ENTERAPP_F];
        }
        else{
            [Flurry logEvent:FLURRY_ENTERAPP_G];
        }
        
    }
}



+ (NSString*)currentLanguage
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
    NSString* currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

@end
