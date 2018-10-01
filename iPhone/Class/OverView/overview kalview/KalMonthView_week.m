/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView_week.h"
#import "KalTileView_week.h"
#import "KalView_week.h"
#import "KalDate_week.h"
#import "KalPrivate_week.h"

#import "PokcetExpenseAppDelegate.h"
#import "Transaction.h"
#import "AppDelegate_iPhone.h"
#import "OverViewWeekCalenderViewController.h"
#import "KalViewController_week.h"
#import "KalLogic_week.h"

extern const CGSize kTileSize_main;

@implementation KalMonthView_week

@synthesize numWeeks;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame]))
  {
      self.backgroundColor = [UIColor clearColor];
    tileAccessibilityFormatter = [[NSDateFormatter alloc] init];
    [tileAccessibilityFormatter setDateFormat:@"EEEE, MMMM d"];
    self.opaque = NO;
    self.clipsToBounds = YES;
      
      AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
      
      double tmpTileWith = SCREEN_WIDTH/7.0;
      if (appDelegate_iphone.overViewController.overViewMonthViewController == nil)
      {
          for (int i=0; i<7; i++)
          {
              CGRect r= CGRectMake(i*tmpTileWith, 0, tmpTileWith, frame.size.height) ;
              [self addSubview:[[KalTileView_week alloc] initWithFrame:r]];
          }
      }
      else
      {
          for (int i=0; i<6; i++) {
              for (int j=0; j<7; j++) {
                  CGRect r = CGRectMake(j*tmpTileWith, i*kTileSize_main.height, tmpTileWith, kTileSize_main.height);
                  [self addSubview:[[KalTileView_week alloc] initWithFrame:r] ];
              }
          }
      }
    
  }
    
    self.backgroundColor = [UIColor clearColor];
  return self;
}

- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates
{
  int tileNum = 0;
  NSArray *dates[] = { leadingAdjacentDates, mainDates, trailingAdjacentDates };
  
  for (int i=0; i<3; i++) {
    for (KalDate_week *d in dates[i]) {
        
        //根据日期获取当月第几个tile，设置date,type信息
      KalTileView_week *tile = [self.subviews objectAtIndex:tileNum];
      [tile resetState];
        
        if (i==0 || i==2)
        {
            tile.date = d;
            tile.showOutDate = NO;
        }
        else
        {
            tile.date = d;
            tile.showOutDate = YES;
        }

        if ([d isToday])
        {
            tile.type = KalTileTypeToday;
        }
        else
            tile.type = KalTileTypeRegular;
        
      tileNum++;
    }
  }
  
    if ([mainDates count]==7) {
        numWeeks = 1;
    }
    else
        numWeeks = ceilf(tileNum / 7.f);
  [self sizeToFit];
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{

}

- (KalTileView_week *)firstTileOfMonth
{
  KalTileView_week *tile = nil;
  for (KalTileView_week *t in self.subviews) {
    if (!t.belongsToAdjacentMonth) {
      tile = t;
      break;
    }
  }
  
  return tile;
}

- (KalTileView_week *)firstTileOfWeek
{
    KalTileView_week *tile = nil;
    for (KalTileView_week *t in self.subviews) {
        if (t.frame.origin.x == 0) {
            tile = t;
            break;
        }
    }
    
    return tile;
}

- (KalTileView_week *)tileForDate:(KalDate_week *)date
{
  KalTileView_week *tile = nil;
  for (KalTileView_week *t in self.subviews) {
    if ([t.date isEqual:date]) {
      tile = t;
      break;
    }
  }
  NSAssert1(tile != nil, @"Failed to find corresponding tile for date %@", date);
  
  return tile;
}

//- (void)sizeToFit
//{
//  self.height = tmpTileWith, frame.size.height * numWeeks;
//}

- (void)markTilesForDates:(NSArray *)dates
{
  for (KalTileView_week *tile in self.subviews)
  {
    tile.marked = [dates containsObject:tile.date];
    NSString *dayString = [tileAccessibilityFormatter stringFromDate:[tile.date NSDate]];
    if (dayString) {
      NSMutableString *helperText = [[NSMutableString alloc] initWithCapacity:128] ;
      if ([tile.date isToday])
        [helperText appendFormat:@"%@ ", NSLocalizedString(@"Today", @"Accessibility text for a day tile that represents today")];
      [helperText appendString:dayString];
      if (tile.marked)
        [helperText appendFormat:@". %@", NSLocalizedString(@"Marked", @"Accessibility text for a day tile which is marked with a small dot")];
      [tile setAccessibilityLabel:helperText];
    }
  }
}

#pragma mark Week Calender Method
- (void)paidmarkTilesForDates:(NSArray *)dates withDates1:(NSArray *)dates1 isTran:(BOOL)isTran
{
    if([dates count] == 0)
    {
        for (KalTileView_week *tile in self.subviews)
        {
            tile.totalExpAmount = 0;
            tile.totalIncAmount = 0;
        }
        return;
    }

    for (KalTileView_week *tile in self.subviews)
    {
        tile.totalExpAmount = 0;
        tile.totalIncAmount = 0;
    }
    if(isTran)
    {
        /////////////////////////
        //Kal mark type
        //0-not show
        //1 - pay all
        //2 -pay any
        //3- not pay
        //4-over due
        NSInteger lastStart=0;
        Transaction *firstTran=nil;
        Transaction *lastTran=nil;
        Transaction *tmpTran;
        
        if([dates count]>0)
        {
            lastTran = [dates lastObject];
            firstTran =[dates objectAtIndex:0];
        }
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        for (KalTileView_week *tile in self.subviews)
        {
            tile.totalExpAmount=0;
            tile.totalExpPaid=0;
            tile.totalIncAmount=0;
            tile.totalIncPaid=0;
            if(firstTran !=nil&&lastTran!=nil)
            {
                if([appDelegate.epnc dateCompare:[tile.date NSDate] withDate:firstTran.dateTime]>=0
                   &&[appDelegate.epnc dateCompare:[tile.date NSDate] withDate:lastTran.dateTime]<=0)
                {
                    for (long i=lastStart; i<[dates count];i++) {
                        tmpTran = [dates objectAtIndex:i];
                        if([appDelegate.epnc dateCompare:tmpTran.dateTime withDate:[tile.date NSDate]]==0)
                        {
                            if([tmpTran.category.categoryType isEqualToString:@"INCOME"]){
                                tile.totalIncAmount +=[tmpTran.amount doubleValue];
                                
                            }
                            else if([tmpTran.category.categoryType isEqualToString:@"EXPENSE"])
                            {
                                tile.totalExpAmount = tile.totalExpAmount +[tmpTran.amount doubleValue];
                                
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
                                
                                tile.totalExpAmount += chilldTotalAmount;
                            }
                            
                        }
                        else   if([appDelegate.epnc dateCompare:tmpTran.dateTime withDate:[tile.date NSDate]]>0)
                            
                        {
                            lastStart = i;
                            break;
                        }
                    }
                }
            }
            
        }
        
        
        return;
    }
    

}


@end
