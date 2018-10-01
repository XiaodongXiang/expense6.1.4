/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalView.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "Transaction.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "BillFather.h"
#import "EP_BillRule.h"
#import "EP_BillItem.h"

extern const CGSize kTileSize_iPad;
extern CGSize kTileSize_Bill_iPad;
@implementation KalMonthView

@synthesize numWeeks;
- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
      self.backgroundColor = [UIColor clearColor];
    tileAccessibilityFormatter = [[NSDateFormatter alloc] init];
    [tileAccessibilityFormatter setDateFormat:@"EEEE, MMMM d"];
    self.opaque = NO;
    self.clipsToBounds = YES;
      AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
      
      
      if (appDelegate_iPad.mainViewController.currentViewSelect==0)
      {
          for (int i=0; i<6; i++) {
              for (int j=0; j<7; j++) {
                  CGRect r = CGRectMake(j*kTileSize_iPad.width, i*kTileSize_iPad.height, kTileSize_iPad.width, kTileSize_iPad.height);
                  [self addSubview:[[KalTileView alloc] initWithFrame:r]];
              }
          }
      }
      else
      {
          for (int i=0; i<6; i++) {
              for (int j=0; j<7; j++)
              {
                  CGRect r = CGRectMake(j*kTileSize_Bill_iPad.width, i*kTileSize_Bill_iPad.height, kTileSize_Bill_iPad.width, kTileSize_Bill_iPad.height);
                  [self addSubview:[[KalTileView alloc] initWithFrame:r] ];
              }
          }
      }
    
  }
    
  return self;
}


- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates
{
  int tileNum = 0;
  NSArray *dates[] = { leadingAdjacentDates, mainDates, trailingAdjacentDates };
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if (appDelegate_iPad.mainViewController.currentViewSelect != 0) {
        for (KalTileView *tile in self.subviews)
		{
			[tile resetState];
			
		}
        for (int i=0; i<3; i++) {
            for (KalDate *d in dates[i]) {
                KalTileView *tile = [self.subviews objectAtIndex:tileNum];
                [tile resetState];
                tile.date = d;
                if(i==0||i==2)
                {
                    tile.showOutDate = FALSE;
					
                }
                else {
                    tile.showOutDate = TRUE;
					
                }
                
                tile.type = dates[i] != mainDates
                ? KalTileTypeAdjacent
                : [d isToday] ? KalTileTypeToday : KalTileTypeRegular;
                tileNum++;
            }
        }

    }
    
    

    else{
  for (int i=0; i<3; i++) {
    for (KalDate *d in dates[i]) {
      KalTileView *tile = [self.subviews objectAtIndex:tileNum];
      [tile resetState];
      tile.date = d;
      tile.type = dates[i] != mainDates
                    ? KalTileTypeAdjacent
                    : [d isToday] ? KalTileTypeToday : KalTileTypeRegular;
      tileNum++;
    }
  }
    }
  numWeeks = ceilf(tileNum / 7.f);
  [self sizeToFit];
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,kTileSize_iPad}, [[UIImage imageNamed:@"Kal.bundle/kal_tile.png"] CGImage]);
}
- (KalTileView *)todaysTileIfVisible
{
    KalTileView *tile = nil;
    for (KalTileView *t in self.subviews) {
        if ([t isToday]) {
            tile = t;
            break;
        }
    }
    
    return tile;
}

- (KalTileView *)firstTileOfMonth
{
  KalTileView *tile = nil;
  for (KalTileView *t in self.subviews) {
    if (!t.belongsToAdjacentMonth) {
      tile = t;
      break;
    }
  }
  
  return tile;
}

- (KalTileView *)tileForDate:(KalDate *)date
{
  KalTileView *tile = nil;
  for (KalTileView *t in self.subviews) {
    if ([t.date isEqual:date]) {
      tile = t;
      break;
    }
  }
  NSAssert1(tile != nil, @"Failed to find corresponding tile for date %@", date);
  
  return tile;
}

- (void)sizeToFit
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if(appDelegate_iPad.mainViewController.currentViewSelect!=0)
    {
        self.height = kTileSize_Bill_iPad.height * numWeeks;
    }
    else
        self.height = kTileSize_iPad.height * numWeeks;
}

