//
//  MonthCalDataView.m
//  PocketExpense
//
//  Created by humingjing on 14/12/2.
//
//

#import "MonthCalDataView.h"
#import "PokcetExpenseAppDelegate.h"
#import "DailyAmountObject.h"
#import "NSDateAdditions.h"

@implementation MonthCalDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        dailyAmountArray = [[NSMutableArray alloc]init];
        
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"d"];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)fetchTransactionFromDate:(NSDate *)fDate endDate:(NSDate *)tDate refreshTask:(BOOL)refreshTask
{
    [dailyAmountArray removeAllObjects];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    
    if ([appDelegate.epnc dateCompare:fDate withDate:tDate]<0)
    {
        while ([appDelegate.epnc dateCompare:fDate withDate:tDate]<=0)
        {
            NSDate *fromDate = fDate;
            NSDateComponents*  parts1 = [[NSCalendar currentCalendar] components:flags fromDate:fDate];
            [parts1 setHour:23];
            [parts1 setMinute:59];
            [parts1 setSecond:59];
            NSDate *toDate = [[NSCalendar currentCalendar] dateFromComponents:parts1];
            
            //get Trans
            NSError *error =nil;
            NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:fromDate,@"startDate",toDate,@"endDate",nil];
            NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"getAllTranscationsWithDate" substitutionVariables:subs];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
            NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects1 = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
            
            //calculate transaction
            DailyAmountObject *oneDailyAmountObject = [[DailyAmountObject alloc]init];
            double totalIncAmount = 0;
            double totalExpAmount = 0;
            oneDailyAmountObject.date = fDate;
            for (int i=0; i<[objects1 count]; i++)
            {
                Transaction *tmpTran = [objects1 objectAtIndex:i];
                if([appDelegate.epnc dateCompare:tmpTran.dateTime withDate:fDate]==0&& [tmpTran.state isEqualToString:@"1"])
                {
                    if([tmpTran.category.categoryType isEqualToString:@"INCOME"]){
                        totalIncAmount +=[tmpTran.amount doubleValue];
                    }
                    else if([tmpTran.category.categoryType isEqualToString:@"EXPENSE"])
                    {
                        totalExpAmount += [tmpTran.amount doubleValue];
                        
                    }
                    else if (tmpTran.category== nil && [[tmpTran.childTransactions allObjects]count]>0)
                    {
                        NSMutableArray *childArray = [[NSMutableArray alloc]initWithArray:[tmpTran.childTransactions allObjects]];
                        double chilldTotalAmount = 0;
                        for (int child = 0; child<[childArray count]; child++ ) {
                            Transaction *oneChild = [childArray objectAtIndex:child];
                            if ([oneChild.state isEqualToString:@"1"]) {
                                chilldTotalAmount += [oneChild.amount doubleValue];
                            }
                        }
                        
                        totalExpAmount += chilldTotalAmount;
                    }
                    
                }
            }
            oneDailyAmountObject.expenseAmount = totalExpAmount;
            oneDailyAmountObject.incomeAmount = totalIncAmount;
            [dailyAmountArray insertObject:oneDailyAmountObject atIndex:[dailyAmountArray count]];
            
            
            //时间+1天
            NSDateComponents*  parts2 = [[NSCalendar currentCalendar] components:flags fromDate:fDate];
            [parts2 setDay:parts2.day+1];
            [parts2 setHour:0];
            [parts2 setMinute:0];
            [parts2 setSecond:0];
            fDate = [[NSCalendar currentCalendar] dateFromComponents:parts2];
        }
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    PokcetExpenseAppDelegate *appDelegate_iphone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //右对齐文字
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentRight];
    [ps setLineBreakMode:NSLineBreakByTruncatingTail];
    
    double tileWidth_WD = SCREEN_WIDTH/7.0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    self.backgroundColor = [UIColor clearColor];

    double incomeTextBottom = 0;
    double expenseTextBottom = 0;
    if (IS_IPHONE_6PLUS)
    {
        incomeTextBottom = 7;
        expenseTextBottom = 21;
    }
    else if (IS_IPHONE_6)
    {
        incomeTextBottom = 6;
        expenseTextBottom = 16;
    }
    else
    {
        incomeTextBottom = 5;
        expenseTextBottom = 16;
    }
    UIColor *textColor;
    CGRect textRect=CGRectMake(2, self.frame.size.height-expenseTextBottom, tileWidth_WD-9, 30);
    
    long  firstAmountDataLocaltion = 7 - [dailyAmountArray count];
    if ([dailyAmountArray count] > 0)
    {
        DailyAmountObject *oneDailyAmountObject = [dailyAmountArray objectAtIndex:0];
        if ([[dateFormatter stringFromDate:oneDailyAmountObject.date] integerValue]!=1)
        {
            firstAmountDataLocaltion = 0;
        }
    }
    for (int i=0; i<[dailyAmountArray count]; i++)
    {
        DailyAmountObject *oneDailyAmountObject = [dailyAmountArray objectAtIndex:i];
        if (oneDailyAmountObject.expenseAmount>0)
        {
            textColor = [UIColor colorWithRed:255/255.0 green:93/255.0 blue:106/255.0 alpha:1];

            //设置金额的显示text
            NSString *expenseAmountString;
            if (oneDailyAmountObject.expenseAmount<100000)//100k-1
            {
                expenseAmountString = [appDelegate_iphone.epnc formatterStringWithOutCurrency:oneDailyAmountObject.expenseAmount];
            }
            else if (oneDailyAmountObject.expenseAmount<100000000)//100k --- 100m-1
                expenseAmountString =[NSString stringWithFormat:@"%.0f k", oneDailyAmountObject.expenseAmount/1000];
            else if(oneDailyAmountObject.expenseAmount < 100000000000)//100m -- 100b-1
                expenseAmountString =[NSString stringWithFormat:@"%.0f m", oneDailyAmountObject.expenseAmount/1000000.0];
            else
                expenseAmountString =[NSString stringWithFormat:@"%.0f b", oneDailyAmountObject.expenseAmount/1000000000.0];
            NSDictionary *attrexpense = @{NSForegroundColorAttributeName: textColor , NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:10],NSParagraphStyleAttributeName:ps};
            
            
//            CGSize size = [expenseAmountString sizeWithAttributes:attrexpense];
            textRect=CGRectMake(1+(i+firstAmountDataLocaltion)*tileWidth_WD, self.frame.size.height-26, tileWidth_WD-9, 13);

            [expenseAmountString drawInRect:textRect withAttributes:attrexpense];
            
        }
        
        
        if (oneDailyAmountObject.incomeAmount>0)
        {
            textColor = [UIColor colorWithRed:28/255.0 green:201/255.0 blue:70/255.0 alpha:1];
            textRect=CGRectMake(2, self.frame.size.height-incomeTextBottom, tileWidth_WD-9, 30);
            NSString *incomeAmountString;
            if (oneDailyAmountObject.incomeAmount<100000)//100k-1
            {
                incomeAmountString = [appDelegate_iphone.epnc formatterStringWithOutCurrency:oneDailyAmountObject.incomeAmount];
            }
            else if (oneDailyAmountObject.incomeAmount<100000000)//100k --- 100m-1
                incomeAmountString =[NSString stringWithFormat:@"%.0f k", oneDailyAmountObject.incomeAmount/1000.0];
            else if(oneDailyAmountObject.incomeAmount < 100000000000)//100m -- 100b-1
                incomeAmountString =[NSString stringWithFormat:@"%.0f m", oneDailyAmountObject.incomeAmount/1000000];
            else
                incomeAmountString =[NSString stringWithFormat:@"%.0f m", oneDailyAmountObject.incomeAmount/1000000000];
            NSDictionary *attrincome = @{NSForegroundColorAttributeName: textColor , NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:10],NSParagraphStyleAttributeName:ps};
            
            
//            CGSize size = [incomeAmountString sizeWithAttributes:attrincome];
            textRect=CGRectMake(1+(i+firstAmountDataLocaltion)*tileWidth_WD, self.frame.size.height-13, tileWidth_WD-9, 13);
            
            [incomeAmountString drawInRect:textRect withAttributes:attrincome];
            
        }
        
        
    }
    
}

@end