- (void)markTilesForDates:(NSArray *)dates
{
  for (KalTileView *tile in self.subviews)
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
#pragma mark-
- (void)paidmarkTilesForDates:(NSArray *)dates withDates1:(NSArray *)dates1 isTran:(BOOL)isTran
{
    if (!isTran) {
        BillFather  *oneBillFather;
        /////////////////////////
        //Kal mark type
        //0-not show
        //1 - pay all
        //2 -pay any
        //3- not pay
        //4-over due
        NSInteger lastStart=0;
        NSInteger lastStart1=0;
        
        BillFather *firstBill=nil;
        BillFather *lastBill=nil;
        
        if([dates count] +[dates1 count] ==0)
        {
            for (KalTileView *tile in self.subviews)
            {
                tile.totalExpAmount=0;
                tile.totalExpPaid=0;
                tile.totalIncAmount=0;
                tile.totalIncPaid=0;
                tile.overDue = FALSE;
                tile.paid= FALSE;
                tile.unpaid= FALSE;
                tile.paidHalf= FALSE;
                [tile setNeedsDisplay];
                
            }
            return;
        }
        
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        for (KalTileView *tile in self.subviews)
        {
            tile.totalExpAmount=0;
            tile.totalExpPaid=0;
            tile.totalIncAmount=0;
            tile.totalIncPaid=0;
            tile.overDue = FALSE;
            tile.paid= FALSE;
            tile.unpaid= FALSE;
            tile.paidHalf= FALSE;
            /////////////////////////
            //Kal mark type
            //0-not show
            //1 - pay all
            //2 -pay any
            //3- not pay
            //4-over due
            if([dates count]>0)
            {
                lastBill = [dates lastObject];
                firstBill =[dates objectAtIndex:0];
            }
            else {
                lastBill = nil;
                firstBill =nil;
                
            }
            
            if(firstBill !=nil&&lastBill!=nil)
            {
                if([appDelegate.epnc dateCompare:[tile.date NSDate] withDate:firstBill.bf_billDueDate]>=0
                   &&[appDelegate.epnc dateCompare:[tile.date NSDate] withDate:lastBill.bf_billDueDate]<=0)
                {
                    for (long i=lastStart; i<[dates count];i++) {
                        oneBillFather = [dates objectAtIndex:i];
                        
                        //事件的时间与比较的时间相等，表明是这一天的事件
                        if([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[tile.date NSDate]]==0)
                        {
                            
                            NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
                            if ([oneBillFather.bf_billRecurringType isEqualToString:@"Never"])
                            {
                                [paymentArray setArray:[oneBillFather.bf_billRule.billRuleHasTransaction allObjects]];
                            }
                            else
                            {
                                [paymentArray setArray:[oneBillFather.bf_billItem.billItemHasTransaction allObjects]];
                            }
                            
                            
                            double paymentAmount = 0;
                            for (int i=0; i<[paymentArray count]; i++) {
                                Transaction *oneTrans = [paymentArray objectAtIndex:i];
                                if ([oneTrans.state isEqualToString:@"1"]) {
                                    paymentAmount += [oneTrans.amount doubleValue];
                                    
                                }
                            }
                            
                            //过期没支付完
                            if ((paymentAmount < oneBillFather.bf_billAmount) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]<0)) {
                                tile.overDue = 1;
                            }
                            //过期支付完
                            else if ((paymentAmount >= oneBillFather.bf_billAmount) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]<0)){
                                tile.paid = 1;
                            }
                            //没过期没支付
                            else if((paymentAmount ==0) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]>=0)){
                                tile.unpaid = 1;
                            }
                            //没过期 没支付完
                            else if ((paymentAmount < oneBillFather.bf_billAmount) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]>=0)){
                                tile.paidHalf = 1;
                            }
                            else{
                                tile.paid =1;
                            }
                            
                        }
                        //时间的时间比比较的时间大，那么要结束本个tile,获取下一个tile
                        else if([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[tile.date NSDate]]>0)
                        {
                            lastStart = i;
                            break;
                        }
                    }
                }
                
            }
            
            if([dates1 count]>0)
            {
                lastBill = [dates1 lastObject];
                firstBill =[dates1 objectAtIndex:0];
            }
            else {
                lastBill = nil;
                firstBill =nil;
                
            }
            if(firstBill !=nil&&lastBill!=nil)
            {
                
                if([appDelegate.epnc dateCompare:[tile.date NSDate] withDate:firstBill.bf_billDueDate]>=0
                   &&[appDelegate.epnc dateCompare:[tile.date NSDate] withDate:lastBill.bf_billDueDate]<=0)
                {
                    for (long i=lastStart1; i<[dates1 count];i++) {
                        oneBillFather = [dates1 objectAtIndex:i];
                        if([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[tile.date NSDate]]==0)
                        {
                            
                            
                            NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
                            if (oneBillFather.bf_billItem != nil) {
                                [paymentArray setArray:[oneBillFather.bf_billItem.billItemHasTransaction allObjects]];
                            }
                            else if(oneBillFather.bf_billRule != nil){
                                [paymentArray setArray:[oneBillFather.bf_billRule.billRuleHasTransaction allObjects]];
                            }
                            
                            double paymentAmount = 0;
                            for (int i=0; i<[paymentArray count]; i++) {
                                Transaction *oneTrans = [paymentArray objectAtIndex:i];
                                paymentAmount += [oneTrans.amount doubleValue];
                            }
                            
                            //过期没支付完
                            if ((paymentAmount < oneBillFather.bf_billAmount) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]<0)) {
                                tile.overDue = 1;
                            }
                            //过期支付完
                            else if ((paymentAmount >= oneBillFather.bf_billAmount) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]<0)){
                                tile.paid = 1;
                            }
                            //没过期没支付
                            else if((paymentAmount ==0) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]>=0)){
                                tile.unpaid = 1;
                            }
                            //没过期 没支付完
                            else if ((paymentAmount < oneBillFather.bf_billAmount) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]>=0)){
                                tile.paidHalf = 1;
                            }
                            
                            else{
                                tile.paid = 1;
                            }
                            
                        }
                        else if([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[tile.date NSDate]]>0)
                        {
                            lastStart1 = i;
                            break;
                        }
                    }
                }
            }
            
            [tile setNeedsDisplay];
        }
        
    }
}
- (void)unpaidmarkTilesForDates
{
    return;
 	for (KalTileView *tile in self.subviews)
		tile.unpaidmarked =TRUE;
	
}

#pragma mark -


@end
